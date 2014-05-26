#import <SpriteKit/SpriteKit.h>


@class DLEdge;


@protocol DLGraphSceneDelegate <NSObject>

- (void)configureVertex:(SKShapeNode *)vertex atIndex:(NSUInteger)index;

@end

@interface DLGraphScene : SKScene

@property (nonatomic, copy, readonly) NSArray *edges;
@property (nonatomic, assign) CGFloat repulsion;
@property (nonatomic, assign) CGFloat attraction;
@property (nonatomic, weak) id<DLGraphSceneDelegate> delegate;

- (void)addEdge:(DLEdge *)edge;
- (void)addEdges:(NSArray *)edges;
- (void)removeEdge:(DLEdge *)edge;
- (void)removeEdges:(NSArray *)edges;

@end