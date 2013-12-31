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

typedef id (^ProceedBlock)();

/**
 Implementation of a join point.
 For internal use only.
 */
@interface APJoinPointImpl : NSObject<APProceedingJoinPoint>

/** Used for overriding the proceed method, nesting several around advice. */
@property (nonatomic, copy) ProceedBlock proceedBlock;

@property (nonatomic, strong, readonly) NSInvocation *invocation;
@property (nonatomic, assign, readonly) BOOL invoked;

/**
 Create a new join point given the supplied invocation.
 @param invocation The invocation.
 @return A join point.
 */
- (id)initWithInvocation:(NSInvocation *)invocation;

@end
