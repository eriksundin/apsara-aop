//
//  AdvisedObjectMock.m
//  ApsaraAOPTests
//
//  Created by Erik Sundin on 23/12/13.
//
//

#import "AdvisedObjectMock.h"

@implementation AdvisedObjectMock

- (void)method {
    self.methodInvoked = YES;
}

- (NSString *)methodWithReturnValue {
    return @"test";
}

- (void)methodWithArg0:(id)arg0 arg1:(id)arg1 {
}

- (void)methodThrowingException {
    [NSException raise:@"TestException" format:@"Exception thrown from mock object"];
}

@end
