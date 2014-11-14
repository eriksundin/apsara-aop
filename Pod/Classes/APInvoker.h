//
// Created by Erik Sundin on 31/12/13.
//

#import <Foundation/Foundation.h>

/**
 Used internally to call an invocation in the context of a collection of advice.
 */
@interface APInvoker : NSObject

- (void)invoke:(NSInvocation *)invocation
        advice:(NSArray *)advice;

@end