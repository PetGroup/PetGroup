//
//  NewLoginViewController.m
//  NewXMPPTest
//
//  Created by 阿铛 on 13-8-19.
//  Copyright (c) 2013年 Tolecen. All rights reserved.
//

#import "NewLoginViewController.h"
#import "NewRegistOneViewController.h"
#import "ReSetPassWordViewController.h"
#import "IdentifyingString.h"
#import "MBProgressHUD.h"

@interface NewLoginViewController ()
{
    MBProgressHUD* hud;
}
@property (nonatomic,strong) UITextField* PhoneNoTF;
@property (nonatomic,strong) UITextField* passWordTF;

@end

@implementation NewLoginViewController

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
    self.navigationController.navigationBarHidden =YES;
    self.view.backgroundColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1];
    float diffH = [Common diffHeight:self];
//    UIImageView * bgimgV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 44+diffH, 320, self.view.frame.size.height-44)];
//    [bgimgV setImage:[UIImage imageNamed:@"regBG.png"]];
//    [self.view addSubview:bgimgV];
    UIImageView *TopBarBGV=[[UIImageView alloc]initWithImage:[UIImage imageNamed:diffH==0?@"topBar1.png":@"topBar2.png"]];
    [TopBarBGV setFrame:CGRectMake(0, 0, 320, 44+diffH)];
    [self.view addSubview:TopBarBGV];
    
    UIButton *backButton=[UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame=CGRectMake(0, 0+diffH, 80, 44);
    [backButton setBackgroundImage:[UIImage imageNamed:@"backnew.png"] forState:UIControlStateNormal];
    [self.view addSubview:backButton];
    [backButton addTarget:self action:@selector(backButton:) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *  titleLabel=[[UILabel alloc] initWithFrame:CGRectMake(50, 2+diffH, 220, 40)];
    titleLabel.backgroundColor=[UIColor clearColor];
    [titleLabel setText:@"登录"];
    [titleLabel setFont:[UIFont boldSystemFontOfSize:18]];
    titleLabel.textAlignment=NSTextAlignmentCenter;
    titleLabel.textColor=[UIColor whiteColor];
    [self.view addSubview:titleLabel];
    
    UIImageView * nameBG = [[UIImageView alloc] initWithFrame:CGRectMake(10, 80+diffH, 300, 108)];
    [nameBG setImage:[UIImage imageNamed:@"newlogbg1"]];
    [self.view addSubview:nameBG];
//    
//    UIImageView * passWordIV = [[UIImageView alloc] initWithFrame:CGRectMake(31.25, 122+diffH, 257.5, 41)];
//    [passWordIV setImage:[UIImage imageNamed:@"shurukuang_bottom"]];
//    [self.view addSubview:passWordIV];
//    
//    UIImageView * a =  [[UIImageView alloc] initWithFrame:CGRectMake(31.75, 121+diffH, 256.5, 1)];
//    a.image = [UIImage imageNamed:@"shurukuang_jiangexian"];
//    [self.view addSubview:a];
    
//    UIImageView * nickNameIV = [[UIImageView alloc] initWithFrame:CGRectMake(31.25, 190+diffH, 257.5, 41)];
//    [nickNameIV setImage:[UIImage imageNamed:@"logininputbg.png"]];
//    [self.view addSubview:nickNameIV];
    
    UILabel* nameL = [[UILabel alloc]initWithFrame:CGRectMake(20, 17, 70, 20)];
    nameL.text = @"账号";
    nameL.font = [UIFont systemFontOfSize:16];
    nameL.backgroundColor = [UIColor clearColor];
    [nameBG addSubview:nameL];
    
    UILabel* passWordL = [[UILabel alloc]initWithFrame:CGRectMake(20, 71, 70, 20)];
    passWordL.text = @"密码";
    passWordL.font = [UIFont systemFontOfSize:16];
    passWordL.backgroundColor = [UIColor clearColor];
    [nameBG addSubview:passWordL];
    
//    UILabel* nickNameL = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, 70, 20)];
//    nickNameL.text = @"忘记密码";
//    nickNameL.font = [UIFont systemFontOfSize:13];
//    nickNameL.backgroundColor = [UIColor clearColor];
//    [nickNameIV addSubview:nickNameL];
    
    self.PhoneNoTF = [[UITextField alloc]initWithFrame:CGRectMake(100, 80+diffH+12, 186, 30)];
    _PhoneNoTF.placeholder = @"手机号";
    _PhoneNoTF.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    _PhoneNoTF.keyboardType = UIKeyboardTypeNumberPad;
    _PhoneNoTF.font = [UIFont systemFontOfSize:15];
//    _PhoneNoTF.backgroundColor = [UIColor redColor];
    [self.view addSubview:_PhoneNoTF];
    [self.PhoneNoTF addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    
    self.passWordTF = [[UITextField alloc]initWithFrame:CGRectMake(100, 80+diffH+12+54, 186, 30)];
    _passWordTF.placeholder = @"请输入登录密码";
    _passWordTF.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    _passWordTF.secureTextEntry = YES;
//    _passWordTF.backgroundColor = [UIColor redColor];
    _passWordTF.font = [UIFont systemFontOfSize:15];
    [self.view addSubview:_passWordTF];
    [self.passWordTF addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    
//    UIButton* passWordB = [UIButton buttonWithType:UIButtonTypeCustom];
//    passWordB.frame = CGRectMake(31.25, 190+diffH, 257.5, 41);
//    [self.view addSubview:passWordB];
//    [passWordB addTarget:self action:@selector(resetPassWord) forControlEvents:UIControlEventTouchUpInside];
//    
//    UIImageView* anjiao = [[UIImageView alloc]initWithFrame:CGRectMake(240, 15, 5, 10)];
//    anjiao.image = [UIImage imageNamed:@"anjiao"];
//    [passWordB addSubview:anjiao];
    
    UIButton* registB = [UIButton buttonWithType:UIButtonTypeCustom];
    [registB setTitle:@"登录" forState:UIControlStateNormal];
    registB.frame = CGRectMake(10, 240+diffH, 300, 40);
    [registB setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [registB setBackgroundImage:[UIImage imageNamed:@"newloginBtn"] forState:UIControlStateNormal];
//    [registB setBackgroundImage:[UIImage imageNamed:@"daanniu_click"] forState:UIControlStateHighlighted];
    [registB addTarget:self action:@selector(next) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:registB];
    
    UIButton * regBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [regBtn setFrame:CGRectMake(10, 300+diffH, 300, 40)];
//    [regBtn.titleLabel setFont:[UIFont systemFontOfSize:16]];
    [regBtn setTitle:@"注册宠物圈账号" forState:UIControlStateNormal];
    [regBtn setBackgroundImage:[UIImage imageNamed:@"newreegBtn"] forState:UIControlStateNormal];
    [regBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.view addSubview:regBtn];
    [regBtn addTarget:self action:@selector(doRegister:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton * forgetBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [forgetBtn setFrame:CGRectMake(235, 190+diffH, 80, 20)];
    [forgetBtn.titleLabel setFont:[UIFont systemFontOfSize:13]];
    [forgetBtn setTitle:@"忘记密码?" forState:UIControlStateNormal];
    [forgetBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    [self.view addSubview:forgetBtn];
    [forgetBtn addTarget:self action:@selector(resetPassWord:) forControlEvents:UIControlEventTouchUpInside];
    
    hud = [[MBProgressHUD alloc] initWithWindow:[UIApplication sharedApplication].keyWindow];
    [[UIApplication sharedApplication].keyWindow addSubview:hud];
    hud.labelText = @"登录中...";
    
    LocationManager * locM = [LocationManager sharedInstance];
    locM.locType = @"open";
    [locM startCheckLocationWithSuccess:^(double lat, double lon) {

    } Failure:^{
        
    }];

}
- (void) textFieldDidChange:(UITextField *) textField
{
    NSLog(@"%@",textField.text);
    if (textField.text.length>2&&[[Emoji allEmoji] containsObject:[textField.text substringFromIndex:textField.text.length-2]]) {
        textField.text = [textField.text substringToIndex:textField.text.length-2];
    }
}
-(void)doRegister:(UIButton *)sender
{
    sender.titleLabel.textColor = [UIColor blueColor];
    NewRegistOneViewController* newRegVC = [[NewRegistOneViewController alloc]init];
    [self.navigationController pushViewController:newRegVC animated:YES];
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
    if (![IdentifyingString validateMobile:_PhoneNoTF.text]) {
        UIAlertView* alert = [[UIAlertView alloc]initWithTitle:nil message:@"请输入正确的手机号" delegate:self cancelButtonTitle:@"知道啦" otherButtonTitles: nil];
        [alert show];
        return;
    }
    if (![IdentifyingString isValidatePassWord:_passWordTF.text]) {
        UIAlertView* alert = [[UIAlertView alloc]initWithTitle:nil message:@"请输入正确的密码" delegate:self cancelButtonTitle:@"知道啦" otherButtonTitles: nil];
        [alert show];
        return;
    }
    [_PhoneNoTF resignFirstResponder];
    [_passWordTF resignFirstResponder];
    NSMutableDictionary* params = [[NSMutableDictionary alloc]init];
    NSTimeInterval cT = [[NSDate date] timeIntervalSince1970];
    long long a = (long long)(cT*1000);
    [params setObject:_PhoneNoTF.text forKey:@"username"];
    [params setObject:_passWordTF.text forKey:@"password"];
    NSString * deviceToken = [[NSUserDefaults standardUserDefaults] objectForKey:PushDeviceToken];
    [params setObject:deviceToken?deviceToken:@"" forKey:@"deviceToken"];
    NSMutableDictionary* body = [[NSMutableDictionary alloc]init];
    [body setObject:@"1" forKey:@"channel"];
    [body setObject:[SFHFKeychainUtils getPasswordForUsername:MACADDRESS andServiceName:LOCALACCOUNT error:nil] forKey:@"mac"];
    [body setObject:@"iphone" forKey:@"imei"];
    [body setObject:params forKey:@"params"];
    [body setObject:@"login" forKey:@"method"];
    [body setObject:@"service.uri.pet_sso" forKey:@"service"];
    [body setObject:[NSString stringWithFormat:@"%lld",a] forKey:@"connectTime"];
    [hud show:YES];
    [NetManager requestWithURLStr:BaseClientUrl Parameters:body TheController:self success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [hud hide:YES];
//        NSString * dede = [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
//        NSRange range=[dede rangeOfString:@"authenticationToken"];
//        if (range.location!=NSNotFound) {
        NSDictionary* dic = responseObject;
        
            [SFHFKeychainUtils storeUsername:LOCALTOKEN andPassword:[[dic objectForKey:@"authenticationToken"] objectForKey:@"token"] forServiceName:LOCALACCOUNT updateExisting:YES error:nil];
            [SFHFKeychainUtils storeUsername:ACCOUNT andPassword:self.PhoneNoTF.text forServiceName:LOCALACCOUNT updateExisting:YES error:nil];
            [SFHFKeychainUtils storeUsername:PASSWORD andPassword:_passWordTF.text forServiceName:LOCALACCOUNT updateExisting:YES error:nil];
            [DataStoreManager setDefaultDataBase:[SFHFKeychainUtils getPasswordForUsername:ACCOUNT andServiceName:LOCALACCOUNT error:nil] AndDefaultModel:@"LocalStore"];
            [DataStoreManager storeMyUserID:[[dic objectForKey:@"authenticationToken"] objectForKey:@"userid"]];
            [self upLoadUserLocationWithLat:[[TempData sharedInstance] returnLat] Lon:[[TempData sharedInstance] returnLon]];
        NSLog(@"LOGIN DIC:%@,USER:%@,PHONRNUM:%@",dic,[SFHFKeychainUtils getPasswordForUsername:ACCOUNT andServiceName:LOCALACCOUNT error:nil],self.PhoneNoTF.text);
//            [self dismissModalViewControllerAnimated:YES];
        [self dismissViewControllerAnimated:NO completion:^{
            
        }];
//        }
//        else {
//            UIAlertView* alert = [[UIAlertView alloc]initWithTitle:nil message:@"用户名或密码错误" delegate:self cancelButtonTitle:@"知道啦" otherButtonTitles: nil];
//            [alert show];
//        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        UIAlertView* alert = [[UIAlertView alloc]initWithTitle:nil message:@"请确保用户名密码正确" delegate:self cancelButtonTitle:@"知道啦" otherButtonTitles: nil];
        [alert show];
        [hud hide:YES];
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
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}

-(void)resetPassWord:(UIButton *)sender
{
    sender.titleLabel.textColor = [UIColor blueColor];
    ReSetPassWordViewController* resetPasswordVC = [[ReSetPassWordViewController alloc]init];
    [self.navigationController pushViewController:resetPasswordVC animated:YES];
}
#pragma mark - touch
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [_PhoneNoTF resignFirstResponder];
    [_passWordTF resignFirstResponder];
}
-(void)allTextFieldResignFirstResponder
{
    [_PhoneNoTF resignFirstResponder];
    [_passWordTF resignFirstResponder];
}
@end
