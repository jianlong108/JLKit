//
//  main.m
//  JLKitDemo
//
//  Created by Wangjianlong on 2017/1/12.
//  Copyright © 2017年 JL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
//#import <dlfcn.h>

int main(int argc, char * argv[]) {
    @autoreleasepool {
        return UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
    }
}

//void __sanitizer_cov_trace_pc_guard(uint32_t *guard) {
//    void *PC = __builtin_return_address(0);
//    Dl_info info;
//    dladdr(PC, &info);
//    printf("jl hook:%s \n",info.dli_sname);
//}
//
//void __sanitizer_cov_trace_pc_guard_init(uint32_t *start, uint32_t *stop) {
//    static uint64_t N;
//    if (start == stop || *start) return;
//    for (uint32_t *x = start; x < stop; x++) {
//        *x = ++N;
//    }
//    printf("jl hook INIT Count: %llu \n", N);
//}
