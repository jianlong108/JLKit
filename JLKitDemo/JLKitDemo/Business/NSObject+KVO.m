//
//  NSObject+KVO.m
//  low-level-analyse
//
//  Created by Wangjianlong on 2017/10/15.
//  Copyright © 2017年 JL. All rights reserved.
//

#import "NSObject+KVO.h"
#import <objc/runtime.h>
#import <objc/message.h>

NSString *const JLKVOClassPrefix = @"JLKVOClassPrefix_";
NSString *const JLKVOAssociatedObserverskey = @"JLKVOAssociatedObserverskey";


@interface JLObservationInfo : NSObject

@property (nonatomic, weak) NSObject *observer;
@property (nonatomic, copy) NSString *key;
@property (nonatomic, copy) JLObservingBlock block;

@end

@implementation JLObservationInfo

- (instancetype)initWithObserver:(NSObject *)observer Key:(NSString *)key block:(JLObservingBlock)block
{
    self = [super init];
    if (self) {
        _observer = observer;
        _key = key;
        _block = block;
    }
    return self;
}

@end

@implementation NSObject (KVO)


/**
 根据属性名称 生成setter

 @param key 属性名称
 @return setter
 */
static NSString * setterForKey(NSString *key)
{
    //  getter==name  --> setName:
    if (key.length <= 0) {
        return nil;
    }
    
    // 1.将key 的第一个字母大写 upper case the first letter
    NSString *firstLetter = [[key substringToIndex:1] uppercaseString];
    
    NSString *remainingLetters = [key substringFromIndex:1];
    
    // add 'set' at the begining and ':' at the end
    NSString *setter = [NSString stringWithFormat:@"set%@%@:", firstLetter, remainingLetters];
    
    return setter;
}

/**
 根据setter方法名称 获得key

 @param setter setter
 @return 获得被监听的 属性名称
 */
static NSString * keyForSetter(NSString *setter)
{
    if (setter.length <=0 || ![setter hasPrefix:@"set"] || ![setter hasSuffix:@":"]) {
        return nil;
    }
    
    // remove 'set' at the begining and ':' at the end
    NSRange range = NSMakeRange(3, setter.length - 4);
    NSString *key = [setter substringWithRange:range];
    
    // lower case the first letter
    NSString *firstLetter = [[key substringToIndex:1] lowercaseString];
    key = [key stringByReplacingCharactersInRange:NSMakeRange(0, 1)
                                       withString:firstLetter];
    
    return key;
}

static Class kvo_class(id self, SEL _cmd)
{
    //假设我们的类名为JLKVOClassPrefix_A,它的父类为A,即我们监听对象的类型.
    //此时的self,为JLKVOClassPrefix_A 类型的实例.下述方法是获得实例self的父类->A
    return class_getSuperclass(object_getClass(self));
}

//重写 setter 方法。新的 setter 在调用原 setter 方法后，通知每个观察者（调用之前传入的 block ）：
static void kvo_setter(id self, SEL _cmd, id newValue)
{
    NSString *setterName = NSStringFromSelector(_cmd);
//    if (![setterName hasPrefix:JLKVOClassPrefix]) {
//        return;
//    }
    NSString *getterName = keyForSetter(setterName);
    
    //安全检查是否有 getter..
    if (!getterName) {
        NSString *reason = [NSString stringWithFormat:@"Object %@ does not have getter %@", self, getterName];
        @throw [NSException exceptionWithName:NSInvalidArgumentException
                                       reason:reason
                                     userInfo:nil];
        return;
    }
    
    //通过getter 获取旧值
    id oldValue = [self valueForKey:getterName];
    
    struct objc_super superclazz = {
        .receiver = self,
        .super_class = class_getSuperclass(object_getClass(self))
    };
    //    细心的同学会发现我们对 objc_msgSendSuper 进行类型转换。在 Xcode 6 里，新的 LLVM 会对 objc_msgSendSuper 以及 objc_msgSend 做严格的类型检查，如果不做类型转换。Xcode 会抱怨有 too many arguments 的错误。（在 WWDC 2014 的视频 What new in LLVM 中有提到过这个问题。）
    // cast our pointer so the compiler won't complain
    void (*objc_msgSendSuperCasted)(void *, SEL, id) = (void *)objc_msgSendSuper;
    
    // call super's setter, which is original class's setter method
//    objc_msgSendSuper(&superclazz, _cmd, newValue);
    objc_msgSendSuper();
    // look up observers and call the blocks
    //    把这个观察的相关信息存在 associatedObject 里。观察的相关信息（观察者，被观察的 key, 和传入的 block ）封装在 PGObservationInfo 类里
    NSMutableArray *observers = objc_getAssociatedObject(self, (__bridge const void *)(JLKVOAssociatedObserverskey));
    for (JLObservationInfo *eachObserver in observers) {
        if ([eachObserver.key isEqualToString:getterName]) {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                eachObserver.block(self, getterName, oldValue, newValue);
            });
        }
    }
}
/**
 根据原始的类,生成一个新的类..以 JLKVOClassPrefix 开头
 
 @param originalClazzName 原始类
 @return 新生成的类 且 重写了class 方法
 */
