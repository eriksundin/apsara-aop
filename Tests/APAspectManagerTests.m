//
//  APAspectManagerTests.m
//  ApsaraAOPTests
//
//  Created by Erik Sundin on 28/12/13.
//
//

#import <XCTest/XCTest.h>
#import "APAspectManager.h"
#import "APAdvice.h"
#import "APPointcut.h"

@interface APAspectManagerTests : XCTestCase

@end

@implementation APAspectManagerTests

- (void)setUp
{
    [super setUp];
    // Put setup code here; it will be run once, before the first test case.
}

- (void)tearDown
{
    // Put teardown code here; it will be run once, after the last test case.
    [super tearDown];
}

- (void)testReturnProxyOnMatchingAdvisor
{
    APAspectManager *manager = [[APAspectManager alloc] init];
    id<APBeforeAdvice> advice = mockProtocol(@protocol(APBeforeAdvice));
    id<APPointcut> pointcut = mockProtocol(@protocol(APPointcut));
    [manager registerAdvice:advice pointcut:pointcut];

    NSNumber *target = @3;
    [given([pointcut matchesTarget:target]) willReturnBool:YES];

    id proxy = [manager advisedProxy:target];
    assertThatBool(proxy != target, equalToBool(YES));
}

- (void)testReturnTargetOnNoMatchingAdvisor
{
    APAspectManager *manager = [[APAspectManager alloc] init];
    id<APBeforeAdvice> advice = mockProtocol(@protocol(APBeforeAdvice));
    id<APPointcut> pointcut = mockProtocol(@protocol(APPointcut));
    [manager registerAdvice:advice pointcut:pointcut];

    NSNumber *target = @3;
    [given([pointcut matchesTarget:target]) willReturnBool:NO];

    id proxy = [manager advisedProxy:target];
    assertThatBool(target == proxy, equalToBool(YES));
}


@end
