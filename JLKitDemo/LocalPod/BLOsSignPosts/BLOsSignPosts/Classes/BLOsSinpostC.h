//
//  BLOsSinpostC.h
//  BLOsSignPosts
//
//  Created by JL on 2023/10/17.
//

#ifndef BLOsSinpostC_h
#define BLOsSinpostC_h

#include <stdio.h>
void bl_os_signpost_begin(char *name);
void bl_os_signpost_end(char *name);
void bl_os_signpost_AppLaunch_event(char *name);
void bl_os_signpost_thread_creat_event(char *name);
#endif /* BLOsSinpostC_h */
