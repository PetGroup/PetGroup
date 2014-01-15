//
//  QRCustomViewControllerViewController.h
//  PetGroup
//
//  Created by wangxr on 14-1-15.
//  Copyright (c) 2014年 Tolecen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <Decoder.h>
@class QRCustomViewController;

@protocol CustomViewControllerDelegate <NSObject>

@optional
- (void)customViewController:(QRCustomViewController *)controller didScanResult:(NSString *)result;
- (void)customViewControllerDidCancel:(QRCustomViewController *)controller;

@end
@interface QRCustomViewController : UIViewController
@property (nonatomic, assign) id<CustomViewControllerDelegate> delegate;
@end
