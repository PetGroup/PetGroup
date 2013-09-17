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

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    UIImageView * bgV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, self.view.frame.size.height)];
    [bgV setImage:[UIImage imageNamed:@"chat_bg.png"]];
    [self.view addSubview:bgV];
    // messages = [NSMutableArray array];
    
    
    UIImageView *TopBarBGV=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"topBG.png"]];
    [TopBarBGV setFrame:CGRectMake(0, 0, 320, 44)];
    [self.view addSubview:TopBarBGV];
    
    UIButton *backButton=[UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame=CGRectMake(0, 0, 80, 44);
    [backButton setBackgroundImage:[UIImage imageNamed:@"back2.png"] forState:UIControlStateNormal];
    //   [backButton setTitle:@" 返回" forState:UIControlStateNormal];
    [backButton.titleLabel setFont:[UIFont boldSystemFontOfSize:15]];
    [self.view addSubview:backButton];
    [backButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    
    
    UILabel * titleLabel=[[UILabel alloc] initWithFrame:CGRectMake(100, 2, 120, 40)];
    titleLabel.backgroundColor=[UIColor clearColor];
    titleLabel.text=@"关于宠物圈";
    [titleLabel setFont:[UIFont boldSystemFontOfSize:18]];
    titleLabel.textAlignment=UITextAlignmentCenter;
    titleLabel.textColor=[UIColor whiteColor];
    [self.view addSubview:titleLabel];
    
    UIImageView * iconImageView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"sss.png"]];
    iconImageView.frame=CGRectMake(120, 80, 80, 80);
    iconImageView.layer.cornerRadius=10;
    [self.view addSubview:iconImageView];
    
    UILabel *showVersion=[[UILabel alloc] init];
    [showVersion setBackgroundColor:[UIColor clearColor]];
    showVersion.frame= CGRectMake(20, 180, 280, 40);
    
    version = [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString *)kCFBundleVersionKey];

    NSString * addString = [NSString stringWithFormat:@"版本号:%@",version];

    
    version = addString;
    showVersion.text=version;
    showVersion.textAlignment=UITextAlignmentCenter;
    showVersion.textColor=[UIColor grayColor];
    //showButton.userInteractionEnabled=NO;
    [self.view addSubview:showVersion];

    UIButton * updateButton=[UIButton buttonWithType:UIButtonTypeRoundedRect];

    updateButton.frame=CGRectMake(20, 240+self.view.frame.size.height-480+30, 280, 40);
 
    [updateButton setTitle:@"检查新版本" forState:UIControlStateNormal];
    updateButton.titleLabel.textColor=[UIColor grayColor];
//    [updateButton setBackgroundImage:[UIImage imageNamed:@"常态.png"] forState:UIControlStateNormal];
//    [updateButton setBackgroundImage:[UIImage imageNamed:@"按下.png"] forState:UIControlStateHighlighted];
    [self.view addSubview:updateButton];
    [updateButton addTarget:self action:@selector(checkNewVersion) forControlEvents:UIControlEventTouchUpInside];
    
   UILabel * protocal=[[UILabel alloc]init];

    protocal.frame=CGRectMake(60, 370+self.view.frame.size.height-480, 200, 20);

    protocal.text=@"版权所有----宠物圈";
    protocal.textColor=[UIColor grayColor];
    protocal.textAlignment=UITextAlignmentCenter;
    protocal.backgroundColor=[UIColor clearColor];
    protocal.font=[UIFont systemFontOfSize:15];
    
    UILabel * protocal1=[[UILabel alloc]init];

    protocal1.frame=CGRectMake(10, 390+self.view.frame.size.height-480, 300, 20);

    
    protocal1.text=@"Aichongwu Technology Ltd.";
    protocal1.textColor=[UIColor grayColor];
    protocal1.textAlignment=UITextAlignmentCenter;
    protocal1.backgroundColor=[UIColor clearColor];
    protocal1.font=[UIFont systemFontOfSize:15];
    
    UILabel * protocal2=[[UILabel alloc]init];

    protocal2.frame=CGRectMake(10, 410+self.view.frame.size.height-480, 300, 20);

    protocal2.text=@"All Rights Reserved";
    protocal2.textColor=[UIColor grayColor];
    protocal2.textAlignment=UITextAlignmentCenter;
    protocal2.backgroundColor=[UIColor clearColor];
    protocal2.font=[UIFont systemFontOfSize:15];
    
    [self.view addSubview:protocal];
    [self.view addSubview:protocal1];
    [self.view addSubview:protocal2];

	// Do any additional setup after loading the view.
}
-(void)checkNewVersion
{
    NSMutableDictionary* params = [[NSMutableDictionary alloc]init];
    NSTimeInterval cT = [[NSDate date] timeIntervalSince1970];
    long long a = (long long)(cT*1000);
    NSMutableDictionary* body = [[NSMutableDictionary alloc]init];
    [body setObject:@"1" forKey:@"channel"];
    [body setObject:[SFHFKeychainUtils getPasswordForUsername:MACADDRESS andServiceName:LOCALACCOUNT error:nil] forKey:@"mac"];
    [body setObject:@"iphone" forKey:@"imei"];
    [body setObject:params forKey:@"params"];
    [body setObject:@"updateVersion" forKey:@"method"];
    [body setObject:[NSString stringWithFormat:@"%lld",a] forKey:@"connectTime"];
    [body setObject:[SFHFKeychainUtils getPasswordForUsername:LOCALTOKEN andServiceName:LOCALACCOUNT error:nil] forKey:@"token"];
    
    [NetManager requestWithURLStr:BaseClientUrl Parameters:body TheController:self success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NSString * newV = [dic objectForKey:@"petVersion"];
        if ([newV doubleValue]>[version doubleValue]) {
            appStroreURL = [dic objectForKey:@"iosurl"];
            UIAlertView * alert = [[UIAlertView alloc]initWithTitle:nil message:[NSString stringWithFormat:@"检测到新版本%@",newV] delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"现在更新", nil];
            [alert show];
        }
        NSLog(@"dddd:%@",dic);
        
    }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:nil message:@"网络请求异常，请确认网络连接正常" delegate:self cancelButtonTitle:@"知道啦" otherButtonTitles: nil];
        [alert show];
    }];

}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==1) {
        NSString * appLink = appStroreURL;
        NSURL *url = [NSURL URLWithString:appLink];
        if([[UIApplication sharedApplication] canOpenURL:url])
        {
            [[UIApplication sharedApplication] openURL:url];
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
