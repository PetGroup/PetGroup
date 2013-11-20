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
#import "NewRegistThreeViewController.h"

@interface NewRegistOneViewController ()<MBProgressHUDDelegate>
{
    BOOL canNext;
    MBProgressHUD * hud;
    UIButton* readB;
    BOOL passVerificationCode;
}
@property (nonatomic, strong) UITextField * phoneTF;

@end

@implementation NewRegistOneViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        canNext = YES;
        passVerificationCode = YES;
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
    self.navigationController.navigationBarHidden =YES;
    
    float diffH = [Common diffHeight:self];
    UIImageView * bgimgV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 44+diffH, 320, self.view.frame.size.height-44)];
    [bgimgV setImage:[UIImage imageNamed:@"regBG.png"]];
    [self.view addSubview:bgimgV];
    UIImageView *TopBarBGV=[[UIImageView alloc]initWithImage:[UIImage imageNamed:diffH==0?@"topBar1.png":@"topBar2.png"]];
    [TopBarBGV setFrame:CGRectMake(0, 0, 320, 44+diffH)];
    [self.view addSubview:TopBarBGV];
    
    UIButton *backButton=[UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame=CGRectMake(0, 0+diffH, 80, 44);
    [backButton setBackgroundImage:diffH==0.0f?[UIImage imageNamed:@"back2.png"]:[UIImage imageNamed:@"backnew.png"] forState:UIControlStateNormal];
    [self.view addSubview:backButton];
    [backButton addTarget:self action:@selector(backButton:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton * nextB = [UIButton buttonWithType:UIButtonTypeCustom];
    nextB.frame = CGRectMake(245, 5+diffH, 70, 34);
    [nextB setTitle:@"下一步" forState:UIControlStateNormal];
    if (diffH==0) {
        [nextB setBackgroundImage:[UIImage imageNamed:@"youshangjiao_normal"] forState:UIControlStateNormal];
        [nextB setBackgroundImage:[UIImage imageNamed:@"youshangjiao_click"] forState:UIControlStateHighlighted];

    }
    [nextB addTarget:self action:@selector(next) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:nextB];
    UILabel *  titleLabel=[[UILabel alloc] initWithFrame:CGRectMake(50, 2+diffH, 220, 40)];
    titleLabel.backgroundColor=[UIColor clearColor];
    [titleLabel setText:@"填写手机号(1/3)"];
    [titleLabel setFont:[UIFont boldSystemFontOfSize:18]];
    titleLabel.textAlignment=NSTextAlignmentCenter;
    titleLabel.textColor=[UIColor whiteColor];
    [self.view addSubview:titleLabel];
    
    UIImageView * nameBG = [[UIImageView alloc] initWithFrame:CGRectMake(31.25, 80+diffH, 257.5, 41)];
    [nameBG setImage:[UIImage imageNamed:@"logininputbg.png"]];
    [self.view addSubview:nameBG];
    
    UILabel* tishi1L = [[UILabel alloc]initWithFrame:CGRectMake(31.25, 141+diffH, 257.5, 60)];
    tishi1L.text = @"输入您的手机号，免费注册宠物圈，宠物圈不会在任何地方泄露您的电话号码。";
    tishi1L.font = [UIFont systemFontOfSize:15];
    tishi1L.numberOfLines = 0;
    tishi1L.backgroundColor = [UIColor clearColor];
    [self.view addSubview:tishi1L];
    
    UILabel* tishi2 = [[UILabel alloc]initWithFrame:CGRectMake(31.25, 221+diffH, 257.5, 40)];
    tishi2.text = @"下一步将发送验证码到您的手机上。";
    tishi2.font = [UIFont systemFontOfSize:15];
    tishi2.numberOfLines = 0;
    tishi2.backgroundColor = [UIColor clearColor];
    [self.view addSubview:tishi2];
    
    readB = [UIButton buttonWithType:UIButtonTypeCustom];
    readB.frame = CGRectMake(31.25, 288.5+diffH, 15, 15);
    [readB setBackgroundImage:[UIImage imageNamed:@"third_common_selected_clicked"] forState:UIControlStateNormal];
    [readB addTarget:self action:@selector(readUserTreaty) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:readB];
    
    UILabel* tishi3 = [[UILabel alloc]initWithFrame:CGRectMake(52.25, 285+diffH, 257.5, 20)];
    tishi3.text = @"已阅读并同意";
    tishi3.font = [UIFont systemFontOfSize:15];
    tishi3.backgroundColor = [UIColor clearColor];
    [self.view addSubview:tishi3];
    
    UILabel* xieyiL = [[UILabel alloc]initWithFrame:CGRectMake(140, 285+diffH, 90, 20)];
    xieyiL.text = @"《用户协议》";
    xieyiL.font = [UIFont systemFontOfSize:15];
    xieyiL.textColor = [UIColor colorWithRed:8/255.0 green:141/255.0 blue:184/255.0 alpha:1];
    xieyiL.backgroundColor = [UIColor clearColor];
    xieyiL.userInteractionEnabled = YES;
    [self.view addSubview:xieyiL];
    
    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(userTreaty:)];
    [xieyiL addGestureRecognizer:tap];
     self.phoneTF = [[UITextField alloc]initWithFrame:CGRectMake(42.25, 85+diffH, 245.5, 30)];
    _phoneTF.placeholder = @"请输入手机号";
    _phoneTF.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
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
-(void)readUserTreaty
{
    if (canNext) {
        [readB setBackgroundImage:[UIImage imageNamed:@"third_common_selected_no"] forState:UIControlStateNormal];
    }else{
        [readB setBackgroundImage:[UIImage imageNamed:@"third_common_selected_clicked"] forState:UIControlStateNormal];
    }
    canNext = !canNext;

}
-(void)next
{
    if (!canNext) {
        UIAlertView* a = [[UIAlertView alloc]initWithTitle:nil message:@"请阅读并同意《用户协议》" delegate:self cancelButtonTitle:@"知道啦" otherButtonTitles: nil];
        [a show];
        return;
    }
    if ([IdentifyingString validateMobile:_phoneTF.text]) {
        [_phoneTF resignFirstResponder];
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
        [body setObject:@"service.uri.pet_sso" forKey:@"service"];
        [body setObject:[NSString stringWithFormat:@"%lld",a] forKey:@"connectTime"];
        [hud show:YES];
        [NetManager requestWithURLStr:BaseClientUrl Parameters:body TheController:self success:^(AFHTTPRequestOperation *operation, id responseObject) {
            if ([responseObject boolValue]==true) {
                UIAlertView* alert = [[UIAlertView alloc]initWithTitle:nil message:@"该手机号已被注册" delegate:self cancelButtonTitle:@"知道啦" otherButtonTitles: nil];
                [alert show];
                [hud hide:YES];
            }else{
                [hud hide:YES];
                [self puchNextView];
            }
        }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            UIAlertView* alert = [[UIAlertView alloc]initWithTitle:nil message:@"网络请求异常，请确认网络连接正常" delegate:self cancelButtonTitle:@"知道啦" otherButtonTitles: nil];
            [alert show];
            [hud hide:YES];
        }];
    }else{
        UIAlertView* alert = [[UIAlertView alloc]initWithTitle:nil message:@"请输入正确的手机号码" delegate:self cancelButtonTitle:@"知道啦" otherButtonTitles: nil];
        [alert show];
        [hud hide:YES];
    }
}
-(void)puchNextView
{
    if (passVerificationCode) {
        NewRegistThreeViewController* newReg = [[NewRegistThreeViewController alloc]init];
        newReg.phoneNo = self.phoneTF.text;
        [self.navigationController pushViewController:newReg animated:YES];
        return;
    }
    NSMutableDictionary* params = [[NSMutableDictionary alloc]init];
    NSTimeInterval cT = [[NSDate date] timeIntervalSince1970];
    long long a = (long long)(cT*1000);
    [params setObject:_phoneTF.text forKey:@"phoneNum"];
    NSMutableDictionary* body = [[NSMutableDictionary alloc]init];
    [body setObject:@"1" forKey:@"channel"];
    [body setObject:[SFHFKeychainUtils getPasswordForUsername:MACADDRESS andServiceName:LOCALACCOUNT error:nil] forKey:@"mac"];
    [body setObject:@"iphone" forKey:@"imei"];
    [body setObject:params forKey:@"params"];
    [body setObject:@"getVerificationCode" forKey:@"method"];
    [body setObject:@"service.uri.pet_sso" forKey:@"service"];
    [body setObject:[NSString stringWithFormat:@"%lld",a] forKey:@"connectTime"];
    [NetManager requestWithURLStr:BaseClientUrl Parameters:body TheController:self success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [hud hide:YES];
        NewRegistTwoViewController* newReg = [[NewRegistTwoViewController alloc]init];
        newReg.phoneNo = self.phoneTF.text;
        [self.navigationController pushViewController:newReg animated:YES];
    }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        UIAlertView* alert = [[UIAlertView alloc]initWithTitle:nil message:@"网络请求异常，请确认网络连接正常" delegate:self cancelButtonTitle:@"知道啦" otherButtonTitles: nil];
        [alert show];
        [hud hide:YES];
    }];
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
