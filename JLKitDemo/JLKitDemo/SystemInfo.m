#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <sys/ioctl.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <netdb.h>
#include <arpa/inet.h>
#include <sys/sockio.h>
#include <net/if.h>
#include <errno.h>
#include <net/if_dl.h>
#import <mach/mach.h>

#include <sys/socket.h> // Per msqr
#include <sys/sysctl.h>

#import "SystemInfo.h"

enum {
    MODEL_IPHONE_SIMULATOR,
    MODEL_IPOD_TOUCH,
    MODEL_IPHONE,
    MODEL_IPHONE_3G,
    MODEL_IPAD
};

@implementation SystemInfo

#pragma mark - Base

+ (NSString *)osVersion
{
	return [NSString stringWithFormat:@"%@ %@", [UIDevice currentDevice].systemName, [UIDevice currentDevice].systemVersion];
}

+ (NSString *)systemVersion
{
	return [UIDevice currentDevice].systemVersion;
}

+ (NSString *)appVersion
{
	return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
}

+ (NSString *)deviceModel
{
	return [UIDevice currentDevice].model;
}

+ (NSString *)bundleId
{
    NSString *bundleId = [[NSBundle mainBundle] bundleIdentifier];
    return bundleId;
}


+ (NSString *)deviceName
{
    return [UIDevice currentDevice].name;
}

+ (NSString *)systemName
{
    return [[UIDevice currentDevice] systemName];
}

#pragma mark - JailBroken

static const char * __jb_app = NULL;

+ (BOOL)isJailBroken
{
	static const char * __jb_apps[] =
	{
		"/Application/Cydia.app", 
		"/Application/limera1n.app", 
		"/Application/greenpois0n.app", 
		"/Application/blackra1n.app",
		"/Application/blacksn0w.app",
		"/Application/redsn0w.app",
        "/Applications/Absinthe.app",
		NULL
	};

	__jb_app = NULL;

	// method 1
    for ( int i = 0; __jb_apps[i]; ++i )
    {
        if ( [[NSFileManager defaultManager] fileExistsAtPath:[NSString stringWithUTF8String:__jb_apps[i]]] )
        {
			__jb_app = __jb_apps[i];
			return YES;
        }
    }
    // method 2
//	if ([[NSFileManager defaultManager] fileExistsAtPath:@"/private/var/lib/apt/"] )
//	{
//        __jb_app = "/private/var/lib/apt";
//		return YES;
//	}
	
	// method 3

    // 尝试执行linux系统命令ls列出当前目录下的文件，若返回值为0表示执行成功
    // 这个方法在某些系统(iOS 8.1.2)的机器上(iPhone6)会导致崩溃，在simulator上运行也会偶尔崩溃
    // 且查阅网上资料发现较少用到这个方法来判断越狱与否，因此暂时屏蔽
//	if ( 0 == system("ls") )
//	{
//		return YES;
//	}
	
    return NO;	
}

+ (NSString *)jailBreaker
{
	if ( __jb_app )
	{
		return [NSString stringWithUTF8String:__jb_app];
	}
	else
	{
		return @"";
	}
}

#pragma mark - Device

+ (NSString *) macaddress
{
    //ios7:[UIDevice identifierForVendor]
	int                  mib[6];
	size_t               len;
	char                *buf;
	unsigned char        *ptr;
	struct if_msghdr    *ifm;
	struct sockaddr_dl    *sdl;
    
	mib[0] = CTL_NET;
	mib[1] = AF_ROUTE;
	mib[2] = 0;
	mib[3] = AF_LINK;
	mib[4] = NET_RT_IFLIST;
    
	
	if ((mib[5] = if_nametoindex("en0")) == 0) {
		return nil;
	}
    
	
	if (sysctl(mib, 6, NULL, &len, NULL, 0) < 0) {
		return nil;
	}
    
	
	if ((buf = (char *)malloc(len)) == NULL) {
		return nil;
	}
    
	if (sysctl(mib, 6, buf, &len, NULL, 0) < 0) {
        free(buf);
		return nil;
	}
    
	
	ifm = (struct if_msghdr *)buf;
	sdl = (struct sockaddr_dl *)(ifm + 1);
	ptr = (unsigned char *)LLADDR(sdl);
    
	// NSString *outstring = [NSString stringWithFormat:@"%02x:%02x:%02x:%02x:%02x:%02x", *ptr, *(ptr+1), *(ptr+2), *(ptr+3), *(ptr+4), *(ptr+5)];
    
	NSString *outstring = [NSString stringWithFormat:@"%02x%02x%02x%02x%02x%02x", *ptr, *(ptr+1), *(ptr+2), *(ptr+3), *(ptr+4), *(ptr+5)];
	free(buf);
    
	return [outstring uppercaseString];
}

