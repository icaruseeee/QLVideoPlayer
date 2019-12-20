//
//  TopSlides+Delegate.h
//  QLVideoPlayer
//
//  Created by HuangRUi on 2019/12/10.
//  Copyright © 2019 QLTest. All rights reserved.
//

#import <UIKit/UIKit.h>
#define ScreenWidth [UIScreen mainScreen].bounds.size.width
#define ScreenHeight [UIScreen mainScreen].bounds.size.height
@class TopSlides;

NS_ASSUME_NONNULL_BEGIN

@protocol TopSlidesDelegate <NSObject>

- (void)topSlides:(TopSlides *)topSlides didClickButtonAtIndex:(NSInteger) index;

@end

@interface TopSlides : UIView

@property (nonatomic, strong) NSArray *slideArray;
@property (nonatomic, weak) id<TopSlidesDelegate> delegate;

- (void)selectButtonAtButtonIndex:(NSInteger)buttonIndex;

@end

NS_ASSUME_NONNULL_END
