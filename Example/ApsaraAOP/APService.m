//
//  APService.m
//  ApsaraAOP
//
//  Created by Erik Sundin on 14/11/14.
//  Copyright (c) 2014 Erik Sundin. All rights reserved.
//

#import "APService.h"

@implementation APService

- (void)apiCall {
    NSLog(@"making api call.");
    [NSException raise:@"SomethingWentWrongException" format:nil];
}

@end
