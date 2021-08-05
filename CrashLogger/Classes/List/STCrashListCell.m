//
//  DoraemonCrashListCell.m
//  DoraemonKit
//
//  Created by wenquan on 2018/11/22.
//

#import "STCrashListCell.h"
#import "STSandboxModel.h"

@interface STCrashListCell ()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIImageView *arrowImageView;

@end

@implementation STCrashListCell

#pragma mark - Lifecycle

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = [UIColor blackColor];
        _titleLabel.font = [UIFont systemFontOfSize:16];
        _titleLabel.adjustsFontSizeToFitWidth = true;
        [self.contentView addSubview:_titleLabel];
        
        
    }
    return self;
}

#pragma mark - Public

- (void)renderUIWithData:(STSandboxModel *)model {
    self.titleLabel.text = @"";
    if ([model.name isKindOfClass:[NSString class]] && (model.name.length > 0)) {
        self.titleLabel.text = model.name;
        [self.titleLabel sizeToFit];
        CGFloat w = self.titleLabel.frame.size.width;
        if (w > [UIScreen mainScreen].bounds.size.width-((120)*[UIScreen mainScreen].bounds.size.height/750)) {
            w = [UIScreen mainScreen].bounds.size.width-((120)*[UIScreen mainScreen].bounds.size.height/750);
        }
        self.titleLabel.frame = CGRectMake(((32)*[UIScreen mainScreen].bounds.size.height/750), [[self class] cellHeight]/2-self.titleLabel.frame.size.height/2, w, self.titleLabel.frame.size.height);
    }
}

+ (CGFloat)cellHeight{
    return ((44)*[UIScreen mainScreen].bounds.size.height/750);
}

@end
