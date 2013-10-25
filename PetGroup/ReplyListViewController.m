//
//  ReplyListViewController.m
//  PetGroup
//
//  Created by 阿铛 on 13-9-24.
//  Copyright (c) 2013年 Tolecen. All rights reserved.
//

#import "ReplyListViewController.h"
#import "ReplyComment.h"
#import "TempData.h"
#import "ReplyListCell.h"
#import "ParticularDynamicViewController.h"
#import "Common.h"
@interface ReplyListViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,retain) UITableView* tableV;
@property (nonatomic,retain) NSMutableDictionary* dynamicDic;
@property (nonatomic,retain) NSMutableArray* dicArray;
@end

@implementation ReplyListViewController

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
    [bgimgV setImage:[UIImage imageNamed:@"chat_bg"]];
    [self.view addSubview:bgimgV];
    UIImageView *TopBarBGV=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"topBG.png"]];
    [TopBarBGV setFrame:CGRectMake(0, 0, 320, 44)];
    [self.view addSubview:TopBarBGV];
    
    UIButton *backButton=[UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame=CGRectMake(0, 0, 80, 44);
    [backButton setBackgroundImage:[UIImage imageNamed:@"back2.png"] forState:UIControlStateNormal];
    [self.view addSubview:backButton];
    [backButton addTarget:self action:@selector(backButton:) forControlEvents:UIControlEventTouchUpInside];
    UILabel *  titleLabel=[[UILabel alloc] initWithFrame:CGRectMake(50, 2, 220, 40)];
    titleLabel.backgroundColor=[UIColor clearColor];
    [titleLabel setText:@"与我相关"];
    [titleLabel setFont:[UIFont boldSystemFontOfSize:18]];
    titleLabel.textAlignment=NSTextAlignmentCenter;
    titleLabel.textColor=[UIColor whiteColor];
    [self.view addSubview:titleLabel];
    
    NSUserDefaults * userDefault = [NSUserDefaults standardUserDefaults];
    self.dicArray = [NSMutableArray arrayWithArray:[userDefault objectForKey:NewComment]];
    self.dynamicDic = [NSMutableDictionary dictionaryWithDictionary:[userDefault objectForKey:MyDynamic]];
    
    self.tableV = [[UITableView alloc]initWithFrame:CGRectMake(0, 44, 320, self.view.frame.size.height-44)];
    _tableV.delegate = self;
    _tableV.dataSource = self;
    [self.view addSubview:_tableV];
    _tableV.rowHeight = 80;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)backButton:(UIButton*)button
{
    [[TempData sharedInstance] Panned:NO];
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)viewWillAppear:(BOOL)animated
{
    [_tableV reloadData];
}
#pragma mark - tableView delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSString * dynamicID = [self.dicArray[indexPath.row] objectForKey:@"dynamicID"];
    ParticularDynamicViewController* parVC = [[ParticularDynamicViewController alloc]init];
    parVC.dynamic = [[Dynamic alloc]initWithNSDictionary:[self.dynamicDic objectForKey:dynamicID]];
    [self.navigationController pushViewController:parVC animated:YES];
    [self.dynamicDic removeObjectForKey:dynamicID];
    
    NSMutableArray * a = [self.dicArray mutableCopy];
    for (NSDictionary*b in _dicArray) {
        if ([[b objectForKey:@"dynamicID"] isEqualToString:dynamicID]) {
            [a removeObject:b];
        }
    }
    self.dicArray = a;
    [_tableV reloadData];
     NSUserDefaults * userDefault = [NSUserDefaults standardUserDefaults];
    [userDefault setObject:_dicArray forKey:NewComment];
    [userDefault setObject:_dynamicDic forKey:MyDynamic];
    [userDefault synchronize];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dicArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"ReplyListCell";
    ReplyListCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier ];
    if (cell == nil) {
        cell = [[ReplyListCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    }
    cell.nameL.text = [_dicArray[indexPath.row] objectForKey:@"fromNickname"];
    NSString* headimage;
    NSArray *arr = [[_dicArray[indexPath.row] objectForKey:@"fromHeadImg"] componentsSeparatedByString:@"_"];
    if (arr.count>1) {
        headimage = arr[0];
    }
    cell.headImageV.imageURL = [NSURL URLWithString:[NSString stringWithFormat:BaseImageUrl"%@",headimage]];
    if ([[_dicArray[indexPath.row] objectForKey:@"theType"]isEqualToString:@"zanDynamic"]) {
        cell.msgL.text = @"赞了这条动态";
    }else{
        cell.msgL.text = [_dicArray[indexPath.row] objectForKey:@"replyContent"];
    }
    
    cell.timeL.text = [Common DynamicCurrentTime:[Common getCurrentTime] AndMessageTime:[NSString stringWithFormat:@"%f",[[_dicArray[indexPath.row] objectForKey:@"time"] doubleValue]/1000 ]];
    NSString * dynamicID = [self.dicArray[indexPath.row] objectForKey:@"dynamicID"];
    Dynamic* dynamic = [[Dynamic alloc]initWithNSDictionary:[self.dynamicDic objectForKey:dynamicID]];
    if (dynamic.smallImage.count>0) {
        cell.dynamicImageV.hidden = NO;
        cell.dynamicL.hidden = YES;
        cell.dynamicImageV.imageURL = [NSURL URLWithString:[NSString stringWithFormat:BaseImageUrl"%@",dynamic.smallImage[0]]];
    }else{
        cell.dynamicImageV.hidden = YES;
        cell.dynamicL.hidden = NO;
        cell.dynamicL.text = dynamic.msg;
    }
    return cell;
}
@end
