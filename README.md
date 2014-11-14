Proxy based Aspect Oriented Programming framework for Objective-C

Note: This framework was developed merely as a proof of concept and should be considered unstable in its current state.

## Structure

An *APJoinPoint* represents a method execution.

An *APPointCut* is a predictate that matches a join point.

An *APAdvice* is what to do at a join point.

--
*APBeforeAdvice* executes before a join point.

*APAfterAdvice* executes after a join point.

*APAfterThrowingAdvice* executes if a join point throws an Exception.

*APAfterAdvice* sorrounds the join point and gives the advice implementation control of proceeding with the join point execution and the return value.

## Usage

Check out the example project for a demo of how you could use the framework.

```
cd Example
pod install
open ApsaraAOP.xcworkspace
```

Preview
```
@interface MyAroundAdvice : NSObject <APAroundAdvice>
@end

@implementation MyAroundAdvice

- (id)around:(id<APProceedingJoinPoint>)joinpoint {
    // The method has not beed called yet.
    // .. Do some pre processing
    
    id returnValue = [joinpoint proceed];
    
    // .. Do some post processing
    
    return returnValue;
}

@end

...

// Simple pointcut that matches all invocations on a class
id<APPointcut> pointcut = [APBlockMatchingPointcut pointcutWithBlock:^BOOL(id target, SEL selector) {
        return [target isKindOfClass:[MyService class]];
    }];

APAspectManager *aspectManager = [APAspectManager new];
[aspectManager registerAdvice:[MyAroundAdvice new] pointcut:pointcut];

MyService *service = [aspectManager advisedProxy:[MyService new]];

// The advice will be applied on calls
NSDictionary *data = [service dataDictionary];

```

## Limitations

Objects need to be passed through the APAspectManager in order to be proxied. That means the framework is best suited for a Dependecy Injection Container or such which has central object creation control.

Since the framework is proxy-based, method calls on self from within an object cannot be intercepted.

In the current implementation:
only methods with object-type return value can be intercepted.
only object-type arguments can be accessed on a JoinPoint within an advice.

## Author

Erik Sundin, erik@eriksundin.se

## License

ApsaraAOP is available under the MIT license. See the LICENSE file for more info.

