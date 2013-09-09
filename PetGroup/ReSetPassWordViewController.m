//
//  ReSetPassWordViewController.m
//  NewXMPPTest
//
//  Created by 阿铛 on 13-8-21.
//  Copyright (c) 2013年 Tolecen. All rights reserved.
//

#import "ReSetPassWordViewController.h"
#import "ResetPassOneViewController.h"
#import "IdentifyingString.h"
#import "MBProgressHUD.h"

@interface ReSetPassWordViewController ()
{
    MBProgressHUD *hud;
}
@property (nonatomic,strong)UITextField* phoneNoTF;

@end

@implementation ReSetPassWordViewController

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
	// Do any additional setup after loading the view.
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
    [titleLabel setText:@"重置密码"];
    [titleLabel setFont:[UIFont boldSystemFontOfSize:18]];
    titleLabel.textAlignment=UITextAlignmentCenter;
    titleLabel.textColor=[UIColor whiteColor];
    [self.view addSubview:titleLabel];
    
    UIImageView * nameBG = [[UIImageView alloc] initWithFrame:CGRectMake(31.25, 80, 257.5, 41)];
    [nameBG setImage:[UIImage imageNamed:@"shurukuang_top"]];
    [self.view addSubview:nameBG];
    
    UIImageView * passWordIV = [[UIImageView alloc] initWithFrame:CGRectMake(31.25, 122, 257.5, 41)];
    [passWordIV setImage:[UIImage imageNamed:@"shurukuang_bottom"]];
    [self.view addSubview:passWordIV];
    
    UIImageView * a =  [[UIImageView alloc] initWithFrame:CGRectMake(31.75, 121, 256.5, 1)];
    a.image = [UIImage imageNamed:@"shurukuang_jiangexian"];
    [self.view addSubview:a];
    
    UILabel* nameL = [[UILabel alloc]initWithFrame:CGRectMake(5, 10, 70, 20)];
    nameL.text = @"中国+86";
    nameL.font = [UIFont systemFontOfSize:13];
    nameL.backgroundColor = [UIColor clearColor];
    [nameBG addSubview:nameL];
    
    self.phoneNoTF = [[UITextField alloc]initWithFrame:CGRectMake(33.25, 129.5, 257.5, 25)];
    _phoneNoTF.placeholder = @"请输入手机号";
    [self.view addSubview:_phoneNoTF];
    _phoneNoTF.keyboardType = UIKeyboardTypeNumberPad;
    
    hud = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:hud];
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
    if ([IdentifyingString validateMobile:_phoneNoTF.text]) {
        NSMutableDictionary* params = [[NSMutableDictionary alloc]init];
        NSTimeInterval cT = [[NSDate date] timeIntervalSince1970];
        long long a = (long long)(cT*1000);
        [params setObject:_phoneNoTF.text forKey:@"phoneNum"];
        NSMutableDictionary* body = [[NSMutableDictionary alloc]init];
        [body setObject:@"1" forKey:@"channel"];
        [body setObject:[SFHFKeychainUtils getPasswordForUsername:MACADDRESS andServiceName:LOCALACCOUNT error:nil] forKey:@"mac"];
        [body setObject:@"iphone" forKey:@"imei"];
        [body setObject:params forKey:@"params"];
        [body setObject:@"getVerificationCode" forKey:@"method"];
        [body setObject:[NSString stringWithFormat:@"%lld",a] forKey:@"connectTime"];
        [NetManager requestWithURLStr:BaseClientUrl Parameters:body success:^(AFHTTPRequestOperation *operation, id responseObject) {
            [hud hide:YES];
            ResetPassOneViewController* resetPassVC = [[ResetPassOneViewController alloc]init];
            resetPassVC.phoneNo = _phoneNoTF.text;
            [self.navigationController pushViewController:resetPassVC animated:YES];
        }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            UIAlertView* alert = [[UIAlertView alloc]initWithTitle:nil message:@"网络请求异常，请确认网络连接正常" delegate:self cancelButtonTitle:@"知道啦" otherButtonTitles: nil];
            [alert show];
            [hud hide:YES];
        }];
    }else{
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"请输入正确的手机号" delegate:self cancelButtonTitle:@"知道啦" otherButtonTitles: nil];
        [alert show];
    }
    
}
#pragma mark - touch
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [_phoneNoTF resignFirstResponder];
}
@end
