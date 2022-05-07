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
    // Get authorization
    AuthorizationRef authRef = [self createAuthRef];
    if (authRef == NULL) {
        [self showMessage:@"Authorization failed"];
        return;
    }
    
    // Bless Helper
    NSError *error = nil;
    if (![self blessHelperWithLabel:@"com.xdissent.ElevatorDOHelper" withAuthRef:authRef error:&error]) {
        [self showMessage:@"Failed to bless helper"];
        return;
    }
    
    // Connect to DO
    [self showMessage:@"Connecting to DO"];
    NSConnection *c = [NSConnection connectionWithRegisteredName:@"com.xdissent.ElevatorDOHelper.mach" host:nil]; 
    XDElevatorObject *proxy = (XDElevatorObject *)[c rootProxy];
    
    // Get name from DO
    NSString *name = [proxy getName];
    if (name == nil) {
        [self showMessage:@"Could not get name"];
        return;
    }
    [self showMessage:[NSString stringWithFormat:@"Got name from DO: %@", name]];
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
