//
//  UIApplication+scanVideo.m
//  QLVideoPlayer
//
//  Created by HuangRUi on 2019/12/14.
//  Copyright © 2019 QLTest. All rights reserved.
//

#import "UIApplication+scanVideo.h"

@implementation UIApplication(scanVideo)

// 搜索视频结果
- (PHFetchResult *) assetsFetchResults {
    PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
    if (status != PHAuthorizationStatusAuthorized) {
        PHFetchResult *res = [PHAsset fetchAssetsWithOptions:nil];
        return res;
    }
    PHFetchOptions *fetchVidelOptions = [[PHFetchOptions alloc] init];
    
    // 扫描相册
    fetchVidelOptions.includeAssetSourceTypes = PHAssetSourceTypeUserLibrary;
    // 时间排序
    fetchVidelOptions.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:YES]];
    
    return [PHAsset fetchAssetsWithMediaType:PHAssetMediaTypeVideo options:fetchVidelOptions];
}

// 获取视频信息
- (NSArray *) getVideoRelatedAttrsArray:(QLVideoAssetType) type {
    NSMutableArray *sourceArray = [NSMutableArray arrayWithCapacity:self.assetsFetchResults.count];
    
    for(PHAsset *asset in self.assetsFetchResults) {
        NSString *videoName = [asset valueForKey:@"filename"];
        CGSize videoSize = CGSizeMake(240, 135);
        PHImageRequestOptions *options = [PHImageRequestOptions new];
        options.synchronous = YES;
        options.resizeMode = PHImageRequestOptionsResizeModeExact;
        
        [[PHImageManager defaultManager] requestImageForAsset:asset
                                                   targetSize:CGSizeMake(videoSize.width, videoSize.height)
                                                  contentMode:PHImageContentModeAspectFill
                                                      options:options
                                                resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
            UIImage *image = result;
            NSString *timeLen = [self formatVideoTime:[self getVideoDuration:asset]];
            
            switch (type) {
                case QLVideoAssetTypeVideoName:
                    [sourceArray addObject:videoName];
                    break;
                    
                case QLVideoAssetTypeVideoImageSource:
                    [sourceArray addObject:image];
                    break;
                    
                case QLVideoAssetTypeVideoTimeLength:
                    [sourceArray addObject:timeLen];
                    break;
                default:
                    break;
            }
        }];
    }
    
    return sourceArray;
}

- (NSString *) formatVideoTime:(NSInteger)duration {
    NSInteger h = (NSInteger)duration/3600;
    NSInteger mTotal = (NSInteger)duration%3600;
    NSInteger m = mTotal/60;
    NSInteger s = mTotal%60;
    
    return [NSString stringWithFormat:@"%02ld:%02ld:%02ld", (long)h,(long)m,(long)s];
}

- (NSInteger) getVideoDuration:(PHAsset *)asset {
    NSInteger duration;
    NSInteger time = asset.duration;
    double time2 = (double)(asset.duration - time);
    
    if (time2 < 0.5) {
        duration = asset.duration;
    } else {
        duration = asset.duration + 1;
    }
    
    return duration;
}

@end
