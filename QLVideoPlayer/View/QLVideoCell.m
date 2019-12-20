//
//  QLVideoCell.m
//  QLVideoPlayer
//
//  Created by HuangRUi on 2019/12/16.
//  Copyright © 2019 QLTest. All rights reserved.
//

#import "QLVideoCell.h"
#define ScreenWidth [UIScreen mainScreen].bounds.size.width

@implementation QLVideoCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self) {
        [self setupView];
    }
    return self;
}

- (void)setupView{
    self.backgroundColor = [UIColor colorWithRed:((0x303632 & 0xFF0000) >> 16) / 255.0
                                           green:((0x303632 & 0x00FF00) >> 8) / 255.0
                                            blue:(0x303632 & 0x0000FF) / 255.0
                                           alpha:1.0];
    
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(242, 20, ScreenWidth - 250, 20)];
//    nameLabel.backgroundColor = [UIColor whiteColor];
    nameLabel.textColor = [UIColor whiteColor];
    nameLabel.textAlignment = NSTextAlignmentRight;
    self.videoNameLabel = nameLabel;
    [self addSubview:self.videoNameLabel];
    
    UILabel *timeLenLabel = [[UILabel alloc] initWithFrame:CGRectMake(242, 40, ScreenWidth - 250, 20)];
    timeLenLabel.textColor = [UIColor whiteColor];
    timeLenLabel.textAlignment = NSTextAlignmentRight;
    self.timeLenLabel = timeLenLabel;
    [self addSubview:self.timeLenLabel];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 20, 240, 135)];
    self.thumImageView = imageView;
    [self addSubview:self.thumImageView];
    
    UIView *bottomLine = [[UIView alloc] initWithFrame:CGRectMake(0, 173, ScreenWidth, 2)];
    bottomLine.backgroundColor = [UIColor colorWithRed:((0x18305C & 0xFF0000) >> 16) / 255.0
                                                 green:((0x18305C & 0x00FF00) >> 8) / 255.0
                                                  blue:(0x18305C & 0x0000FF) / 255.0
                                                 alpha:1.0];
    [self addSubview:bottomLine];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
