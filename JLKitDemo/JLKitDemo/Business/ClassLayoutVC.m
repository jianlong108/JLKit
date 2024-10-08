//
//  ClassLayoutVC.m
//  low-level-analyse
//
//  Created by thk on 2017/10/13.
//  Copyright © 2017年 JL. All rights reserved.
//

#import "ClassLayoutVC.h"
#import <objc/objc.h>
#import <objc/runtime.h>
#import <objc/message.h>

@interface MyClass : NSObject

@property (nonatomic, strong) NSArray *array;
@property (nonatomic, copy) NSString *home;

- (void)run;

- (void)eat;

+ (void)classMethod1;

@end

@interface MyClass ()
{
    NSInteger height;
    
    NSString  *name;
}

@property (nonatomic, assign) NSUInteger integer;

- (void)method3WithArg1:(NSInteger)arg1 arg2:(NSString *)arg2;

@end

@implementation MyClass

+ (void)classMethod1 {
    
}

- (void)run {
    NSLog(@"call method: %@",NSStringFromSelector(_cmd));
}

- (void)eat {
    NSLog(@"call method: %@",NSStringFromSelector(_cmd));
}

- (void)method3WithArg1:(NSInteger)arg1 arg2:(NSString *)arg2 {
    
    NSLog(@"arg1 : %ld, arg2 : %@", arg1, arg2);
}


@end

@implementation ClassLayoutVC

- (void)viewDidLoad{
    [super viewDidLoad];
    
    [self self_class_super_class_superclass];
//    [self class_property_method];
//    [self meta_class_test];
//    [self test_nil_sendmsg];
    //只有当前类已经注册到了runtime中,才会返回Class对象,否则返回nil
    Class class_obj = NSClassFromString(@"test");
    if (class_obj) {
        NSLog(@"存在 类: test");
    }else{
        NSLog(@"不存在 类: test");
    }
}
#pragma mark - [self class]与[super class]区别
- (void)self_class_super_class_superclass{
    // LLVM 6.0后增加了OBJC_OLD_DISPATCH_PROTOTYPES，需要在build setting中将Enable Strict Checking of objc_msgSend Calls设置为NO才可以使用objc_msgSend(id self, SEL op, ...);

    //NSLog(@"objc_msgSend(self, @selector(class)) == %@",objc_msgSend(self, @selector(class)));
    NSLog(@"self.class == %@",self.class);
    
    
    struct objc_super tempSupe = {self,NSClassFromString(@"ClassLayoutVC"),NSClassFromString(@"UIViewController")};
    //NSLog(@"objc_msgSendSuper(&tempSupe, @selector(class)) == %@",objc_msgSendSuper(&tempSupe, @selector(class)));
    NSLog(@"super.class == %@",super.class);
    
    
    NSLog(@"self.superclass == %@",self.superclass);
}
#pragma mark - class结构体探究
- (void)class_property_method {
    MyClass *myclass = [[MyClass alloc] init];
    
    
    Class cls = myclass.class;
    
    // 类名
    NSLog(@"============获取类名=======================");
    NSLog(@"class name: %s", class_getName(cls));
    
    
    // 父类
    NSLog(@"============获取父类=======================");
    NSLog(@"super class name: %s", class_getName(class_getSuperclass(cls)));
    
    // 是否是元类
    NSLog(@"%@ is %@ a meta-class",NSStringFromClass([MyClass class]), (class_isMetaClass([MyClass class]) ? @"" : @"not"));
    NSLog(@"==========================================================");
    
    Class meta_class = objc_getMetaClass(class_getName(cls));
    NSLog(@"%@的 meta-class is %@", myclass, meta_class);
    NSLog(@"==========================================================");
    
    // 变量实例大小
    NSLog(@"instance myclass size: %zu", class_getInstanceSize(cls));
    NSLog(@"==========================================================");
    
    
    unsigned int outCount = 0;
    // 成员变量
    Ivar *ivars = class_copyIvarList(cls, &outCount);
    for (int i = 0; i < outCount; i++) {
        Ivar ivar = ivars[i];
        NSLog(@"instance %@ variable's name: %s at index: %d",myclass, ivar_getName(ivar), i);
    }
    
    free(ivars);
    //获取指定成员变量
    Ivar string = class_getInstanceVariable(cls, "name");
    if (string != NULL) {
        NSLog(@"instace variable %s", ivar_getName(string));
    }
    
    NSLog(@"=====================属性操作============");
    
    // 属性操作
    // class_copyPropertyList   return An array of pointers of type \c objc_property_t describing the properties
    objc_property_t * properties = class_copyPropertyList(cls, &outCount);
    for (int i = 0; i < outCount; i++) {
        objc_property_t property = properties[i];
        NSLog(@"%s",property_getAttributes(property));
        NSLog(@"property's name: %s", property_getName(property));
    }
    
    free(properties);
    
    objc_property_t array = class_getProperty(cls, "array");
    if (array != NULL) {
        NSLog(@"property %s", property_getName(array));
    }
    
    NSLog(@"==========================================================");
    
    // 方法操作
    Method *methods = class_copyMethodList(cls, &outCount);
    for (int i = 0; i < outCount; i++) {
        Method method = methods[i];
        NSLog(@"method's signature: %@", NSStringFromSelector(method_getName(method)) );
    }
    
    free(methods);
    
    Method method1 = class_getInstanceMethod(cls, @selector(run));
    if (method1 != NULL) {
        NSLog(@"method %@", NSStringFromSelector(method_getName(method1)) );
    }
    
    Method classMethod = class_getClassMethod(cls, @selector(classMethod1));
    if (classMethod != NULL) {
        NSLog(@"class method : %@", NSStringFromSelector(method_getName(classMethod)));
    }
    
    NSLog(@"MyClass is%@ responsd to selector: method3WithArg1:arg2:", class_respondsToSelector(cls, @selector(method3WithArg1:arg2:)) ? @"" : @" not");
    
    IMP imp = class_getMethodImplementation(cls, @selector(method1));
    
    
    NSLog(@"==========================================================");
    
    // 协议
    Protocol * __unsafe_unretained * protocols = class_copyProtocolList(cls, &outCount);
    Protocol * protocol;
    for (int i = 0; i < outCount; i++) {
        protocol = protocols[i];
        NSLog(@"protocol name: %s", protocol_getName(protocol));
    }
    
    NSLog(@"MyClass is%@ responsed to protocol %s", class_conformsToProtocol(cls, protocol) ? @"" : @" not", protocol_getName(protocol));
    
    NSLog(@"==========================================================");
}
#pragma mark - nil发送消息
typedef struct {
    int gender;
    float height;
}Person;
- (void)test_nil_sendmsg{
    [self test_nil_sendmsg:nil];
}
- (void)test_nil_sendmsg:(ClassLayoutVC *)vc{
    ClassLayoutVC *vct = vc;
    
    NSLog(@"%@",[vct noReturnValue]);
    NSLog(@"%@",[vct returnNssting]);
    Person p = [vct returnStruct];
    NSLog(@"%d %f",p.gender,p.height);
    
    
}
- (void *)noReturnValue{
    return @"2";
}
- (NSString *)returnNssting{
    return @"";
}

