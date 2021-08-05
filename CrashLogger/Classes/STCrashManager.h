//
//  STCrashManager.h
//  CrashLogger
//
//  Created by Endless Summer on 2021/8/4.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN


@interface STCrashManager : NSObject

+ (void)regiterHandle;

+ (void)openPluginFrom:(UIViewController *)fromVC;

@end

NS_ASSUME_NONNULL_END
