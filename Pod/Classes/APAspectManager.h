//
//  APAspectManager.h
//  ApsaraAOPTests
//
//  Created by Erik Sundin on 27/12/13.
//
//

#import <Foundation/Foundation.h>

/**
 Manages aspects and creation of advised objects.
 */
@protocol APAdvice, APPointcut;
@interface APAspectManager : NSObject

/**
 Register a new advice for a pointcut.
 @param advice The advice to register.
 @param pointcut The pointcut.
 */
- (void)registerAdvice:(id<APAdvice>)advice
              pointcut:(id<APPointcut>)pointcut;

/**
 Factory method for creating an advised proxy for an object.
 @param object The object to advise.
 @return A proxied object or the same object if no pointcuts match.
 */
- (id)advisedProxy:(id)object;

@end
