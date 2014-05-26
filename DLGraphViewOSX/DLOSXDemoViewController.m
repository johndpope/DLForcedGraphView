//
//  DLOSXDemoViewController.m
//  DLGraphView
//
//  Created by Dzianis Lebedzeu on 5/26/14.
//  Copyright (c) 2014 Home. All rights reserved.
//

#import "DLOSXDemoViewController.h"
#import "DLForcedGraphView.h"
#import "DLEdge.h"

@interface DLOSXDemoViewController () <DLGraphSceneDelegate>

@end

@implementation DLOSXDemoViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        DLGraphScene *scene = self.graphView.graphScene;
        scene.delegate = self;
        [self showDebugInfo];
        
        NSArray *edges = @[
                           DLMakeEdge(0, 1),
                           DLMakeEdge(1, 2),
                           DLMakeEdge(2, 3),
                           DLMakeEdge(3, 0),
                           DLMakeEdge(3, 4),
                           DLMakeEdge(4, 5),
                           DLMakeEdge(4, 6),
                           DLMakeEdge(4, 7),
                           DLMakeEdge(4, 8),
                           ];
        
        [scene addEdges:edges];
        
        [scene performSelector:@selector(removeEdge:) withObject:DLMakeEdge(0, 1) afterDelay:4.0];
        [scene performSelector:@selector(addEdge:) withObject:DLMakeEdge(0, 1) afterDelay:7.0];
    }

    return self;
}

- (DLForcedGraphView *)graphView
{
    return (DLForcedGraphView *)self.view;
}

- (void)showDebugInfo
{
    self.graphView.showsDrawCount = YES;
    self.graphView.showsNodeCount = YES;
    self.graphView.showsFPS = YES;
    //self.graphView.showsPhysics = YES;
}

#pragma mark - DLGraphSceneDelegate

- (void)configureVertex:(SKShapeNode *)vertex atIndex:(NSUInteger)index
{
    vertex.strokeColor = vertex.fillColor = [SKColor greenColor];
    SKLabelNode *label = [SKLabelNode node];
    label.text = [@(index) stringValue];
    [vertex addChild:label];
}

@end
