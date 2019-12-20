//
//  QLVideoScanController.m
//  QLVideoPlayer
//
//  Created by HuangRUi on 2019/12/14.
//  Copyright © 2019 QLTest. All rights reserved.
//

#import "QLVideoScanController.h"
#import "UIApplication+scanVideo.h"
#import "QLVideoCell.h"
#import "VideoPlayController.h"
#import <Photos/Photos.h>

@interface QLVideoScanController () <UITableViewDelegate, UITableViewDataSource>

@end

@implementation QLVideoScanController

- (void)viewDidLoad {
    [super viewDidLoad];
    CGFloat topPadding = 0;
    if (@available(iOS 11.0, *)) {
        UIWindow *window = UIApplication.sharedApplication.keyWindow;
        CGFloat topPaddingTemp = window.safeAreaInsets.top;
        topPadding = topPaddingTemp > StatusBarHeight? topPaddingTemp - StatusBarHeight: 0;
    }
    [self checkStatus];
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)
                                                          style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.backgroundColor = [UIColor colorWithRed:((0x303632 & 0xFF0000) >> 16) / 255.0
                                                green:((0x303632 & 0x00FF00) >> 8) / 255.0
                                                 blue:(0x303632 & 0x0000FF) / 255.0
                                                alpha:1.0];
    self.tableView = tableView;
    
    [self.tableView registerClass:[QLVideoCell class] forCellReuseIdentifier:@"videoCell"];
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    PHFetchResult* arr = [UIApplication sharedApplication].assetsFetchResults;
    return arr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    QLVideoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"videoCell" forIndexPath:indexPath];
    
    if (!cell) {
        cell = [[QLVideoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"videoCell"];
    }
    
    cell.videoNameLabel.text = [[UIApplication sharedApplication]getVideoRelatedAttrsArray:QLVideoAssetTypeVideoName][indexPath.row];
    cell.thumImageView.image = [[UIApplication sharedApplication]getVideoRelatedAttrsArray:QLVideoAssetTypeVideoImageSource][indexPath.row];
    cell.timeLenLabel.text = [[UIApplication sharedApplication]getVideoRelatedAttrsArray:QLVideoAssetTypeVideoTimeLength][indexPath.row];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    return 175;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    PHAsset *asset = [UIApplication sharedApplication].assetsFetchResults[indexPath.row];

    [[PHImageManager defaultManager] requestPlayerItemForVideo:asset
                                                       options:nil
                                                 resultHandler:^(AVPlayerItem * _Nullable playerItem,
                                                                 NSDictionary * _Nullable info)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            VideoPlayController *vpc = [[VideoPlayController alloc] init];
            vpc.playerItem = playerItem;
            [self.navigationController pushViewController:vpc animated:YES];
            NSLog(@"Player Callback");
        });
    }];
}

- (void)checkStatus{
    PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
    switch (status) {
        case PHAuthorizationStatusDenied:
        case PHAuthorizationStatusNotDetermined:
            NSLog(@"请打开访问相册的权限");
            [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus rStatus) {
                if (rStatus == PHAuthorizationStatusAuthorized) {
                    NSLog(@"权限打开成功");
                } else {
                    NSLog(@"权限打开失败");
                }
            }];
            break;
        case PHAuthorizationStatusRestricted:
            NSLog(@"处于家长控制模式");
            break;
        default:
            break;
    }
}
@end
