#import <Specta/Specta.h>
#define EXP_SHORTHAND
#import <Expecta/Expecta.h>
#define MOCKITO_SHORTHAND
#import <OCMockito/OCMockito.h>
#import "DLGraphScene.h"
#import "DLGraphScene+Private.h"
#import "DLEdge.h"

SharedExamplesBegin(DLGraphScene)

    sharedExamplesFor(@"graph vertexes", ^(NSDictionary *data) {
        __block DLGraphScene *scene;
        __block NSDictionary *vertexes;
        __block NSUInteger count;

        beforeEach(^{
            scene = data[@"scene"];
            vertexes = data[@"vertexes"];
            count = [data[@"count"] unsignedIntegerValue];
        });

        it(@"has provided count of vertexes", ^{
            expect(scene.vertexes).to.haveCountOf(count);
            for (SKNode *node in vertexes.allValues) {
                expect(node.parent).to.equal(scene);
            }
        });
    });

    sharedExamplesFor(@"graph connections", ^(NSDictionary *data) {
        __block DLGraphScene *scene;
        __block NSDictionary *connections;
        __block NSUInteger count;

        beforeEach(^{
            scene = data[@"scene"];
            connections = data[@"connections"];
            count = [data[@"count"] unsignedIntegerValue];
        });

        it(@"has provided count of nodes", ^{
            expect(scene.connections).to.haveCountOf(count);
            for (SKNode *node in connections.allValues) {
                expect(node.parent).to.equal(scene);
            }
        });
    });

SharedExamplesEnd

SpecBegin(DLGraphScene)

describe(@"DLGraphScene", ^{

    __block DLGraphScene *scene;

    beforeEach(^{
        scene = [[DLGraphScene alloc] initWithSize:CGSizeZero];
    });

    context(@"Given an edge", ^{

        beforeEach(^{
            [scene addEdge:DLMakeEdge(0, 1)];
        });

        it(@"has 2 vertexes", ^{
            itBehavesLike(@"graph vertexes", @{
                @"scene": scene,
                @"vertexes": scene.vertexes,
                @"count": @2
            });
        });

        it (@"has 1 connection", ^{
            itBehavesLike(@"graph connections", @{
                @"scene": scene,
                @"connections": scene.connections,
                @"count": @1
            });
        });

        context(@"given an edge with existing vertex", ^{

            beforeEach(^{
                [scene addEdge:DLMakeEdge(1, 2)];
            });

            it(@"has 3 vertexes", ^{
                itBehavesLike(@"graph vertexes", @{
                    @"scene": scene,
                    @"vertexes": scene.vertexes,
                    @"count": @3
                });
            });

            it(@"has 2 connections", ^{
                itBehavesLike(@"graph connections", @{
                    @"scene": scene,
                    @"connections": scene.connections,
                    @"count": @2
                });
            });
        });
    });

    context(@"add edges", ^{
        beforeEach(^{
            [scene addEdges:@[
                DLMakeEdge(0, 1),
                DLMakeEdge(1, 2)
            ]];
        });
        it(@"has 3 vertexes", ^{
            itBehavesLike(@"graph vertexes", @{
                @"scene": scene,
                @"vertexes": scene.vertexes,
                @"count": @3
            });
        });

        it(@"has 2 connections", ^{
            itBehavesLike(@"graph connections", @{
                @"scene": scene,
                @"connections": scene.connections,
                @"count": @2
            });
        });
    });

    context(@"remove edge", ^{
        beforeEach(^{
            [scene removeEdge:DLMakeEdge(0, 1)];
        });

        it(@"has one vertex", ^{
            itBehavesLike(@"graph vertexes", @{
                @"scene": scene,
                @"vertexes": scene.vertexes,
                @"count": @1
            });
        });

        it(@"has no edges", ^{
            itBehavesLike(@"graph connections", @{
                @"scene": scene,
                @"connections": scene.connections,
                @"count": @0
            });
        });
    });

    context(@"remove edges", ^{
        beforeEach(^{
            [scene removeEdges:@[DLMakeEdge(0, 1)]];
        });

        it(@"has one vertex", ^{
            itBehavesLike(@"graph vertexes", @{
                @"scene": scene,
                @"vertexes": scene.vertexes,
                @"count": @1
            });
        });

        it(@"has no edges", ^{
            itBehavesLike(@"graph connections", @{
                @"scene": scene,
                @"connections": scene.connections,
                @"count": @0
            });
        });
    });

    context(@"given delegate", ^{
        __block id<DLGraphSceneDelegate> spyDelegate;

        beforeEach(^{
            spyDelegate = mockProtocol(@protocol(DLGraphSceneDelegate));
            scene.delegate = spyDelegate;
            [scene addEdge:DLMakeEdge(0, 1)];
        });
        it (@"calls configure method for each added vertex", ^{
            [MKTVerify(spyDelegate) configureVertex:scene.vertexes[@0] atIndex:0];
            [MKTVerify(spyDelegate) configureVertex:scene.vertexes[@1] atIndex:1];
        });
    });
});

SpecEnd
