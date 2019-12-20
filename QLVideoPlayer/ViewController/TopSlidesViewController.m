//
//  TopSlidesViewController.m
//  QLVideoPlayer
//
//  Created by HuangRUi on 2019/12/12.
//  Copyright © 2019 QLTest. All rights reserved.
//

#import "TopSlidesViewController.h"
#import "TopSlides+Delegate.h"

@interface TopSlidesViewController ()<TopSlidesDelegate>

@end

@implementation TopSlidesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    TopSlides *topSlides = [[TopSlides alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, NavBarHeight)];
    [self.view addSubview:topSlides];
    topSlides.slideArray = @[@"好片评点", @"烂片话题", @"新片预告"];
    topSlides.delegate = self;
    self.slideArray = topSlides.slideArray;
    [topSlides selectButtonAtButtonIndex:1];
}

#pragma mark - slides代理
- (void)topSlides:(TopSlides *)topSlides didClickButtonAtIndex:(NSInteger)index{
    NSLog(@"点击了第%ld个button", index);
    self.parentViewController.navigationItem.title = self.slideArray[index];
}
@end
