//
//  DedLoginViewController.m
//  NewXMPPTest
//
//  Created by 阿铛 on 13-8-20.
//  Copyright (c) 2013年 Tolecen. All rights reserved.
//

#import "DedLoginViewController.h"
#import "SelectorPetViewController.h"

@interface DedLoginViewController ()

@end

@implementation DedLoginViewController

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
    UILabel *  titleLabel=[[UILabel alloc] initWithFrame:CGRectMake(50, 2, 220, 40)];
    titleLabel.backgroundColor=[UIColor clearColor];
    [titleLabel setText:@"注册完成"];
    [titleLabel setFont:[UIFont boldSystemFontOfSize:18]];
    titleLabel.textAlignment=UITextAlignmentCenter;
    titleLabel.textColor=[UIColor whiteColor];
    [self.view addSubview:titleLabel];
    
    UIImageView* heheIV = [[UIImageView alloc]initWithFrame:CGRectMake(112.5, 70, 95, 45)];
    heheIV.image = [UIImage imageNamed:@"chenggong"];
    [self.view addSubview:heheIV];
    
    UILabel* tishiL1 = [[UILabel alloc]initWithFrame:CGRectMake(20, 150, 250, 30)];
    tishiL1.text = @"恭喜你，你已经注册成功！";
    tishiL1.font = [UIFont fontWithName:@"Helvetica-Bold" size:20];
    tishiL1.backgroundColor = [UIColor clearColor];
    [self.view addSubview:tishiL1];
    
    UILabel* tishiL2 = [[UILabel alloc]initWithFrame:CGRectMake(20, 190, 280, 60)];
    tishiL2.text = @"快去选择你的宠物，并且给你和你的宠物设置一个高端大气上档次得头像吧，可以更好地与宠友们交流。";
    tishiL2.backgroundColor = [UIColor clearColor];
    tishiL2.numberOfLines = 0;
    [self.view addSubview:tishiL2];
    
    UIButton * laterBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [laterBtn setBackgroundImage:[UIImage imageNamed:@"denglu_normal.png"] forState:UIControlStateNormal];
    [laterBtn setFrame:CGRectMake(32, 320, 110, 41)];
    [self.view addSubview:laterBtn];
    [laterBtn setTitle:@"以后再说" forState:UIControlStateNormal];
    [laterBtn setTitleColor:[UIColor brownColor] forState:UIControlStateNormal];
    laterBtn.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:20];
    [laterBtn addTarget:self action:@selector(laterBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    UIButton * goBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [goBtn setBackgroundImage:[UIImage imageNamed:@"zhuce_normal.png"] forState:UIControlStateNormal];
    [goBtn setFrame:CGRectMake(152, 320, 136, 41)];
    [self.view addSubview:goBtn];
    goBtn.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:20];
    [goBtn setTitle:@"现在去完善" forState:UIControlStateNormal];
    [goBtn setTitleColor:[UIColor brownColor] forState:UIControlStateNormal];
    [goBtn addTarget:self action:@selector(goBtnClicked) forControlEvents:UIControlEventTouchUpInside];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - button action
-(void)laterBtnClicked
{
    
}
-(void)goBtnClicked
{
    SelectorPetViewController* selPetVC = [[SelectorPetViewController alloc]init];
    [self.navigationController pushViewController:selPetVC animated:YES];
}
@end
