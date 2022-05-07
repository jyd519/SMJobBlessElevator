//
//  XDElevatorObject.m
//  Elevator
//
//  Created by Greg Thornton on 2/11/12.
//  Copyright (c) 2012 xdissent.com. All rights reserved.
//

#import "XDElevatorObject.h"

@implementation XDElevatorObject

- (NSString *)getVersion
{
    NSString* version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
    return version;
}

- (NSString *)getName:(NSString*)arg
{
    NSString* name =  @"Elevator ";
    name = [name stringByAppendingFormat:@"[%@] ", arg];
    return [name stringByAppendingString:[self getVersion]];
}

@end
