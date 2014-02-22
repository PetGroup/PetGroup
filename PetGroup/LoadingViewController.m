//
//  LoadingViewController.m
//  PetGroup
//
//  Created by Tolecen on 13-8-20.
//  Copyright (c) 2013年 Tolecen. All rights reserved.
//

#import "LoadingViewController.h"
#import "CustomTabBar.h"
#import "MessageViewController.h"
#import "NearByViewController.h"
#import "ContactsViewController.h"
#import "PersonalCenterViewController.h"
#import "DiscoverViewController.h"
#import "JSON.h"
#import "CircleViewController.h"
#import "NewCircleViewController.h"
#import "ContentDetailViewController.h"
@interface LoadingViewController ()

@end

@implementation LoadingViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        firstOpenIt = NO;
    }
    return self;
}
-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    [[NSUserDefaults standardUserDefaults] setObject:@"https://itunes.apple.com/us/app/chong-wu-quan-ai-chong-wu/id686838840?ls=1&mt=8" forKey:@"IOSURL"];
    [[NSUserDefaults standardUserDefaults] synchronize];
//    if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_6_1) {
//        // Load resources for iOS 6.1 or earlier
//    } else {
//        // Load resources for iOS 7 or later
//        [UIApplication sharedApplication].statusBarHidden = YES;
//    }
    float diffH = [Common diffHeight:self];
    diffH++;
    NSString * openImgStr = [[NSUserDefaults standardUserDefaults] objectForKey:@"OpenImg"];
    NSString *path1 = [RootDocPath stringByAppendingPathComponent:@"OpenImages"];
    NSFileManager *fm1 = [NSFileManager defaultManager];
    if([fm1 fileExistsAtPath:path1] == NO)
    {
        [fm1 createDirectoryAtPath:path1 withIntermediateDirectories:YES attributes:nil error:nil];
    }
    NSString  *openImgPath = [NSString stringWithFormat:@"%@/openImage.jpg",path1];

    if (openImgStr) {
        
        NSData * nsData= [NSData dataWithContentsOfFile:openImgPath];
        UIImage * openPic= [UIImage imageWithData:nsData];
        if (openPic) {
            splashImageView=[[UIImageView alloc]initWithImage:openPic];
            splashImageView.frame=CGRectMake(0, 0, 320, 568);
        }
        else
        {
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"OpenImg"];
            if (iPhone5) {
                splashImageView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"Default-568h@2x.png"]];
                splashImageView.frame=CGRectMake(0, 0, 320, self.view.frame.size.height);
            }
            else
            {
                splashImageView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"Default@2x.png"]];
                splashImageView.frame=CGRectMake(0, 0, 320, self.view.frame.size.height);
            }
        }
        
    }
    else
    {
        if (iPhone5) {
            splashImageView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"Default-568h@2x.png"]];
            splashImageView.frame=CGRectMake(0, 0, 320, self.view.frame.size.height);
        }
        else
        {
            splashImageView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"Default@2x.png"]];
            splashImageView.frame=CGRectMake(0, 0, 320, self.view.frame.size.height);
        }
    }
    [self.view addSubview:splashImageView];
