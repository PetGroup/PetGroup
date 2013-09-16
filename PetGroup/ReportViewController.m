//
//  ReportViewController.m
//  NewXMPPTest
//
//  Created by Tolecen on 13-7-18.
//  Copyright (c) 2013年 Tolecen. All rights reserved.
//

#import "ReportViewController.h"

@interface ReportViewController ()

@end

@implementation ReportViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.realReport = NO;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    bigBG = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, self.view.frame.size.height)];
    bigBG.backgroundColor = [UIColor clearColor];
    [self.view addSubview:bigBG];
    UIImageView * bgV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, self.view.frame.size.height)];
    [bgV setImage:[UIImage imageNamed:@"chat_bg.png"]];
    [bigBG addSubview:bgV];
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
    titleLabel.text=self.theTitle;
    [titleLabel setFont:[UIFont boldSystemFontOfSize:18]];
    titleLabel.textAlignment=UITextAlignmentCenter;
    titleLabel.textColor=[UIColor whiteColor];
    [self.view addSubview:titleLabel];
    
    
    UIImageView * bg = [[UIImageView alloc] initWithFrame:CGRectMake(10, 54, 300, 160)];
    [bg setImage:[UIImage imageNamed:@"outkuang.png"]];
    [bigBG addSubview:bg];
    
    UIImageView * inputBg = [[UIImageView alloc] initWithFrame:CGRectMake(20, 64, 280, 110)];
    [inputBg setImage:[UIImage imageNamed:@"reportinput.png"]];
    [bigBG addSubview:inputBg];
    
    self.inputTextF = [[UITextView alloc] initWithFrame:CGRectMake(25, 69, 260, 90)];
    [self.inputTextF setBackgroundColor:[UIColor clearColor]];
    self.inputTextF.text = self.defaultContent;
    self.inputTextF.delegate = self;
    self.inputTextF.font = [UIFont systemFontOfSize:16];


    [bigBG addSubview:self.inputTextF];
    


    UIButton * bottomBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [bottomBtn setFrame:CGRectMake(10, 224, 300, 38)];
    [bottomBtn setBackgroundImage:[UIImage imageNamed:@"brownlong-normal.png"] forState:UIControlStateNormal];
    [bottomBtn setTitle:@"确定" forState:UIControlStateNormal];
    [bottomBtn.titleLabel setFont:[UIFont boldSystemFontOfSize:18]];
    [bottomBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [bigBG addSubview:bottomBtn];
    [bottomBtn addTarget:self action:@selector(submitBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    
    if (self.realReport) {
        self.emailField = [[UITextField alloc] initWithFrame:CGRectMake(10, 224, 300, 30)];
        self.emailField.borderStyle = UITextBorderStyleRoundedRect;
        self.emailField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        self.emailField.delegate = self;
        self.emailField.backgroundColor = [UIColor whiteColor];
        self.emailField.placeholder = @"留一下邮箱吧，以便给您反馈";
        [bigBG addSubview:self.emailField];
        [bottomBtn setFrame:CGRectMake(10, 264, 300, 38)];
    }
    
    remainingLabel=[[UILabel alloc]init];
    [remainingLabel setFrame:CGRectMake(180, 184, 120, 20)];
    remainingLabel.backgroundColor=[UIColor clearColor];
    [remainingLabel setTextAlignment:NSTextAlignmentRight];
    remainingLabel.textColor=[UIColor grayColor];
    [remainingLabel setFont:[UIFont systemFontOfSize:14]];
    [remainingLabel setText:[NSString stringWithFormat:@"还可以输入%d字",self.maxCount]];
    [bigBG addSubview:remainingLabel];
    
    hud = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:hud];
    hud.delegate = self;
    hud.labelText = @"提交中...";
	// Do any additional setup after loading the view.
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.inputTextF resignFirstResponder];
    return YES;
}
#pragma mark 显示字数的区域
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    [UIView animateWithDuration:0.3 animations:^{
        [bigBG setFrame:CGRectMake(0, 0, 320, self.view.frame.size.height)];
    } completion:^(BOOL finished) {
        
    }];
//    NSInteger contentLen = self.inputTextF.text.length;
//    self.adviceTextView=textView;
//    self.adviceTextView.text=[NSString stringWithFormat:@"%@",self.adviceTextView.text];
//    lastCount.text=[NSString stringWithFormat:@"%d",140-contentLen];
//	
    return  YES;
}
#pragma mark 检测输入框字数，避免显示为负数
- (void)textViewDidChange:(UITextView *)textView
{
    NSUInteger contentLen = self.inputTextF.text.length;
    if (contentLen<=self.maxCount)
    {
        remainingLabel.text=[NSString stringWithFormat:@"还可以输入%d字",self.maxCount-contentLen];
    }
    else
    {
        remainingLabel.text=[NSString stringWithFormat:@"还可以输入0字"];
        self.inputTextF.text=[self.inputTextF.text substringToIndex:self.maxCount];
        //  self.adviceTextView.text=[[NSString stringWithFormat:@"%@",self.adviceTextView.text]substringToIndex:140];
    }

}
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    [UIView animateWithDuration:0.3 animations:^{
        [bigBG setFrame:CGRectMake(0, -60, 320, self.view.frame.size.height)];
    } completion:^(BOOL finished) {
        
    }];
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.inputTextF resignFirstResponder];
    if (self.realReport) {
        [self.emailField resignFirstResponder];
        [UIView animateWithDuration:0.3 animations:^{
            [bigBG setFrame:CGRectMake(0, 0, 320, self.view.frame.size.height)];
        } completion:^(BOOL finished) {
            
        }];
    }
}

-(void)submitBtnClicked
{
    if (self.inputTextF.text.length<2) {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请输入至少2个字" delegate:self cancelButtonTitle:@"知道了" otherButtonTitles: nil];
        [alert show];
        return;
    }
    if (self.realReport) {
        [self submitReport];
    }
    else{

        [self.textDelegate changeText:self.inputTextF.text WithIndex:self.thisIndex];
        [self.navigationController popViewControllerAnimated:YES];
    }
}
-(void)submitReport
{
    [hud show:YES];
    NSMutableDictionary* params = [[NSMutableDictionary alloc]init];
    NSTimeInterval cT = [[NSDate date] timeIntervalSince1970];
    long long a = (long long)(cT*1000);
    [params setObject:self.inputTextF.text forKey:@"feedback"];
    [params setObject:self.emailField.text?self.emailField.text:@"" forKey:@"email"];
    NSMutableDictionary* body = [[NSMutableDictionary alloc]init];
    [body setObject:@"1" forKey:@"channel"];
    [body setObject:[SFHFKeychainUtils getPasswordForUsername:MACADDRESS andServiceName:LOCALACCOUNT error:nil] forKey:@"mac"];
    [body setObject:@"iphone" forKey:@"imei"];
    [body setObject:params forKey:@"params"];
    [body setObject:@"feedback" forKey:@"method"];
    [body setObject:[NSString stringWithFormat:@"%lld",a] forKey:@"connectTime"];
    [body setObject:[SFHFKeychainUtils getPasswordForUsername:LOCALTOKEN andServiceName:LOCALACCOUNT error:nil] forKey:@"token"];
    
    [NetManager requestWithURLStr:BaseClientUrl Parameters:body success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [hud hide:YES];
        [self.navigationController popViewControllerAnimated:YES];
        
    }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:nil message:@"网络请求异常，请确认网络连接正常" delegate:self cancelButtonTitle:@"知道啦" otherButtonTitles: nil];
        [alert show];
        [hud hide:YES];
    }];

}
-(void)back
{
    [hud hide:YES];
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
