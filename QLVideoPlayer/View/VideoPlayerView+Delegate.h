//
//  VideoPlayerView+Delegate.h
//  QLVideoPlayer
//
//  Created by HuangRUi on 2019/12/18.
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

typedef NS_ENUM(NSInteger, QLGesDirect) {
    QLGesDirectHorizontal,
    QLGesDirectVertical,
};

@protocol VideoPlayerDelegate <NSObject>

- (void)getControllerItem: (AVPlayerItem *)player;

@end

@interface VideoPlayerView: UIView
@property(nonatomic) BOOL isFullScreen;
@property(nonatomic) BOOL isPlay;
@property(nonatomic) CGFloat sumTime;
@property(nonatomic) BOOL isVolume;
@property(nonatomic, strong) AVPlayerItem *playerItem;
@property(nonatomic, weak) UIView *bottomView;
@property(nonatomic, weak) UIButton *playButton;
@property(nonatomic, weak) UISlider *progress;
@property(nonatomic, weak) UIButton *fullScreenButton;
@property(nonatomic, weak) UISlider *volumeSlider;

@property(nonatomic) QLGesDirect gesDirect;

- (void)loadWithPlayer:(AVPlayerItem *)player;
@end

NS_ASSUME_NONNULL_END
