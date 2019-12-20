//
//  QLVideoCell.h
//  QLVideoPlayer
//
//  Created by HuangRUi on 2019/12/16.
//  Copyright © 2019 QLTest. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface QLVideoCell : UITableViewCell
@property (weak, nonatomic)  UILabel *videoNameLabel;
@property (weak, nonatomic)  UILabel *timeLenLabel;
@property (weak, nonatomic)  UIImageView *thumImageView;
@end

NS_ASSUME_NONNULL_END
