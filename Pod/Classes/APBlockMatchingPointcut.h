//
//  APBlockMatchingPointcut.h
//  ApsaraAOPTests
//
//  Created by Erik Sundin on 23/12/13.
//
//

#import <Foundation/Foundation.h>
#import "APPointcut.h"

/**
 Block-based implementation of a APPointcut.
 */
@interface APBlockMatchingPointcut : NSObject<APPointcut>

/**
* Create a new pointcut using an evaluation block.
* Block should return YES if the pointcut applies for invoking selector on target.  
*/
+ (APBlockMatchingPointcut *)pointcutWithBlock:(BOOL (^)(id target, SEL selector))block;


@end
