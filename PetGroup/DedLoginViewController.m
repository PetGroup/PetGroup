//
//  DedLoginViewController.m
//  NewXMPPTest
//
//  Created by 阿铛 on 13-8-20.
//  Copyright (c) 2013年 Tolecen. All rights reserved.
//

#import "DedLoginViewController.h"
#import "SelectorPetViewController.h"

@interface DedLoginViewController ()

@end

@implementation DedLoginViewController

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
	// Do any additional setup after loading the view.
    float diffH = [Common diffHeight:self];
    self.view.backgroundColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1];
    UIImageView *TopBarBGV=[[UIImageView alloc]initWithImage:[UIImage imageNamed:diffH==0?@"topBar1.png":@"topBar2.png"]];
    [TopBarBGV setFrame:CGRectMake(0, 0, 320, 44+diffH)];
    [self.view addSubview:TopBarBGV];

    UILabel *  titleLabel=[[UILabel alloc] initWithFrame:CGRectMake(50, 2+diffH, 220, 40)];
    titleLabel.backgroundColor=[UIColor clearColor];
    [titleLabel setText:@"注册完成"];
    [titleLabel setFont:[UIFont boldSystemFontOfSize:18]];
    titleLabel.textAlignment=NSTextAlignmentCenter;
    titleLabel.textColor=[UIColor whiteColor];
    [self.view addSubview:titleLabel];
    
    UIImageView* heheIV = [[UIImageView alloc]initWithFrame:CGRectMake(112.5, 70+diffH, 95, 45)];
    heheIV.image = [UIImage imageNamed:@"chenggong"];
    [self.view addSubview:heheIV];
    
    UILabel* tishiL1 = [[UILabel alloc]initWithFrame:CGRectMake(0, 150+diffH, 320, 30)];
    tishiL1.text = @"恭喜你，你已经注册成功！";
    tishiL1.font = [UIFont boldSystemFontOfSize:16];
    tishiL1.backgroundColor = [UIColor clearColor];
    tishiL1.textAlignment = NSTextAlignmentCenter;
    tishiL1.textColor = [UIColor orangeColor];
    [self.view addSubview:tishiL1];
    
    UILabel* tishiL2 = [[UILabel alloc]initWithFrame:CGRectMake(20, 220+diffH, 280, 90)];
    tishiL2.text = @"快去选择你的宠物，并且给你和你的宠物设置一个高端大气上档次的头像吧，可以更好地与宠友们交流。";
    tishiL2.backgroundColor = [UIColor clearColor];
    tishiL2.numberOfLines = 0;
    [self.view addSubview:tishiL2];
    
    UIButton * laterBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [laterBtn setBackgroundImage:[UIImage imageNamed:@"newreegBtn"] forState:UIControlStateNormal];
    [laterBtn setFrame:CGRectMake(10, 360+diffH, 300, 40)];
    [self.view addSubview:laterBtn];
    [laterBtn setTitle:@"以后再说" forState:UIControlStateNormal];
    [laterBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    laterBtn.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:20];
    [laterBtn addTarget:self action:@selector(laterBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    UIButton * goBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [goBtn setBackgroundImage:[UIImage imageNamed:@"newloginBtn"] forState:UIControlStateNormal];
    [goBtn setFrame:CGRectMake(10, 310+diffH, 300, 40)];
    [self.view addSubview:goBtn];
    goBtn.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:20];
    [goBtn setTitle:@"现在去完善" forState:UIControlStateNormal];
    [goBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [goBtn addTarget:self action:@selector(goBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    
    hud = [[MBProgressHUD alloc] initWithWindow:[UIApplication sharedApplication].keyWindow];
    [[UIApplication sharedApplication].keyWindow addSubview:hud];
    hud.labelText = @"正在设置您的个人信息";
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - button action
-(void)laterBtnClicked
{
    //[self dismissModalViewControllerAnimated:YES];
    [self updataUserInfo];
}
-(void)updataUserInfo
{
    NSTimeInterval cT = [[NSDate date] timeIntervalSince1970];
    long long a = (long long)(cT*1000);
    NSMutableDictionary* body = [[NSMutableDictionary alloc]init];
    [body setObject:@"1" forKey:@"channel"];
    [body setObject:[SFHFKeychainUtils getPasswordForUsername:MACADDRESS andServiceName:LOCALACCOUNT error:nil] forKey:@"mac"];
    [body setObject:@"iphone" forKey:@"imei"];
    [body setObject:[SFHFKeychainUtils getPasswordForUsername:LOCALTOKEN andServiceName:LOCALACCOUNT error:nil] forKey:@"token"];
    [body setObject:[NSString stringWithFormat:@"%lld",a] forKey:@"connectTime"];
    NSMutableDictionary* params = [[NSMutableDictionary alloc]init];
    [params setObject:[self.dic objectForKey:@"nickname"] forKey:@"nickname"];
    [params setObject:[self.dic objectForKey:@"gender"] forKey:@"gender"];
    [params setObject:[self.dic objectForKey:@"birthdate"] forKey:@"birthdate"];
    [params setObject:[self.dic objectForKey:@"city"] forKey:@"city"];
    [params setObject:@"" forKey:@"backgroundImg"];
    [params setObject:@"" forKey:@"img"];
    [params setObject:@"默认签名" forKey:@"signature"];
    [params setObject:@"默认爱好" forKey:@"hobby"];
    [body setObject:params forKey:@"params"];
    [body setObject:@"updateUser" forKey:@"method"];
    [body setObject:@"service.uri.pet_user" forKey:@"service"];
    [NetManager requestWithURLStr:BaseClientUrl Parameters:body TheController:self success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        [DataStoreManager saveUserInfo:[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil]];
        [params setObject:[SFHFKeychainUtils getPasswordForUsername:ACCOUNT andServiceName:LOCALACCOUNT error:nil] forKey:@"username"];
        [params setObject:[DataStoreManager getMyUserID] forKey:@"id"];
        [DataStoreManager saveUserInfo:params];
        [hud hide:YES];
//        [self dismissModalViewControllerAnimated:YES];
        [self dismissViewControllerAnimated:YES completion:^{
            
        }];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [hud hide:YES];
        [self dismissViewControllerAnimated:YES completion:^{
            
        }];
    }];
    
}
-(void)goBtnClicked
{
    SelectorPetViewController* selPetVC = [[SelectorPetViewController alloc]init];
    selPetVC.dic = self.dic;
    [self.navigationController pushViewController:selPetVC animated:YES];
}
@end