- (Class)makeKvoClassWithOriginalClassName:(NSString *)originalClazzName
{
    NSString *kvoClazzName = [JLKVOClassPrefix stringByAppendingString:originalClazzName];
    Class class_obj = NSClassFromString(kvoClazzName);
    
    //如果已经(load)存在,就直接返回
    //只有当前类已经注册到了runtime中,才会返回Class对象,否则返回nil
    if (class_obj) {
        return class_obj;
    }
    
    // 如果不存在此类,就需要将新生类的 class 方法重写.达到隐藏子类的目的
    // 动态创建新的类需要用 objc/runtime.h 中定义的 objc_allocateClassPair() 函数。传一个父类，类名，然后额外的空间（通常为 0），它返回给你一个类。然后就给这个类添加方法，也可以添加变量。
    // grab class method's signature so we can borrow it
    //这里，我们只重写了 class 方法。哈哈，跟 Apple 一样，这时候我们也企图隐藏这个子类的存在。
    
    //获取当前对象的 class
    Class originalClazz = object_getClass(self);
    //创建当前对象所属类的  子类
    Class kvoClazz = objc_allocateClassPair(originalClazz, kvoClazzName.UTF8String, 0);
    
    
    //获取 当前对象的class方法 Method
    Method clazzMethod = class_getInstanceMethod(originalClazz, @selector(class));
    //获取class方法的参数和类型 所对应的字符串
    const char *types = method_getTypeEncoding(clazzMethod);
    
    //为新生类 增加 kvo_class 方法,用来隐藏真实的类
    //为新生类增加自己的class方法,其实就是拿父类的class 这里，我们只重写了 class 方法。哈哈，跟 Apple 一样，这时候我们也企图隐藏这个子类的存在。
    class_addMethod(kvoClazz, @selector(class), (IMP)kvo_class, types);
    
    //最后 objc_registerClassPair() 告诉 Runtime 这个类的存在。
    objc_registerClassPair(kvoClazz);
    
    return kvoClazz;
}


- (BOOL)hasSelector:(SEL)selector
{
    Class clazz = object_getClass(self);
    unsigned int methodCount = 0;
    Method* methodList = class_copyMethodList(clazz, &methodCount);
    for (unsigned int i = 0; i < methodCount; i++) {
        SEL thisSelector = method_getName(methodList[i]);
        if (thisSelector == selector) {
            free(methodList);
            return YES;
        }
    }
    
    free(methodList);
    return NO;
}

#pragma mark - interface
- (void)JL_addObserver:(NSObject *)observer
                forKey:(NSString *)key
             withBlock:(JLObservingBlock)block{
    //1.获取被观察者的 属性key 的 setter
    SEL setterSelector = NSSelectorFromString(setterForKey(key));
    //2.根据生成的setter 获取 对应的 Method
    Method setterMethod = class_getInstanceMethod([self class], setterSelector);
    //3.安全检查
    if (!setterMethod) {
        NSString *reason = [NSString stringWithFormat:@"Object %@ does not have a setter for key %@", self, key];
        @throw [NSException exceptionWithName:NSInvalidArgumentException
                                       reason:reason
                                     userInfo:nil];
        
        return;
    }
    //4. 获取当前被监听对象的 class 类型
    Class class_obj = object_getClass(self);
    NSString *className = NSStringFromClass(class_obj);
    
    //5.我们先看类名有没有我们定义的前缀。如果没有，我们就去创建新类.新类继承自当前类，并通过 object_setClass() 修改 isa 指针。
    if (![className hasPrefix:JLKVOClassPrefix]) {
        //根据对象的 原始class 生成一个新的class
        class_obj = [self makeKvoClassWithOriginalClassName:className];
        //为当前对象 的isa指针 指向class_obj
        object_setClass(self, class_obj);
    }
    
    //6.获得类之后,就要为它添加setter方法..注意此时的self 已经是JLKVOClassPrefix_A 类型了
    if (![self hasSelector:setterSelector]) {
        //        重写 setter 方法。新的 setter 在调用原 setter 方法后，通知每个观察者（调用之前传入的 block
        const char *types = method_getTypeEncoding(setterMethod);
        class_addMethod(class_obj, setterSelector, (IMP)kvo_setter, types);
    }
    
    //7.生成监听对象对应的数据model.并进行存储
    JLObservationInfo *info = [[JLObservationInfo alloc] initWithObserver:observer Key:key block:block];
    NSMutableArray *observers = objc_getAssociatedObject(self, (__bridge const void *)(JLKVOAssociatedObserverskey));
    if (!observers) {
        observers = [NSMutableArray array];
        objc_setAssociatedObject(self, (__bridge const void *)(JLKVOAssociatedObserverskey), observers, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    [observers addObject:info];
}

- (void)JL_removeObserver:(NSObject *)observer forKey:(NSString *)key{
    NSMutableArray* observers = objc_getAssociatedObject(self, (__bridge const void *)(JLKVOAssociatedObserverskey));
    
    JLObservationInfo *infoToRemove;
    for (JLObservationInfo* info in observers) {
        if (info.observer == observer && [info.key isEqual:key]) {
            infoToRemove = info;
            break;
        }
    }
    
    [observers removeObject:infoToRemove];
}


@end
