//
//  APAdvisedProxy.m
//  ApsaraAOPTests
//
//  Created by Erik Sundin on 23/12/13.
//
//

#import "APAdvisedProxy.h"
#import "APPointcutAdvisor.h"
#import "APBlockMatchingPointcut.h"
#import "APInvoker.h"
#import "APAdvice.h"

@implementation APAdvisedProxy
{
    id _target;
    NSArray *_advisors;
    APInvoker *_invoker;
}

- (id)initWithTarget:(id)target advisors:(NSArray *)advisors invoker:(APInvoker *)invoker
{
    NSAssert(target, @"No target set!");
    NSAssert(advisors, @"No advisors set!");
    NSAssert(invoker, @"No invoker set!");

    if ([advisors count] == 0)
    {
        self = nil;
        return target;
    }

    if (self)
    {
        _target = target;
        _advisors = advisors;
        _invoker = invoker;
    }
    return self;
}

#pragma mark - NSProxy methods

- (NSMethodSignature *)methodSignatureForSelector:(SEL)sel
{
    return [_target methodSignatureForSelector:sel];
}

- (void)forwardInvocation:(NSInvocation *)invocation
{
    [invocation setTarget:_target];

    NSMutableArray *invocationAdvice = [[NSMutableArray alloc] initWithCapacity:[_advisors count]];
    for (APPointcutAdvisor *advisor in _advisors)
    {
        if ([[advisor pointcut] matchesInvocation:invocation])
        {
            [invocationAdvice addObject:[advisor advice]];
        }
    }

    [_invoker invoke:invocation advice:invocationAdvice];
}

@end



