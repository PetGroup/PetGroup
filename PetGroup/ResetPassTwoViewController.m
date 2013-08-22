//
//  ResetPassTwoViewController.m
//  NewXMPPTest
//
//  Created by 阿铛 on 13-8-21.
//  Copyright (c) 2013年 Tolecen. All rights reserved.
//

#import "ResetPassTwoViewController.h"

@interface ResetPassTwoViewController ()

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
    [nextB setTitle:@"完成" forState:UIControlStateNormal];
    [nextB setBackgroundImage:[UIImage imageNamed:@"youshangjiao_normal"] forState:UIControlStateNormal];
    [nextB setBackgroundImage:[UIImage imageNamed:@"youshangjiao_click"] forState:UIControlStateHighlighted];
    [nextB addTarget:self action:@selector(next) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:nextB];
    UILabel *  titleLabel=[[UILabel alloc] initWithFrame:CGRectMake(50, 2, 220, 40)];
    titleLabel.backgroundColor=[UIColor clearColor];
    [titleLabel setText:@"修改密码"];
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
    nameL.text = @"重置密码";
    nameL.font = [UIFont systemFontOfSize:13];
    nameL.backgroundColor = [UIColor clearColor];
    [nameBG addSubview:nameL];
    
    UILabel* passWordL = [[UILabel alloc]initWithFrame:CGRectMake(5, 10, 70, 20)];
    passWordL.text = @"重复密码";
    passWordL.font = [UIFont systemFontOfSize:13];
    passWordL.backgroundColor = [UIColor clearColor];
    [passWordIV addSubview:passWordL];
    
    self.PhoneNoTF = [[UITextField alloc]initWithFrame:CGRectMake(111.25, 91, 175, 20)];
    _PhoneNoTF.placeholder = @"不少于6位且不要过于简单";
    _PhoneNoTF.font = [UIFont systemFontOfSize:13];
    [self.view addSubview:_PhoneNoTF];
    
    self.passWordTF = [[UITextField alloc]initWithFrame:CGRectMake(111.25, 131, 175, 20)];
    _passWordTF.placeholder = @"在此输入密码";
    _passWordTF.font = [UIFont systemFontOfSize:13];
    [self.view addSubview:_passWordTF];
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
    [self.navigationController popToViewController:self.navigationController.viewControllers[1] animated:YES];
}
#pragma mark - touch
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [_PhoneNoTF resignFirstResponder];
    [_passWordTF resignFirstResponder];
}
@end
