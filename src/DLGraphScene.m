#import "DLGraphScene.h"
#import "DLGraphScene+Private.h"


@interface DLGraphScene ()

@property (nonatomic, strong) SKNode *touchedNode;
@property (nonatomic , assign) BOOL contentCreated;
@property (nonatomic, assign) BOOL stable;
@property (nonatomic, assign) NSUInteger nodesCount;

@end


@implementation DLGraphScene

- (instancetype)init
{
    if (self = [super init]) {

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

    self.repulsion = 800.f;
    self.attraction = 0.1f;

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self addEdge:@[@0, @4]];
    });
}

- (void)createSceneContents
{
    self.backgroundColor = [SKColor blueColor];
    self.scaleMode = SKSceneScaleModeAspectFit;
    self.physicsBody = [SKPhysicsBody bodyWithEdgeLoopFromRect:self.frame];
    self.physicsWorld.gravity = CGVectorMake(0,0);
}

- (void)setEdges:(NSArray *)edges
{
    if (_edges == edges) {
        return;
    }

    _edges = edges;

    self.nodesCount = [self calculateNodesCount];

    [self addVertices];
    [self addEdgeLines];
}

- (void)addEdge:(NSArray *)edge
{
    //делать внутреннюю mutable copy edges
    _edges = [self.edges arrayByAddingObject:edge];

    //иногда нужно создавать vertex - иногда нет
    //[self createVertice];
    [self createEdgeLine];
}

- (void)addEdges:(NSArray *)edges
{

}

- (void)removeEdge:(NSArray *)edge
{

}

- (void)removeEdges:(NSArray *)edges
{

}


- (void)addEdgeLines
{
    self.lines = [NSMutableArray array];

    for (NSUInteger i = 0; i < self.edges.count; i++) {
        [self createEdgeLine];
    }
}

- (void)createEdgeLine
{
    SKShapeNode *edge = [SKShapeNode node];
    [edge setStrokeColor:[UIColor redColor]];
    [edge setFillColor:[UIColor redColor]];
    [edge setLineWidth:1.f];
    [self addChild:edge];
    [self.lines addObject:edge];
}

- (void)addVertices
{
    self.vertices = [NSMutableArray arrayWithCapacity:self.nodesCount];

    for (NSUInteger i = 0; i < self.nodesCount; i ++) {
        [self createVertice];
    }
}

- (void)createVertice
{
    NSUInteger i = self.vertices.count;
    SKShapeNode *circle = [self newCircleWithIndex:i];
    circle.position = CGPointMake(arc4random() % (NSUInteger)self.size.width,
                                  arc4random() % (NSUInteger)self.size.height);
    [self addChild:circle];
    [self.vertices addObject:circle];
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

    for  (NSUInteger i = 0; i < n; i++) {
        SKShapeNode *v = self.vertices[i];
        SKSpriteNode *u;

        CGFloat vForceX = 0;
        CGFloat vForceY = 0;

        for (NSUInteger j = 0; j < n; j++) {
            if (i == j) continue;

            u = self.vertices[j];

            double rsq = pow((v.position.x - u.position.x), 2) + pow((v.position.y - u.position.y), 2);
            vForceX += self.repulsion * (v.position.x - u.position.x) / rsq;
            vForceY += self.repulsion * (v.position.y - u.position.y) / rsq;
        }

        for (NSUInteger j = 0; j < n; j++) {
            if(![self hasConnectedA:i toB:j]) continue;

            u = self.vertices[j];

            vForceX += self.attraction * (u.position.x - v.position.x);
            vForceY += self.attraction * (u.position.y - v.position.y);
        }

        v.physicsBody.linearDamping = 0.85;
        v.physicsBody.velocity = CGVectorMake((v.physicsBody.velocity.dx + vForceX),
                                              (v.physicsBody.velocity.dy + vForceY));

        [v.physicsBody applyForce:CGVectorMake(vForceX, vForceY)];
        v.physicsBody.angularVelocity = 0;
    }

    [self updateEdgeLines];
}

- (void)updateEdgeLines
{
    for (NSUInteger i = 0; i < self.edges.count; i++) {
        // боюсь ошибиться, но здесь линии выхватываются не
        // в нужно очередности, по факту линии нужно привязывать к edges индкесам
        NSArray *edge = self.edges[i];
        SKShapeNode *a = self.lines[i];
        CGMutablePathRef pathToDraw = CGPathCreateMutable();

        SKNode *na = self.vertices[[edge[0] unsignedIntegerValue]];
        SKNode *nb = self.vertices[[edge[1] unsignedIntegerValue]];

        CGPathMoveToPoint(pathToDraw, NULL, na.position.x, na.position.y);
        CGPathAddLineToPoint(pathToDraw, NULL, nb.position.x, nb.position.y);
        a.path = pathToDraw;
    }
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
