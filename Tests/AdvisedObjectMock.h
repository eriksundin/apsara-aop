//
//  AdvisedObjectMock.h
//  ApsaraAOPTests
//
//  Created by Erik Sundin on 23/12/13.
//
//

#import <Foundation/Foundation.h>

@interface AdvisedObjectMock : NSObject

@property (nonatomic, assign) BOOL methodInvoked;

- (void)method;

- (NSString *)methodWithReturnValue;

- (void)methodThrowingException;

- (void)methodWithArg0:(id)arg0 arg1:(id)arg1;

@end
