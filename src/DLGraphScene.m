#import "DLGraphScene.h"
#import "DLGraphScene+Private.h"
#import "DLEdge.h"


@interface DLGraphScene ()

@property (nonatomic, strong) SKNode *touchedNode;
@property (nonatomic , assign) BOOL contentCreated;
@property (nonatomic, assign) BOOL stable;
@property (nonatomic, strong) NSMutableArray *mutableEdges;

@end


@implementation DLGraphScene

#pragma mark - SKScene

- (instancetype)initWithSize:(CGSize)size
{
    if (self = [super initWithSize:size]) {
        _connections = [NSMutableDictionary dictionary];
        _vertices = [NSMutableDictionary dictionary];
        _mutableEdges = [NSMutableArray array];

        _repulsion = 600.f;
        _attraction = 0.1f;
    }

    return self;
}

- (void)didMoveToView:(SKView *)view
{
    if (self.contentCreated == NO)
    {
        [self createSceneContents];
        self.contentCreated = YES;
    }
}

- (void)didSimulatePhysics
{
    //нужно как то давать системе разогнаться
//    CGFloat xVelocity = 0.f;
//    CGFloat yVelocity = 0.f;
//
//    for (SKShapeNode *vertice in self.vertices) {
//        xVelocity += vertice.physicsBody.velocity.dx;
//        yVelocity += vertice.physicsBody.velocity.dy;
//    }
//
//    NSLog(@"%.3f, %.3f", xVelocity, yVelocity);
//    if (ABS(xVelocity) < 0.01 && ABS((yVelocity) < 0.01)) {
//        self.stable = YES;
//    }
}

- (void)update:(NSTimeInterval)currentTime
{
    if (self.stable) {
        return;
    }

    NSUInteger n = self.vertices.count;

    for  (NSUInteger i = 0; i < n; i++) {
        SKShapeNode *v = self.vertices[@(i)];
        SKSpriteNode *u;

        CGFloat vForceX = 0;
        CGFloat vForceY = 0;

        for (NSUInteger j = 0; j < n; j++) {
            if (i == j) continue;

            u = self.vertices[@(j)];

            double rsq = pow((v.position.x - u.position.x), 2) + pow((v.position.y - u.position.y), 2);
            vForceX += self.repulsion * (v.position.x - u.position.x) / rsq;
            vForceY += self.repulsion * (v.position.y - u.position.y) / rsq;
        }

        for (NSUInteger j = 0; j < n; j++) {
            if(![self hasConnectedA:i toB:j]) continue;

            u = self.vertices[@(j)];;

            vForceX += self.attraction * (u.position.x - v.position.x);
            vForceY += self.attraction * (u.position.y - v.position.y);
        }

        v.physicsBody.linearDamping = 0.95;
        v.physicsBody.velocity = CGVectorMake((v.physicsBody.velocity.dx + vForceX),
                                              (v.physicsBody.velocity.dy + vForceY));

        [v.physicsBody applyForce:CGVectorMake(vForceX, vForceY)];
        v.physicsBody.angularVelocity = 0;
    }

    [self updateConnections];
}

- (void)didChangeSize:(CGSize)oldSize
{
    [super didChangeSize:oldSize];
    self.physicsBody = [SKPhysicsBody bodyWithEdgeLoopFromRect:self.frame];
}

#pragma mark - Public

- (NSArray *)edges
{
    return [self.mutableEdges copy];
}

- (void)addEdge:(DLEdge *)edge
{
    [self.mutableEdges addObject:edge];

    [self createVerticesForEdge:edge];
    [self createConnectionForEdge:edge];
}

- (void)addEdges:(NSArray *)edges
{
    for (DLEdge *edge in edges) {
        [self addEdge:edge];
    }
}

- (void)removeEdge:(DLEdge *)edge
{
    [self.mutableEdges removeObject:edge];

    SKShapeNode *connection = self.connections[edge];
    [connection removeFromParent];
    [self.connections removeObjectForKey:edge];
}

- (void)removeEdges:(NSArray *)edges
{
    for (DLEdge *edge in edges) {
        [self removeEdge:edge];
    }
}

#pragma mark - Private

- (void)createVertexWithIndex:(NSUInteger)index
{
    SKShapeNode *circle = [self createVertexNode];
    [self.delegate configureVertex:circle atIndex:index];

    circle.position = CGPointMake(arc4random() % (NSUInteger)self.size.width,
                                  arc4random() % (NSUInteger)self.size.height);
    [self addChild:circle];
    self.vertices[@(index)] = circle;
}

- (void)createConnectionForEdge:(DLEdge *)edge
{
    SKShapeNode *connection = [SKShapeNode node];
    connection.strokeColor = [UIColor redColor];
    connection.fillColor = [UIColor redColor];
    connection.lineWidth = 3.f;

    [self addChild:connection];
    self.connections[edge] = connection;
}

- (void)createVerticesForEdge:(DLEdge *)edge
{
    [self createVertexIfNeeded:edge.i];
    [self createVertexIfNeeded:edge.j];
}

- (void)createVertexIfNeeded:(NSUInteger)index
{
    if (self.vertices[@(index)] == nil) {
        [self createVertexWithIndex:index];
    }
}

- (void)createSceneContents
{
    self.backgroundColor = [SKColor blueColor];
    self.physicsWorld.gravity = CGVectorMake(0,0);
}

- (void)updateConnections
{
    [self.connections enumerateKeysAndObjectsUsingBlock:^(DLEdge *key, SKShapeNode *connection, BOOL *stop) {
        CGMutablePathRef pathToDraw = CGPathCreateMutable();

        SKNode *vertexA = self.vertices[@(key.i)];
        SKNode *vertexB = self.vertices[@(key.j)];

        CGPathMoveToPoint(pathToDraw, NULL, vertexA.position.x, vertexA.position.y);
        CGPathAddLineToPoint(pathToDraw, NULL, vertexB.position.x, vertexB.position.y);
        connection.path = pathToDraw;
    }];
}

- (BOOL)hasConnectedA:(NSUInteger)a toB:(NSUInteger)b
{
    return  [self.edges containsObject:DLMakeEdge(a, b)];
}

- (SKShapeNode *)createVertexNode {
#warning shape node ликуют - проверить.
    SKShapeNode *node = [SKShapeNode node];
    node.zPosition = 10;
    node.physicsBody.allowsRotation = NO;
    node.name = @"circle";
    CGFloat diameter = 40;
    CGRect circleRect = CGRectMake(- diameter / 2, - diameter / 2, diameter, diameter);
    node.path =CGPathCreateWithEllipseInRect(circleRect, nil);
    node.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:diameter / 2];

    return node;
}

#pragma mark - Touch handling

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint positionInScene = [touch locationInNode:self];
    [self selectNodeForTouch:positionInScene];
}

- (void)selectNodeForTouch:(CGPoint)touchLocation
{
    NSArray *nodes = [self nodesAtPoint:touchLocation];
    NSPredicate *predicate = [NSPredicate predicateWithBlock:^BOOL(SKNode *_node, id _) {
        return [_node.name isEqualToString:@"circle"];
    }];

    SKNode *node = [nodes filteredArrayUsingPredicate:predicate].firstObject;

    self.touchedNode = node;
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint positionInScene = [touch locationInNode:self];
    self.touchedNode.position = positionInScene;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self endTouch];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self endTouch];
}

- (void)endTouch
{
    self.touchedNode = nil;
}

@end
