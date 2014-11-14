//
//  AdviceMock.h
//  ApsaraAOPTests
//
//  Created by Erik Sundin on 23/12/13.
//
//

#import <Foundation/Foundation.h>
#import "APAdvice.h"
#import "APProceedingJoinPoint.h"

@interface AdviceMock : NSObject<APBeforeAdvice, APAroundAdvice, APAfterReturningAdvice, APAfterAdvice, APAfterThrowingAdvice>

@property (nonatomic, strong) id returnValue;

@property (nonatomic, strong) id<APJoinPoint> before;
@property (nonatomic, strong) id<APJoinPoint> afterReturning;
@property (nonatomic, strong) id<APProceedingJoinPoint> around;
@property (nonatomic, strong) id<APJoinPoint> afterThrowing;
@property (nonatomic, strong) id<APJoinPoint> after;

@property (nonatomic, strong) NSException *exception;


@end
