//
//  NewRegistOneViewController.m
//  NewXMPPTest
//
//  Created by 阿铛 on 13-8-19.
//  Copyright (c) 2013年 Tolecen. All rights reserved.
//

#import "NewRegistOneViewController.h"
#import "NewRegistTwoViewController.h"
#import "UserTreatyViewController.h"
#import "IdentifyingString.h"
#import "MBProgressHUD.h"

@interface NewRegistOneViewController ()<MBProgressHUDDelegate>
{
    BOOL canNext;
    MBProgressHUD * hud;
}
@property (nonatomic, strong) UITextField * phoneTF;

@end

@implementation NewRegistOneViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        canNext = NO;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.navigationController.navigationBarHidden =YES;
    
    UIImageView * bgimgV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 44, 320, self.view.frame.size.height-44)];
    [bgimgV setImage:[UIImage imageNamed:@"regBG.png"]];
    [self.view addSubview:bgimgV];
    UIImageView *TopBarBGV=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"topBG.png"]];
    [TopBarBGV setFrame:CGRectMake(0, 0, 320, 44)];
    [self.view addSubview:TopBarBGV];
    
    UIButton *backButton=[UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame=CGRectMake(0, 0, 80, 44);
    [backButton setBackgroundImage:[UIImage imageNamed:@"back2.png"] forState:UIControlStateNormal];
    [self.view addSubview:backButton];
    [backButton addTarget:self action:@selector(backButton:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton * nextB = [UIButton buttonWithType:UIButtonTypeCustom];
    nextB.frame = CGRectMake(245, 5, 70, 34);
    [nextB setTitle:@"下一步" forState:UIControlStateNormal];
    [nextB setBackgroundImage:[UIImage imageNamed:@"youshangjiao_normal"] forState:UIControlStateNormal];
    [nextB setBackgroundImage:[UIImage imageNamed:@"youshangjiao_click"] forState:UIControlStateHighlighted];
    [nextB addTarget:self action:@selector(next) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:nextB];
    UILabel *  titleLabel=[[UILabel alloc] initWithFrame:CGRectMake(50, 2, 220, 40)];
    titleLabel.backgroundColor=[UIColor clearColor];
    [titleLabel setText:@"填写手机号(1/3)"];
    [titleLabel setFont:[UIFont boldSystemFontOfSize:18]];
    titleLabel.textAlignment=UITextAlignmentCenter;
    titleLabel.textColor=[UIColor whiteColor];
    [self.view addSubview:titleLabel];
    
    UIImageView * nameBG = [[UIImageView alloc] initWithFrame:CGRectMake(31.25, 80, 257.5, 41)];
    [nameBG setImage:[UIImage imageNamed:@"logininputbg.png"]];
    [self.view addSubview:nameBG];
    
    UILabel* tishi1L = [[UILabel alloc]initWithFrame:CGRectMake(31.25, 141, 257.5, 60)];
    tishi1L.text = @"输入那你的手机号，免费注册宠物圈，宠物圈不会在任何地方泄露你的电话号码。";
    tishi1L.font = [UIFont systemFontOfSize:15];
    tishi1L.numberOfLines = 0;
    tishi1L.backgroundColor = [UIColor clearColor];
    [self.view addSubview:tishi1L];
    
    UILabel* tishi2 = [[UILabel alloc]initWithFrame:CGRectMake(31.25, 221, 257.5, 40)];
    tishi2.text = @"下一步将发送验证码到你号码对应手机上，点击下一步表示同意";
    tishi2.font = [UIFont systemFontOfSize:15];
    tishi2.numberOfLines = 0;
    tishi2.backgroundColor = [UIColor clearColor];
    [self.view addSubview:tishi2];
    
    UILabel* xieyiL = [[UILabel alloc]initWithFrame:CGRectMake(190, 240, 90, 20)];
    xieyiL.text = @"《用户协议》";
    xieyiL.font = [UIFont systemFontOfSize:15];
    xieyiL.textColor = [UIColor colorWithRed:8/255.0 green:141/255.0 blue:184/255.0 alpha:1];
    xieyiL.backgroundColor = [UIColor clearColor];
    xieyiL.userInteractionEnabled = YES;
    [self.view addSubview:xieyiL];
    
    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(userTreaty:)];
    [xieyiL addGestureRecognizer:tap];
     self.phoneTF = [[UITextField alloc]initWithFrame:CGRectMake(32.25, 90, 255.5, 20)];
    _phoneTF.placeholder = @"请输入手机号";
    _phoneTF.keyboardType = UIKeyboardTypeNumberPad;
    [self.view addSubview:_phoneTF];
    
    hud = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:hud];
    hud.delegate = self;
    hud.labelText = @"正在发送，请稍后";
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - button action
-(void)backButton:(UIButton*)button
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)next
{
    NSMutableDictionary* params = [[NSMutableDictionary alloc]init];
    NSTimeInterval cT = [[NSDate date] timeIntervalSince1970];
    long long a = (long long)(cT*1000);
    [params setObject:_phoneTF.text forKey:@"username"];
    NSMutableDictionary* body = [[NSMutableDictionary alloc]init];
    [body setObject:@"1" forKey:@"channel"];
    [body setObject:[SFHFKeychainUtils getPasswordForUsername:MACADDRESS andServiceName:LOCALACCOUNT error:nil] forKey:@"mac"];
    [body setObject:@"iphone" forKey:@"imei"];
    [body setObject:params forKey:@"params"];
    [body setObject:@"isUsernameInuse" forKey:@"method"];
    [body setObject:[NSString stringWithFormat:@"%lld",a] forKey:@"connectTime"];
    [hud show:YES];
    [NetManager requestWithURLStr:BaseClientUrl Parameters:body success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([[[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding] isEqualToString:@"true"]) {
            UIAlertView* alert = [[UIAlertView alloc]initWithTitle:nil message:@"该手机号已被注册" delegate:self cancelButtonTitle:@"知道啦" otherButtonTitles: nil];
            [alert show];
            [hud hide:YES];
        }else{
            [self puchNextView];
        }
    }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        UIAlertView* alert = [[UIAlertView alloc]initWithTitle:nil message:@"网络请求异常，请确认网络连接正常" delegate:self cancelButtonTitle:@"知道啦" otherButtonTitles: nil];
        [alert show];
        [hud hide:YES];
    }];
}
-(void)puchNextView
{
//    if ([IdentifyingString validateMobile:_phoneTF.text]) {
//        NSMutableDictionary* params = [[NSMutableDictionary alloc]init];
//        NSTimeInterval cT = [[NSDate date] timeIntervalSince1970];
//        long long a = (long long)(cT*1000);
//        [params setObject:_phoneTF.text forKey:@"phoneNum"];
//        NSMutableDictionary* body = [[NSMutableDictionary alloc]init];
//        [body setObject:@"1" forKey:@"channel"];
//        [body setObject:[SFHFKeychainUtils getPasswordForUsername:MACADDRESS andServiceName:LOCALACCOUNT error:nil] forKey:@"mac"];
//        [body setObject:@"iphone" forKey:@"imei"];
//        [body setObject:params forKey:@"params"];
//        [body setObject:@"getVerificationCode" forKey:@"method"];
//        [body setObject:[NSString stringWithFormat:@"%lld",a] forKey:@"connectTime"];
//        [NetManager requestWithURLStr:BaseClientUrl Parameters:body success:^(AFHTTPRequestOperation *operation, id responseObject) {
            [hud hide:YES];
            NewRegistTwoViewController* newReg = [[NewRegistTwoViewController alloc]init];
            newReg.phoneNo = self.phoneTF.text;
            [self.navigationController pushViewController:newReg animated:YES];
//        }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//            UIAlertView* alert = [[UIAlertView alloc]initWithTitle:nil message:@"网络请求异常，请确认网络连接正常" delegate:self cancelButtonTitle:@"知道啦" otherButtonTitles: nil];
//            [alert show];
//            [hud hide:YES];
//        }];
//    }else{
//        UIAlertView* alert = [[UIAlertView alloc]initWithTitle:nil message:@"请输入正确的手机号码" delegate:self cancelButtonTitle:@"知道啦" otherButtonTitles: nil];
//        [alert show];
//        [hud hide:YES];
//    }
}

-(void)userTreaty:(UIGestureRecognizer*)gr
{
    ((UILabel*)gr.view).textColor = [UIColor blueColor];
    UserTreatyViewController* userTreatyVC = [[UserTreatyViewController alloc]init];
    [self.navigationController pushViewController:userTreatyVC animated:YES];
}
#pragma mark - touch
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [_phoneTF resignFirstResponder];
}
@end
