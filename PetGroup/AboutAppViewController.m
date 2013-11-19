//
//  AboutAppViewController.m
//  NewXMPPTest
//
//  Created by Tolecen on 13-8-9.
//  Copyright (c) 2013年 Tolecen. All rights reserved.
//

#import "AboutAppViewController.h"

@interface AboutAppViewController ()

@end

@implementation AboutAppViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    UIImageView * bgV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, self.view.frame.size.height)];
    [bgV setImage:[UIImage imageNamed:@"chat_bg.png"]];
    [self.view addSubview:bgV];
    // messages = [NSMutableArray array];
    
    
    float diffH = [Common diffHeight:self];
    
    UIImageView *TopBarBGV=[[UIImageView alloc]initWithImage:[UIImage imageNamed:diffH==0?@"topBar1.png":@"topBar2.png"]];
    [TopBarBGV setFrame:CGRectMake(0, 0, 320, 44+diffH)];
    [self.view addSubview:TopBarBGV];
    
    UIButton *backButton=[UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame=CGRectMake(0, 0+diffH, 80, 44);
    [backButton setBackgroundImage:diffH==0.0f?[UIImage imageNamed:@"back2.png"]:[UIImage imageNamed:@"backnew.png"] forState:UIControlStateNormal];
    //   [backButton setTitle:@" 返回" forState:UIControlStateNormal];
    [backButton.titleLabel setFont:[UIFont boldSystemFontOfSize:15]];
    [self.view addSubview:backButton];
    [backButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    
    
    UILabel * titleLabel=[[UILabel alloc] initWithFrame:CGRectMake(100, 2+diffH, 120, 40)];
    titleLabel.backgroundColor=[UIColor clearColor];
    titleLabel.text=@"关于宠物圈";
    [titleLabel setFont:[UIFont boldSystemFontOfSize:18]];
    titleLabel.textAlignment=NSTextAlignmentCenter;
    titleLabel.textColor=[UIColor whiteColor];
    [self.view addSubview:titleLabel];
    
    UIImageView * iconImageView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"icon-256.png"]];
    iconImageView.frame=CGRectMake(120, 80+diffH, 80, 80);
    iconImageView.layer.cornerRadius=10;
    [self.view addSubview:iconImageView];
    
    UILabel *showVersion=[[UILabel alloc] init];
    [showVersion setBackgroundColor:[UIColor clearColor]];
    showVersion.frame= CGRectMake(20, 180+diffH, 280, 40);
    
    version = [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString *)kCFBundleVersionKey];

    NSString * addString = [NSString stringWithFormat:@"版本号:%@",version];


    showVersion.text=addString;
    showVersion.textAlignment=NSTextAlignmentCenter;
    showVersion.textColor=[UIColor grayColor];
    //showButton.userInteractionEnabled=NO;
    [self.view addSubview:showVersion];

    UIButton * updateButton=[UIButton buttonWithType:UIButtonTypeRoundedRect];

    updateButton.frame=CGRectMake(20, 240+self.view.frame.size.height-480+30+diffH, 280, 40);
 
    [updateButton setTitle:@"检查新版本" forState:UIControlStateNormal];
    updateButton.titleLabel.textColor=[UIColor grayColor];
