//
//  APViewController.m
//  ApsaraAOP
//
//  Created by Erik Sundin on 11/13/2014.
//  Copyright (c) 2014 Erik Sundin. All rights reserved.
//

#import "APViewController.h"
#import "APService.h"

@interface APViewController ()

@property (nonatomic, strong) APService *service;

@end

@implementation APViewController

- (instancetype)initWithService:(APService *)service {
    self = [super init];
    if (self) {
        _service = service;
    }
    return self;
}

- (void)loadView {
    [super loadView];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setBackgroundColor:[UIColor blueColor]];
    [button setTitle:@"Service Call" forState:UIControlStateNormal];
    [button setFrame:CGRectMake(0, 0, 200.0, 44.0)];
    [button setCenter:self.view.center];
    [button addTarget:self action:@selector(actionButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}

- (void)actionButtonPressed:(id)sender {
    [self.service apiCall];
}

@end
