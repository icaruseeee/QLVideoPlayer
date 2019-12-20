//
//  TopSlides+Delegate.m
//  QLVideoPlayer
//
//  Created by HuangRUi on 2019/12/10.
//  Copyright © 2019 QLTest. All rights reserved.
//

#import "TopSlides+Delegate.h"
#import "frameAdjust.h"

const NSInteger Button_Begin_Tag = 100;

@interface BadgeButton : UIButton

@end

@implementation BadgeButton

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    self.clipsToBounds = NO;
    
    return self;
}

- (void)setSelected:(BOOL)selected{
    if(selected) {
        [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.titleLabel setFont:[UIFont boldSystemFontOfSize:16]];
    } else {
        [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.titleLabel setFont:[UIFont systemFontOfSize:16]];
    }
}
@end

@interface TopSlides() {
    UIView *_bottomLine;
}
@end

@implementation TopSlides

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    [self setUpUI];
    return self;
}

- (void)setUpUI {
    self.backgroundColor = [UIColor grayColor];
    _bottomLine = [[UIView alloc] initWithFrame:CGRectMake(0, self.frame.size.height - 2, 0, 2)];
    [self addSubview:_bottomLine];
    _bottomLine.backgroundColor = [UIColor whiteColor];
}

#pragma mark - 设置slides文本
- (void)setSlideArray:(NSArray *)slideArray {
    NSLog(@"Array length:%lu", slideArray.count);
    _slideArray = slideArray;
    
    for (BadgeButton *button in self.subviews) {
        if ([button isMemberOfClass:[BadgeButton class]]) {
            [button removeFromSuperview];
        }
    }
    
    for (int i = 0; i < _slideArray.count; i ++) {
        CGFloat buttonWidth = ScreenWidth / _slideArray.count;
        BadgeButton *btn = [[BadgeButton alloc]initWithFrame:CGRectMake(i * buttonWidth, 0, buttonWidth, self.frame.size.height - 2)];
        [self addSubview:btn];
        btn.selected = NO;
        [btn addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchDown];
        btn.tag = Button_Begin_Tag + i;
        [btn setTitle:_slideArray[i] forState:UIControlStateNormal];
        [btn layoutIfNeeded];
    }
}

- (void)buttonClicked:(BadgeButton *)sender{
    NSInteger index = sender.tag - Button_Begin_Tag;
    [self selectButtonAtButtonIndex:index];
    if([self.delegate respondsToSelector:@selector(topSlides:didClickButtonAtIndex:)]) {
        [self.delegate topSlides:self didClickButtonAtIndex:index];
    }
}

- (void)selectButtonAtButtonIndex:(NSInteger)buttonIndex {
    for (int i = 0; i < _slideArray.count; i++) {
        BadgeButton *button = [self viewWithTag:(i + Button_Begin_Tag)];
        if (i == buttonIndex) {
            [button setSelected:true];
        } else {
            [button setSelected:false];
        }
    }
    
    BadgeButton *button = [self viewWithTag:(buttonIndex + Button_Begin_Tag)];
    
    [UIView animateWithDuration:0.3 animations:^{
        self->_bottomLine.width = button.titleLabel.width;
        self->_bottomLine.centerX = button.centerX;
    }];
    
}
@end
