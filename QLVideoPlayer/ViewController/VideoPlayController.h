//
//  VideoPlayController.h
//  QLVideoPlayer
//
//  Created by HuangRUi on 2019/12/17.
//  Copyright © 2019 QLTest. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#define StatusBarHeight [[UIApplication sharedApplication] statusBarFrame].size.height
#define NavBarHeight 44
#define NavHeight (StatusBarHeight + NavBarHeight)
#define ScreenWidth [UIScreen mainScreen].bounds.size.width
#define ScreenHeight [UIScreen mainScreen].bounds.size.height

NS_ASSUME_NONNULL_BEGIN

@interface VideoPlayController : UIViewController
@property (nonatomic, strong) AVPlayerItem *playerItem;
@property (weak, nonatomic) IBOutlet UIButton *playOrPause;
@property (weak, nonatomic) IBOutlet UIProgressView *progress;
@property (nonatomic) CGRect originFrame;
@end

NS_ASSUME_NONNULL_END
