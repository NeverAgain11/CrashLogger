//
//  STViewController.m
//  CrashLogger
//
//  Created by ljk on 08/04/2021.
//  Copyright (c) 2021 ljk. All rights reserved.
//

#import "STViewController.h"
#import <CrashLogger/STCrashManager.h>


@interface STViewController ()

@end

@implementation STViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    [STCrashManager regiterHandle];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [STCrashManager openPluginFrom:self];
    
//    NSArray *a = @[];
//
//    NSString *asd = a[0];
//
//    NSLog(asd);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
