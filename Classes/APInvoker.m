//
// Created by Erik Sundin on 31/12/13.
//

#import "APInvoker.h"
#import "APAdvice.h"
#import "APJoinPointImpl.h"

@interface AdviceTable : NSObject

- (id)initWithAdviceList:(NSArray *)adviceList;

- (NSArray *)beforeAdvice;

- (NSArray *)aroundAdvice;

- (NSArray *)afterReturningAdvice;

- (NSArray *)afterThrowingAdvice;

- (NSArray *)afterAdvice;

@end

@implementation APInvoker

- (void)invoke:(NSInvocation *)invocation advice:(NSArray *)adviceList
{
    if ([adviceList count] > 0)
    {
        AdviceTable *adviceTable = [[AdviceTable alloc] initWithAdviceList:adviceList];

        NSInvocation *joinpointInvocation = invocation;
        if ([[adviceTable aroundAdvice] count] > 0)
        {
            // Around advice can manipulate the return value of the invocation so we create a copy.
            joinpointInvocation = [self copyOfInvocation:invocation];
        }
        APJoinPointImpl *joinpoint = [[APJoinPointImpl alloc] initWithInvocation:joinpointInvocation];

        @try
        {
            // Before
            for (id<APBeforeAdvice> advice in [adviceTable beforeAdvice])
            {
                [advice before:joinpoint];
            }

            // Around
            NSArray *aroundAdvice = [adviceTable aroundAdvice];

            id retVal;
            if ([aroundAdvice count] == 1)
            {
                retVal = [aroundAdvice[0] around:joinpoint];
            }
            else if ([aroundAdvice count] > 1)
            {
                // Walk down the chain of around advice
                NSEnumerator *enumerator = [aroundAdvice objectEnumerator];
                retVal = [self adviseJoinPoint:joinpoint
                                  aroundAdvice:[enumerator nextObject]
                              adviceEnumerator:enumerator];
            }
            else
            {
                retVal = [joinpoint proceed];
            }

            if (retVal)
            {

                if (strcmp([invocation.methodSignature methodReturnType], @encode(void)) == 0)
                {
                    [NSException raise:NSInternalInconsistencyException
                                format:@"Proceeding join point provided return value but method %@ does not have one.",
                                       NSStringFromSelector(invocation.selector)];
                }

                [invocation setReturnValue:&retVal];
            }

            // After returning
            for (id<APAfterReturningAdvice> advice in [adviceTable afterReturningAdvice])
            {
                [advice afterReturning:joinpoint];
            }
        }
        @catch (NSException *exception)
        {
            // After throwing
            for (id<APAfterThrowingAdvice> advice in [adviceTable afterThrowingAdvice])
            {
                [advice afterThrowing:joinpoint exception:exception];
            }
        }
        @finally
        {
            // After
            for (id<APAfterAdvice> advice in [adviceTable afterAdvice])
            {
                [advice after:joinpoint];
            }
        }
    }
    else
    {
        [invocation invoke];
    }
}

- (id)adviseJoinPoint:(APJoinPointImpl *)joinPoint
         aroundAdvice:(id<APAroundAdvice>)advice
     adviceEnumerator:(NSEnumerator *)enumerator
{
    id<APAroundAdvice> nextAdvice = enumerator.nextObject;
    if (nextAdvice)
    {
        [joinPoint setProceedBlock:^id
        {

            return [self adviseJoinPoint:joinPoint
                            aroundAdvice:nextAdvice
                        adviceEnumerator:enumerator];
        }];
    }

    return [advice around:joinPoint];
}

- (NSInvocation *)copyOfInvocation:(NSInvocation *)invocation
{
    NSInvocation *copy = [[invocation class] invocationWithMethodSignature:[invocation methodSignature]];
    [copy setTarget:[invocation target]];
    [copy setSelector:[invocation selector]];

    NSUInteger argCount = [[invocation methodSignature] numberOfArguments];
    for (int i = 0; i < argCount; i++)
    {
        char buffer[sizeof(intmax_t)];
        [invocation getArgument:(void *) &buffer atIndex:i];
        [copy setArgument:(void *) &buffer atIndex:i];
    }
    return copy;
}

@end

@implementation AdviceTable
{
    NSDictionary *_internalTable;
}

- (id)initWithAdviceList:(NSArray *)adviceList
{
    self = [super init];
    if (self)
    {
        _internalTable = [self adviceTypeTableFromAdviceArray:adviceList];
    }
    return self;
}

- (NSDictionary *)adviceTypeTableFromAdviceArray:(NSArray *)adviceList
{
    NSMutableArray *beforeAdvice = [[NSMutableArray alloc] initWithCapacity:[adviceList count]];
    NSMutableArray *aroundAdvice = [[NSMutableArray alloc] initWithCapacity:[adviceList count]];
    NSMutableArray *afterReturningAdvice = [[NSMutableArray alloc] initWithCapacity:[adviceList count]];
    NSMutableArray *afterThrowingAdvice = [[NSMutableArray alloc] initWithCapacity:[adviceList count]];
    NSMutableArray *afterAdvice = [[NSMutableArray alloc] initWithCapacity:[adviceList count]];
    NSDictionary *adviceTable = @{
            NSStringFromProtocol(@protocol(APBeforeAdvice)) : beforeAdvice,
            NSStringFromProtocol(@protocol(APAroundAdvice)) : aroundAdvice,
            NSStringFromProtocol(@protocol(APAfterReturningAdvice)) : afterReturningAdvice,
            NSStringFromProtocol(@protocol(APAfterThrowingAdvice)) : afterThrowingAdvice,
            NSStringFromProtocol(@protocol(APAfterAdvice)) : afterAdvice,
    };

    for (id<APAdvice> advice in adviceList)
    {
        if ([advice conformsToProtocol:@protocol(APBeforeAdvice)])
        {
            [beforeAdvice addObject:advice];
        }
        if ([advice conformsToProtocol:@protocol(APAroundAdvice)])
        {
            [aroundAdvice addObject:advice];
        }
        if ([advice conformsToProtocol:@protocol(APAfterReturningAdvice)])
        {
            [afterReturningAdvice addObject:advice];
        }
        if ([advice conformsToProtocol:@protocol(APAfterThrowingAdvice)])
        {
            [afterThrowingAdvice addObject:advice];
        }
        if ([advice conformsToProtocol:@protocol(APAfterAdvice)])
        {
            [afterAdvice addObject:advice];
        }
    }
    return adviceTable;
}

- (NSArray *)adviceForProtocol:(Protocol *)protocol
{
    return _internalTable[NSStringFromProtocol(protocol)];
}

- (NSArray *)beforeAdvice
{
    return [self adviceForProtocol:@protocol(APBeforeAdvice)];
}

- (NSArray *)aroundAdvice
{
    return [self adviceForProtocol:@protocol(APAroundAdvice)];
}

- (NSArray *)afterReturningAdvice
{
    return [self adviceForProtocol:@protocol(APAfterReturningAdvice)];
}

- (NSArray *)afterThrowingAdvice
{
    return [self adviceForProtocol:@protocol(APAfterThrowingAdvice)];
}

- (NSArray *)afterAdvice
{
    return [self adviceForProtocol:@protocol(APAfterAdvice)];
}

@end