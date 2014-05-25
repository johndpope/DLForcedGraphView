#import "DLForcedGraphView.h"

@interface DLForcedGraphView ()

@property (nonatomic, strong, readwrite) DLGraphScene *graphScene;

@end

@implementation DLForcedGraphView

- (void)didMoveToSuperview
{
    [super didMoveToSuperview];
    self.scene.scaleMode = SKSceneScaleModeResizeFill;
    [self presentScene:self.scene];
}

- (DLGraphScene *)graphScene
{
    if (!_graphScene) {
        _graphScene = [[DLGraphScene alloc] initWithSize:self.bounds.size];
    }
    return _graphScene;
}

- (SKScene *)scene
{
    return [self graphScene];
}

@end