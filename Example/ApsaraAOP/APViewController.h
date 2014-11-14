//
//  APViewController.h
//  ApsaraAOP
//
//  Created by Erik Sundin on 11/13/2014.
//  Copyright (c) 2014 Erik Sundin. All rights reserved.
//

#import <UIKit/UIKit.h>

@class APService;
@interface APViewController : UIViewController

- (instancetype)initWithService:(APService *)service;

@end
