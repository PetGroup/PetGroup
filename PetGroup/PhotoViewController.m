//
//  PhotoViewController.m
//  PetGroup
//
//  Created by 阿铛 on 13-9-4.
//  Copyright (c) 2013年 Tolecen. All rights reserved.
//

#import "PhotoViewController.h"
#import "EGOImageView.h"
#import "sharePlatformView.h"
#import <ShareSDK/ShareSDK.h>
#import "EditShareContentViewController.h"

@interface PhotoViewController ()<UIScrollViewDelegate,UIActionSheetDelegate,EGOImageViewDelegate,sharePlatformViewDelegate>
@property (nonatomic,retain)UIImage* oneImage;
@property (nonatomic,retain)UIScrollView* sc;
@property (nonatomic,retain)UIImage* myimage;
@property (nonatomic,retain)NSArray* smallImageArray;
@property (nonatomic,retain)UILabel* titleL;
@property (nonatomic,assign)int page;
@property (nonatomic,retain)sharePlatformView * shareView;
@end

@implementation PhotoViewController
- (id)initWithPath:(NSString*)path
{
    if (self = [super init]) {
        NSData* data = [NSData dataWithContentsOfFile:path];
        UIImage *image = [[UIImage alloc] initWithData:data];
        self.oneImage = image;
    }
    return self;
}
- (id)initWithSmallImages:(NSArray*)sImages images:(NSArray*)images indext:(int)indext
{
    self = [super init];
    if (self) {
        self.smallImageArray = sImages;
        self.imgIDArray = images;
        self.indext = indext;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.sc = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, 320, self.view.frame.size.height)];
    _sc.delegate = self;
    _sc.backgroundColor = [UIColor blackColor];
    _sc.pagingEnabled=YES;
    _sc.showsHorizontalScrollIndicator=NO;
    _sc.showsVerticalScrollIndicator=NO;
    _sc.bounces = NO;
    _sc.contentOffset = CGPointMake(self.indext*320, 0);
    _sc.contentSize = CGSizeMake(320*self.imgIDArray.count, _sc.frame.size.height);
    [self.view addSubview:_sc];
    if (self.oneImage) {
        self.view.backgroundColor = [UIColor blackColor];
        UIImageView * imageV = [[UIImageView alloc]init];
        imageV.frame = CGRectMake(110,(_sc.frame.size.height-100)/2 , 100, 100);
        imageV.image = _oneImage;
        UIScrollView * subSC = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, 320, self.view.frame.size.height)];
        subSC.tag = 1000;
        [subSC addSubview:imageV];
        imageV.userInteractionEnabled = YES;
        UIActivityIndicatorView*act = [[UIActivityIndicatorView alloc]initWithFrame:CGRectMake((self.view.frame.size.width-10)/2, (self.view.frame.size.height-10)/2, 10, 10)];
        [subSC addSubview:act];
        subSC.maximumZoomScale = 2.0;
        subSC.bouncesZoom = NO;
        subSC.delegate = self;
        [_sc addSubview:subSC];
        UITapGestureRecognizer* tapOne = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapOne:)];
        tapOne.numberOfTapsRequired = 1;
        [imageV addGestureRecognizer:tapOne];
        UITapGestureRecognizer* tapTwo = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapTwo:)];
        tapTwo.numberOfTapsRequired = 2;
        [imageV addGestureRecognizer:tapTwo];
        UILongPressGestureRecognizer* longPress = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPress:)];
        [imageV addGestureRecognizer:longPress];
        
        [tapOne requireGestureRecognizerToFail:tapTwo];
        return;
    }
    for (int i = 0;i < self.imgIDArray.count;i++) {
        UIScrollView * subSC = [[UIScrollView alloc]initWithFrame:CGRectMake(i*320, 0, 320, _sc.frame.size.height)];
        subSC.tag = 1000+i;
        EGOImageView* imageV = [[EGOImageView alloc]initWithFrame:CGRectMake(110,(_sc.frame.size.height-100)/2 , 100, 100)];
        imageV.placeholderImage = _smallImageArray[i];
        [subSC addSubview:imageV];
        imageV.userInteractionEnabled = YES;
        UIActivityIndicatorView*act = [[UIActivityIndicatorView alloc]initWithFrame:CGRectMake((_sc.frame.size.width-10)/2, (_sc.frame.size.height-10)/2, 10, 10)];
        [act startAnimating];
        [subSC addSubview:act];
        imageV.delegate = self;
        
        subSC.maximumZoomScale = 2.0;
        subSC.bouncesZoom = NO;
        subSC.delegate = self;
        [_sc addSubview:subSC];
        UITapGestureRecognizer* tapOne = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapOne:)];
        tapOne.numberOfTapsRequired = 1;
        [imageV addGestureRecognizer:tapOne];
        UITapGestureRecognizer* tapTwo = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapTwo:)];
        tapTwo.numberOfTapsRequired = 2;
        [imageV addGestureRecognizer:tapTwo];
        UILongPressGestureRecognizer* longPress = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPress:)];
        [imageV addGestureRecognizer:longPress];
        
        [tapOne requireGestureRecognizerToFail:tapTwo];
    }
    if (self.delegate) {
        UIImageView* bgView = [[UIImageView alloc]initWithFrame:CGRectMake(187, self.view.frame.size.height - 53, 75, 26)];
        bgView.image = [UIImage imageNamed:@"like_bg"];
        [self.view addSubview:bgView];
        
        UIButton * zanB = [UIButton buttonWithType:UIButtonTypeCustom];
        [zanB setBackgroundImage:[UIImage imageNamed:@"zanDatu"] forState:UIControlStateNormal];
        zanB.frame = CGRectMake(180, self.view.frame.size.height - 62, 44, 43);
        [zanB addTarget:self action:@selector(zanButtinAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:zanB];
        
        _titleL = [[UILabel alloc]initWithFrame:CGRectMake(210, self.view.frame.size.height - 50, 52, 20)];
        _titleL.textColor = [UIColor whiteColor];
        _titleL.textAlignment = NSTextAlignmentCenter;
        [self.view addSubview:_titleL];
        
        UIButton* shareB = [UIButton buttonWithType:UIButtonTypeCustom];
        [shareB setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [shareB setTitle:@"分享" forState:UIControlStateNormal];
        shareB.frame = CGRectMake(120, self.view.frame.size.height - 53, 75, 26);
        [shareB addTarget:self action:@selector(shareTheArticle) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:shareB];
        
        self.shareView = [[sharePlatformView alloc]initWithView:self];
        _shareView.delegate = self;
    }
    [self scrollViewDidEndDecelerating:_sc];
}
-(void)viewDidAppear:(BOOL)animated
{
    if (_oneImage) {
        CGSize size = _oneImage.size;
        float a = 0;
        if (self.view.frame.size.height > 320*(size.height/size.width)) {
            a = self.view.frame.size.height - 320*(size.height/size.width);
        }
        CGRect rect = CGRectMake(0, a/2, 320, 320*(size.height/size.width));
        [UIView animateWithDuration:0.3 animations:^{
            ((UIImageView*)[_sc viewWithTag:1000].subviews[0]).frame = rect;
        }completion:^(BOOL finished) {
            if (a == 0) {
                ((UIScrollView*)[_sc viewWithTag:1000]).contentSize = CGSizeMake(320, 320*(size.height/size.width));
            }
        }];
    }
}
-(void)shareTheArticle
{
    [_shareView showSharePlatformView];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)tapOne:(UITapGestureRecognizer*)tap
{
//    [self performSelector:@selector(desappear) withObject:nil afterDelay:0.2f];
    [self desappear];
}
-(void)desappear
{
    self.view.userInteractionEnabled = NO;
    int a = _sc.contentOffset.x/320;
    [UIView animateWithDuration:0.3 animations:^{
        ((UIView*)((UIView*)_sc.subviews[a]).subviews[0]).frame = CGRectMake(160,_sc.frame.size.height/2,0,0);
    } completion:^(BOOL finished) {
        [self dismissViewControllerAnimated:NO completion:nil];
    }];
}
-(void)tapTwo:(UITapGestureRecognizer*)tap
{
//    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(desappear) object:nil];
    UIScrollView*subSC = (UIScrollView*)tap.view.superview;
    CGPoint touchPoint = [tap locationInView:tap.view];
    if (subSC.contentSize.width>639) {
        [subSC setZoomScale:1 animated:YES];
    }else{
        [subSC zoomToRect:CGRectMake(touchPoint.x, touchPoint.y, 1, 1) animated:YES];
    }
}
-(void)longPress:(UILongPressGestureRecognizer*)longPress
{
    if (longPress.state == UIGestureRecognizerStateBegan) {
        self.myimage = ((EGOImageView*)longPress.view).image;
        UIActionSheet* act = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles: @"保存",nil];
        [act showInView:longPress.view];
    }
}
-(void)zanButtinAction:(UIButton*)sender
{
    sender.enabled = NO;
    UIImageView * dingShow = [[UIImageView alloc] initWithFrame:CGRectMake(210, self.titleL.frame.origin.y, 50, 25)];
    [dingShow setImage:[UIImage imageNamed:@"dingShow.png"]];
    [self.view addSubview:dingShow];
    [dingShow setAlpha:1];
    [UIView animateWithDuration:0.5 animations:^{
        [dingShow setFrame:CGRectMake(dingShow.frame.origin.x-22.5, dingShow.frame.origin.y-25, 100, 50)];
    } completion:^(BOOL finished) {
        [dingShow setFrame:CGRectMake(dingShow.frame.origin.x+12.5, dingShow.frame.origin.y+25, 50, 25)];
        [dingShow removeFromSuperview];
        sender.enabled = YES;
    }];
    if ([self.delegate respondsToSelector:@selector(zanButtonActionWithPage:)]) {
        [_delegate zanButtonActionWithPage:self.page];
    }
    if ([self.delegate respondsToSelector:@selector(titleLableTextWithPage:)]) {
        _titleL.text = [_delegate titleLableTextWithPage:self.page];
    }
}
#pragma mark - actionsheet delegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==0) {
        UIImageWriteToSavedPhotosAlbum(self.myimage, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
    }
    self.myimage = nil;
}
- (void)image: (UIImage *) image didFinishSavingWithError: (NSError *) error contextInfo: (void *) contextInfo
{
    NSString *msg = nil ;
    if(error != NULL){
        msg = @"保存图片失败,请允许本应用访问您的相册";
    }else{
        msg = @"保存图片成功" ;
    }
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:msg delegate:self cancelButtonTitle:@"确定"otherButtonTitles:nil];
    [alert show];
}
#pragma mark - scrollView delegate
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
// return a view that will be scaled. if delegate returns nil, nothing happens
{
    if (scrollView == _sc) {
        return nil;
    }
    return [scrollView.subviews objectAtIndex:0];
}
- (void)scrollViewDidZoom:(UIScrollView *)scrollView
{
    if (scrollView!=_sc) {
        CGSize size = ((UIView*)scrollView.subviews[0]).frame.size;
        if (scrollView.frame.size.height>size.height) {
            ((UIView*)scrollView.subviews[0]).frame = CGRectMake(0, (scrollView.frame.size.height-size.height)/2, size.width, size.height);
        }
    }
}
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (scrollView == _sc) {
        float a=scrollView.contentOffset.x;
        _page=floor((a-320/2)/320)+1;
        
        EGOImageView* imageV = (EGOImageView*)[_sc viewWithTag:_page+1000].subviews[0];
        NSRange range=[self.imgIDArray[_page] rangeOfString:@"<local>"];
        if (range.location!=NSNotFound) {
            NSString *path = [RootDocPath stringByAppendingPathComponent:@"tempImage"];
            NSString  *openImgPath = [NSString stringWithFormat:@"%@/%@",path,[self.imgIDArray[_page] substringFromIndex:7]];
            NSData * nsData= [NSData dataWithContentsOfFile:openImgPath];
            UIImage * openPic= [UIImage imageWithData:nsData];
            imageV.image = openPic;
            [self imageViewLoadedImage:imageV];
        }
        else{
            imageV.imageURL = [NSURL URLWithString:[NSString stringWithFormat:BaseImageUrl"%@",self.imgIDArray[_page]]];
        }
        if ([self.delegate respondsToSelector:@selector(titleLableTextWithPage:)]) {
            _titleL.text = [_delegate titleLableTextWithPage:self.page];
        }
    }
}
#pragma mark - EGOImageView delegate
- (void)imageViewLoadedImage:(EGOImageView*)imageView
{
    float a = 0.0;
    CGSize size = imageView.image.size;
    if (320*size.height/size.width<_sc.frame.size.height) {
        a = (_sc.frame.size.height-320*size.height/size.width)/2;
    }
//    imageView.frame = CGRectMake(160,_sc.frame.size.height/2,0,0);
    [UIView animateWithDuration:0.3 animations:^{
        imageView.frame = CGRectMake(0, a, 320, 320*size.height/size.width);
    }completion:^(BOOL finished) {
        if (a == 0) {
            ((UIScrollView*)imageView.superview).contentSize = CGSizeMake(320, 320*(size.height/size.width));
        }
    }];
    [((UIActivityIndicatorView*)imageView.superview.subviews[1]) stopAnimating];
}
- (void)imageViewFailedToLoadImage:(EGOImageView*)imageView error:(NSError*)error
{
    //未完待续
    [self dismissViewControllerAnimated:NO completion:^{
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:nil message:@"图片加载失败" delegate:nil cancelButtonTitle:@"知道啦" otherButtonTitles: nil];
        [alert show];
    }];
}
#pragma mark - sharePlatformView Delegate
-(void)sharePlatformViewPressButtonWithIntage:(NSInteger)integer
{
    NSString* imageURL = [NSString stringWithFormat:BaseImageUrl"%@",self.imgIDArray[_page]];
    NSString* editString = @"我在《宠物圈》看到一张有意思的图片分享给你~~~";
    switch (integer) {
        case 1:{
            NSLog(@"新浪");
            EditShareContentViewController* editVC = [[EditShareContentViewController alloc]init];
            editVC.shareStyle = shareStyleSineWeiBo;
            editVC.contentString = editString;
            editVC.imageUrl = imageURL;
            editVC.delegate = _shareView;
            [self presentViewController:editVC animated:YES completion:nil];
        }break;
        case 2:{
            NSLog(@"腾讯");
            EditShareContentViewController* editVC = [[EditShareContentViewController alloc]init];
            editVC.shareStyle = shareStyleTencentWeiBo;
            editVC.contentString = editString;
            editVC.imageUrl = imageURL;
            editVC.delegate = _shareView;
            [self presentViewController:editVC animated:YES completion:nil];
        }break;
        case 3:{
            NSLog(@"朋友圈");
            id<ISSContent> content = [ShareSDK content:nil
                                        defaultContent:nil
                                                 image:[ShareSDK imageWithUrl:imageURL]
                                                 title:nil
                                                   url:nil
                                           description:nil
                                             mediaType:SSPublishContentMediaTypeImage];
            
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
            
            [ShareSDK shareContent:content
                              type:ShareTypeWeixiTimeline
                       authOptions:authOptions
                     statusBarTips:YES
                            result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                                
                                if (state == SSPublishContentStateSuccess)
                                {
                                    [_shareView canclesharePlatformView];
                                }
                                else if (state == SSPublishContentStateFail)
                                {
                                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示"
                                                                                        message:[NSString stringWithFormat:@"发送失败!%@", [error errorDescription]]
                                                                                       delegate:nil
                                                                              cancelButtonTitle:@"知道了"
                                                                              otherButtonTitles:nil];
                                    [alertView show];
                                }
                            }];
        }break;
        case 4:{
            NSLog(@"微信好友");
            id<ISSContent> content = [ShareSDK content:nil
                                        defaultContent:nil
                                                 image:[ShareSDK imageWithUrl:imageURL]
                                                 title:nil
                                                   url:nil
                                           description:nil
                                             mediaType:SSPublishContentMediaTypeImage];
            
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
            
            [ShareSDK shareContent:content
                              type:ShareTypeWeixiSession
                       authOptions:authOptions
                     statusBarTips:YES
                            result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                                
                                if (state == SSPublishContentStateSuccess)
                                {
                                    [_shareView canclesharePlatformView];
                                }
                                else if (state == SSPublishContentStateFail)
                                {
                                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示"
                                                                                        message:[NSString stringWithFormat:@"发送失败!%@", [error errorDescription]]
                                                                                       delegate:nil
                                                                              cancelButtonTitle:@"知道了"
                                                                              otherButtonTitles:nil];
                                    [alertView show];
                                }
                            }];
        }break;
        case 5:{
            NSLog(@"qq空间");
            id<ISSContent> content = [ShareSDK content:nil
                                        defaultContent:nil
                                                 image:[ShareSDK imageWithUrl:imageURL]
                                                 title:nil
                                                   url:nil
                                           description:nil
                                             mediaType:SSPublishContentMediaTypeImage];
            
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
            
            [ShareSDK shareContent:content
                              type:ShareTypeQQ
                       authOptions:authOptions
                     statusBarTips:YES
                            result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                                
                                if (state == SSPublishContentStateSuccess)
                                {
                                    [_shareView canclesharePlatformView];
                                }
                                else if (state == SSPublishContentStateFail)
                                {
                                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示"
                                                                                        message:[NSString stringWithFormat:@"发送失败!%@", [error errorDescription]]
                                                                                       delegate:nil
                                                                              cancelButtonTitle:@"知道了"
                                                                              otherButtonTitles:nil];
                                    [alertView show];
                                }
                            }];
        }break;
        case 6:{
            NSLog(@"短信");
            //创建分享内容
            id<ISSContent> publishContent = [ShareSDK content:[NSString stringWithFormat:@"我在《宠物圈》看到一张有意思的图片分享给你~~~%@",imageURL]
                                               defaultContent:@""
                                                        image:nil
                                                        title:nil
                                                          url:nil
                                                  description:nil
                                                    mediaType:SSPublishContentMediaTypeImage];
            
            
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
            
            //显示分享菜单
            [ShareSDK showShareViewWithType:ShareTypeSMS
                                  container:nil
                                    content:publishContent
                              statusBarTips:YES
                                authOptions:authOptions
                               shareOptions:[ShareSDK defaultShareOptionsWithTitle:nil
                                                                   oneKeyShareList:[NSArray defaultOneKeyShareList]
                                                                    qqButtonHidden:NO
                                                             wxSessionButtonHidden:NO
                                                            wxTimelineButtonHidden:NO
                                                              showKeyboardOnAppear:NO
                                                                 shareViewDelegate:nil
                                                               friendsViewDelegate:nil
                                                             picViewerViewDelegate:nil]
                                     result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                                         
                                         if (state == SSPublishContentStateSuccess)
                                         {
                                             [_shareView canclesharePlatformView];
                                         }
                                         else if (state == SSPublishContentStateFail)
                                         {
                                             UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示"
                                                                                                 message:[NSString stringWithFormat:@"发送失败!%@", [error errorDescription]]
                                                                                                delegate:nil
                                                                                       cancelButtonTitle:@"知道了"
                                                                                       otherButtonTitles:nil];
                                             [alertView show];
                                         }
                                     }];
        }break;
        default:
            break;
    }
}
@end
