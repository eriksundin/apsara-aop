//
// Created by Erik Sundin on 31/12/13.
//

#import <Foundation/Foundation.h>

@protocol APAdvice, APPointcut;

@interface APPointcutAdvisor : NSObject
{
    id<APAdvice> _advice;
    id<APPointcut> _pointcut;
}

- (id)initWithPointcut:(id<APPointcut>)pointcut advice:(id<APAdvice>)advice;

@property(nonatomic, strong, readonly) id<APAdvice> advice;

@property(nonatomic, strong, readonly) id<APPointcut> pointcut;


@end