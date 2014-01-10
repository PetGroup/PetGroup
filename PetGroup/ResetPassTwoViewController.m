//
//  ResetPassTwoViewController.m
//  NewXMPPTest
//
//  Created by 阿铛 on 13-8-21.
//  Copyright (c) 2013年 Tolecen. All rights reserved.
//

#import "ResetPassTwoViewController.h"
#import "MBProgressHUD.h"

@interface ResetPassTwoViewController ()
{
    MBProgressHUD *hud;
}
@property (nonatomic,strong) UITextField* PhoneNoTF;
@property (nonatomic,strong) UITextField* passWordTF;

@end

@implementation ResetPassTwoViewController

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
    
    UIButton *backButton=[UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame=CGRectMake(0, 0+diffH, 80, 44);
    [backButton setBackgroundImage:[UIImage imageNamed:@"backnew.png"] forState:UIControlStateNormal];
    [self.view addSubview:backButton];
    [backButton addTarget:self action:@selector(backButton:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton * nextB = [UIButton buttonWithType:UIButtonTypeCustom];
    nextB.frame = CGRectMake(240, 0+diffH, 80, 44);
    [nextB setBackgroundImage:[UIImage imageNamed:@"nextBtn"] forState:UIControlStateNormal];
    [nextB.titleLabel setFont:[UIFont systemFontOfSize:15]];
    [nextB setTitle:@"完成" forState:UIControlStateNormal];
//    if (diffH==0) {
//        [nextB setBackgroundImage:[UIImage imageNamed:@"youshangjiao_normal"] forState:UIControlStateNormal];
//        [nextB setBackgroundImage:[UIImage imageNamed:@"youshangjiao_click"] forState:UIControlStateHighlighted];
//    }
    [nextB addTarget:self action:@selector(next) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:nextB];
    UILabel *  titleLabel=[[UILabel alloc] initWithFrame:CGRectMake(50, 2+diffH, 220, 40)];
    titleLabel.backgroundColor=[UIColor clearColor];
    [titleLabel setText:@"修改密码"];
    [titleLabel setFont:[UIFont boldSystemFontOfSize:18]];
    titleLabel.textAlignment=NSTextAlignmentCenter;
    titleLabel.textColor=[UIColor whiteColor];
    [self.view addSubview:titleLabel];
    
    UIImageView * nameBG = [[UIImageView alloc] initWithFrame:CGRectMake(10, 80+diffH, 300, 108)];
    [nameBG setImage:[UIImage imageNamed:@"newlogbg1"]];
    [self.view addSubview:nameBG];
    
    UILabel* nameL = [[UILabel alloc]initWithFrame:CGRectMake(5, 20, 70, 20)];
    nameL.text = @"重置密码";
    nameL.font = [UIFont systemFontOfSize:16];
    nameL.backgroundColor = [UIColor clearColor];
    [nameBG addSubview:nameL];
    
    UILabel* passWordL = [[UILabel alloc]initWithFrame:CGRectMake(5, 70, 70, 20)];
    passWordL.text = @"重复密码";
    passWordL.font = [UIFont systemFontOfSize:16];
    passWordL.backgroundColor = [UIColor clearColor];
    [nameBG addSubview:passWordL];
    
    self.PhoneNoTF = [[UITextField alloc]initWithFrame:CGRectMake(111.25, 101+diffH, 200, 20)];
    _PhoneNoTF.placeholder = @"不少于6位且不要过于简单";
    _PhoneNoTF.secureTextEntry = YES;
    _PhoneNoTF.font = [UIFont systemFontOfSize:16];
    [self.view addSubview:_PhoneNoTF];
    
    self.passWordTF = [[UITextField alloc]initWithFrame:CGRectMake(111.25, 151+diffH, 175, 20)];
    _passWordTF.placeholder = @"再次输入密码";
    _passWordTF.secureTextEntry = YES;
    _passWordTF.font = [UIFont systemFontOfSize:16];
    [self.view addSubview:_passWordTF];
    
    hud = [[MBProgressHUD alloc] initWithWindow:[UIApplication sharedApplication].keyWindow];
    [[UIApplication sharedApplication].keyWindow addSubview:hud];
    hud.labelText = @"处理中...";
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
-(void)next//{"method":"resetPassword","token":"","channel":"","mac":"","imei":"","connectTime":"dd-mm-yy","params":{"password":"XXX","phonenumber":"XXX"}}
{
    NSMutableDictionary* params = [[NSMutableDictionary alloc]init];
    NSTimeInterval cT = [[NSDate date] timeIntervalSince1970];
    long long a = (long long)(cT*1000);
    [params setObject:self.phoneNo forKey:@"phonenumber"];
    [params setObject:_passWordTF.text forKey:@"password"];
    NSMutableDictionary* body = [[NSMutableDictionary alloc]init];
    [body setObject:@"1" forKey:@"channel"];
    [body setObject:[SFHFKeychainUtils getPasswordForUsername:MACADDRESS andServiceName:LOCALACCOUNT error:nil] forKey:@"mac"];
    [body setObject:@"iphone" forKey:@"imei"];
    [body setObject:params forKey:@"params"];
    [body setObject:@"resetPassword" forKey:@"method"];
    [body setObject:@"service.uri.pet_sso" forKey:@"service"];
    [body setObject:[NSString stringWithFormat:@"%lld",a] forKey:@"connectTime"];
    [hud show:YES];
    [NetManager requestWithURLStr:BaseClientUrl Parameters:body TheController:self success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([responseObject isEqualToString:@"OK"]) {
           [self.navigationController popToViewController:self.navigationController.viewControllers[1] animated:YES]; 
        }else{
            UIAlertView * alert = [[UIAlertView alloc]initWithTitle:nil message:@"密码修改失败，请重试" delegate:self cancelButtonTitle:@"知道啦" otherButtonTitles: nil];
            [alert show];
        }
        [hud hide:YES];
        
    }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [hud hide:YES];
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:nil message:@"网络请求异常，请确认网络连接正常" delegate:self cancelButtonTitle:@"知道啦" otherButtonTitles: nil];
        [alert show];
    }];
}
#pragma mark - touch
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [_PhoneNoTF resignFirstResponder];
    [_passWordTF resignFirstResponder];
}
@end
