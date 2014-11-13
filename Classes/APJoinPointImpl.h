//
//  APJoinPointImpl.h
//  ApsaraAOPTests
//
//  Created by Erik Sundin on 23/12/13.
//
//

#import <Foundation/Foundation.h>
#import "APJoinPoint.h"
#import "APProceedingJoinPoint.h"

@class APJoinPointImpl;

/**
 Implementation of a join point.
 For internal use only.
 */
@interface APJoinPointImpl : NSObject<APProceedingJoinPoint>

/** Chain of APAroundAdvice for proceed calls. */ 
@property (nonatomic, strong) NSArray *aroundAdviceChain;

@property (nonatomic, strong, readonly) NSInvocation *invocation;

/**
 Create a new join point given the supplied invocation.
 @param invocation The invocation.
 @return A join point.
 */
- (id)initWithInvocation:(NSInvocation *)invocation;

@end
