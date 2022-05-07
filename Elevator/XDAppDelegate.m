//
//  XDAppDelegate.m
//  Elevator
//
//  Created by Greg Thornton on 2/11/12.
//  Copyright (c) 2012 xdissent.com. All rights reserved.
//
// [subject.CN] = "Apple Development: Yongdong Ji (3R2KBU63T4)" and certificate 1[field.1.2.840.113635.100.6.2.1] /* exists */


#import "XDAppDelegate.h"

@implementation XDAppDelegate

@synthesize window = _window;
@synthesize textField;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
  XDElevatorObject* obj = [self getElevatorObject];
  if (!obj) {
    [self installHelper];
  }
  NSString* version = [obj getVersion];
  if (![version isEqualToString:@"1.5"]) {
     [self installHelper];
     obj = [self getElevatorObject];
  }
  NSString* name = [obj getName:@"????"];
  [self showMessage:[NSString stringWithFormat:@"Got name from DO: %@", name]];
}

- (XDElevatorObject*) getElevatorObject
{
  NSConnection *c = [NSConnection connectionWithRegisteredName:@"com.xdissent.ElevatorDOHelper.mach" host:nil];
  if (c == nil) {
    return nil;
  }
  
  XDElevatorObject *proxy = (XDElevatorObject *)[c rootProxy];
  return proxy;
}

- (bool) installHelper
{
    // Get authorization
    AuthorizationRef authRef = [self createAuthRef];
    if (authRef == NULL) {
        [self showMessage:@"Authorization failed"];
        return false;
    }
    
    // Bless Helper
    NSError *error = nil;
    if (![self blessHelperWithLabel:@"com.xdissent.ElevatorDOHelper" withAuthRef:authRef error:&error]) {
        [self showMessage:@"Failed to bless helper"];
        return false;
    }
  return true;
}
- (void)showMessage:(NSString *)msg
{
    NSLog(@"%@", msg);
    [[self textField] setStringValue:msg];
}

- (AuthorizationRef)createAuthRef
{
    AuthorizationRef authRef = NULL;
    AuthorizationItem authItem = { kSMRightBlessPrivilegedHelper, 0, NULL, 0 };
    AuthorizationRights authRights = { 1, &authItem };
    AuthorizationFlags flags = kAuthorizationFlagDefaults | kAuthorizationFlagInteractionAllowed | kAuthorizationFlagPreAuthorize | kAuthorizationFlagExtendRights;
    
    OSStatus status = AuthorizationCreate(&authRights, kAuthorizationEmptyEnvironment, flags, &authRef);
    if (status != errAuthorizationSuccess) {
        NSLog(@"Failed to create AuthorizationRef, return code %i", status);
    }
    
    return authRef;
}

- (BOOL)blessHelperWithLabel:(NSString *)label withAuthRef:(AuthorizationRef)authRef error:(NSError **)error
{
    CFErrorRef err;
    BOOL result = SMJobBless(kSMDomainSystemLaunchd, (__bridge CFStringRef)label, authRef, &err);
    *error = (__bridge NSError *)err;
    
    return result;
}

@end
