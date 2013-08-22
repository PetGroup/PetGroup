//
//  DynamicViewController.m
//  NewXMPPTest
//
//  Created by Tolecen on 13-7-3.
//  Copyright (c) 2013年 Tolecen. All rights reserved.
//

#import "DynamicViewController.h"
#import "CustomTabBar.h"
@interface DynamicViewController ()

@end

@implementation DynamicViewController

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
    self.hidesBottomBarWhenPushed = YES;
    UIImageView * bgV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, self.view.frame.size.height)];
    [bgV setImage:[UIImage imageNamed:@"chat_bg.png"]];
    [self.view addSubview:bgV];
    UIImageView *TopBarBGV=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"topBG.png"]];
    [TopBarBGV setFrame:CGRectMake(0, 0, 320, 44)];
    [self.view addSubview:TopBarBGV];
    
    titleLabel=[[UILabel alloc] initWithFrame:CGRectMake(50, 2, 220, 40)];
    titleLabel.backgroundColor=[UIColor clearColor];
    [titleLabel setText:@"动态"];
    [titleLabel setFont:[UIFont boldSystemFontOfSize:18]];
    titleLabel.textAlignment=UITextAlignmentCenter;
    titleLabel.textColor=[UIColor whiteColor];
    [self.view addSubview:titleLabel];

    UIButton *publishButton=[UIButton buttonWithType:UIButtonTypeCustom];
    publishButton.frame=CGRectMake(278, 6, 32, 26.6);
    [publishButton setBackgroundImage:[UIImage imageNamed:@"publish.png"] forState:UIControlStateNormal];
    //   [backButton setTitle:@" 返回" forState:UIControlStateNormal];
    [self.view addSubview:publishButton];
    [publishButton addTarget:self action:@selector(publishBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *titleLabel2=[[UILabel alloc] initWithFrame:CGRectMake(0, 20, 320, 60)];
    titleLabel2.backgroundColor=[UIColor clearColor];
    [titleLabel2 setText:@"Happy Every Day..."];
    [titleLabel2 setFont:[UIFont boldSystemFontOfSize:18]];
    titleLabel2.textAlignment=UITextAlignmentCenter;
    titleLabel2.textColor=[UIColor grayColor];
    [bgV addSubview:titleLabel2];
    
    self.headBigImageV = [[UIView alloc] initWithFrame:CGRectMake(0, 44, 320, 140)];
    [self.headBigImageV setBackgroundColor:[UIColor redColor]];
    //  [self.view addSubview:self.headBigImageV];
    //大图片imageview
    self.headBigImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 140)];
    [self.headBigImage setBackgroundColor:[UIColor clearColor]];
    [self.headBigImageV addSubview:self.headBigImage];
    self.hostNameLabel = [[UILabel alloc] init];
    self.hostNameLabel.backgroundColor = [UIColor clearColor];
    [self.hostNameLabel setNumberOfLines:0];
    [self.hostNameLabel setTextColor:[UIColor whiteColor]];
    [self.hostNameLabel setLineBreakMode:UILineBreakModeCharacterWrap];
    [self.hostNameLabel setFont:[UIFont systemFontOfSize:18]];
    [self.headBigImageV addSubview:self.hostNameLabel];
    
    self.genderImageV = [[UIImageView alloc] init];
    [self.headBigImageV addSubview:self.genderImageV];
    
    
    UIView * sigV = [[UIView alloc] initWithFrame:CGRectMake(0, self.headBigImageV.frame.size.height-30, 320, 30)];
    [sigV setBackgroundColor:[UIColor blackColor]];
    [sigV setAlpha:0.6];
    [self.headBigImageV addSubview:sigV];
    self.headSignatureL = [[UILabel alloc] initWithFrame:CGRectMake(10, self.headBigImageV.frame.size.height-25, 320, 20)];
    [self.headSignatureL setBackgroundColor:[UIColor clearColor]];
    [self.headSignatureL setTextColor:[UIColor whiteColor]];
    [self.headSignatureL setFont:[UIFont systemFontOfSize:14]];
    [self.headBigImageV addSubview:self.headSignatureL];
    [self.headSignatureL setText:@"Whole World,Only for You!"];
    
    self.loveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.loveBtn setFrame:CGRectMake(240, 82.5, 22.5, 22.5)];
    [self.loveBtn setImage:[UIImage imageNamed:@"loveit.png"] forState:UIControlStateNormal];
    [self.headBigImageV addSubview:self.loveBtn];
    
    self.loveLabel = [[UILabel alloc] initWithFrame:CGRectMake(267.5, 83, 40, 20)];
    [self.loveLabel setBackgroundColor:[UIColor clearColor]];
    [self.loveLabel setTextAlignment:NSTextAlignmentCenter];
    [self.loveLabel setTextColor:[UIColor whiteColor]];
    [self.loveLabel setFont:[UIFont systemFontOfSize:12]];
    [self.hostNameLabel setNumberOfLines:0];
    [self.hostNameLabel setLineBreakMode:UILineBreakModeCharacterWrap];
    [self.headBigImageV addSubview:self.loveLabel];
    
    [self setSometh];//设置头部的方法，必要时修改...
    
    self.infoTableV = [[UITableView alloc] initWithFrame:CGRectMake(0,44, 320, self.view.frame.size.height-44) style:UITableViewStylePlain];
    [self.view addSubview:self.infoTableV];
    self.infoTableV.tableHeaderView = self.headBigImageV;
    self.infoTableV.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"chat_bg.png"]];
    self.infoTableV.dataSource = self;
    self.infoTableV.delegate = self;
    
	// Do any additional setup after loading the view.
}
//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
//{
//    return self.headBigImageV;
//}
//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
//{
//    return self.headBigImageV.frame.size.height;
//}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 10;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"infoCell";
    
    UITableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    [cell.contentView setBackgroundColor:[UIColor whiteColor]];
    return cell;
}
-(void)setSometh
{
    NSString * hostName = @"Tolecen";
    int theGender = 1;
    CGSize textSize = {220.0 , 100.0};
    CGSize size = [hostName sizeWithFont:[UIFont systemFontOfSize:18] constrainedToSize:textSize lineBreakMode:UILineBreakModeCharacterWrap];
    [self.hostNameLabel setText:hostName];
    [self.hostNameLabel setFrame:CGRectMake(10, 10, size.width, size.height)];
    
    UIImage * genderImg = theGender==1?[UIImage imageNamed:@"manicon.png"]:[UIImage imageNamed:@"womenicon.png"];
    [self.genderImageV setImage:genderImg];
    [self.genderImageV setFrame:CGRectMake(10+size.width+3, 16, genderImg.size.width/2, genderImg.size.height/2)];
 
    NSString * loveCount = @"132";
    CGSize textSize2 = {220.0 , 20.0};
    CGSize size2 = [loveCount sizeWithFont:[UIFont systemFontOfSize:12] constrainedToSize:textSize2 lineBreakMode:UILineBreakModeCharacterWrap];
    [self.loveLabel setText:loveCount];
    [self.loveLabel setFrame:CGRectMake(320-10-size2.width, 83, size2.width, 20)];
    [self.loveBtn setFrame:CGRectMake(310-size2.width-22.5-5, 82.5, 22.5, 22.5)];
    
    [self.headBigImage setImage:[UIImage imageNamed:@"temp_02.png"]];
}
-(void)publishBtnClicked
{
    
}

-(void)viewWillAppear:(BOOL)animated
{
    //[self.leveyTabBarController removeNotificatonOfIndex:1];
//     [self.customTabBarController hidesTabBar:NO animated:YES];
//    [self.customTabBarController removeNotificatonOfIndex:1];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
