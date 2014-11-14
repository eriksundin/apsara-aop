//
//  APBlockMatchingPointcut.m
//  ApsaraAOPTests
//
//  Created by Erik Sundin on 23/12/13.
//
//

#import "APBlockMatchingPointcut.h"
#import <objc/runtime.h>

typedef BOOL (^ExpressionBlock)(id target, SEL selector);

@interface APBlockMatchingPointcut ()

@property (nonatomic, copy) ExpressionBlock expressionBlock;

@end

@implementation APBlockMatchingPointcut

+ (APBlockMatchingPointcut *)pointcutWithBlock:(BOOL (^)(id target, SEL selector))block
{
    APBlockMatchingPointcut *pointcut = [[self alloc] init];
    pointcut.expressionBlock = block;
    return pointcut;
}

- (BOOL)matchesTarget:(id)target
{
    // First do a check without selector
    if (self.expressionBlock(target, NULL))
    {
        return YES;
    }

    // Check providing implemented instance methods in the class
    // TODO: Probably want to dig a bit deeper, looking at sub classes.
    unsigned int count;
    Method *method = class_copyMethodList([target class], &count);

    BOOL canApply = NO;
    for (unsigned int i = 0; i < count; i++)
    {
        if (self.expressionBlock(target, method_getName(method[i])))
        {
            canApply = YES;
            break;
        }
    }
    free(method);

    return canApply;
}

- (BOOL)matchesInvocation:(NSInvocation *)invocation
{
    return self.expressionBlock([invocation target], [invocation selector]);
}

@end
