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
 A pointcut is used to match join points.
 */
@interface APBlockMatchingPointcut : NSObject<APPointcut>

/**
* Create a new pointcut using an evaluation block.
*/
+ (APBlockMatchingPointcut *)pointcutWithBlock:(BOOL (^)(id target, SEL selector))block;


@end
