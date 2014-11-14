//
//  AdviceMock.m
//  ApsaraAOPTests
//
//  Created by Erik Sundin on 23/12/13.
//
//

#import "AdviceMock.h"

@implementation AdviceMock

- (void)before:(id<APJoinPoint>)joinpoint
{
    self.before = joinpoint;
}

- (id)around:(id<APProceedingJoinPoint>)joinpoint
{
    id retVal = [joinpoint proceed];
    self.around = joinpoint;
    return self.returnValue ? self.returnValue : retVal;
}

- (void)afterReturning:(id<APJoinPoint>)joinpoint
{
    self.afterReturning = joinpoint;
}

- (void)afterThrowing:(id<APJoinPoint>)joinpoint exception:(NSException *)exception
{
    self.afterThrowing = joinpoint;
    self.exception = exception;
}

- (void)after:(id<APJoinPoint>)joinpoint
{
    self.after = joinpoint;
}


@end
