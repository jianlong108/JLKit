//
//  BLOsSinpostC.c
//  BLOsSignPosts
//
//  Created by JL on 2023/10/17.
//

#include "BLOsSinpostC.h"
#import <os/signpost.h>

static inline os_log_t creatWithBundleId(const char * bundleId, const char *key) {
   return os_log_create(bundleId, key);
}
const char * getGroupName(int groupId) {
    switch (groupId) {
        case 1:
            return "AppLaunch";
        case 2:
            return "threadCreat";
        case 3:
            return "threadCreat";
    }
    return "";
}
os_log_t launchLogger(void) {
    static os_log_t logger = NULL;
    if (!logger) {
        logger = creatWithBundleId("bigolive", "AppLaunch");
    }
    return logger;
}

os_signpost_id_t launchLoggerID(void) {
    static os_signpost_id_t loggerid = 0;
    if (loggerid == 0) {
        loggerid = os_signpost_id_generate(launchLogger());
    }
    return loggerid;
}

void bl_os_signpost_begin(char *name) {
//    os_signpost_id_t signPostId = os_signpost_id_make_with_pointer(launchLogger(),pointerId);
    // 标记时间段开始
    os_signpost_interval_begin(launchLogger(), launchLoggerID(), "AppLaunch","%{public}s",name);
}

void bl_os_signpost_end(char *name) {
//    os_signpost_id_t signPostId = os_signpost_id_make_with_pointer(launchLogger(),pointerId);
    // 标记时间段开始
    os_signpost_interval_end(launchLogger(), launchLoggerID(), "AppLaunch","%{public}s",name);
}

void bl_os_signpost_AppLaunch_event(char *name) {
    os_signpost_event_emit(launchLogger(), launchLoggerID(),"AppLaunch","%{public}s",name);
}

void bl_os_signpost_thread_creat_event(char *name) {

//    sprintf(thread_string, "thread:%d", thread_count++);
    os_signpost_event_emit(launchLogger(), launchLoggerID(),"threadCreat","%{public}s",name);
}
