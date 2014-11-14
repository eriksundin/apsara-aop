//
// Created by Erik Sundin on 31/12/13.
//

#import "APPointcutAdvisor.h"


@implementation APPointcutAdvisor

- (id)initWithPointcut:(id<APPointcut>)pointcut advice:(id<APAdvice>)advice
{
    self = [super init];
    if (self)
    {
        _advice = advice;
        _pointcut = pointcut;
    }
    return self;
}

@end