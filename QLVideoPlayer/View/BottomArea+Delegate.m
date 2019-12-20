//
//  BottomArea+Delegate.m
//  QLVideoPlayer
//
//  Created by HuangRUi on 2019/12/10.
//  Copyright © 2019 QLTest. All rights reserved.
//

#import "BottomArea+Delegate.h"

@implementation BottomArea

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    self.backgroundColor = [UIColor colorWithRed:((0x18305C & 0xFF0000) >> 16) / 255.0
                                           green:((0x18305C & 0x00FF00) >> 8) / 255.0
                                            blue:(0x18305C & 0x0000FF) / 255.0
                                           alpha:1.0];
    return self;
}

@end
