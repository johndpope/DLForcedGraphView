#import "DLGraphDemoViewController.h"
#import "DLForcedGraphView.h"
#import "DLEdge.h"

@interface DLGraphDemoViewController () <DLGraphSceneDelegate>

- (IBAction)attractionDidChange:(UISlider *)sender;
- (IBAction)repulsionDidChange:(UISlider *)sender;

@end

@implementation DLGraphDemoViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self showDebugInfo];

    DLGraphScene *scene = self.graphView.graphScene;
    scene.delegate = self;

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

- (void)showDebugInfo
{
    self.graphView.showsDrawCount = YES;
    self.graphView.showsNodeCount = YES;
    self.graphView.showsFPS = YES;
    self.graphView.showsPhysics = YES;
}

- (DLForcedGraphView *)graphView
{
    return (DLForcedGraphView *)self.view;
}

- (IBAction)attractionDidChange:(UISlider *)sender
{
    self.graphView.graphScene.attraction = sender.value;
}

- (IBAction)repulsionDidChange:(UISlider *)sender
{
    self.graphView.graphScene.repulsion = sender.value;
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