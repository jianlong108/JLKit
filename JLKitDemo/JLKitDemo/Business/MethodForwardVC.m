//
//  MethodForwardVC.m
//  low-level-analyse
//
//  Created by 王建龙 on 2017/10/12.
//  Copyright © 2017年 JL. All rights reserved.
//

#import "MethodForwardVC.h"
#import <objc/objc.h>
#import <objc/runtime.h>
#import <objc/message.h>

@interface Method_Car : NSObject

- (void)run;

@end

@implementation Method_Car

- (void)run{
    
    NSLog(@"Method_Car  run");
    
}
- (void)haveFourWheel{
    
    NSLog(@"Method_Car  haveFourWheel");
    
}
@end



///////////////////////////////////////////////
///////////////////////////////////////////////
///////////////////////////////////////////////



@interface MethodForwardVC ()

@property (nonatomic, strong)NSMutableDictionary *backingStore;

@property (nonatomic,strong) NSString *name;
@property (nonatomic,strong) NSNumber *number;
@property (nonatomic,strong) NSDate *date;
- (void)run;
- (void)haveFourWheel;

@end

@implementation MethodForwardVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.backingStore = [NSMutableDictionary dictionary];
    self.title = @"消息转发测试";
    self.view.backgroundColor = [UIColor orangeColor];
    // Do any additional setup after loading the view.
    [self methodForward_test];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
/**
 消息转发 测试
 */
-(void)methodForward_test{
    
    self.date = [NSDate dateWithTimeIntervalSince1970:475372800];
    NSLog(@"%@ %p",self.date,&self);
    NSString *str = [NSString stringWithFormat:@"%p",self];
    NSLog(@"%@ %@",self.date,str);
    
    [self run];
    [self haveFourWheel];
}


#pragma mark 消息转发
/**
 第一阶段先征询接收者，所属的类，看其是否能动态添加方法，以处理当前这个“未知的选择子”（unknown selector）,这叫做“动态方法解析”（dynamic method resolution）
 
 @param selector 方法描述
 @return 是否实现
 */
+ (BOOL)resolveInstanceMethod:(SEL)selector
{
    NSString *selectorString = NSStringFromSelector(selector);
    
    //不动态解析 方法名为run 和 haveFourWheel 这两个方法
    if ([selectorString isEqualToString:@"run"]||[selectorString isEqualToString:@"haveFourWheel"]) {
        return NO;
    }
    
    //动态解析setter
    if ([selectorString hasPrefix:@"set"]) {
        class_addMethod(self, selector, (IMP)autoDictionarySetter, "v@:@");
    } else {
        class_addMethod(self, selector, (IMP)autoDictionaryGetter, "@@:");
    }
    return YES;
}

id autoDictionaryGetter(MethodForwardVC *self,SEL _cmd)
{
    NSMutableDictionary *backingStore = self.backingStore;
    NSString *key = NSStringFromSelector(_cmd);
    return [backingStore objectForKey:key];
}
void autoDictionarySetter(MethodForwardVC *self,SEL _cmd,id value)
{
    NSMutableDictionary *backingStore = self.backingStore;
    NSString *selectorString = NSStringFromSelector(_cmd);
    NSMutableString *key  = [selectorString mutableCopy];
    [key deleteCharactersInRange:NSMakeRange(key.length - 1, 1)];
    [key deleteCharactersInRange:NSMakeRange(0, 3)];
    NSString *lowercaseFirstChar = [[key substringToIndex:1] lowercaseString];
    [key replaceCharactersInRange:NSMakeRange(0, 1) withString:lowercaseFirstChar];
    if (value) {
        [backingStore setObject:value forKey:key];
    } else {
        [backingStore removeObjectForKey:key];
    }
}

/**
 第二方法参数代表未知的选择子，若当前接收者能找到备援对象，则将其返回，若找不到就返回nil。在一个对象内部，可能还有一系列其他对象，该对象可经由此方法将能够处理某选择子的相关内部对象返回，这样的话，在外界看来，好像是该对象亲自处理了这些消息似的
 
 @param aSelector 方法因子
 @return 需要处理方法的对象
 */
-(id)forwardingTargetForSelector:(SEL)aSelector{
    
    NSString *selectorString = NSStringFromSelector(aSelector);
    if ([selectorString isEqualToString:@"run"]) {
        return [[Method_Car alloc]init];
    }else{
        return nil;
    }
    
}

/**
 消息转发机制使用 从 此方法中获取的信息来创建NSInvocation对象。因此我们必须重写这个方法，为给定的selector提供一个合适的方法签名。
 
 @param aSelector 方法因子
 @return 方法签名
 */
- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector{
    NSString *selectorString = NSStringFromSelector(aSelector);
    if ([selectorString isEqualToString:@"haveFourWheel"]) {
        return [NSMethodSignature signatureWithObjCTypes:"v@:"];
    }else{
        return [super methodSignatureForSelector:aSelector];
    }
    
}

/**
 运行时系统会在这一步给消息接收者最后一次机会将消息转发给其它对象。系统帮助 对象创建一个表示消息的NSInvocation对象，把与尚未处理的消息 有关的全部细节都封装在anInvocation中，包括selector，目标(target)和参数。我们可以在forwardInvocation 方法中选择将消息转发给其它对象。
 
 @param anInvocation NSInvocation * 消息 对象
 */
- (void)forwardInvocation:(NSInvocation *)anInvocation{
    SEL oneSelector = anInvocation.selector;
    Method_Car *car = [[Method_Car alloc]init];
    if ([car respondsToSelector:oneSelector]) {
        [anInvocation invokeWithTarget:car];
    }
    
}
@end
