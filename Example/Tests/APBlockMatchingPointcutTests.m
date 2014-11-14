//
//  APBlockMatchingPointcutTests.m
//  ApsaraAOPTests
//
//  Created by Erik Sundin on 23/12/13.
//
//

#import <XCTest/XCTest.h>
#import "APBlockMatchingPointcut.h"

@interface TestTaget : NSObject

- (void)method1;

- (void)method2;

@end

@interface APBlockMatchingPointcutTests : XCTestCase

@end

@implementation APBlockMatchingPointcutTests

- (void)setUp
{
    [super setUp];
}

- (void)tearDown
{
    [super tearDown];
}

- (void)testMatchesTarget
{
    __block BOOL blockCalled = NO;
    TestTaget *testTaget = [[TestTaget alloc] init];

    APBlockMatchingPointcut *pc = [APBlockMatchingPointcut pointcutWithBlock:^BOOL(id target, SEL selector)
    {
        blockCalled = YES;
        XCTAssertEqual(target, testTaget);
        return YES;
    }];

    XCTAssertTrue([pc matchesTarget:testTaget]);
    XCTAssertTrue(blockCalled);
}

- (void)testMatchesInvocation
{
    __block BOOL blockCalled = NO;
    TestTaget *testTaget = [[TestTaget alloc] init];

    APBlockMatchingPointcut *pc = [APBlockMatchingPointcut pointcutWithBlock:^BOOL(id target, SEL selector)
    {
        blockCalled = YES;
        XCTAssertEqual(target, testTaget);
        XCTAssertEqualObjects(NSStringFromSelector(selector), NSStringFromSelector(@selector(method1)));
        return YES;
    }];

    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[testTaget methodSignatureForSelector:@selector(method1)]];
    [invocation setTarget:testTaget];
    [invocation setSelector:@selector(method1)];

    XCTAssertTrue([pc matchesInvocation:invocation]);
    XCTAssertTrue(blockCalled);
}




@end


@implementation TestTaget
- (void)method1 {}

- (void)method2 {}
@end