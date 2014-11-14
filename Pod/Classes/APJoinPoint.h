//
//  APJoinPoint.h
//  ApsaraAOPTests
//
//  Created by Erik Sundin on 23/12/13.
//
//

#import <Foundation/Foundation.h>

/**
  Represents the point of execution of a method.
 */
@protocol APJoinPoint<NSObject>

/**
 @return The selector being called.
 */
- (SEL)selector;

/**
 @return The target object on which the selector is being called.
 */
- (id)target;

/**
 @return The arguments used in the execution.
 */
- (NSArray *)arguments;

@end
