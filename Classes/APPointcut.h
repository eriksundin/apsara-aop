//
// Created by Erik Sundin on 31/12/13.
//

#import <Foundation/Foundation.h>

/**
* Represents a pointcut - a predicate to match join points.
*/
@protocol APPointcut<NSObject>

/**
* Checks if the pointcut match any join point on the given target.
*/
- (BOOL)matchesTarget:(id)target;

/**
* Checks if the pointcut match the given invocation.
*/
- (BOOL)matchesInvocation:(NSInvocation *)invocation;


@end