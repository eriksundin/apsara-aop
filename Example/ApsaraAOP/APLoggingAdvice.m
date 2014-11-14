//
//  APLoggingAdvice.m
//  ApsaraAOP
//
//  Created by Erik Sundin on 14/11/14.
//  Copyright (c) 2014 Erik Sundin. All rights reserved.
//

#import "APLoggingAdvice.h"

@implementation APLoggingAdvice

- (void)traceJoinPoint:(id<APJoinPoint>)joinpoint state:(NSString *)state {
    NSLog(@"[%@ -%@] %@", NSStringFromClass([[joinpoint target] class]), NSStringFromSelector([joinpoint selector]), state);
}

#pragma mark - APAdvice implementation

- (void)before:(id<APJoinPoint>)joinpoint {
    [self traceJoinPoint:joinpoint state:@"before"];
}

- (id)around:(id<APProceedingJoinPoint>)joinpoint {
    [self traceJoinPoint:joinpoint state:@"around - pre-invoke"];
    id retVal = [joinpoint proceed];
    [self traceJoinPoint:joinpoint state:@"around - post-invoke"];
    return retVal;
}

- (void)after:(id<APJoinPoint>)joinpoint {
    [self traceJoinPoint:joinpoint state:@"after"];
}

- (void)afterThrowing:(id<APJoinPoint>)joinpoint exception:(NSException *)exception {
    [self traceJoinPoint:joinpoint state:[NSString stringWithFormat:@"throwing %@", [exception name]]];
}

@end