+ (UIDevice*)device
{
    return [UIDevice currentDevice];
}

+ (uint) detectDevice {
    NSString *model= [[UIDevice currentDevice] model];
    
    // Some iPod Touch return "iPod Touch", others just "iPod"
    
    NSString *iPodTouch = @"iPod";
    NSString *iPad = @"iPad";
    NSString *iPhoneSimulator = @"iPhone Simulator";
    
    NSRange result = [model rangeOfString:iPhoneSimulator];
    if (result.location != NSNotFound) {
        // iPhone simulator
        return MODEL_IPHONE_SIMULATOR;
    }
    
    result = [model rangeOfString:iPad];
    if (result.location != NSNotFound) {
        // iPad
        return MODEL_IPAD;
    }
    
    result = [model rangeOfString:iPodTouch];
    if (result.location != NSNotFound) {
        //iPodTouch
        return MODEL_IPOD_TOUCH;
    }
    
    return MODEL_IPHONE;

    
    /*
    // Could be an iPhone V1 or iPhone 3G (model should be "iPhone")
    struct utsname u;
    // u.machine could be "i386" for the simulator, "iPod1,1" on iPod Touch, "iPhone1,1" on iPhone V1 & "iPhone1,2" on iPhone3G
    
    uname(&u);
    
    if (!strcmp(u.machine, "iPhone1,1")) {
        detected = MODEL_IPHONE;
    } else {
        detected = MODEL_IPHONE_3G;
    }*/
}

+ (BOOL)isTotalMemoryBelow512M {
    static BOOL isBelow = NO;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        int64_t mem = [[NSProcessInfo processInfo] physicalMemory];
        if (mem <= 512 * 1024 * 1024) isBelow = YES;
    });
    return isBelow;
}

+ (BOOL)isTotalMemoryBelow2G {
    static BOOL isBelow = NO;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        uint64_t mem = [[NSProcessInfo processInfo] physicalMemory];
        isBelow = mem <= 2048 * 1024 * 1024;
    });
    return isBelow;
}

+ (vm_size_t)usedMemoryLikeXcode {
#if TARGET_OS_OSX
#else
    if ([[UIDevice currentDevice].systemVersion intValue] < 10) {
        kern_return_t kr;
        mach_msg_type_number_t info_count;
        task_vm_info_data_t vm_info;
        info_count = TASK_VM_INFO_COUNT;
        kr = task_info(mach_task_self(), TASK_VM_INFO_PURGEABLE, (task_info_t)&vm_info, &info_count);
        if (kr == KERN_SUCCESS) {
            return (vm_size_t)(vm_info.internal + vm_info.compressed - vm_info.purgeable_volatile_pmap);
        }
        return 0;
    }
#endif
    task_vm_info_data_t vmInfo;
    mach_msg_type_number_t count = TASK_VM_INFO_COUNT;
    kern_return_t result = task_info(mach_task_self(), TASK_VM_INFO, (task_info_t)&vmInfo, &count);
    if (result != KERN_SUCCESS)
        return 0;
    return (vm_size_t)vmInfo.phys_footprint;
}

#pragma mark - Disk

+ (float)totalDiskSpace
{
    float totalSpace = 0;
    NSDictionary *dictionary = [[NSFileManager defaultManager] attributesOfFileSystemForPath:NSHomeDirectory() error:nil];
    
    if (dictionary)
    {
        NSNumber *fileSystemSizeInBytes = [dictionary objectForKey:NSFileSystemSize];
        totalSpace = [fileSystemSizeInBytes floatValue];
    }
    
    return totalSpace;
}

