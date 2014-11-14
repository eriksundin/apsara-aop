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

- (id)initWithIdentifier:(NSString *)identifier;

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
    TestInvocation *invocation = (TestInvocation *) [TestInvocation invocationWithMethodSignature:invocationSignature];
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

    [MKTVerifyCount(advice1, times(1)) before:anything()];
    [MKTVerifyCount(advice2, times(1)) before:anything()];
}

- (void)testAroundAdvice
{
    id<APAroundAdvice> advice = mockProtocol(@protocol(APAroundAdvice));

    [given([advice around:anything()]) willReturn:@"1"];
    [_invoker invoke:_invocation advice:@[advice]];

    [MKTVerifyCount(advice, times(1)) around:anything()];

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

    [MKTVerifyCount(advice1, times(1)) around:anything()];
    [MKTVerifyCount(advice2, times(0)) around:anything()];

    NSString *returnValue;
    [_invocation getReturnValue:&returnValue];
    assertThat(returnValue, equalTo(@"1"));
}

- (void)testChainedAroundAdviceCallingWholeChain
{
    MockAroundAdvice *advice1 = [[MockAroundAdvice alloc] initWithIdentifier:@"1"];
    MockAroundAdvice *advice2 = [[MockAroundAdvice alloc] initWithIdentifier:@"2"];
    MockAroundAdvice *advice3 = [[MockAroundAdvice alloc] initWithIdentifier:@"3"];
    
    [_invoker invoke:_invocation advice:@[advice1, advice2, advice3]];
    
    NSString *returnValue;
    [_invocation getReturnValue:&returnValue];
    assertThat(returnValue, equalTo(@"1"));
}

- (void)testAfterReturningAdviceCalled
{
    id<APAdvice> advice1 = mockProtocol(@protocol(APAfterReturningAdvice));
    id<APAdvice> advice2 = mockProtocol(@protocol(APAfterReturningAdvice));

    [_invoker invoke:_invocation advice:@[advice1, advice2]];

    [MKTVerifyCount(advice1, times(1)) afterReturning:anything()];
    [MKTVerifyCount(advice2, times(1)) afterReturning:anything()];
}

- (void)testAfterAdviceCalled
{
    id<APAdvice> advice1 = mockProtocol(@protocol(APAfterAdvice));
    id<APAdvice> advice2 = mockProtocol(@protocol(APAfterAdvice));

    [_invoker invoke:_invocation advice:@[advice1, advice2]];

    [MKTVerifyCount(advice1, times(1)) after:anything()];
    [MKTVerifyCount(advice2, times(1)) after:anything()];
}

- (void)testAfterThrowingAdviceCalled
{
    id<APAdvice> advice1 = mockProtocol(@protocol(APAfterThrowingAdvice));
    id<APAdvice> advice2 = mockProtocol(@protocol(APAfterThrowingAdvice));

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
    [_invocation setSelector:@selector(magicValue)];
#pragma clang diagnostic pop
    
    [_invoker invoke:_invocation advice:@[advice1, advice2]];

    [MKTVerifyCount(advice1, times(1)) afterThrowing:anything() exception:anything()];
    [MKTVerifyCount(advice2, times(1)) afterThrowing:anything() exception:anything()];
}


@end


@implementation MockAroundAdvice {
    NSString *_identifier;
}

- (id)initWithIdentifier:(NSString *)identifier {
    self = [super init];
    if (self) {
        _identifier = identifier;
    }
    return self;
}

- (id)around:(id<APProceedingJoinPoint>)joinpoint
{
    return _identifier;
}

- (NSString *)description {
    return _identifier;
}

@end

@implementation TestInvocation

- (void)invoke
{
    self.invokeCount++;
    [super invoke];
}

@end