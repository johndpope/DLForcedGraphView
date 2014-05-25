#import "DLGraphDemoViewController.h"
#import "DLGraphView.h"

@interface DLGraphDemoViewController ()

@end

@implementation DLGraphDemoViewController

- (void)loadView
{
    self.view = [[DLGraphView alloc] initWithFrame:CGRectZero];
    self.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self showDebugInfo];
    DLGraphScene *scene = self.graphView.scene;

    NSArray *edges =  @[
        @[@0, @1],
        @[@1, @2],
        @[@2, @3],
        @[@3, @4],
    ];

    [scene addEdges:edges];
}

- (void)showDebugInfo
{
    self.graphView.showsDrawCount = YES;
    self.graphView.showsNodeCount = YES;
    self.graphView.showsFPS = YES;
    self.graphView.showsPhysics = YES;
}

- (DLGraphView *)graphView
{
    return (DLGraphView *)self.view;
}

@end