+ (float)freeDiskSpace
{
    float freespace = 0;
    NSDictionary *dictionary = [[NSFileManager defaultManager] attributesOfFileSystemForPath:NSHomeDirectory() error:nil];
    
    if (dictionary)
    {
        NSNumber *freeFileSystemSizeInBytes = [dictionary objectForKey:NSFileSystemFreeSize];
        freespace = [freeFileSystemSizeInBytes floatValue];
    }
    
    return freespace;
}


+ (int64_t)deviceMemory {
    static int64_t gTotalMemory = 0;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        gTotalMemory = [[NSProcessInfo processInfo] physicalMemory];
        if (gTotalMemory < -1) gTotalMemory = -1;
    });
    return gTotalMemory;
}

#pragma mark - Device Model

+ (CGSize)screenCurrentModeSize {
    static CGSize size;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        size = [[UIScreen mainScreen] currentMode].size;
    });
    return size;
}

+ (BOOL)isPad {
    static BOOL isPad = NO;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        isPad = [SystemInfo detectDevice] == MODEL_IPAD;
    });
    return isPad;
}

+ (BOOL)isIPodTouch {
    static BOOL isIPodTouch = NO;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        isIPodTouch = [SystemInfo detectDevice] == MODEL_IPOD_TOUCH;
    });
    return isIPodTouch;
}

+ (BOOL)isRetina {
    static BOOL isRetina = NO;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        isRetina = [self screenCurrentModeSize].width >= 640;
    });
    return isRetina;
}

+ (BOOL)isIPhone4 {
    static BOOL isIPhone4 = NO;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        isIPhone4 = (CGSizeEqualToSize(CGSizeMake(640, 960), [self screenCurrentModeSize]) ||
                     CGSizeEqualToSize(CGSizeMake(320, 480), [self screenCurrentModeSize]) ||
                     CGSizeEqualToSize(CGSizeMake(320, 480), [[UIScreen mainScreen] bounds].size));
    });
    return isIPhone4;
}

+ (BOOL)isIPhone5 {
    static BOOL isIPhone5 = NO;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        isIPhone5 = CGSizeEqualToSize(CGSizeMake(640, 1136), [self screenCurrentModeSize]);
    });
    return isIPhone5;
}

+ (BOOL)isIPhone6 {
    static BOOL isIPhone6 = NO;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        isIPhone6 = (CGSizeEqualToSize(CGSizeMake(750, 1334), [self screenCurrentModeSize]));
    });
    return isIPhone6;
}

+ (BOOL)isIPhone6Plus {
    static BOOL isIPhone6Plus = NO;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        isIPhone6Plus = (CGSizeEqualToSize(CGSizeMake(1125, 2001), [self screenCurrentModeSize]) ||
                         CGSizeEqualToSize(CGSizeMake(1242, 2208), [self screenCurrentModeSize]));
    });
    return isIPhone6Plus;
}

+ (BOOL)isIPhoneX {
    static BOOL isIPhoneX = NO;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        isIPhoneX = (CGSizeEqualToSize(CGSizeMake(1242, 2688), [self screenCurrentModeSize]) ||
                     CGSizeEqualToSize(CGSizeMake(1125, 2436), [self screenCurrentModeSize]) ||
                     CGSizeEqualToSize(CGSizeMake(828, 1792), [self screenCurrentModeSize]) ||
                     CGSizeEqualToSize(CGSizeMake(750, 1624), [self screenCurrentModeSize]) ||
                     CGSizeEqualToSize(CGSizeMake(1170, 2532), [self screenCurrentModeSize]) ||
                     CGSizeEqualToSize(CGSizeMake(1284, 2778), [self screenCurrentModeSize]) ||
                     CGSizeEqualToSize(CGSizeMake(1179, 2556), [self screenCurrentModeSize]) ||
                     CGSizeEqualToSize(CGSizeMake(1290, 2796), [self screenCurrentModeSize]));
    });
    return isIPhoneX;
}

@end
