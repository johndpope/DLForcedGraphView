@interface DLGraphScene : SKScene

@property (nonatomic, copy, readonly) NSArray *edges;

@property (nonatomic, assign) CGFloat repulsion;
@property (nonatomic, assign) CGFloat attraction;

- (void)addEdge:(NSArray *)edge;
- (void)addEdges:(NSArray *)edges;
- (void)removeEdge:(NSArray *)edge;
- (void)removeEdges:(NSArray *)edges;

@end