//    [SFHFKeychainUtils deleteItemForUsername:MACADDRESS andServiceName:LOCALACCOUNT error:nil];
    if (![SFHFKeychainUtils getPasswordForUsername:MACADDRESS andServiceName:LOCALACCOUNT error:nil]) {
//        NSString *idfv = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
        NSString *idfa = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
//        DeviceIdentifier * dv = [[DeviceIdentifier alloc] init];
//        NSString * macAddress = [dv macaddress];
        [SFHFKeychainUtils storeUsername:MACADDRESS andPassword:idfa forServiceName:LOCALACCOUNT updateExisting:YES error:nil];
    }
    NSString * theVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString *)kCFBundleVersionKey];
    
    NSString *path = [RootDocPath stringByAppendingPathComponent:[NSString stringWithFormat:@"TestFirstPet%@",theVersion]];
    NSFileManager *fm = [NSFileManager defaultManager];
    if([fm fileExistsAtPath:path] == NO)
    {
        firstOpenIt = YES;
        if ([SFHFKeychainUtils getPasswordForUsername:MACADDRESS andServiceName:LOCALACCOUNT error:nil]) {
            [SFHFKeychainUtils deleteItemForUsername:MACADDRESS andServiceName:LOCALACCOUNT error:nil];
            NSString *idfa = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
            [SFHFKeychainUtils storeUsername:MACADDRESS andPassword:idfa forServiceName:LOCALACCOUNT updateExisting:YES error:nil];
        }
        [self firtOpen];
        [self doOpen];

        
        if (![SFHFKeychainUtils getPasswordForUsername:@"petGroupVersion" andServiceName:LOCALACCOUNT error:nil])
        {
            [SFHFKeychainUtils deleteItemForUsername:LOCALTOKEN andServiceName:LOCALACCOUNT error:nil];
            [SFHFKeychainUtils deleteItemForUsername:ACCOUNT andServiceName:LOCALACCOUNT error:nil];
            [SFHFKeychainUtils deleteItemForUsername:MACADDRESS andServiceName:LOCALACCOUNT error:nil];
        }
        
        [SFHFKeychainUtils storeUsername:@"petGroupVersion" andPassword:theVersion forServiceName:LOCALACCOUNT updateExisting:YES error:nil];
    
        [fm createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
        NSString *storeURL = [NSPersistentStore MR_applicationStorageDirectory];;
        NSDirectoryEnumerator *dirEnum = [[NSFileManager defaultManager] enumeratorAtPath:storeURL];
        NSString *fileName;
        while (fileName= [dirEnum nextObject]) {
            [[NSFileManager defaultManager] removeItemAtPath: [NSString stringWithFormat:@"%@/%@",storeURL,fileName] error:nil];
        }
    }
    else
    {
        firstOpenIt = NO;
        [self doOpen];
    }
//    NSDirectoryEnumerator *dirEnum = [[NSFileManager defaultManager] enumeratorAtPath:yourpath];
//    NSString *fileName;
//    while (fileName= [dirEnum nextObject]) {
//        [[NSFileManager defaultManager] removeItemAtPath:  [NSString stringWithFormat:@"yourpath%@",fileName]; error:&error];
//    }


//    NSLog(@"uuuuurrrrrlllll:%@",storeURL.path);
//    [[NSFileManager defaultManager] removeItemAtPath:storeURL.path error:nil];
    if (![SFHFKeychainUtils getPasswordForUsername:MACADDRESS andServiceName:LOCALACCOUNT error:nil]) {
//        NSString *idfv = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
        NSString *idfa = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
        //        DeviceIdentifier * dv = [[DeviceIdentifier alloc] init];
        //        NSString * macAddress = [dv macaddress];
        [SFHFKeychainUtils storeUsername:MACADDRESS andPassword:idfa forServiceName:LOCALACCOUNT updateExisting:YES error:nil];
    }
    [[LocationManager sharedInstance] initLocation];
    [self getUserLocation];
    [self performSelector:@selector(toMainView) withObject:nil afterDelay:2];
   // [self testGetOneState];
	// Do any additional setup after loading the view.
}
-(void)setLabelTitle:(NSString *)title
{
    if (messageV) {
        [messageV setTheTitleLabelText];
    }
    
}
-(void)setMakeLogin
{
    if ([SFHFKeychainUtils getPasswordForUsername:LOCALTOKEN andServiceName:LOCALACCOUNT error:nil]) {
        if ([[TempData sharedInstance] ifOpened]) {
            [messageV logInToChatServer];
        }
        else
            [messageV logInToServer];
    }
}
-(void)getUserLocation
{
    LocationManager * locM = [LocationManager sharedInstance];
    locM.locType = @"open";
    [locM startCheckLocationWithSuccess:^(double lat, double lon) {
        [[TempData sharedInstance] setLat:lat Lon:lon];
        if ([SFHFKeychainUtils getPasswordForUsername:LOCALTOKEN andServiceName:LOCALACCOUNT error:nil]) {
            [self upLoadUserLocationWithLat:lat Lon:lon];
        }
    } Failure:^{

    }];
}
-(void)testGetOneState
{
    NSMutableDictionary * postDict = [NSMutableDictionary dictionary];
    NSMutableDictionary * locationDict = [NSMutableDictionary dictionary];
    [locationDict setObject:@"124" forKey:@"stateid"];
    [postDict setObject:@"1" forKey:@"channel"];
    [postDict setObject:@"findOneState" forKey:@"method"];
    [postDict setObject:[SFHFKeychainUtils getPasswordForUsername:LOCALTOKEN andServiceName:LOCALACCOUNT error:nil] forKey:@"token"];
    [postDict setObject:locationDict forKey:@"params"];
    NSTimeInterval cT = [[NSDate date] timeIntervalSince1970];
    long long a = (long long)(cT*1000);
    [postDict setObject:[NSString stringWithFormat:@"%lld",a] forKey:@"connectTime"];
    [NetManager requestWithURLStr:BaseClientUrl Parameters:postDict TheController:self success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *receiveStr = [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSDictionary * recDict = [receiveStr JSONValue];
        NSLog(@"rrrrrrrr:%@",recDict);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];

}

-(void)upLoadUserLocationWithLat:(double)userLatitude Lon:(double)userLongitude
{
    NSMutableDictionary * postDict = [NSMutableDictionary dictionary];
    NSDictionary * locationDict = [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%f",userLongitude],@"longitude",[NSString stringWithFormat:@"%f",userLatitude],@"latitude", nil];
    [postDict setObject:@"1" forKey:@"channel"];
    [postDict setObject:@"updateUserLocation" forKey:@"method"];
    [postDict setObject:@"service.uri.pet_user" forKey:@"service"];
    [postDict setObject:[SFHFKeychainUtils getPasswordForUsername:LOCALTOKEN andServiceName:LOCALACCOUNT error:nil] forKey:@"token"];
    [postDict setObject:locationDict forKey:@"params"];
    NSTimeInterval cT = [[NSDate date] timeIntervalSince1970];
    long long a = (long long)(cT*1000);
    [postDict setObject:[NSString stringWithFormat:@"%lld",a] forKey:@"connectTime"];
    [NetManager requestWithURLStr:BaseClientUrl Parameters:postDict TheController:self success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        NSString *receiveStr = [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
//        NSDictionary * recDict = [receiveStr JSONValue];
        NSLog(@"rrrrrrrr:%@",responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}

-(void)firtOpen
{
    NSMutableDictionary * postDict = [NSMutableDictionary dictionary];
    NSMutableDictionary * userInfoDict = [NSMutableDictionary dictionary];

    [postDict setObject:userInfoDict forKey:@"params"];
    [postDict setObject:@"1" forKey:@"channel"];
    [postDict setObject:@"firstOpen" forKey:@"method"];
  //  [postDict setObject:@"" forKey:@"token"];
    [postDict setObject:@"service.uri.pet_sso" forKey:@"service"];
    [postDict setObject:[SFHFKeychainUtils getPasswordForUsername:MACADDRESS andServiceName:LOCALACCOUNT error:nil] forKey:@"mac"];
    [postDict setObject:@"iphone" forKey:@"imei"];
    NSTimeInterval cT = [[NSDate date] timeIntervalSince1970];
    long long a = (long long)(cT*1000);
    [postDict setObject:[NSString stringWithFormat:@"%lld",a] forKey:@"createTime"];
    [NetManager requestWithURLStr:BaseClientUrl Parameters:postDict TheController:self success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self openSuccessWithInfo:responseObject From:@"firstOpen"];
//        //存储返回的DeviceID，注册使用...
//        [[NSUserDefaults standardUserDefaults] setObject:[recDict objectForKey:@"id"] forKey:@"DeviceID"];
//        [[NSUserDefaults standardUserDefaults] synchronize];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];

}

-(void)doOpen
{
    NSMutableDictionary * postDict = [NSMutableDictionary dictionary];
    NSMutableDictionary * userInfoDict = [NSMutableDictionary dictionary];
    
    [postDict setObject:userInfoDict forKey:@"params"];
    [postDict setObject:@"1" forKey:@"channel"];
    [postDict setObject:@"open" forKey:@"method"];
    //  [postDict setObject:@"" forKey:@"token"];
    [postDict setObject:@"service.uri.pet_sso" forKey:@"service"];
    [postDict setObject:[SFHFKeychainUtils getPasswordForUsername:MACADDRESS andServiceName:LOCALACCOUNT error:nil] forKey:@"mac"];
    [postDict setObject:@"iphone" forKey:@"imei"];
    NSTimeInterval cT = [[NSDate date] timeIntervalSince1970];
    long long a = (long long)(cT*1000);
    [postDict setObject:[NSString stringWithFormat:@"%lld",a] forKey:@"createTime"];
    [NetManager requestWithURLStr:BaseClientUrl Parameters:postDict TheController:self success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self openSuccessWithInfo:responseObject From:@"open"];
        //        //存储返回的DeviceID，注册使用...
        //        [[NSUserDefaults standardUserDefaults] setObject:[recDict objectForKey:@"id"] forKey:@"DeviceID"];
        //        [[NSUserDefaults standardUserDefaults] synchronize];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
    
}

-(void)openSuccessWithInfo:(NSDictionary *)dict From:(NSString *)where
{
    if ((!firstOpenIt&&[where isEqualToString:@"open"])||(firstOpenIt&&[where isEqualToString:@"firstOpen"])) {
        NSString * version = [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString *)kCFBundleVersionKey];
        
        if ([[[dict objectForKey:@"version"] objectForKey:@"petVersion"] floatValue]>[version floatValue]) {
            //        appStoreURL = [dict objectForKey:@"iosurl"];
            //        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"检测到新版本，您的版本已低于最低版本需求，请立即升级" delegate:self cancelButtonTitle:@"立即升级" otherButtonTitles: nil];
            //        alert.tag = 20;
            //        [alert show];
            appStoreURL = [[dict objectForKey:@"version"] objectForKey:@"iosurl"];
            [[NSUserDefaults standardUserDefaults] setObject:appStoreURL forKey:@"IOSURL"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"检测到新版本，您要升级吗" delegate:self cancelButtonTitle:@"立刻升级" otherButtonTitles:@"取消", nil];
            alert.tag = 21;
            [alert show];
        }
        appStoreURL = [[dict objectForKey:@"version"] objectForKey:@"iosurl"];
        [[NSUserDefaults standardUserDefaults] setObject:appStoreURL forKey:@"IOSURL"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        NSString * receivedImgStr = [dict objectForKey:@"firstImage"];
        NSString * openImgStr = [[NSUserDefaults standardUserDefaults] objectForKey:@"OpenImg"];
        if (!openImgStr||![receivedImgStr isEqualToString:openImgStr]) {
            [self downloadImageWithID:receivedImgStr Type:@"open" PicName:nil];
        }

    }
    NSString * verifyCodeStatus = [dict objectForKey:@"verifyCode"];
    NSString * vd = @"shouldSend";
    if (verifyCodeStatus) {
        if ([verifyCodeStatus isEqualToString:@"disable"]) {
            vd = @"doNotSend";
        }
    }
    [[NSUserDefaults standardUserDefaults] setObject:vd forKey:@"verifyCode"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
-(void)downloadImageWithID:(NSString *)imageId Type:(NSString *)theType PicName:(NSString *)picName
{
    [NetManager downloadImageWithBaseURLStr:imageId ImageId:@"" success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
        if ([theType isEqualToString:@"open"]) {
            NSString *path = [RootDocPath stringByAppendingPathComponent:@"OpenImages"];
            NSFileManager *fm = [NSFileManager defaultManager];
            if([fm fileExistsAtPath:path] == NO)
            {
                [fm createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
            }
            NSString  *openImgPath = [NSString stringWithFormat:@"%@/openImage.jpg",path];
            
            
            if ([UIImageJPEGRepresentation(image, 1.0) writeToFile:openImgPath atomically:YES]) {
                NSLog(@"success///");
                [[NSUserDefaults standardUserDefaults] setObject:imageId forKey:@"OpenImg"];
                [[NSUserDefaults standardUserDefaults] synchronize];
            }
            else
            {
                NSLog(@"fail");
            }
            //            NSFileManager *file_manager = [NSFileManager defaultManager];
            //            if ([file_manager fileExistsAtPath:[[NSUserDefaults standardUserDefaults]objectForKey:@"OpenImg"]]) {
            //                [file_manager removeItemAtPath:[[NSUserDefaults standardUserDefaults]objectForKey:@"OpenImg"] error:nil];
            //            }
            
        }
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
        
    }];
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==0) {
        NSString * appLink = appStoreURL;
        if (appStoreURL&&![appStoreURL isKindOfClass:[NSNull class]]) {
            NSURL *url = [NSURL URLWithString:appLink];
            if([[UIApplication sharedApplication] canOpenURL:url])
            {
                [[UIApplication sharedApplication] openURL:url];
            }
        }
    }
}

-(void)makeNotFirstOpen
{
//    NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)objectAtIndex:0];
    
    NSString *path = [RootDocPath stringByAppendingPathComponent:@"TestFirst"];
    NSFileManager *fm = [NSFileManager defaultManager];
    if([fm fileExistsAtPath:path] == NO)
    {
        [SFHFKeychainUtils deleteItemForUsername:LOCALTOKEN andServiceName:LOCALACCOUNT error:nil];
        [fm createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
    }
}
-(void)toMainView
{
//    CircleViewController* circleVC = [[CircleViewController alloc]init];
//    self.NaviDynamic = [[MLNavigationController alloc] initWithRootViewController:circleVC];
//    circleVC.mlNavigationController = self.NaviDynamic;
    
    NewCircleViewController* circleVC = [[NewCircleViewController alloc]init];
    self.NaviDynamic = [[MLNavigationController alloc] initWithRootViewController:circleVC];
//    circleVC.mlNavigationController = self.NaviDynamic;
    
//    DynamicViewController * dynamicV = [[DynamicViewController alloc] init];
//    self.NaviDynamic = [[MLNavigationController alloc] initWithRootViewController:dynamicV];
    DiscoverViewController * nearbyV = [[DiscoverViewController alloc] init];
    self.NaviNearBy = [[MLNavigationController alloc] initWithRootViewController:nearbyV];
    ContactsViewController * contactsV = [[ContactsViewController alloc] init];
    self.NaviContacts = [[MLNavigationController alloc] initWithRootViewController:contactsV];
    //    MoreViewController * moreV = [[MoreViewController alloc] init];
    PersonalCenterViewController* mpVC = [[PersonalCenterViewController alloc]init];
    self.NaviMore = [[MLNavigationController alloc] initWithRootViewController:mpVC];
    
    //为什么message放最后，因为message页面需要滑动删除cell，与MLNavigationController的手势冲突，放在最后一个当修改的时候才能修改到最后一个的页面，如果其他页面也需要这功能，暂时没想到好办法，在写一个类似于MLNavigationController的类吧...
    messageV = [[MessageViewController alloc] init];
    self.NaviMessage = [[MLNavigationController alloc] initWithRootViewController:messageV];
    messageV.mlNavigationController = self.NaviMessage;
    
    self.NaviMessage.delegate = (id)self;
    self.NaviDynamic.delegate = (id)self;
    self.NaviMessage.navigationBarHidden = YES;
    self.NaviNearBy.navigationBarHidden = YES;
    self.NaviContacts.navigationBarHidden = YES;
    self.NaviMore.navigationBarHidden = YES;
    self.NaviDynamic.navigationBarHidden = YES;
    
    NSArray * views = [NSArray arrayWithObjects:self.NaviDynamic,self.NaviNearBy,self.NaviMessage,self.NaviContacts,self.NaviMore, nil];
//    NSArray * normalPic = [NSArray arrayWithObjects:diffH==0.0f?@"os6normal_02.png":@"os7normal_02.png",diffH==0.0f?@"os6normal_01.png":@"os7normal_01.png",diffH==0.0f?@"os6normal_03.png":@"os7normal_03.png",diffH==0.0f?@"os6normal_04.png":@"os7normal_04.png",diffH==0.0f?@"os6normal_05.png":@"os7normal_05.png", nil];
    NSArray * normalPic = [NSArray arrayWithObjects:@"tabbar01.png",@"tabbar03.png",@"tabbar02.png",@"tabbar04.png",@"tabbar05.png", nil];
    NSArray * selectPic = [NSArray arrayWithObjects:@"tabbar_sel_01.png",@"tabbar_sel_03.png",@"tabbar_sel_02.png",@"tabbar_sel_04.png",@"tabbar_sel_05.png", nil];
//    NSArray * selectPic = [NSArray arrayWithObjects:diffH==0.0f?@"os6select_02.png":@"os7select_02.png", diffH==0.0f?@"os6select_01.png":@"os7select_01.png",diffH==0.0f?@"os6select_03.png":@"os7select_03.png",diffH==0.0f?@"os6select_04.png":@"os7select_04.png",diffH==0.0f?@"os6select_05.png":@"os7select_05.png",nil];
    self.tabBarC = [[CustomTabBar alloc] initWithImages:normalPic AndSelected:selectPic AndControllers:views];
    
    [self presentViewController:self.tabBarC animated:NO completion:^{
        TempData * td = [TempData sharedInstance];
        if (td.needDisplayPushNotification) {
            [self performSelector:@selector(makeTabbarPresentAViewController:) withObject:nil afterDelay:2];
        }
        
    }];
    
    [splashImageView setImage:nil];
    splashImageView = nil;
}

-(void)makeTabbarPresentAViewController:(NSDictionary *)dict
{
    NSDictionary * infoDict = [[NSUserDefaults standardUserDefaults] objectForKey:@"RemoteNotification"];
    if (infoDict) {
        NSString * infoType = [infoDict objectForKey:@"type"];
        if (infoType) {
            if ([infoType isEqualToString:@"bbs_note"]) {
                ArticleViewController * articleVC = [[ArticleViewController alloc]init];
                articleVC.articleID = [infoDict objectForKey:@"id"];
                articleVC.shouldDismiss = YES;
                [self.tabBarC presentViewController:articleVC animated:YES completion:^{
                    
                }];
            }
            else if ([infoType isEqualToString:@"ency"]){
                ContentDetailViewController * cv = [[ContentDetailViewController alloc] init];
                cv.contentType = contentTypeWebView;
                cv.typeName = @"宠物介绍";
                cv.needRequestURL = YES;
                cv.needDismiss = YES;
                cv.articleID = [infoDict objectForKey:@"id"];
                [self.tabBarC presentViewController:cv animated:YES completion:^{
                    
                }];
            }
            else if ([infoType isEqualToString:@"exper"]){
                ContentDetailViewController * cv = [[ContentDetailViewController alloc] init];
                cv.contentType = contentTypeTextView;
                cv.typeName = @"养宠经验";
                cv.needDismiss = YES;
                cv.articleID = [infoDict objectForKey:@"id"];
                [self.tabBarC presentViewController:cv animated:YES completion:^{
                    
                }];
            }
            else if ([infoType isEqualToString:@"notice"]){
                ContentDetailViewController * cv = [[ContentDetailViewController alloc] init];
                cv.contentType = contentTypeTextView;
                cv.typeName = @"通知";
                cv.needDismiss = YES;
                cv.isSystemNoti = YES;
                cv.articleID = [infoDict objectForKey:@"id"];
                [self.tabBarC presentViewController:cv animated:YES completion:^{
                    
                }];
            }
            

        }
    }

    TempData * td = [TempData sharedInstance];
    td.needDisplayPushNotification = NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
