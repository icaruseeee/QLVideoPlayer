//
//  VideoPlayerView+Delegate.m
//  QLVideoPlayer
//
//  Created by HuangRUi on 2019/12/18.
//  Copyright © 2019 QLTest. All rights reserved.
//

#import "VideoPlayerView+Delegate.h"
#import "frameAdjust.h"
#import <AVFoundation/AVFoundation.h>

@interface VideoPlayerView ()
@property (nonatomic, strong) AVPlayer *player;
@end

@implementation VideoPlayerView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    [self setupUI];
    return self;
}

- (void)setupUI {
    [self createBottomView];
    [self createProgress];
}

- (void)createBottomView{
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, self.frame.size.height - 20, self.width, 20)];
    bottomView.backgroundColor = [UIColor clearColor];
    bottomView.layer.zPosition = 1;
    self.bottomView = bottomView;
    [self addSubview:self.bottomView];
    [self bringSubviewToFront:self.bottomView];
}

- (void)createProgress{
    CGFloat width = _isFullScreen == NO ? self.frame.size.width : self.frame.size.height;
    UISlider *progress = [[UISlider alloc] init];
    progress.frame = CGRectMake(20, -20, width - 40, 5);
    progress.centerY = _bottomView.height / 2.0;
    progress.maximumValue = 1.0;
    [progress addTarget:self
                  action:@selector(sliderValueChange)
        forControlEvents:UIControlEventValueChanged];
    
    [progress addTarget:self
              action:@selector(sliderTouchDown)
    forControlEvents:UIControlEventTouchDown];
    
    [progress addTarget:self
              action:@selector(sliderTouchUpInside)
    forControlEvents:UIControlEventTouchUpInside];
    
    self.progress = progress;
    [_bottomView addSubview:self.progress];
}

- (void)loadWithPlayer:(AVPlayerItem *)player {
    UIInterfaceOrientation ori = [[UIApplication sharedApplication] statusBarOrientation];
    CGFloat videoHeight;
    if (ori != UIInterfaceOrientationPortrait) {
        videoHeight = 0;
    } else {
        videoHeight = NavHeight;
    }
    
    self.player = [[AVPlayer alloc] initWithPlayerItem:player];
    AVPlayerLayer *playerLayer = [AVPlayerLayer playerLayerWithPlayer:self.player];
    playerLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    playerLayer.contentsScale = [UIScreen mainScreen].scale;
    playerLayer.frame = CGRectMake(0, videoHeight, self.bounds.size.width, self.bounds.size.width *9/16);
    playerLayer.zPosition = 0;
    [self.layer addSublayer:playerLayer];
    
    // 监听status属性
    [self.player.currentItem addObserver:self
                              forKeyPath:@"status"
                                 options:NSKeyValueObservingOptionNew
                                 context:nil];
    
    // 监听播放完成通知
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(playerItemDidEnd)
                                                 name:AVPlayerItemDidPlayToEndTimeNotification
                                               object:nil];
}

- (void)playerItemDidEnd {
    NSLog(@"Finish");
    [self.player.currentItem removeObserver:self
                                 forKeyPath:@"status"];
}

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary<NSKeyValueChangeKey,id> *)change
                       context:(void *)context {
    AVPlayerItem *playerItem = (AVPlayerItem *)object;
    if ([keyPath isEqualToString:@"status"]) {
        if ([playerItem status] == AVPlayerItemStatusReadyToPlay) {
            NSLog(@"AVPlayerReadyToPlay");
            [self.player play];
            __weak typeof(self) weakSelf = self;
            CGFloat totalTime = CMTimeGetSeconds(self.player.currentItem.duration);
            [self.player addPeriodicTimeObserverForInterval:CMTimeMake(1.0, 1.0)
                                                      queue:dispatch_get_main_queue()
                                                 usingBlock:^(CMTime time) {
                weakSelf.progress.value = CMTimeGetSeconds(time) / totalTime;
            }];
        }
    }
}

- (IBAction)sliderValueChange {
    NSLog(@"Slide Value Change");
    if (_progress.value <= _progress.maximumValue) {
        CMTime moveTime = CMTimeMake(CMTimeGetSeconds(self.player.currentItem.duration) * _progress.value, 1.0);
        [self.player seekToTime:moveTime];
    }
}

- (IBAction)sliderTouchDown {
    // 监听status属性
    [self.player.currentItem addObserver:self
                              forKeyPath:@"status"
                                 options:NSKeyValueObservingOptionNew
                                 context:nil];
    [self.player pause];
}

- (IBAction)sliderTouchUpInside {
    [self.player play];
}
@end
