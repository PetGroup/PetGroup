//
//  ContentDetailViewController.h
//  PetGroup
//
//  Created by Tolecen on 13-11-28.
//  Copyright (c) 2013年 Tolecen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>
#import "EGOImageButton.h"
#import "WebViewViewController.h"
#import "PhotoViewController.h"
#import "MBProgressHUD.h"
#import "TempData.h"
typedef  enum
{
    contentTypeWebView = 0,
    contentTypeTextView
}ContentType;
typedef  enum
{
    ButtonTypeImage = 1,
    ButtonTypeNormal
}ButtonType;
@interface ContentDetailViewController : UIViewController<DTAttributedTextContentViewDelegate,MBProgressHUDDelegate,UIAlertViewDelegate,UIWebViewDelegate>
{
    DTAttributedTextView *_textView;
    MBProgressHUD * hud;
    UIWebView * theWebView;
}
@property (nonatomic, strong) NSMutableSet *mediaPlayers;
@property (nonatomic,strong)NSString * typeName;
@property (nonatomic,strong)NSString * articleID;
@property (nonatomic,assign)ContentType contentType;
@property (nonatomic,assign)BOOL needDismiss;
@property (nonatomic,assign)BOOL needRequestURL;
@property (nonatomic,assign)BOOL isSystemNoti;
@property (strong,nonatomic)NSURL * addressURL;
@end
