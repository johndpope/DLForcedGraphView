#import "DLGraphDemoViewController.h"
#import "DLGraphView.h"

@interface DLGraphDemoViewController ()

- (IBAction)attractionDidChange:(UISlider *)sender;
- (IBAction)repulsionDidChange:(UISlider *)sender;

@end

@implementation DLGraphDemoViewController

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

    //TODO: дать возможность делать это в viewDidLoad
    [self showDebugInfo];
    DLGraphScene *scene = self.graphView.graphScene;

    NSArray *edges =  @[
        @[@0, @1],
        @[@1, @2],
        @[@2, @3],
        @[@3, @4],
        @[@4, @5],
        @[@5, @0]
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

- (IBAction)attractionDidChange:(UISlider *)sender {
    self.graphView.graphScene.attraction = sender.value;

}

- (IBAction)repulsionDidChange:(UISlider *)sender {
    self.graphView.graphScene.repulsion = sender.value;
}
@end