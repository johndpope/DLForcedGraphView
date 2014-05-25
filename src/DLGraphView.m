#import "DLGraphView.h"
#import "DLGraphScene.h"


@implementation DLGraphView

- (void)didMoveToSuperview
{
    [super didMoveToSuperview];
    DLGraphScene *scene = [[DLGraphScene alloc] initWithSize:self.bounds.size];
    scene.scaleMode = SKSceneScaleModeResizeFill;
    [self presentScene:scene];
}

@end