//
//  ReportViewController.h
//  NewXMPPTest
//
//  Created by Tolecen on 13-7-18.
//  Copyright (c) 2013年 Tolecen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
@interface ReportViewController : UIViewController<UITextViewDelegate,MBProgressHUDDelegate>
{
    UILabel * remainingLabel;
    MBProgressHUD * hud;
}
@property (strong,nonatomic) UITextView * inputTextF;
@property (strong,nonatomic) NSString * theTitle;
@property (strong,nonatomic) NSString * defaultContent;
@property (assign,nonatomic) int maxCount;
@end
