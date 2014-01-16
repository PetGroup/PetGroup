//
//  AddQPCodeNumberViewController.m
//  PetGroup
//
//  Created by wangxr on 14-1-16.
//  Copyright (c) 2014年 Tolecen. All rights reserved.
//

#import "AddQPCodeNumberViewController.h"
#import "TempData.h"
@interface AddQPCodeNumberViewController ()
@property (nonatomic,retain)UITextField *RQCodeNoTF;
@end

@implementation AddQPCodeNumberViewController

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
    [self.view setBackgroundColor:[UIColor colorWithRed:0.90 green:0.90 blue:0.90 alpha:1]];
    
    float diffH = [Common diffHeight:self];
    UIImageView *TopBarBGV=[[UIImageView alloc]initWithImage:[UIImage imageNamed:diffH==0?@"topBar1.png":@"topBar2.png"]];
    [TopBarBGV setFrame:CGRectMake(0, 0, 320, 44+diffH)];
    [self.view addSubview:TopBarBGV];
    
    UIButton *backButton=[UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame=CGRectMake(0, 0+diffH, 80, 44);
    [backButton setBackgroundImage:[UIImage imageNamed:@"backnew.png"] forState:UIControlStateNormal];
    [self.view addSubview:backButton];
    [backButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *titleLabel=[[UILabel alloc] initWithFrame:CGRectMake(90, 2+diffH, 140, 40)];
    titleLabel.backgroundColor=[UIColor clearColor];
    titleLabel.text = @"二维码信息";
    [titleLabel setFont:[UIFont boldSystemFontOfSize:17]];
    titleLabel.textAlignment=NSTextAlignmentCenter;
    titleLabel.textColor=[UIColor whiteColor];
    [self.view addSubview:titleLabel];
    
    UIImageView * nameBG = [[UIImageView alloc] initWithFrame:CGRectMake(10, 100+diffH, 300, 54)];
    [nameBG setImage:[UIImage imageNamed:@"newtypein"]];
    [self.view addSubview:nameBG];
    
    UILabel * tishiL = [[UILabel alloc]initWithFrame:CGRectMake(10, 64+diffH, 320, 20)];
    tishiL.backgroundColor = [UIColor clearColor];
    tishiL.text = @"填写与硬件匹配的编码:";
    [self.view addSubview:tishiL];
    
    self.RQCodeNoTF = [[UITextField alloc]initWithFrame:CGRectMake(30, 100+diffH+12, 260, 30)];
    _RQCodeNoTF.placeholder = @"请输入编码";
    [_RQCodeNoTF setFont:[UIFont systemFontOfSize:20]];
    _RQCodeNoTF.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    [self.view addSubview:_RQCodeNoTF];
    
    UIButton * nextB = [UIButton buttonWithType:UIButtonTypeCustom];
    [nextB setTitle:@"确认" forState:UIControlStateNormal];
    [nextB addTarget:self action:@selector(next) forControlEvents:UIControlEventTouchUpInside];
    nextB.frame = CGRectMake(125, 180 + diffH, 70, 30);
    [self.view addSubview:nextB];
    
    
}
- (void)next
{
    if (_RQCodeNoTF.text.length > 0) {
        AddPetMessageViewController*addpetVC = [[AddPetMessageViewController alloc]init];
        addpetVC.delegate = self.delegate;
        addpetVC.RQCodeNo = _RQCodeNoTF.text;
        [self.navigationController pushViewController:addpetVC animated:YES];
    }
}
-(void)back
{
    [[TempData sharedInstance] Panned:NO];
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
