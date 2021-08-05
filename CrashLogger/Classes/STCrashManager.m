//
//  STCrashManager.m
//  CrashLogger
//
//  Created by Endless Summer on 2021/8/4.
//

#import "STCrashManager.h"
#import "STCrashUncaughtExceptionHandler.h"
#import "STCrashSignalExceptionHandler.h"
#import "STCrashListViewController.h"

@implementation STCrashManager

+ (void)openPluginFrom:(UIViewController *)fromVC {
    UIViewController *vc = [[STCrashListViewController alloc]init];
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:vc];
    [nav setModalPresentationStyle: UIModalPresentationPageSheet];
    [fromVC presentViewController:nav animated:true completion:nil];
}

+ (void)regiterHandle {
    [STCrashUncaughtExceptionHandler registerHandler];
    [STCrashSignalExceptionHandler registerHandler];
}

@end
