//
//  APAdvisedProxy.h
//  ApsaraAOPTests
//
//  Created by Erik Sundin on 23/12/13.
//
//

#import <Foundation/Foundation.h>

/**
 Proxy object that applies advice to invocations on the target object.
 */
@protocol APAdvice;
@class APInvoker;

@interface APAdvisedProxy : NSProxy

- (id)initWithTarget:(id)target
            advisors:(NSArray *)advisors
             invoker:(APInvoker *)invoker;

@end
