//
//  AddPetMessageViewController.m
//  PetGroup
//
//  Created by wangxr on 14-1-16.
//  Copyright (c) 2014年 Tolecen. All rights reserved.
//

#import "AddPetMessageViewController.h"
#import "AppDelegate.h"
#import "TempData.h"
#import "PetProfileCell.h"
#import "ReportViewController.h"
#import "KGStatusBar.h"
#import "XMPPHelper.h"
#import "MBProgressHUD.h"
@interface AddPetMessageViewController ()<UITableViewDataSource,UITableViewDelegate,ChangeText>
{
    float specialHigh;
    MBProgressHUD* hud;
}
@property (nonatomic,retain)UITableView * tableV;

@property (nonatomic,retain)NSString* RQCodeNo;
@end

@implementation AddPetMessageViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.edit = NO;
        specialHigh = 50;
    }
    return self;
}

- (void)viewDidLoad
{
    float a =[_RQCodeMessage[@"petOwnerMsg"] sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(200, 300) lineBreakMode:NSLineBreakByWordWrapping].height;
    if (a > 20) {
        specialHigh = a +30;
    }
    self.RQCodeNo = _RQCodeMessage[@"id"];
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
    titleLabel.text = @"编辑二维码信息";
    [titleLabel setFont:[UIFont boldSystemFontOfSize:17]];
    titleLabel.textAlignment=NSTextAlignmentCenter;
    titleLabel.textColor=[UIColor whiteColor];
    [self.view addSubview:titleLabel];
    self.tableV = [[UITableView alloc]initWithFrame:CGRectMake(0, 44 + diffH, 320, self.view.frame.size.height - 44 - diffH) style:UITableViewStyleGrouped];
    UIView * headV = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 55)];
    _tableV.tableHeaderView = headV;
    _tableV.delegate = self;
    _tableV.dataSource = self;
    [self.view addSubview:_tableV];
    
    UILabel* tishiL = [[UILabel alloc]initWithFrame:CGRectMake(10, 5, 300, 20)];
    tishiL.text = [NSString stringWithFormat:@"挂件编号:%@",_RQCodeNo];
    tishiL.font = [UIFont systemFontOfSize:16];
    tishiL.backgroundColor = [UIColor clearColor];
    [headV addSubview:tishiL];
    
    hud = [[MBProgressHUD alloc] initWithWindow:[UIApplication sharedApplication].keyWindow];
    [[UIApplication sharedApplication].keyWindow addSubview:hud];
    hud.labelText = @"提交中...";
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)finishEdit
{
    if (!_RQCodeMessage[@"petType"]) {
        
    }else if (!_RQCodeMessage[@"petNickname"]) {
        
    }else if (!_RQCodeMessage[@"petOwner"]) {
        
    }else if (!_RQCodeMessage[@"petOwnerTel"]) {
        
    }else if (!_RQCodeMessage[@"petOwnerMsg"]) {
        
    }else
    {
        [self setCardInfoByID:_RQCodeNo];
    }
}
-(void)back
{
    [[TempData sharedInstance] Panned:NO];
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)setCardInfoByID:(NSString *)theID
{
    [hud show:YES];
    NSMutableDictionary* params = [[NSMutableDictionary alloc]init];
    NSTimeInterval cT = [[NSDate date] timeIntervalSince1970];
    long long a = (long long)(cT*1000);
    [params setObject:theID forKey:@"id"];
    [params setObject:_RQCodeMessage[@"petType"] forKey:@"petType"];
    [params setObject:_RQCodeMessage[@"petNickname"] forKey:@"petNickname"];
    [params setObject:_RQCodeMessage[@"petOwner"] forKey:@"petOwner"];
    [params setObject:_RQCodeMessage[@"petOwnerTel"] forKey:@"petOwnerTel"];
    [params setObject:_RQCodeMessage[@"petOwnerMsg"] forKey:@"petOwnerMsg"];
    
    NSMutableDictionary* body = [[NSMutableDictionary alloc]init];
    [body setObject:@"1" forKey:@"channel"];
    [body setObject:[SFHFKeychainUtils getPasswordForUsername:MACADDRESS andServiceName:LOCALACCOUNT error:nil] forKey:@"mac"];
    [body setObject:@"iphone" forKey:@"imei"];
    [body setObject:params forKey:@"params"];
    [body setObject:@"setPetCard" forKey:@"method"];
    [body setObject:@"service.uri.pet_user" forKey:@"service"];
    [body setObject:[NSString stringWithFormat:@"%lld",a] forKey:@"connectTime"];
    [body setObject:[SFHFKeychainUtils getPasswordForUsername:LOCALTOKEN andServiceName:LOCALACCOUNT error:nil] forKey:@"token"];
    
    [NetManager requestWithURLStr:BaseClientUrl Parameters:body TheController:self  success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [hud hide:YES];
        if (self.delegate&&[_delegate respondsToSelector:@selector(finishAddRQCodeMessageWithPet:)]) {
            [_RQCodeMessage setObject:[SFHFKeychainUtils getPasswordForUsername:ACCOUNT andServiceName:LOCALACCOUNT error:nil] forKey:@"username"];
            [_RQCodeMessage setObject:_RQCodeNo forKey:@"id"];
            [_delegate finishAddRQCodeMessageWithPet:_RQCodeMessage];
        }
    }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:nil message:@"发送失败，请重发" delegate:nil cancelButtonTitle:@"知道啦" otherButtonTitles: nil];
        [alert show];
        [hud hide:YES];
    }];
}
#pragma mark - table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section == 0){
        return 2;
    }else if(section == 1){
        return 3;
    }else {
        return 1;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 2) {
        static NSString *yescellIdentifier = @"YESCell";
        UITableViewCell*cell = [tableView dequeueReusableCellWithIdentifier:yescellIdentifier ];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:yescellIdentifier];
            cell.contentView.backgroundColor = [UIColor orangeColor];
            UILabel* titleL = [[UILabel alloc]initWithFrame:cell.contentView.frame];
            [cell.contentView addSubview:titleL];
            titleL.text = @"保存修改";
            titleL.backgroundColor = [UIColor clearColor];
            titleL.textColor = [UIColor whiteColor];
            titleL.textAlignment = NSTextAlignmentCenter;
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    static NSString *cellIdentifier = @"Cell";
    PetProfileCell*cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier ];
    if (cell == nil) {
        cell = [[PetProfileCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    }
    if (indexPath.section == 0) {
        switch (indexPath.row) {
            case 0:{
                cell.titleLabel.text = @"宠物品种:";
                cell.describeLabel.text = _RQCodeMessage[@"petType"];
            }break;
            case 1:{
                cell.titleLabel.text = @"宠物昵称:";
                cell.describeLabel.text = _RQCodeMessage[@"petNickname"];
            }break;
            default:
                break;
        }
    }else if (indexPath.section == 1)
    {
        switch (indexPath.row) {
            case 0:{
                cell.titleLabel.text = @"主人名称:";
                cell.describeLabel.text = _RQCodeMessage[@"petOwner"];
            }break;
            case 1:{
                cell.titleLabel.text = @"主人电话:";
                cell.describeLabel.text = _RQCodeMessage[@"petOwnerTel"];
            }break;
            case 2:{
                cell.titleLabel.text = @"主人寄语:";
                cell.describeLabel.text = _RQCodeMessage[@"petOwnerMsg"];
                cell.describeLabel.frame = CGRectMake(cell.describeLabel.frame.origin.x, cell.describeLabel.frame.origin.y, cell.describeLabel.frame.size.width, [_RQCodeMessage[@"petOwnerMsg"] sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(200, 300) lineBreakMode:NSLineBreakByWordWrapping].height);
            }break;
            default:
                break;
        }
    }
    
    return cell;
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}
#pragma mark - table view delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1 && indexPath.row == 2) {
        return specialHigh;
    }
    return 50;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 2) {
        [self finishEdit];
        return;
    }
    ReportViewController * reportV = [[ReportViewController alloc] init];
    reportV.textDelegate = self;
    reportV.maxCount = 16;
    if (indexPath.section == 0) {
        switch (indexPath.row) {
            case 0:{
                reportV.theTitle = @"宠物品种";
                reportV.defaultContent = _RQCodeMessage[@"petType"];
                reportV.thisIndex = indexPath.row;
            }break;
            case 1:{
                reportV.theTitle = @"宠物昵称";
                reportV.defaultContent = _RQCodeMessage[@"petNickname"];
                reportV.thisIndex = indexPath.row;
            }break;
            default:
                break;
        }
        [self.navigationController pushViewController:reportV animated:YES];
    }else if (indexPath.section == 1){
        switch (indexPath.row) {
            case 0:{
                reportV.theTitle = @"主人名称";
                reportV.defaultContent = _RQCodeMessage[@"petOwner"];
                reportV.thisIndex = indexPath.row+10;
            }break;
            case 1:{
                reportV.theTitle = @"主人电话";
                reportV.defaultContent = _RQCodeMessage[@"petOwnerTel"];
                reportV.thisIndex = indexPath.row+10;
            }break;
            case 2:{
                reportV.theTitle = @"主人寄语";
                reportV.defaultContent = _RQCodeMessage[@"petOwnerMsg"];
                reportV.thisIndex = indexPath.row+10;
                reportV.maxCount = 50;
            }break;
            default:
                break;
        }
        [self.navigationController pushViewController:reportV animated:YES];
    }
}
#pragma mark - ChangeText
-(void)changeText:(NSString *)textinfo WithIndex:(int)theIndex
{
    switch (theIndex) {
        case 0:{
            [_RQCodeMessage setObject:textinfo forKey:@"petType"];
        }break;
        case 1:{
            [_RQCodeMessage setObject:textinfo forKey:@"petNickname"];
        }break;
        case 10:{
            [_RQCodeMessage setObject:textinfo forKey:@"petOwner"];
        }break;
        case 11:{
            [_RQCodeMessage setObject:textinfo forKey:@"petOwnerTel"];
        }break;
        case 12:{
            [_RQCodeMessage setObject:textinfo forKey:@"petOwnerMsg"];
            float a =[textinfo sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(200, 300) lineBreakMode:NSLineBreakByWordWrapping].height;
            if (a > 20) {
                specialHigh = a + 30;
            }
        }break;
            
        default:
            break;
    }
    [_tableV reloadData];
}
@end
