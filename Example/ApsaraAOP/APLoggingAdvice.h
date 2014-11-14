//
//  APLoggingAdvice.h
//  ApsaraAOP
//
//  Created by Erik Sundin on 14/11/14.
//  Copyright (c) 2014 Erik Sundin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ApsaraAOP.h>

@interface APLoggingAdvice : NSObject <APBeforeAdvice, APAroundAdvice, APAfterAdvice, APAfterThrowingAdvice>

@end
