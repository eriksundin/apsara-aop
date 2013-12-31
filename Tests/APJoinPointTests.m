//
//  APJoinPointTests.m
//  ApsaraAOPTests
//
//  Created by Erik Sundin on 23/12/13.
//
//

#import <XCTest/XCTest.h>
#import "APJoinPointImpl.h"
#import "AdvisedObjectMock.h"

@interface APJoinPointTests : XCTestCase

@end

@implementation APJoinPointTests {
    NSInvocation *_invocation;
    APJoinPointImpl *_joinpoint;
    AdvisedObjectMock *_mock;
}

- (void)setUp
{
    [super setUp];
    
    _mock = [[AdvisedObjectMock alloc] init];
    NSMethodSignature *signature = [_mock methodSignatureForSelector:@selector(method)];
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
    [invocation setTarget:_mock];
    [invocation setSelector:@selector(method)];
    _invocation = invocation;
    _joinpoint = [[APJoinPointImpl alloc] initWithInvocation:_invocation];
}

- (void)tearDown
{
    // Put teardown code here; it will be run once, after the last test case.
    [super tearDown];
}

- (void)testThrowsExceptionWhenInvocationMissingTarget
{
    [_invocation setTarget:nil];
    XCTAssertThrowsSpecificNamed([[APJoinPointImpl alloc] initWithInvocation:_invocation],
                                 NSException,
                                 NSInvalidArgumentException,
                                 @"Expected exception");
}

- (void)testRetrieveTarget
{
    XCTAssertEqual([_invocation target], [_joinpoint target]);
}

- (void)testRetrieveSelector
{
    XCTAssertEqualObjects(NSStringFromSelector([_invocation selector]),
                          NSStringFromSelector([_joinpoint selector]));
}

- (void)testProceedJoinPoint {
    XCTAssertFalse([_mock methodInvoked]);
    id returnVal = [_joinpoint proceed];
    XCTAssertTrue([_mock methodInvoked]);
    XCTAssertNil(returnVal);
}

- (void)testProceedJoinPointWithObjectReturnValue {
    NSMethodSignature *signature = [_mock methodSignatureForSelector:@selector(methodWithReturnValue)];
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
    [invocation setTarget:_mock];
    [invocation setSelector:@selector(methodWithReturnValue)];
    APJoinPointImpl *jp = [[APJoinPointImpl alloc] initWithInvocation:invocation];
    
    id returnVal = [jp proceed];
    XCTAssertEqualObjects(returnVal, @"test");
}

- (void)testArgumentsReturnNilOnMethodWithoutArgs {
    XCTAssertNil([_joinpoint arguments]);
}

- (void)testArgumentsReturnObjectArray {
    NSMethodSignature *signature = [_mock methodSignatureForSelector:@selector(methodWithArg0:arg1:)];
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
    [invocation setTarget:_mock];
    [invocation setSelector:@selector(methodWithArg0:arg1:)];

    NSString *arg1 = @"arg1";
    NSString *arg2 = @"arg2";
    
    [invocation setArgument:&arg1 atIndex:2];
    [invocation setArgument:&arg2 atIndex:3];
    APJoinPointImpl *jp = [[APJoinPointImpl alloc] initWithInvocation:invocation];
    
    NSArray *args = @[arg1, arg2];
    XCTAssertEqualObjects([jp arguments], args);
}

@end
