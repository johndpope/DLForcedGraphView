#import <Specta/Specta.h>
#define EXP_SHORTHAND
#import <Expecta/Expecta.h>
#import "DLEdge.h"


SpecBegin(DLEdge)

describe(@"DLEdge", ^{

    context(@"given i and j", ^{

        __block DLEdge *edge;

        beforeEach(^{
            edge = DLMakeEdge(1, 2);
        });

        it(@"stores i and j assigned", ^{
            expect(edge.i).to.equal(1);
            expect(edge.j).to.equal(2);
        });

        context(@"given edges with equal endings", ^{
            it(@"reports edges as equal", ^{
                expect(edge).to.equal(DLMakeEdge(1, 2));
            });

            it(@"reports reverted edges as equal",^{
                expect(edge).to.equal(DLMakeEdge(2, 1));
            });
        });
    });
});

SpecEnd
