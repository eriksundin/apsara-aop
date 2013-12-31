//
//  APInvokerTests.m
//  ApsaraAOPTests
//
//  Created by Erik Sundin on 31/12/13.
//
//

#import <XCTest/XCTest.h>
#import "APInvoker.h"
#import "APAdvice.h"
#import "APProceedingJoinPoint.h"
#import "APJoinPointImpl.h"

typedef id (^AroundBlock)(id<APProceedingJoinPoint> jp);

@interface MockAroundAdvice : NSObject<APAroundAdvice>

@property (nonatomic, copy) AroundBlock aroundBlock;

+ (id)withBlock:(id (^)(id<APProceedingJoinPoint> jp))block;

@end

@interface TestInvocation : NSInvocation

@property (nonatomic, assign) NSUInteger invokeCount;

@end

@interface APInvokerTests : XCTestCase

@end

@implementation APInvokerTests
{
    APInvoker *_invoker;
    TestInvocation *_invocation;
}

- (void)setUp
{
    [super setUp];
    _invoker = [[APInvoker alloc] init];

    NSNumber *invocationTarget = @5;
    SEL invocationSelector = @selector(stringValue);
    NSMethodSignature *invocationSignature = [invocationTarget methodSignatureForSelector:invocationSelector];
    TestInvocation *invocation = [TestInvocation invocationWithMethodSignature:invocationSignature];
    [invocation setTarget:invocationTarget];
    [invocation setSelector:invocationSelector];
    [invocation retainArguments];

    _invocation = invocation;
}

- (void)tearDown
{
    [super tearDown];
}

- (void)testNoAdvice
{
    [_invoker invoke:_invocation advice:@[]];

    assertThatUnsignedInt(_invocation.invokeCount, equalToUnsignedInt(1));
    NSString *returnValue;
    [_invocation getReturnValue:&returnValue];
    assertThat(returnValue, equalTo(@"5"));
}

- (void)testBeforeAdviceCalled
{
    id<APAdvice> advice1 = mockProtocol(@protocol(APBeforeAdvice));
    id<APAdvice> advice2 = mockProtocol(@protocol(APBeforeAdvice));

    [_invoker invoke:_invocation advice:@[advice1, advice2]];

    [verifyCount(advice1, times(1)) before:anything()];
    [verifyCount(advice2, times(1)) before:anything()];
}

- (void)testAroundAdvice
{
    id<APAroundAdvice> advice = mockProtocol(@protocol(APAroundAdvice));

    [given([advice around:anything()]) willReturn:@"1"];
    [_invoker invoke:_invocation advice:@[advice]];

    [verifyCount(advice, times(1)) around:anything()];

    NSString *returnValue;
    [_invocation getReturnValue:&returnValue];
    assertThat(returnValue, equalTo(@"1"));
}

- (void)testChainedAroundAdviceWithShortCuttingFirstAdvice
{
    id<APAroundAdvice> advice1 = mockProtocol(@protocol(APAroundAdvice));
    id<APAroundAdvice> advice2 = mockProtocol(@protocol(APAroundAdvice));

    [given([advice1 around:anything()]) willReturn:@"1"];
    [given([advice2 around:anything()]) willReturn:@"2"];

    [_invoker invoke:_invocation advice:@[advice1, advice2]];

    [verifyCount(advice1, times(1)) around:anything()];
    [verifyCount(advice2, times(0)) around:anything()];

    NSString *returnValue;
    [_invocation getReturnValue:&returnValue];
    assertThat(returnValue, equalTo(@"1"));
}

- (void)testChainedAroundAdviceCallingWholeChain
{
    __block TestInvocation *actualInvocation;
    __block NSUInteger advicesCalled = 0;
    MockAroundAdvice *advice1 = [MockAroundAdvice withBlock:^id(id<APProceedingJoinPoint> jp)
    {
        // Capture the actual invocation being used. (around advice creates a copy)
        actualInvocation = (TestInvocation *) [(APJoinPointImpl *)jp invocation];

        advicesCalled++;
        [jp proceed];
        return @"1";
    }];
    MockAroundAdvice *advice2 = [MockAroundAdvice withBlock:^id(id<APProceedingJoinPoint> jp)
    {
        advicesCalled++;
        [jp proceed];
        return @"2";
    }];
    MockAroundAdvice *advice3 = [MockAroundAdvice withBlock:^id(id<APProceedingJoinPoint> jp)
    {
        advicesCalled++;
        [jp proceed];
        return @"3";
    }];

    [_invoker invoke:_invocation advice:@[advice1, advice2, advice3]];

    assertThatUnsignedInt(advicesCalled, equalToUnsignedInt(3));
    assertThatUnsignedInt(actualInvocation.invokeCount, equalToUnsignedInt(1));

    NSString *returnValue;
    [_invocation getReturnValue:&returnValue];
    assertThat(returnValue, equalTo(@"1"));
}

- (void)testAfterReturningAdviceCalled
{
    id<APAdvice> advice1 = mockProtocol(@protocol(APAfterReturningAdvice));
    id<APAdvice> advice2 = mockProtocol(@protocol(APAfterReturningAdvice));

    [_invoker invoke:_invocation advice:@[advice1, advice2]];

    [verifyCount(advice1, times(1)) afterReturning:anything()];
    [verifyCount(advice2, times(1)) afterReturning:anything()];
}

- (void)testAfterAdviceCalled
{
    id<APAdvice> advice1 = mockProtocol(@protocol(APAfterAdvice));
    id<APAdvice> advice2 = mockProtocol(@protocol(APAfterAdvice));

    [_invoker invoke:_invocation advice:@[advice1, advice2]];

    [verifyCount(advice1, times(1)) after:anything()];
    [verifyCount(advice2, times(1)) after:anything()];
}

- (void)testAfterThrowingAdviceCalled
{
    id<APAdvice> advice1 = mockProtocol(@protocol(APAfterThrowingAdvice));
    id<APAdvice> advice2 = mockProtocol(@protocol(APAfterThrowingAdvice));

    [_invocation setSelector:@selector(magicValue)];

    [_invoker invoke:_invocation advice:@[advice1, advice2]];

    [verifyCount(advice1, times(1)) afterThrowing:anything() exception:anything()];
    [verifyCount(advice2, times(1)) afterThrowing:anything() exception:anything()];
}


@end


@implementation MockAroundAdvice

+ (id)withBlock:(id (^)(id<APProceedingJoinPoint> jp))block
{
    MockAroundAdvice *advice = [[MockAroundAdvice alloc] init];
    [advice setAroundBlock:block];
    return advice;
}

- (id)around:(id<APProceedingJoinPoint>)joinpoint
{
    AroundBlock block = self.aroundBlock;
    self.aroundBlock = nil;
    return block(joinpoint);
}

@end

@implementation TestInvocation

- (void)invoke
{
    [super invoke];
    self.invokeCount++;
}

@end