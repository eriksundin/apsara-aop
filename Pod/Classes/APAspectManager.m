//
//  APAspectManager.m
//  ApsaraAOPTests
//
//  Created by Erik Sundin on 27/12/13.
//
//

#import "APAspectManager.h"
#import "APPointcut.h"
#import "APPointcutAdvisor.h"
#import "APAdvisedProxy.h"
#import "APInvoker.h"

@implementation APAspectManager
{
    NSMutableArray *_advisors;
}

- (id)init
{
    self = [super init];
    if (self)
    {
        _advisors = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)registerAdvice:(id<APAdvice>)advice pointcut:(id<APPointcut>)pointcut
{
    APPointcutAdvisor *advisor = [[APPointcutAdvisor alloc] initWithPointcut:pointcut
                                                                      advice:advice];
    [_advisors addObject:advisor];
}

- (id)advisedProxy:(id)object
{
    // Find advisors that have a point-cut that can be applied to the given object.
    NSMutableArray *advisors = [[NSMutableArray alloc] initWithCapacity:[_advisors count]];
    [_advisors enumerateObjectsUsingBlock:^(APPointcutAdvisor *obj, NSUInteger idx, BOOL *stop)
    {
        if ([obj.pointcut matchesTarget:object])
        {
            [advisors addObject:obj];
        }
    }];

    // Proxy the object if we found some advisors for it.
    if ([advisors count] > 0)
    {
        object = [[APAdvisedProxy alloc] initWithTarget:object advisors:advisors invoker:[[APInvoker alloc] init]];
    }
    return object;
}

@end
