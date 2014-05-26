//
//  DLAppDelegate.m
//  DLGraphViewOSX
//
//  Created by Dzianis Lebedzeu on 5/26/14.
//  Copyright (c) 2014 Home. All rights reserved.
//

#import "DLAppDelegate.h"
#import "DLOSXDemoViewController.h"

@interface DLAppDelegate ()

@property (nonatomic, strong) NSViewController *viewController;

@end

@implementation DLAppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    self.viewController = [[DLOSXDemoViewController alloc] initWithNibName:nil bundle:nil];
    self.viewController.view.frame = ((NSView*)self.window.contentView).bounds;
    [self.window.contentView addSubview:self.viewController.view];
    
}

@end
