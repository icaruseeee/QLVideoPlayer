//
//  QLVideoScanController.h
//  QLVideoPlayer
//
//  Created by HuangRUi on 2019/12/14.
//  Copyright © 2019 QLTest. All rights reserved.
//

#import <UIKit/UIKit.h>

#define StatusBarHeight [[UIApplication sharedApplication] statusBarFrame].size.height
#define NavBarHeight 44
#define NavHeight (StatusBarHeight + NavBarHeight)
#define ScreenWidth [UIScreen mainScreen].bounds.size.width
#define ScreenHeight [UIScreen mainScreen].bounds.size.height

NS_ASSUME_NONNULL_BEGIN

@interface QLVideoScanController : UITableViewController

@end

NS_ASSUME_NONNULL_END
