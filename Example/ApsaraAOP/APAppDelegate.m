//
//  APAppDelegate.m
//  ApsaraAOP
//
//  Created by CocoaPods on 11/13/2014.
//  Copyright (c) 2014 Erik Sundin. All rights reserved.
//

#import "APAppDelegate.h"
#import <ApsaraAOP.h>
#import "APViewController.h"
#import "APService.h"

@interface APAppDelegate () <APBeforeAdvice, APAroundAdvice, APAfterAdvice, APAfterThrowingAdvice>

@property (nonatomic, strong) APAspectManager *aspectManager;

@end


@implementation APAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // We want to cut in on calls to -apiCall on the APService class
    id<APPointcut> pointcut = [APBlockMatchingPointcut pointcutWithBlock:^BOOL(id target, SEL selector) {
        return [target isKindOfClass:[APService class]] && selector == @selector(apiCall);
    }];
    self.aspectManager = [[APAspectManager alloc] init];
    [self.aspectManager registerAdvice:self pointcut:pointcut];
    
    // Proxy the service
    APService *service = [self.aspectManager advisedProxy:[[APService alloc] init]];
    APViewController *viewController = [[APViewController alloc] initWithService:service];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.rootViewController = viewController;
    [self.window makeKeyAndVisible];
    return YES;
}

#pragma mark - APAdvice

- (void)traceJoinPoint:(id<APJoinPoint>)joinpoint state:(NSString *)state {
    NSLog(@"[%@] %@ %@", NSStringFromClass([[joinpoint target] class]), state, NSStringFromSelector([joinpoint selector]));
}

- (void)before:(id<APJoinPoint>)joinpoint {
    [self traceJoinPoint:joinpoint state:@"before"];
}

- (id)around:(id<APProceedingJoinPoint>)joinpoint {
    [self traceJoinPoint:joinpoint state:@"around before proceed"];
    id retVal = [joinpoint proceed];
    [self traceJoinPoint:joinpoint state:@"around after proceed"];
    return retVal;
}

- (void)after:(id<APJoinPoint>)joinpoint {
    [self traceJoinPoint:joinpoint state:@"after"];
}

- (void)afterThrowing:(id<APJoinPoint>)joinpoint exception:(NSException *)exception {
    [self traceJoinPoint:joinpoint state:[NSString stringWithFormat:@"throwing %@", [exception name]]];
}

@end
