//
//  AppDelegate.m
//  AddToReminders
//
//  Created by Harshad Dange on 22/07/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate

@synthesize window = _window;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    // Insert code here to initialize your application
}

- (void)applicationDidBecomeActive:(NSNotification *)notification {
    [self.window makeKeyAndOrderFront:self];
}



- (BOOL)applicationShouldTerminateAfterLastWindowClosed:(NSApplication *)sender {
    return NO;
}

@end