//    [updateButton setBackgroundImage:[UIImage imageNamed:@"常态.png"] forState:UIControlStateNormal];
//    [updateButton setBackgroundImage:[UIImage imageNamed:@"按下.png"] forState:UIControlStateHighlighted];
    [self.view addSubview:updateButton];
    [updateButton addTarget:self action:@selector(checkNewVersion) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton * protocolBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [protocolBtn setFrame:CGRectMake(0, 330+self.view.frame.size.height-480+diffH, 320, 30)];
    [protocolBtn setTitle:@"点此查看《用户协议》" forState:UIControlStateNormal];
    [self.view addSubview:protocolBtn];
    [protocolBtn.titleLabel setFont:[UIFont systemFontOfSize:15]];
    [protocolBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [protocolBtn addTarget:self action:@selector(userProtocol) forControlEvents:UIControlEventTouchUpInside];
    
   UILabel * protocal=[[UILabel alloc]init];

    protocal.frame=CGRectMake(10, 370+self.view.frame.size.height-480+diffH, 300, 20);

    protocal.text=@"版权所有--爱宠联盟科技有限公司";
    protocal.textColor=[UIColor grayColor];
    protocal.textAlignment=NSTextAlignmentCenter;
    protocal.backgroundColor=[UIColor clearColor];
    protocal.font=[UIFont systemFontOfSize:15];
    
    UILabel * protocal1=[[UILabel alloc]init];

    protocal1.frame=CGRectMake(10, 390+self.view.frame.size.height-480+diffH, 300, 20);

    
    protocal1.text=@"客服电话:010-562921815";
    protocal1.textColor=[UIColor grayColor];
    protocal1.textAlignment=NSTextAlignmentCenter;
    protocal1.backgroundColor=[UIColor clearColor];
    protocal1.font=[UIFont systemFontOfSize:15];
    
    UILabel * protocal2=[[UILabel alloc]init];

    protocal2.frame=CGRectMake(10, 410+self.view.frame.size.height-480+diffH, 300, 20);

    protocal2.text=@"All Rights Reserved";
    protocal2.textColor=[UIColor grayColor];
    protocal2.textAlignment=NSTextAlignmentCenter;
    protocal2.backgroundColor=[UIColor clearColor];
    protocal2.font=[UIFont systemFontOfSize:15];
    
    [self.view addSubview:protocal];
    [self.view addSubview:protocal1];
    [self.view addSubview:protocal2];

	// Do any additional setup after loading the view.
}
-(void)userProtocol
{
    UserTreatyViewController * uvv = [[UserTreatyViewController alloc] init];
    [self.navigationController pushViewController:uvv animated:YES];
}
-(void)checkNewVersion
{
//    NSMutableDictionary* params = [[NSMutableDictionary alloc]init];
//    NSTimeInterval cT = [[NSDate date] timeIntervalSince1970];
//    long long a = (long long)(cT*1000);
//    NSMutableDictionary* body = [[NSMutableDictionary alloc]init];
//    [body setObject:@"1" forKey:@"channel"];
//    [body setObject:[SFHFKeychainUtils getPasswordForUsername:MACADDRESS andServiceName:LOCALACCOUNT error:nil] forKey:@"mac"];
//    [body setObject:@"iphone" forKey:@"imei"];
//    [body setObject:params forKey:@"params"];
//    [body setObject:@"updateVersion" forKey:@"method"];
//    [body setObject:[NSString stringWithFormat:@"%lld",a] forKey:@"connectTime"];
//    [body setObject:[SFHFKeychainUtils getPasswordForUsername:LOCALTOKEN andServiceName:LOCALACCOUNT error:nil] forKey:@"token"];
//    
//    [NetManager requestWithURLStr:BaseClientUrl Parameters:body TheController:self success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
//        NSString * newV = [dic objectForKey:@"petVersion"];
//        if ([newV doubleValue]>[version doubleValue]) {
//            appStroreURL = [dic objectForKey:@"iosurl"];
//            UIAlertView * alert = [[UIAlertView alloc]initWithTitle:nil message:[NSString stringWithFormat:@"检测到新版本%@",newV] delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"现在更新", nil];
//            [alert show];
//        }
//        else
//        {
//            appStroreURL = [dic objectForKey:@"iosurl"];
//            UIAlertView * alert = [[UIAlertView alloc]initWithTitle:nil message:@"已经是最新版本啦，继续享受宠物圈给你带来的快乐吧" delegate:self cancelButtonTitle:@"知道了" otherButtonTitles: nil];
//            [alert show];
//        }
//        NSLog(@"dddd:%@,%f",dic,[version doubleValue]);
//        
//    }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:nil message:@"网络请求异常，请确认网络连接正常" delegate:self cancelButtonTitle:@"知道啦" otherButtonTitles: nil];
//        [alert show];
//    }];
    NSMutableDictionary * userInfoDict = [NSMutableDictionary dictionary];
    NSMutableDictionary * postDict = [NSMutableDictionary dictionary];
    //    [userInfoDict setObject:[SFHFKeychainUtils getPasswordForUsername:ACCOUNT andServiceName:LOCALACCOUNT error:nil] forKey:@"username"];
    //    [userInfoDict setObject:[SFHFKeychainUtils getPasswordForUsername:PASSWORD andServiceName:LOCALACCOUNT error:nil] forKey:@"password"];
    //    [userInfoDict setObject:@"31" forKey:@"imgId"];
    //    [userInfoDict setObject:@"2" forKey:@"type"];
    [userInfoDict setObject:@"open" forKey:@"action"];
    //    NSString * version = [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString *)kCFBundleVersionKey];
    //    [userInfoDict setObject:version forKey:@"version"];
    [postDict setObject:userInfoDict forKey:@"params"];
    [postDict setObject:@"1" forKey:@"channel"];
    [postDict setObject:@"token" forKey:@"method"];
    [postDict setObject:@"service.uri.pet_sso" forKey:@"service"];
    [postDict setObject:[SFHFKeychainUtils getPasswordForUsername:LOCALTOKEN andServiceName:LOCALACCOUNT error:nil] forKey:@"token"];
    [postDict setObject:[SFHFKeychainUtils getPasswordForUsername:MACADDRESS andServiceName:LOCALACCOUNT error:nil] forKey:@"mac"];
    [postDict setObject:@"iphone" forKey:@"imei"];
    
    NSTimeInterval cT = [[NSDate date] timeIntervalSince1970];
    long long a = (long long)(cT*1000);
    [postDict setObject:[NSString stringWithFormat:@"%lld",a] forKey:@"connectTime"];
    
    [NetManager requestWithURLStr:BaseClientUrl Parameters:postDict TheController:self success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //        NSString *receiveStr = [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
        //        NSDictionary * recDict = [receiveStr JSONValue];
        //        if ([[recDict objectForKey:@"token"] length]>3) {
        [self logInServerSuccessWithInfo:responseObject];
        //        }
        //        else
        //        {
        //            titleLabel.text = @"消息(未连接)";
        //        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];


}
-(void)logInServerSuccessWithInfo:(NSDictionary *)dict
{
    NSString * versionq = [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString *)kCFBundleVersionKey];
    
    if ([[[dict objectForKey:@"version"] objectForKey:@"petVersion"] floatValue]>[versionq floatValue]) {
        //        appStoreURL = [dict objectForKey:@"iosurl"];
        //        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"检测到新版本，您的版本已低于最低版本需求，请立即升级" delegate:self cancelButtonTitle:@"立即升级" otherButtonTitles: nil];
        //        alert.tag = 20;
        //        [alert show];
        appStroreURL = [[dict objectForKey:@"version"] objectForKey:@"iosurl"];
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"检测到新版本，您要升级吗" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"立刻升级", nil];
        [alert show];
    }
    else
    {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"已经是最新版本啦，继续享受宠物圈给你带来的快乐吧" delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:nil];
        [alert show];
    }
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==1) {
        NSString * appLink = appStroreURL;
        if (appStroreURL&&![appStroreURL isKindOfClass:[NSNull class]]) {
            NSURL *url = [NSURL URLWithString:appLink];
            if([[UIApplication sharedApplication] canOpenURL:url])
            {
                [[UIApplication sharedApplication] openURL:url];
            }
        }
        
    }
}
-(void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
