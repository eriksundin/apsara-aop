//
//  APProceedingJoinPoint.h
//  ApsaraAOPTests
//
//  Created by Erik Sundin on 23/12/13.
//
//

#import <Foundation/Foundation.h>
#import "APJoinPoint.h"

/**
 Represents a joinpoint used in an APAroundAdvice. Calling the proceed method will
 invoke the underlying execution.
 */
@protocol APProceedingJoinPoint<APJoinPoint>

/**
 Proceed with the method execution.
 @return The return value of the execution.
 */
- (id)proceed;

@end
