//
//  APJoinPointImpl.m
//  ApsaraAOPTests
//
//  Created by Erik Sundin on 23/12/13.
//
//

#import "APJoinPointImpl.h"

@implementation APJoinPointImpl
{
    NSInvocation *_invocation;
    BOOL _invoked;
}

- (id)initWithInvocation:(NSInvocation *)invocation
{
    self = [super init];
    if (self)
    {

        if (![invocation target])
        {
            [NSException raise:NSInvalidArgumentException
                        format:@"Invocation is missing a target!"];
        }

        _invocation = invocation;
    }
    return self;
}

- (SEL)selector
{
    return [_invocation selector];
}

- (id)target
{
    return [_invocation target];
}

- (id)returnValue
{
    NSMethodSignature *signature = [_invocation methodSignature];

    id returnVal;
    const char *type = [signature methodReturnType];
    if (strcmp(type, @encode(void)) == 0)
    {
        returnVal = nil;
    } else if (strcasecmp(type, @encode(id)) == 0)
    {
        [_invocation getReturnValue:&returnVal];
    } else
    {
        [NSException raise:NSInvalidArgumentException
                    format:@"Return type %s is not supported on JoinPoint", type];
    }
    return returnVal;
}

- (id)proceed
{
    if (self.proceedBlock)
    {
        ProceedBlock proceedBlock = self.proceedBlock;
        self.proceedBlock = nil;
        BOOL stop;
        return proceedBlock();
    }
    else
    {
        [_invocation invoke];
    }
    return [self returnValue];
}

- (NSArray *)arguments
{

    NSArray *args = nil;
    NSMethodSignature *signature = [_invocation methodSignature];
    NSUInteger numArgs = [signature numberOfArguments];
    if (numArgs > 2)
    {

        NSMutableArray *mutableArgs = [[NSMutableArray alloc] initWithCapacity:numArgs - 2];
        for (NSUInteger i = 2; i < numArgs; i++)
        {
            const char *type = [signature getArgumentTypeAtIndex:i];

            if (strcasecmp(type, @encode(id)) == 0)
            {
                id arg;
                [_invocation getArgument:&arg atIndex:i];
                [mutableArgs addObject:arg];
            } else
            {
                [NSException raise:NSInvalidArgumentException
                            format:@"Argument type %s is not supported on JoinPoint", type];
            }
        }
        args = [mutableArgs copy];
    }
    return args;
}


@end
