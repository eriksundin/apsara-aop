//
//  APAdvisedProxyTests.m
//  ApsaraAOPTests
//
//  Created by Erik Sundin on 31/12/13.
//
//

#import <XCTest/XCTest.h>
#import "AdviceMock.h"
#import "APPointcutAdvisor.h"
#import "APInvoker.h"
#import "APAdvisedProxy.h"
#import "APPointcut.h"

@interface APAdvisedProxyTests : XCTestCase

@end

@implementation APAdvisedProxyTests
{
    APInvoker *_invokerMock;
    APPointcutAdvisor *_advisorMock;
    id<APPointcut> _pointcutMock;
    id<APAdvice> _adviceMock;
    NSInvocation *_invocation;
    NSObject *_target;
}

- (void)setUp
{
    [super setUp];

    _invokerMock = mock([APInvoker class]);
    _advisorMock = mock([APPointcutAdvisor class]);
    _pointcutMock = mockProtocol(@protocol(APPointcut));
    _adviceMock = mockProtocol(@protocol(APAdvice));
    _target = [[NSObject alloc] init];
    NSMethodSignature *signature = [_target methodSignatureForSelector:@selector(description)];
    _invocation = [NSInvocation invocationWithMethodSignature:signature];

    // Default behaviour
    [given([_advisorMock pointcut]) willReturn:_pointcutMock];
    [given([_advisorMock advice]) willReturn:_adviceMock];
    [given([_pointcutMock matchesInvocation:_invocation]) willReturnBool:YES];
}

- (void)tearDown
{
    [super tearDown];
}

- (void)testTargetSetOnInvocation
{
    [given([_pointcutMock matchesInvocation:_invocation]) willReturnBool:NO];

    APAdvisedProxy *proxy = [[APAdvisedProxy alloc] initWithTarget:_target
                                                          advisors:@[_advisorMock]
                                                           invoker:_invokerMock];
    [proxy forwardInvocation:_invocation];

    assertThat([_invocation target], equalTo(_target));
}

- (void)testInvokerInvoked
{
    APAdvisedProxy *proxy = [[APAdvisedProxy alloc] initWithTarget:_target
                                                          advisors:@[_advisorMock]
                                                           invoker:_invokerMock];
    [proxy forwardInvocation:_invocation];

    [verify(_invokerMock) invoke:_invocation advice:@[_adviceMock]];
}

- (void)testAdvisorsWithoutMatchingPointcutSortedOut
{
    APPointcutAdvisor *advisor2 = mock([APPointcutAdvisor class]);
    id<APPointcut> pointcut2 = mockProtocol(@protocol(APPointcut));
    [given([advisor2 pointcut]) willReturn:pointcut2];
    [given([pointcut2 matchesInvocation:_invocation]) willReturnBool:NO];

    APAdvisedProxy *proxy = [[APAdvisedProxy alloc] initWithTarget:_target
                                                          advisors:@[_advisorMock, advisor2]
                                                           invoker:_invokerMock];
    [proxy forwardInvocation:_invocation];

    [verify(_invokerMock) invoke:_invocation advice:@[_adviceMock]];
}

@end
