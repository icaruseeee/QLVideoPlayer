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
#import <MediaPlayer/MediaPlayer.h>

@interface VideoPlayerView ()
@property (nonatomic, strong) AVPlayer *player;
@end

@implementation VideoPlayerView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    [self configureVolume];
    [self setupUI];
    return self;
}

- (void)setupUI {
    [self createBottomView];
    [self createPlayButton];
    [self createProgress];
    [self createFullScreenBtn];
    
    UIPanGestureRecognizer *qlGes = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(qlGes:)];
    [self addGestureRecognizer:qlGes];
}

- (void)createBottomView{
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, self.frame.size.height - 20, self.width, 20)];
    bottomView.backgroundColor = [UIColor clearColor];
    bottomView.layer.zPosition = 1;
    self.bottomView = bottomView;
    [self addSubview:self.bottomView];
    [self bringSubviewToFront:self.bottomView];
}

- (void)createPlayButton{
    UIButton *playBtn = [[UIButton alloc] initWithFrame:CGRectMake(5, 0, 20, 20)];
    UIImage *playBtnIcon = [UIImage imageNamed:@"play"];
    [playBtn setImage:playBtnIcon forState:UIControlStateNormal];
    [playBtn addTarget:self action:@selector(onPlayBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    self.isPlay = NO;
    self.playButton = playBtn;
    [_bottomView addSubview:playBtn];
}

- (void)onPlayBtnClicked:(id)sender {
    _isPlay = !_isPlay;
    if (_isPlay) {
        [self.player play];
    } else {
        [self.player pause];
    }
    [self resetPlayBtn];
}

- (void)resetPlayBtn {
    UIImage *playBtnIcon = [UIImage imageNamed:@"play"];
    UIImage *pauseBtnIcon = [UIImage imageNamed:@"pause"];
    UIImage *btnIcon;
    if (_isPlay) {
        btnIcon = pauseBtnIcon;
    } else {
        btnIcon = playBtnIcon;
    }
    [_playButton setImage:btnIcon forState:UIControlStateNormal];
}

- (void)createProgress{
    CGFloat width = _isFullScreen == NO ? self.frame.size.width : self.frame.size.height;
    UISlider *progress = [[UISlider alloc] init];
    progress.frame = CGRectMake(30, -20, width - 60, 5);
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

- (void)createFullScreenBtn {
    CGFloat width = _isFullScreen == NO ? self.frame.size.width : self.frame.size.height;
    UIButton *fullScreenBtn = [[UIButton alloc] initWithFrame:CGRectMake(width - 25, 0, 20, 20)];
    UIImage *fsbIcon = [UIImage imageNamed:@"fullScreen"];
    [fullScreenBtn setImage:fsbIcon forState:UIControlStateNormal];
    [fullScreenBtn addTarget:self action:@selector(onFsBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    self.fullScreenButton = fullScreenBtn;
    [_bottomView addSubview:self.fullScreenButton];
}

- (void)onFsBtnClicked:(id)sender {
//    _isFullScreen = !_isFullScreen;
    NSLog(@"full screen clicked");
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
            _isPlay = YES;
            [self resetPlayBtn];
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
    _isPlay = NO;
    [self resetPlayBtn];
}

- (IBAction)sliderTouchUpInside {
    [self.player play];
    _isPlay = YES;
    [self resetPlayBtn];
}

#pragma mark - 音量相关
- (void)configureVolume {
    MPVolumeView *volumeView = [[MPVolumeView alloc] init];
    _volumeSlider = nil;
    
    for (UIView *view in [volumeView subviews]) {
        if ([view.class.description isEqualToString:@"MPVolumeSlider"]) {
            _volumeSlider = (UISlider *)view;
            break;
        }
    }
    
    // 在静音条件下播放声音
    NSError *setCategoryError = nil;
    BOOL success = [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:&setCategoryError];
    if (!success) { NSLog(@"volume category error"); }
}

#pragma mark - 手势相关
- (void)qlGes:(UIPanGestureRecognizer *) sender{
    CGPoint point = [sender locationInView:self];
    CGPoint velocityPoint = [sender velocityInView:self];
    switch (sender.state) {
        case UIGestureRecognizerStateBegan:
            {
                CGFloat x = fabs(velocityPoint.x);
                CGFloat y = fabs(velocityPoint.y);
                
                if (x > y) {
                    self.gesDirect = QLGesDirectHorizontal;
                    [self.player pause];
                    _isPlay = NO;
                    [self resetPlayBtn];
                    
                    CMTime currentTime = _player.currentTime;
                    self.sumTime = currentTime.value / currentTime.timescale;
                    
                    //TODO 进度视图
                } else if (x < y) {
                    self.gesDirect = QLGesDirectVertical;
                    if (point.x > [UIScreen mainScreen].bounds.size.width/2) {
                        _isVolume = YES;
                    } else {
                        _isVolume = NO;
                        
                        //TODO 亮度视图
                    }
                }
            }
            break;
        
        case UIGestureRecognizerStateChanged:
            {
                if (_gesDirect == QLGesDirectVertical) {
                    [self verticalGesChaned:velocityPoint.y];
                } else {
                    [self horizontalGesChanged:velocityPoint.x];
                }
            }
            break;
        
        case UIGestureRecognizerStateEnded:
            {
                if (_gesDirect == QLGesDirectHorizontal) {
                    [self.player seekToTime:CMTimeMake(self.sumTime, 1) toleranceBefore:kCMTimeZero toleranceAfter:kCMTimeZero];
                    
                    self.sumTime = 0;
                    [self.player play];
                    _isPlay = YES;
                    [self resetPlayBtn];
                } else {
                    _isVolume = NO;
                }
            }
            break;
        default:
            break;
    }
}

- (void)horizontalGesChanged:(CGFloat)gesPointX{
    if (_gesDirect != QLGesDirectHorizontal) { return; }
    
    _sumTime += gesPointX/500;
    
    if (_sumTime > CMTimeGetSeconds(self.playerItem.duration)) {
        _sumTime = CMTimeGetSeconds(self.playerItem.duration);
    } else if (_sumTime <= 0) {
        _sumTime = 0;
    }
}

- (void)verticalGesChaned:(CGFloat)gesPointY{
    if (_gesDirect != QLGesDirectVertical) { return; }
    if (_isVolume) {
        CGFloat volume = gesPointY / 10000;
        _volumeSlider.value -= volume;
        NSLog(@"%f", volume);
    } else {
        CGFloat brightness = [UIScreen mainScreen].brightness;
        brightness -= gesPointY / 10000;
        NSLog(@"%f", brightness);
        [[UIScreen mainScreen] setBrightness:brightness];
    }
}
@end
