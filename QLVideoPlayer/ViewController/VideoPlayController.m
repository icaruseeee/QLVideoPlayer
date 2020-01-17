//
//  VideoPlayController.m
//  QLVideoPlayer
//
//  Created by HuangRUi on 2019/12/17.
//  Copyright © 2019 QLTest. All rights reserved.
//

#import "VideoPlayController.h"
#import "VideoPlayerView+Delegate.h"

@interface VideoPlayController ()<VideoPlayerDelegate>
@property (nonatomic, strong) AVPlayer *player;
@end

@implementation VideoPlayController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setupView];
}

- (void)setupView {
    UIInterfaceOrientation ori = [[UIApplication sharedApplication] statusBarOrientation];
    CGFloat videoHeight;
    if (ori != UIInterfaceOrientationPortrait) {
        videoHeight = 0;
    } else {
        videoHeight = NavHeight;
    }
    
    VideoPlayerView *vpView = [[VideoPlayerView alloc] initWithFrame:CGRectMake(0, videoHeight, ScreenWidth, NavHeight + self.view.bounds.size.width * 9/16)];
    vpView.delegate = self;
    [vpView loadWithPlayer:_playerItem];
    self.view = vpView;
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)videoPlayerView:(nonnull VideoPlayerView *)videoPlayerView clickFullScreenBtn:(BOOL)isFullScreen {
    NSLog(@"full screen clicked");
}

@end