- (Person)returnStruct{
    Person p = {0,180};
    return p;
}

#pragma mark - meta-class 探究

- (void)meta_class_test{
    
    Class cls = objc_allocateClassPair([UIView class], "JLView", 0);
    class_addMethod(cls, @selector(submethod1), (IMP)imp_submethod1, "v@:");
//    class_replaceMethod(cls, @selector(method1), (IMP)imp_submethod1, "v@:");
    class_addIvar(cls, "nameLabel", sizeof(NSString *), log(sizeof(NSString *)), "i");
//
//    objc_property_attribute_t type = {"T", "@\"NSString\""};
//    objc_property_attribute_t ownership = { "C", "" };
//    objc_property_attribute_t backingivar = { "V", "_ivar1"};
//    objc_property_attribute_t attrs[] = {type, ownership, backingivar};
//
//    class_addProperty(cls, "property2", attrs, 3);
    objc_registerClassPair(cls);
    
    id instance = [[cls alloc] init];
    [instance performSelector:@selector(submethod1)];
}



static void imp_submethod1(id self, SEL _cmd){
    NSLog(@"This objcet is %p", self);
    NSLog(@"Class is %@, super class is %@", [self class], [self superclass]);
    
    Class currentClass = [self class];
    for (int i = 0; i < 4; i++) {
        NSLog(@"Following the isa pointer %d times gives %p", i, currentClass);
        currentClass = objc_getClass((__bridge void *)currentClass);
    }
    
    NSLog(@"NSObject's class is %p", [NSObject class]);
    NSLog(@"NSObject's meta class is %p", objc_getClass((__bridge void *)[NSObject class]));
}



@end
