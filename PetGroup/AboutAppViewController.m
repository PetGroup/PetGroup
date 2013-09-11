//
//  AboutAppViewController.m
//  NewXMPPTest
//
//  Created by Tolecen on 13-8-9.
//  Copyright (c) 2013年 Tolecen. All rights reserved.
//

#import "AboutAppViewController.h"

@interface AboutAppViewController ()

@end

@implementation AboutAppViewController

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
    [self.view setBackgroundColor:[UIColor whiteColor]];
    UIImageView * bgV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, self.view.frame.size.height)];
    [bgV setImage:[UIImage imageNamed:@"chat_bg.png"]];
    [self.view addSubview:bgV];
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
    titleLabel.text=@"关于宠物圈";
    [titleLabel setFont:[UIFont boldSystemFontOfSize:18]];
    titleLabel.textAlignment=UITextAlignmentCenter;
    titleLabel.textColor=[UIColor whiteColor];
    [self.view addSubview:titleLabel];
    
    UIImageView * iconImageView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"sss.png"]];
    iconImageView.frame=CGRectMake(120, 80, 80, 80);
    iconImageView.layer.cornerRadius=10;
    [self.view addSubview:iconImageView];
    
    UILabel *showVersion=[[UILabel alloc] init];
    [showVersion setBackgroundColor:[UIColor clearColor]];
    showVersion.frame= CGRectMake(20, 180, 280, 40);
    
   NSString * version = [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString *)kCFBundleVersionKey];

    NSString * addString = [NSString stringWithFormat:@"版本号:%@",version];

    
    version = addString;
    showVersion.text=version;
    showVersion.textAlignment=UITextAlignmentCenter;
    showVersion.textColor=[UIColor grayColor];
    //showButton.userInteractionEnabled=NO;
    [self.view addSubview:showVersion];

    UIButton * updateButton=[UIButton buttonWithType:UIButtonTypeRoundedRect];

    updateButton.frame=CGRectMake(20, 240+self.view.frame.size.height-480+30, 280, 40);
 
    [updateButton setTitle:@"检查新版本" forState:UIControlStateNormal];
    updateButton.titleLabel.textColor=[UIColor grayColor];
//    [updateButton setBackgroundImage:[UIImage imageNamed:@"常态.png"] forState:UIControlStateNormal];
//    [updateButton setBackgroundImage:[UIImage imageNamed:@"按下.png"] forState:UIControlStateHighlighted];
    [self.view addSubview:updateButton];
    [updateButton addTarget:self action:@selector(checkNewVersion) forControlEvents:UIControlEventTouchUpInside];
    
   UILabel * protocal=[[UILabel alloc]init];

    protocal.frame=CGRectMake(60, 370+self.view.frame.size.height-480, 200, 20);

    protocal.text=@"版权所有----宠物圈";
    protocal.textColor=[UIColor grayColor];
    protocal.textAlignment=UITextAlignmentCenter;
    protocal.backgroundColor=[UIColor clearColor];
    protocal.font=[UIFont systemFontOfSize:15];
    
    UILabel * protocal1=[[UILabel alloc]init];

    protocal1.frame=CGRectMake(10, 390+self.view.frame.size.height-480, 300, 20);

    
    protocal1.text=@"Aichongwu Technology Ltd.";
    protocal1.textColor=[UIColor grayColor];
    protocal1.textAlignment=UITextAlignmentCenter;
    protocal1.backgroundColor=[UIColor clearColor];
    protocal1.font=[UIFont systemFontOfSize:15];
    
    UILabel * protocal2=[[UILabel alloc]init];

    protocal2.frame=CGRectMake(10, 410+self.view.frame.size.height-480, 300, 20);

    protocal2.text=@"All Rights Reserved";
    protocal2.textColor=[UIColor grayColor];
    protocal2.textAlignment=UITextAlignmentCenter;
    protocal2.backgroundColor=[UIColor clearColor];
    protocal2.font=[UIFont systemFontOfSize:15];
    
    [self.view addSubview:protocal];
    [self.view addSubview:protocal1];
    [self.view addSubview:protocal2];

	// Do any additional setup after loading the view.
}
-(void)checkNewVersion
{
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"您现在已经是最新版本啦" delegate:self cancelButtonTitle:@"好的" otherButtonTitles: nil];
    [alert show];
}
-(void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
