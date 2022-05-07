//
//  main.m
//  ElevatorDOHelper
//
//  Created by Greg Thornton on 2/11/12.
//  Copyright (c) 2012 xdissent.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <launch.h>
#import <syslog.h>
#import "XDElevatorObject.h"

int main (int argc, const char * argv[])
{

    @autoreleasepool {
        
        syslog(LOG_NOTICE, "ElevatorDOHelper launched (uid: %d, euid: %d, pid: %d)", getuid(), geteuid(), getpid());
        
        launch_data_t req = launch_data_new_string(LAUNCH_KEY_CHECKIN);
        launch_data_t resp = launch_msg(req);
        launch_data_t machData = launch_data_dict_lookup(resp, LAUNCH_JOBKEY_MACHSERVICES);
        launch_data_t machPortData = launch_data_dict_lookup(machData, "com.xdissent.ElevatorDOHelper.mach");

        mach_port_t mp = launch_data_get_machport(machPortData);
        launch_data_free(req);
        launch_data_free(resp);

        NSMachPort *rp = [[NSMachPort alloc] initWithMachPort:mp];
        NSConnection *c = [NSConnection connectionWithReceivePort:rp sendPort:nil];

        XDElevatorObject *obj = [XDElevatorObject new];
        [c setRootObject:obj];
        
        [[NSRunLoop currentRunLoop] run];
        
    }
    return 0;
}

