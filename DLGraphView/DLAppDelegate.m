//
//  DLAppDelegate.m
//  DLGraphView
//
//  Created by Dzianis Lebedzeu on 5/25/14.
//  Copyright (c) 2014 Home. All rights reserved.
//

#import "DLAppDelegate.h"

@implementation DLAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}

@end
