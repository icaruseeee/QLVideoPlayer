//
//  UIApplication+scanVideo.h
//  QLVideoPlayer
//
//  Created by HuangRUi on 2019/12/14.
//  Copyright © 2019 QLTest. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Photos/Photos.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, QLVideoAssetType) {
    QLVideoAssetTypeVideoImageSource,
    QLVideoAssetTypeVideoTimeLength,
    QLVideoAssetTypeVideoName,
};

@interface UIApplication(scanVideo)

// 搜索视频结果
- (PHFetchResult *) assetsFetchResults;

// 获取视频信息
- (NSArray *) getVideoRelatedAttrsArray:(QLVideoAssetType) type;

@end

NS_ASSUME_NONNULL_END
