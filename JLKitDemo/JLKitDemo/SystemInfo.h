#import <UIKit/UIKit.h>

#define IOS12_OR_LATER BG_SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"12.0")
#define IOS13_OR_LATER BG_SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"13.0")
#define IOS14_OR_LATER BG_SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"14.0")

#define BG_SYSTEM_VERSION_EQUAL_TO(v) ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define BG_SYSTEM_VERSION_GREATER_THAN(v) ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define BG_SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v) \
    ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define BG_SYSTEM_VERSION_LESS_THAN(v) ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define BG_SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v) \
    ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)

#define iPhone4 ([SystemInfo isIPhone4])  // iPhone3G也算作iPhone4中 ipad上显示也算作iPhone4

#define iPhone5 ([SystemInfo isIPhone5])

#define iPhone6 ([SystemInfo isIPhone6])

#define iPhone6Plus ([SystemInfo isIPhone6Plus])

#define iPhoneX ([SystemInfo isIPhoneX])

// 状态栏高度
#define STATUS_BAR_HEIGHT (iPhoneX ? 44.f : 20.f)
// 导航栏 & 状态栏 高度
#define NAVIGATION_BAR_HEIGHT (iPhoneX ? 88.f : 64.f)
// home indicator
#define HOME_INDICATOR_HEIGHT (iPhoneX ? 34.f : 0.f)

#define portraiteSafeTopInset (iPhoneX ? 44 : 0)

#define portraiteSafeBottomInset (iPhoneX ? 34 : 0) // tabBar高度

#define tabBarHeight (iPhoneX ? (49.f + 34.f) : (49.f))

#define landscapeSafeLeftAndRightInset (iPhoneX ? 44 : 0)


#define landscapeSafeBottomInset (iPhoneX ? 21 : 0)

#define AppFrameHeight [[UIScreen mainScreen] applicationFrame].size.height
#define AppFrameWidth [[UIScreen mainScreen] applicationFrame].size.width

#define ScreenHeight [[UIScreen mainScreen] bounds].size.height
#define ScreenWidth [[UIScreen mainScreen] bounds].size.width

#define SCREEN_MIN MIN(ScreenHeight, ScreenWidth)
#define SCREEN_MAX MAX(ScreenHeight, ScreenWidth)

#define SuitableWidthSince320(a) (CGFloat)(a) / 320.f * ScreenWidth //设备屏幕宽度变大时候，（相对于iPhone4，5）宽度等比例拉伸
#define SuitableHeightSince480(a) (CGFloat)(a) / 480.f * ScreenHeight //设备屏幕高度变大时候，（相对于iPhone4）高度等比例拉伸
#define SuitableWidthFixedBothSide(a) ScreenWidth - 2 * (a)           //固定两边。中间拉伸
#define SuitableXFromRight(a) (ScreenWidth - (a))                     //右对齐

#define OnePixel (1.0f / [[UIScreen mainScreen] scale])

#define CURRENT_APP_LAN ([[[[NSBundle mainBundle] preferredLocalizations] firstObject] uppercaseString])

NS_ASSUME_NONNULL_BEGIN

@interface SystemInfo : NSObject

+ (NSString *)osVersion;
+ (NSString *)appVersion;
+ (NSString *)systemVersion;
+ (NSString *)deviceModel;
+ (NSString *)bundleId;
+ (NSString *)deviceName;
+ (NSString *)systemName;
+ (BOOL)isJailBroken;
+ (NSString *)jailBreaker;
+ (NSString *)macaddress;

+ (UIDevice *)device;

+ (float)totalDiskSpace; // 获取设备总空间(Byte)
+ (float)freeDiskSpace;  // 获取设备剩余空间(Byte)
+ (int64_t)deviceMemory; // 获取设备内存(Byte)

+ (BOOL)isTotalMemoryBelow512M;
+ (BOOL)isTotalMemoryBelow2G;
+ (vm_size_t)usedMemoryLikeXcode;

// device model
+ (BOOL)isPad;
+ (BOOL)isIPodTouch;
+ (BOOL)isRetina;
+ (BOOL)isIPhone4;
+ (BOOL)isIPhone5;
+ (BOOL)isIPhone6;
+ (BOOL)isIPhone6Plus;
+ (BOOL)isIPhoneX;

@end

NS_ASSUME_NONNULL_END
