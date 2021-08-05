//
//  DoraemonCrashListCell.h
//  DoraemonKit
//
//  Created by wenquan on 2018/11/22.
//

#import <UIKit/UIKit.h>

@class STSandboxModel;

NS_ASSUME_NONNULL_BEGIN

@interface STCrashListCell : UITableViewCell

- (void)renderUIWithData:(STSandboxModel *)model;

+ (CGFloat)cellHeight;

@end

NS_ASSUME_NONNULL_END
