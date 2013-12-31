//
// Created by Erik Sundin on 31/12/13.
//

#import <Foundation/Foundation.h>


@interface APInvoker : NSObject

- (void)invoke:(NSInvocation *)invocation
        advice:(NSArray *)advice;

@end