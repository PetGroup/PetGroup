//
//  WebViewViewController.h
//  PetGroup
//
//  Created by Tolecen on 13-11-1.
//  Copyright (c) 2013年 Tolecen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
@interface WebViewViewController : UIViewController<MBProgressHUDDelegate,UIAlertViewDelegate>
{
    MBProgressHUD * hud;
    UIWebView * theWebView;
}
@property (strong,nonatomic)NSURL * addressURL;
@end
