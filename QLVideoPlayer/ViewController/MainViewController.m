//
//  MainViewController.m
//  QLVideoPlayer
//
//  Created by HuangRUi on 2019/12/17.
//  Copyright © 2019 QLTest. All rights reserved.
//

#import "MainViewController.h"
#import "TopSlidesViewController.h"
#import "QLVideoScanController.h"
#import "frameAdjust.h"
#import "BottomArea+Delegate.h"

@interface MainViewController ()

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // 开始生成设备旋转notifications
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
    
    // 添加
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleDeviceOrientationDidChange:)
                                                 name:UIDeviceOrientationDidChangeNotification
                                               object:nil];
    
    [self setupUI];
}

#pragma mark - 响应横竖屏变化
- (void) handleDeviceOrientationDidChange:(UIInterfaceOrientation)interfaceOrientation
{
    UIDevice *device = [UIDevice currentDevice];
    if (device.orientation != self.lastOri){
        [self setupUI];
        self.lastOri = device.orientation;
    }
}

- (void)setupUI{
    CGFloat topPadding = 0;
    if (@available(iOS 11.0, *)) {
        UIWindow *window = UIApplication.sharedApplication.keyWindow;
        CGFloat topPaddingTemp = window.safeAreaInsets.top;
        topPadding = topPaddingTemp > StatusBarHeight? topPaddingTemp - StatusBarHeight: 0;
    }
    
    [self setupNav];
    
    TopSlidesViewController *tsvc = [[TopSlidesViewController alloc] init];
    [self addChildViewController:tsvc];
    [tsvc didMoveToParentViewController:self];
    [tsvc.view setFrame:CGRectMake(0, NavHeight, ScreenWidth, NavBarHeight)];
    [self.view addSubview:tsvc.view];
    
    QLVideoScanController *qvsc = [[QLVideoScanController alloc] init];
    [self addChildViewController:qvsc];
    [qvsc didMoveToParentViewController:self];
    [qvsc.view setFrame:CGRectMake(0, NavHeight + NavBarHeight, ScreenWidth, ScreenHeight - NavBarHeight * 2 - NavHeight)];
    [self.view addSubview:qvsc.view];
    
    UIViewController *bc = [[UIViewController alloc] init];
    bc.view = [[BottomArea alloc] initWithFrame:CGRectMake(0, ScreenHeight - NavBarHeight, ScreenWidth, NavBarHeight)];
    [self addChildViewController:bc];
    [bc didMoveToParentViewController:self];
    [self.view addSubview:bc.view];
}

- (void)setupNav{
    UIInterfaceOrientation ori = [[UIApplication sharedApplication] statusBarOrientation];
    if (ori != UIInterfaceOrientationPortrait) {
        self.navigationController.navigationBarHidden = YES;
    } else {
        self.navigationController.navigationBarHidden = NO;
    }
    
    self.navigationItem.title = @"烂片话题";
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:((0x18305C & 0xFF0000) >> 16) / 255.0
                                                                            green:((0x18305C & 0x00FF00) >> 8) / 255.0
                                                                            blue:(0x18305C & 0x0000FF) / 255.0
                                                                            alpha:1.0];
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
    UIImage *menuIcon = [UIImage imageNamed:@"menu"];
    UIImage *searchIcon = [UIImage imageNamed:@"search"];
    
    UIButton* leftButton = [UIButton buttonWithType:UIButtonTypeSystem];
    leftButton.backgroundColor = [UIColor clearColor];
    leftButton.frame = CGRectMake(0, 0, 65, 40);
    [leftButton setImage:menuIcon forState:UIControlStateNormal];
    [leftButton setTitle:@"菜单" forState:UIControlStateNormal];
    leftButton.tintColor = [UIColor whiteColor];
    leftButton.autoresizesSubviews = YES;
    leftButton.imageEdgeInsets = UIEdgeInsetsMake(10, 0, 10, 45);
    leftButton.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0);
    leftButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    leftButton.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleLeftMargin;
    [leftButton addTarget:self action:@selector(menuTouchDown) forControlEvents:UIControlEventTouchUpInside];
    UIView *leftCustomView = [[UIView alloc] initWithFrame:leftButton.frame];
    [leftCustomView addSubview:leftButton];
    UIBarButtonItem* leftItem = [[UIBarButtonItem alloc] initWithCustomView:leftCustomView];
    self.navigationItem.leftBarButtonItem = leftItem;
    
    UIButton* rightButton = [UIButton buttonWithType:UIButtonTypeSystem];
    rightButton.backgroundColor = [UIColor clearColor];
    rightButton.frame = CGRectMake(0, 0, 45, 40);
    [rightButton setImage:searchIcon forState:UIControlStateNormal];
    rightButton.tintColor = [UIColor whiteColor];
    rightButton.autoresizesSubviews = YES;
    rightButton.imageEdgeInsets = UIEdgeInsetsMake(10, 25, 10, 0);
    rightButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    rightButton.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleLeftMargin;
    [rightButton addTarget:self action:@selector(menuTouchDown) forControlEvents:UIControlEventTouchUpInside];
    UIView *rightCustomView = [[UIView alloc] initWithFrame:rightButton.frame];
    [rightCustomView addSubview:rightButton];
    UIBarButtonItem* rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightCustomView];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    UIBarButtonItem* backButtonItem = [[UIBarButtonItem alloc] init];
    backButtonItem.title = @"返回";
    self.navigationItem.backBarButtonItem = backButtonItem;
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
}

- (void)menuTouchDown{
    NSLog(@"Menu");
}
@end
