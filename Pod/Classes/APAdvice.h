//
//  APAdvice.h
//  ApsaraAOPTests
//
//  Created by Erik Sundin on 23/12/13.
//
//

#import <Foundation/Foundation.h>

@protocol APJoinPoint;
@protocol APProceedingJoinPoint;


/**
 Marker protocol for all advice types.
 */
@protocol APAdvice<NSObject>
@end

/**
 Advice to execute before a joinpoint.
 */
@protocol APBeforeAdvice<APAdvice>

- (void)before:(id<APJoinPoint>)joinpoint;

@end

/**
 Advice to execute around a joinpoint.
 */
@protocol APAroundAdvice<APAdvice>

- (id)around:(id<APProceedingJoinPoint>)joinpoint;

@end

/**
 Advice to execute after a joinpoint returns.
 */
@protocol APAfterReturningAdvice<APAdvice>

- (void)afterReturning:(id<APJoinPoint>)joinpoint;

@end

/**
 Advice to execute after a joinpoint throws an exception.
 */
@protocol APAfterThrowingAdvice<APAdvice>

- (void)afterThrowing:(id<APJoinPoint>)joinpoint exception:(NSException *)exception;

@end

/**
 Advice to execute after (finally) a joinpoint.
 */
@protocol APAfterAdvice<APAdvice>

- (void)after:(id<APJoinPoint>)joinpoint;

@end


