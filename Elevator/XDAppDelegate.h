//
//  XDAppDelegate.h
//  Elevator
//
//  Created by Greg Thornton on 2/11/12.
//  Copyright (c) 2012 xdissent.com. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <ServiceManagement/ServiceManagement.h>
#import <Security/Authorization.h>
#import "XDElevatorObject.h"

@interface XDAppDelegate : NSObject <NSApplicationDelegate>

@property (assign) IBOutlet NSWindow *window;
@property (weak) IBOutlet NSTextField *textField;

- (void)showMessage:(NSString *)msg;
- (AuthorizationRef)createAuthRef;
- (BOOL)blessHelperWithLabel:(NSString *)label withAuthRef:(AuthorizationRef)authRef error:(NSError **)error;

@end
