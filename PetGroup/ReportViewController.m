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
-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
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
    
    
    float diffH = [Common diffHeight:self];
    
    UIImageView *TopBarBGV=[[UIImageView alloc]initWithImage:[UIImage imageNamed:diffH==0?@"topBar1.png":@"topBar2.png"]];
    [TopBarBGV setFrame:CGRectMake(0, 0, 320, 44+diffH)];
    [self.view addSubview:TopBarBGV];
    
    UIButton *backButton=[UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame=CGRectMake(0, 0+diffH, 80, 44);
    [backButton setBackgroundImage:[UIImage imageNamed:@"backnew.png"] forState:UIControlStateNormal];
    //   [backButton setTitle:@" 返回" forState:UIControlStateNormal];
    [backButton.titleLabel setFont:[UIFont boldSystemFontOfSize:15]];
    [self.view addSubview:backButton];
    [backButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    
    
    UILabel * titleLabel=[[UILabel alloc] initWithFrame:CGRectMake(100, 2+diffH, 120, 40)];
    titleLabel.backgroundColor=[UIColor clearColor];
    titleLabel.text=self.theTitle;
    [titleLabel setFont:[UIFont boldSystemFontOfSize:18]];
    titleLabel.textAlignment=NSTextAlignmentCenter;
    titleLabel.textColor=[UIColor whiteColor];
    [self.view addSubview:titleLabel];
    
    
    UIImageView * bg = [[UIImageView alloc] initWithFrame:CGRectMake(10, 54+diffH, 300, 160)];
    [bg setImage:[UIImage imageNamed:@"outkuang.png"]];
    [bigBG addSubview:bg];
    
    UIImageView * inputBg = [[UIImageView alloc] initWithFrame:CGRectMake(20, 64+diffH, 280, 110)];
    [inputBg setImage:[UIImage imageNamed:@"reportinput.png"]];
    [bigBG addSubview:inputBg];
    
    self.inputTextF = [[UITextView alloc] initWithFrame:CGRectMake(25, 69+diffH, 260, 90)];
    [self.inputTextF setBackgroundColor:[UIColor clearColor]];
    self.inputTextF.text = self.defaultContent.length>self.maxCount?[self.defaultContent substringToIndex:self.maxCount]:self.defaultContent;
    self.inputTextF.delegate = self;
    self.inputTextF.font = [UIFont systemFontOfSize:16];


    [bigBG addSubview:self.inputTextF];
    


    UIButton * bottomBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [bottomBtn setFrame:CGRectMake(10, 224+diffH, 300, 38)];
    diffH==0.0f?[bottomBtn setBackgroundImage:[UIImage imageNamed:@"brownlong-normal.png"] forState:UIControlStateNormal]:[bottomBtn setBackgroundColor:[UIColor orangeColor]];
    [bottomBtn setTitle:@"确定" forState:UIControlStateNormal];
    [bottomBtn.titleLabel setFont:[UIFont boldSystemFontOfSize:18]];
    [bottomBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [bigBG addSubview:bottomBtn];
    [bottomBtn addTarget:self action:@selector(submitBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    
    if (self.realReport) {
        self.emailField = [[UITextField alloc] initWithFrame:CGRectMake(10, 224+diffH, 300, 30)];
        self.emailField.borderStyle = UITextBorderStyleRoundedRect;
        self.emailField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        self.emailField.delegate = self;
        self.emailField.backgroundColor = [UIColor whiteColor];
        self.emailField.placeholder = @"留一下邮箱吧，以便给您反馈";
        [bigBG addSubview:self.emailField];
        [bottomBtn setFrame:CGRectMake(10, 264+diffH, 300, 38)];
    }
    
    remainingLabel=[[UILabel alloc]init];
    [remainingLabel setFrame:CGRectMake(180, 184+diffH, 120, 20)];
    remainingLabel.backgroundColor=[UIColor clearColor];
    [remainingLabel setTextAlignment:NSTextAlignmentRight];
    remainingLabel.textColor=[UIColor grayColor];
    [remainingLabel setFont:[UIFont systemFontOfSize:14]];
    [remainingLabel setText:[NSString stringWithFormat:@"还可以输入%d字",self.maxCount-self.inputTextF.text.length]];
    [bigBG addSubview:remainingLabel];
    
    hud = [[MBProgressHUD alloc] initWithWindow:[UIApplication sharedApplication].keyWindow];
    [[UIApplication sharedApplication].keyWindow addSubview:hud];
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
//- (void)textViewDidChange:(UITextView *)textView
//{
//
//    NSString * hhh = self.inputTextF.text;
//    NSUInteger contentLen = self.inputTextF.text.length;
//    if (contentLen<self.maxCount)
//    {
//        remainingLabel.text=[NSString stringWithFormat:@"还可以输入%d字",self.maxCount-contentLen];
//        if (hhh.length>2&&[[Emoji allEmoji] containsObject:[hhh substringFromIndex:hhh.length-2]]) {
//            self.inputTextF.text = [hhh substringToIndex:hhh.length-2];
//        }
//    }
//    else
//    {
//        remainingLabel.text=[NSString stringWithFormat:@"还可以输入0字"];
//        self.inputTextF.text=[hhh substringToIndex:self.maxCount-1];
//        //  self.adviceTextView.text=[[NSString stringWithFormat:@"%@",self.adviceTextView.text]substringToIndex:140];
//    }
//
//
//}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    NSString * hhh = self.inputTextF.text;
    NSUInteger contentLen = self.inputTextF.text.length;
    if (contentLen<self.maxCount)
    {
        remainingLabel.text=[NSString stringWithFormat:@"还可以输入%d字",self.maxCount-contentLen];
        if (hhh.length>2&&[[Emoji allEmoji] containsObject:[hhh substringFromIndex:hhh.length-2]]) {
            self.inputTextF.text = [hhh substringToIndex:hhh.length-2];
        }
    }
    else
    {
        remainingLabel.text=[NSString stringWithFormat:@"还可以输入0字"];
        self.inputTextF.text=[hhh substringToIndex:self.maxCount];
        //  self.adviceTextView.text=[[NSString stringWithFormat:@"%@",self.adviceTextView.text]substringToIndex:140];
    }
    return YES;
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
    if (self.inputTextF.text.length<2||[IdentifyingString isValidateAllSpace:self.inputTextF.text]) {
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
    [params setObject:self.emailField.text.length>0?self.emailField.text:@"" forKey:@"Email"];
    NSMutableDictionary* body = [[NSMutableDictionary alloc]init];
    [body setObject:@"1" forKey:@"channel"];
    [body setObject:@"service.uri.pet_feedback" forKey:@"service"];
    [body setObject:[SFHFKeychainUtils getPasswordForUsername:MACADDRESS andServiceName:LOCALACCOUNT error:nil] forKey:@"mac"];
    [body setObject:@"iphone" forKey:@"imei"];
    [body setObject:params forKey:@"params"];
    [body setObject:@"feedback" forKey:@"method"];
    [body setObject:[NSString stringWithFormat:@"%lld",a] forKey:@"connectTime"];
    [body setObject:[SFHFKeychainUtils getPasswordForUsername:LOCALTOKEN andServiceName:LOCALACCOUNT error:nil] forKey:@"token"];
    
    [NetManager requestWithURLStr:BaseClientUrl Parameters:body TheController:self success:^(AFHTTPRequestOperation *operation, id responseObject) {
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
