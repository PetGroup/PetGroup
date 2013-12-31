//
//  EditShareContentViewController.m
//  PetGroup
//
//  Created by wangxr on 13-12-19.
//  Copyright (c) 2013年 Tolecen. All rights reserved.
//

#import "EditShareContentViewController.h"
#import <ShareSDK/ShareSDK.h>
#import "MBProgressHUD.h"
@interface EditShareContentViewController ()
{
    int beganCount;
    MBProgressHUD* hud;
}
@property (nonatomic,retain) UITextView * textV;
@end

@implementation EditShareContentViewController
-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    float diffH = [Common diffHeight:self];
    
    UIImageView *TopBarBGV=[[UIImageView alloc]initWithImage:[UIImage imageNamed:diffH==0?@"topBar1.png":@"topBar2.png"]];
    [TopBarBGV setFrame:CGRectMake(0, 0, 320, 44+diffH)];
    [self.view addSubview:TopBarBGV];
    
    UIButton *backButton=[UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame=CGRectMake(0, 0+diffH, 80, 44);
    [backButton setBackgroundImage:[UIImage imageNamed:@"backnew.png"] forState:UIControlStateNormal];
    [self.view addSubview:backButton];
    [backButton addTarget:self action:@selector(backButton) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *  titleLabel=[[UILabel alloc] initWithFrame:CGRectMake(50, 2+diffH, 220, 40)];
    titleLabel.backgroundColor=[UIColor clearColor];
    switch (self.shareStyle) {
        case shareStyleSineWeiBo:{
            [titleLabel setText:@"分享至新浪微博"];
        }break;
        case shareStyleTencentWeiBo:{
            [titleLabel setText:@"分享至腾讯微博"];
        }break;
        default:
            break;
    }
    [titleLabel setFont:[UIFont boldSystemFontOfSize:18]];
    titleLabel.textAlignment=NSTextAlignmentCenter;
    titleLabel.textColor=[UIColor whiteColor];
    [self.view addSubview:titleLabel];
    
    UIButton * nextB = [UIButton buttonWithType:UIButtonTypeCustom];
    nextB.frame = CGRectMake(240, 0+diffH, 80, 44);
    [nextB setBackgroundImage:[UIImage imageNamed:@"nextBtn"] forState:UIControlStateNormal];
    [nextB.titleLabel setFont:[UIFont systemFontOfSize:15]];
    [nextB setTitle:@"分享" forState:UIControlStateNormal];
    [nextB addTarget:self action:@selector(shareContent) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:nextB];
    
	self.textV = [[UITextView alloc]initWithFrame:CGRectMake(0, 44+diffH, 320, self.view.frame.size.height-253)];
    _textV.text = self.contentString;
    [_textV becomeFirstResponder];
    _textV.font = [UIFont systemFontOfSize:16];
    [self.view addSubview:_textV];
    hud = [[MBProgressHUD alloc] initWithWindow:[UIApplication sharedApplication].keyWindow];
    [[UIApplication sharedApplication].keyWindow addSubview:hud];
    hud.labelText = @"正在分享,请稍等";
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)backButton
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(void)shareContent
{
    beganCount = 0;
    id<ISSContent> publishContent = [ShareSDK content:_textV.text
                                       defaultContent:nil
                                                image:self.imageUrl?[ShareSDK imageWithUrl:self.imageUrl]:[ShareSDK jpegImageWithImage:[UIImage imageNamed:@"icon-256"] quality:1]
                                                title:nil
                                                  url:nil
                                          description:nil
                                            mediaType:SSPublishContentMediaTypeText];
    
    id<ISSAuthOptions> authOptions = [ShareSDK authOptionsWithAutoAuth:YES
                                                         allowCallback:YES
                                                         authViewStyle:SSAuthViewStyleFullScreenPopup
                                                          viewDelegate:nil
                                               authManagerViewDelegate:nil];
    
    //在授权页面中添加关注官方微博
    [authOptions setFollowAccounts:[NSDictionary dictionaryWithObjectsAndKeys:
                                    [ShareSDK userFieldWithType:SSUserFieldTypeName value:@"宠物圈主"],
                                    SHARE_TYPE_NUMBER(ShareTypeSinaWeibo),
                                    [ShareSDK userFieldWithType:SSUserFieldTypeName value:@"宠物圈"],
                                    SHARE_TYPE_NUMBER(ShareTypeTencentWeibo),
                                    nil]];
    ShareType shareType = 0;
    switch (self.shareStyle) {
        case shareStyleSineWeiBo:{
            shareType = ShareTypeSinaWeibo;
        }break;
        case shareStyleTencentWeiBo:{
            shareType = ShareTypeTencentWeibo;
        }break;
        default:
            break;
    }
    [ShareSDK shareContent:publishContent
                      type:shareType
               authOptions:authOptions
             statusBarTips:NO
                    result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                        if (state == SSResponseStateBegan) {
                            NSLog(@"Began");
                            [hud show:YES];
                            beganCount++;
                            if (beganCount == 4) {
                                [hud hide:YES];
                                [ShareSDK cancelAuthWithType:shareType];
                            }
                        }
                        if (state == SSResponseStateSuccess) {
                            [hud hide:YES];
                            if (self.delegate) {
                                [_delegate shareContentSuccess];
                            }
                            [self dismissViewControllerAnimated:YES completion:nil];
                        }
                        if (state == SSResponseStateFail) {
                            [hud hide:YES];
                            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示"
                                                                                message:[NSString stringWithFormat:@"发送失败!%@", [error errorDescription]]
                                                                               delegate:nil
                                                                      cancelButtonTitle:@"知道了"
                                                                      otherButtonTitles:nil];
                            [alertView show];
                        }
                    }];
}
@end
