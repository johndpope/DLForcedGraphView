#import "DLGraphScene.h"
#import "DLGraphScene+Private.h"


@interface DLGraphScene ()

@property (nonatomic, strong) SKNode *touchedNode;
@property (nonatomic , assign) BOOL contentCreated;
@property (nonatomic, assign) BOOL stable;
@property (nonatomic, assign) NSUInteger nodesCount;

@property (nonatomic, strong) NSMutableArray *mutableEdges;

@end


@implementation DLGraphScene

- (instancetype)initWithSize:(CGSize)size
{
    if (self = [super initWithSize:size]) {
        _connections = [NSMutableDictionary dictionary];
        _vertices = [NSMutableDictionary dictionary];
        _mutableEdges = [NSMutableArray array];

        _repulsion = 800.f;
        _attraction = 0.1f;
    }

    return self;
}

- (void)didMoveToView:(SKView *)view
{
    if (!self.contentCreated)
    {
        [self createSceneContents];
        self.contentCreated = YES;
    }
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        [self addEdge:@[@0, @4]];
//    });
}

- (void)createSceneContents
{
    self.backgroundColor = [SKColor blueColor];
    self.physicsWorld.gravity = CGVectorMake(0,0);
}

- (void)didChangeSize:(CGSize)oldSize {
    [super didChangeSize:oldSize];
    self.physicsBody = [SKPhysicsBody bodyWithEdgeLoopFromRect:self.frame];
}

- (NSArray *)edges
{
    return [self.mutableEdges copy];
}

- (void)addEdge:(NSArray *)edge
{
    [self.mutableEdges addObject:edge];

    [self createVerticesForEdge:edge];
    [self createConnectionFroEdge:edge];
}

- (void)addEdges:(NSArray *)edges
{
    for (NSArray *edge in edges) {
        [self addEdge:edge];
    }
}

- (void)removeEdge:(NSArray *)edge
{

}

- (void)removeEdges:(NSArray *)edges
{

}

- (void)createConnectionFroEdge:(NSArray *)edge
{
    SKShapeNode *connection = [SKShapeNode node];
    connection.strokeColor = [UIColor redColor];
    connection.fillColor = [UIColor redColor];
    connection.lineWidth = 3.f;

    [self addChild:connection];
    self.connections[edge] = connection;
}

- (void)createVerticesForEdge:(NSArray *)edge
{
    [self createVertexIfNeeded:edge.firstObject];
    [self createVertexIfNeeded:edge.lastObject];
}

- (void)createVertexIfNeeded:(NSNumber *)index
{
    if (self.vertices[index] == nil) {
        [self createVertexWithIndex:index];
    }
}

- (void)createVertexWithIndex:(NSNumber *)index
{
    SKShapeNode *circle = [self newCircleWithIndex:index.unsignedIntegerValue];
    circle.position = CGPointMake(arc4random() % (NSUInteger)self.size.width,
                                  arc4random() % (NSUInteger)self.size.height);
    [self addChild:circle];
    self.vertices[index] = circle;
}

- (NSUInteger)calculateNodesCount
{
    NSUInteger nodesCount = 0;
    for (NSArray *edge in self.edges) {
        nodesCount = MAX(MAX([edge[0] integerValue], [edge[1] integerValue]), nodesCount) ;
    }

    return ++nodesCount;
}

- (void)update:(NSTimeInterval)currentTime
{
    if (self.stable) {
        return;
    }

    NSUInteger n = self.vertices.count;

    NSArray *vertices = self.vertices.allValues;

    for  (NSUInteger i = 0; i < n; i++) {
        SKShapeNode *v = vertices[i];
        SKSpriteNode *u;

        CGFloat vForceX = 0;
        CGFloat vForceY = 0;

        for (NSUInteger j = 0; j < n; j++) {
            if (i == j) continue;

            u = vertices[j];

            double rsq = pow((v.position.x - u.position.x), 2) + pow((v.position.y - u.position.y), 2);
            vForceX += self.repulsion * (v.position.x - u.position.x) / rsq;
            vForceY += self.repulsion * (v.position.y - u.position.y) / rsq;
        }

        for (NSUInteger j = 0; j < n; j++) {
            if(![self hasConnectedA:i toB:j]) continue;

            u = vertices[j];

            vForceX += self.attraction * (u.position.x - v.position.x);
            vForceY += self.attraction * (u.position.y - v.position.y);
        }

        v.physicsBody.linearDamping = 0.85;
        v.physicsBody.velocity = CGVectorMake((v.physicsBody.velocity.dx + vForceX),
                                              (v.physicsBody.velocity.dy + vForceY));

        [v.physicsBody applyForce:CGVectorMake(vForceX, vForceY)];
        v.physicsBody.angularVelocity = 0;
    }

    [self updateConnections];
}

- (void)updateConnections
{
    [self.connections enumerateKeysAndObjectsUsingBlock:^(NSArray *key, SKShapeNode *connection, BOOL *stop) {
        CGMutablePathRef pathToDraw = CGPathCreateMutable();

        SKNode *vertexA = self.vertices[key.firstObject];
        SKNode *vertexB = self.vertices[key.lastObject];

        CGPathMoveToPoint(pathToDraw, NULL, vertexA.position.x, vertexA.position.y);
        CGPathAddLineToPoint(pathToDraw, NULL, vertexB.position.x, vertexB.position.y);
        connection.path = pathToDraw;
    }];
}

- (BOOL)hasConnectedA:(NSUInteger)a toB:(NSUInteger)b
{
    for (NSArray *edge in self.edges) {
        NSUInteger i = [edge[0] unsignedIntegerValue];
        NSUInteger j = [edge[1] unsignedIntegerValue];
        if ((a == i && b == j) || (a == j && b == i)) {
            return YES;
        }
    }
    return NO;
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

- (SKShapeNode *)newCircleWithIndex:(NSInteger)index {
#warning shape node ликуют - проверить.
    SKShapeNode *node = [SKShapeNode node];
    node.zPosition = 10;
    node.physicsBody.allowsRotation = NO;
    node.name = @"circle";
    CGFloat diameter = 80;
    [node setPath:CGPathCreateWithEllipseInRect(CGRectMake(-diameter /2, -diameter / 2, diameter, diameter), nil)];
    node.strokeColor = node.fillColor = [SKColor greenColor];
    node.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:diameter / 2];

    SKLabelNode *label = [SKLabelNode node];
    label.text = [@(index) stringValue];
    [node addChild:label];

    return node;
}


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

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    self.touchedNode = nil;
}

@end
