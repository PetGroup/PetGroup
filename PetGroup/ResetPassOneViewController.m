//
//  ResetPassOneViewController.m
//  PetGroup
//
//  Created by 阿铛 on 13-9-7.
//  Copyright (c) 2013年 Tolecen. All rights reserved.
//

#import "ResetPassOneViewController.h"
#import "MBProgressHUD.h"
#import "IdentifyingString.h"
#import "ResetPassTwoViewController.h"


@interface ResetPassOneViewController ()

{
    UIButton * reGetB;
    NSTimer* timer;
    int i;
    MBProgressHUD *hud;
}
@property (nonatomic ,strong) UITextField * identifyingCodeTF;

@end

@implementation ResetPassOneViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        i = 60;
        // Custom initialization
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
    //   [backButton setTitle:@" 返回" forState:UIControlStateNormal];
    [backButton.titleLabel setFont:[UIFont boldSystemFontOfSize:15]];
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
    [titleLabel setText:@"输入验证码"];
    [titleLabel setFont:[UIFont boldSystemFontOfSize:18]];
    titleLabel.textAlignment=UITextAlignmentCenter;
    titleLabel.textColor=[UIColor whiteColor];
    [self.view addSubview:titleLabel];
    
    UIImageView * nameBG = [[UIImageView alloc] initWithFrame:CGRectMake(31.25, 140, 257.5, 41)];
    [nameBG setImage:[UIImage imageNamed:@"logininputbg.png"]];
    [self.view addSubview:nameBG];
    
    UILabel* tishi1L = [[UILabel alloc]initWithFrame:CGRectMake(31.25, 80, 75, 20)];
    tishi1L.text = @"我们已发送";
    tishi1L.font = [UIFont systemFontOfSize:15];
    tishi1L.backgroundColor = [UIColor clearColor];
    [self.view addSubview:tishi1L];
    
    UILabel* tishi2 = [[UILabel alloc]initWithFrame:CGRectMake(106.25, 80, 75, 20)];
    tishi2.text = @"短信验证码";
    tishi2.font = [UIFont systemFontOfSize:15];
    tishi2.textColor = [UIColor blueColor];
    tishi2.backgroundColor = [UIColor clearColor];
    [self.view addSubview:tishi2];
    
    UILabel* xieyiL = [[UILabel alloc]initWithFrame:CGRectMake(181.25, 80, 75, 20)];
    xieyiL.text = @"到这个号码";
    xieyiL.font = [UIFont systemFontOfSize:15];
    xieyiL.backgroundColor = [UIColor clearColor];
    [self.view addSubview:xieyiL];
    
    UILabel* phoneL = [[UILabel alloc]initWithFrame:CGRectMake(31.25, 100, 290, 20)];
    phoneL.text = [NSString stringWithFormat:@"+86 %@",self.phoneNo];
    phoneL.font = [UIFont systemFontOfSize:15];
    phoneL.backgroundColor = [UIColor clearColor];
    [self.view addSubview:phoneL];
    
    self.identifyingCodeTF = [[UITextField alloc]initWithFrame:CGRectMake(32.25, 150, 255.5, 20)];
    _identifyingCodeTF.placeholder = @"请输入验证码";
    _identifyingCodeTF.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:_identifyingCodeTF];
    
    reGetB = [UIButton buttonWithType:UIButtonTypeCustom];
    reGetB.frame = CGRectMake(60, 201, 200, 40);
    [reGetB setTitle:@"重新发送验证码（60s）" forState:UIControlStateNormal];
    [reGetB setBackgroundImage:[UIImage imageNamed:@"yanzhengma_normal"] forState:UIControlStateNormal];
    [reGetB setBackgroundImage:[UIImage imageNamed:@"yanzhengma_click"] forState:UIControlStateHighlighted];
    reGetB.userInteractionEnabled = NO;
    [reGetB addTarget:self action:@selector(reGetIdentifyingCode) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:reGetB];
    
    timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(countDown) userInfo:nil repeats:YES];
    
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
-(void)reGetIdentifyingCode
{
    NSMutableDictionary* params = [[NSMutableDictionary alloc]init];
    NSTimeInterval cT = [[NSDate date] timeIntervalSince1970];
    long long a = (long long)(cT*1000);
    [params setObject:self.phoneNo forKey:@"phoneNum"];
    NSMutableDictionary* body = [[NSMutableDictionary alloc]init];
    [body setObject:@"1" forKey:@"channel"];
    [body setObject:[SFHFKeychainUtils getPasswordForUsername:MACADDRESS andServiceName:LOCALACCOUNT error:nil] forKey:@"mac"];
    [body setObject:@"iphone" forKey:@"imei"];
    [body setObject:params forKey:@"params"];
    [body setObject:@"getVerificationCode" forKey:@"method"];
    [body setObject:[NSString stringWithFormat:@"%lld",a] forKey:@"connectTime"];
    [hud show:YES];
    [NetManager requestWithURLStr:BaseClientUrl Parameters:body TheController:self success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [hud hide:YES];
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:nil message:@"验证码已重新发送到您的手机" delegate:self cancelButtonTitle:@"知道啦" otherButtonTitles: nil];
        [alert show];
    }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [hud hide:YES];
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:nil message:@"网络请求异常，请确认网络连接正常" delegate:self cancelButtonTitle:@"知道啦" otherButtonTitles: nil];
        [alert show];
    }];
    [reGetB setTitle:@"重新发送验证码（60s）" forState:UIControlStateNormal];
    reGetB.userInteractionEnabled = NO;
    if (timer != nil) {
        [timer invalidate];
    }
    timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(countDown) userInfo:nil repeats:YES];
}
-(void)countDown
{
    i = i - 1;
    [reGetB setTitle:[NSString  stringWithFormat: @"重新发送验证码（%ds）",i]forState:UIControlStateNormal];
    if (i < 1) {
        [timer invalidate];
        reGetB.userInteractionEnabled = YES;
        i = 60;
        
    }
}
-(void)backButton:(UIButton*)button
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)next
{
    if ([IdentifyingString isValidateIdentionCode:_identifyingCodeTF.text]) {
        NSMutableDictionary* params = [[NSMutableDictionary alloc]init];
        NSTimeInterval cT = [[NSDate date] timeIntervalSince1970];
        long long a = (long long)(cT*1000);
        [params setObject:self.phoneNo forKey:@"phoneNum"];
        [params setObject:_identifyingCodeTF.text forKey:@"verificationCode"];
        NSMutableDictionary* body = [[NSMutableDictionary alloc]init];
        [body setObject:@"1" forKey:@"channel"];
        [body setObject:[SFHFKeychainUtils getPasswordForUsername:MACADDRESS andServiceName:LOCALACCOUNT error:nil] forKey:@"mac"];
        [body setObject:@"iphone" forKey:@"imei"];
        [body setObject:params forKey:@"params"];
        [body setObject:@"verifyCode" forKey:@"method"];
        [body setObject:[NSString stringWithFormat:@"%lld",a] forKey:@"connectTime"];
        [hud show:YES];
        [NetManager requestWithURLStr:BaseClientUrl Parameters:body TheController:self success:^(AFHTTPRequestOperation *operation, id responseObject) {
            [hud hide:YES];
            NSLog(@"%@",[[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding]);
            if ([[[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding]isEqualToString:@"true"]) {
                ResetPassTwoViewController* newReg = [[ResetPassTwoViewController alloc]init];
                newReg.phoneNo = self.phoneNo;
                [self.navigationController pushViewController:newReg animated:YES];
            }else{
                [self showAlertView];
            }
        }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [hud hide:YES];
            UIAlertView * alert = [[UIAlertView alloc]initWithTitle:nil message:@"网络请求异常，请确认网络连接正常" delegate:self cancelButtonTitle:@"知道啦" otherButtonTitles: nil];
            [alert show];
        }];
    }else{
        [self showAlertView];
    }
    
    
}
-(void)showAlertView
{
    UIAlertView * alert = [[UIAlertView alloc]initWithTitle:nil message:@"请输入正确得验证码" delegate:self cancelButtonTitle:@"知道啦" otherButtonTitles: nil];
    [alert show];
}
#pragma mark - touch
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [_identifyingCodeTF resignFirstResponder];
}

@end
