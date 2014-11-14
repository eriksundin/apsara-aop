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
#import "APLoggingAdvice.h"

@interface APAppDelegate ()

@property (nonatomic, strong) APAspectManager *aspectManager;

@end


@implementation APAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // We want to cut in on calls to the APService class
    id<APPointcut> pointcut = [APBlockMatchingPointcut pointcutWithBlock:^BOOL(id target, SEL selector) {
        return [target isKindOfClass:[APService class]];
    }];
    self.aspectManager = [APAspectManager new];
    [self.aspectManager registerAdvice:[APLoggingAdvice new] pointcut:pointcut];
    
    // Proxy the service
    APService *service = [self.aspectManager advisedProxy:[APService new]];
    APViewController *viewController = [[APViewController alloc] initWithService:service];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.rootViewController = viewController;
    [self.window makeKeyAndVisible];
    return YES;
}

@end
