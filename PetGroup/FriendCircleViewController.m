//
//  FriendCircleViewController.m
//  PetGroup
//
//  Created by 阿铛 on 13-10-14.
//  Copyright (c) 2013年 Tolecen. All rights reserved.
//

#import "FriendCircleViewController.h"
#import "TempData.h"
#import "EditDynamicViewController.h"
#import "EGOImageView.h"
#import "EGOImageButton.h"
#import "OnceDynamicViewController.h"

@interface FriendCircleViewController ()<UITableViewDelegate,DynamicCellDelegate>
@property (nonatomic,retain)UIView* headV;
@property (nonatomic,retain)UITableView* tableV;
@property (nonatomic,retain)FriendCircleDataSource* friendCircleDS;
@end

@implementation FriendCircleViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.friendCircleDS = [[FriendCircleDataSource alloc]init];
        _friendCircleDS.myController = self;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    UIImageView *TopBarBGV=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"topBG.png"]];
    [TopBarBGV setFrame:CGRectMake(0, 0, 320, 44)];
    [self.view addSubview:TopBarBGV];
    
    UIButton *backButton=[UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame=CGRectMake(0, 0, 80, 44);
    [backButton setBackgroundImage:[UIImage imageNamed:@"back2.png"] forState:UIControlStateNormal];
    [self.view addSubview:backButton];
    [backButton addTarget:self action:@selector(backButton) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *  titleLabel=[[UILabel alloc] initWithFrame:CGRectMake(50, 2, 220, 40)];
    titleLabel.backgroundColor=[UIColor clearColor];
    [titleLabel setText:@"朋友圈"];
    [titleLabel setFont:[UIFont boldSystemFontOfSize:18]];
    titleLabel.textAlignment=NSTextAlignmentCenter;
    titleLabel.textColor=[UIColor whiteColor];
    [self.view addSubview:titleLabel];
    
    UIButton *publishButton=[UIButton buttonWithType:UIButtonTypeCustom];
    publishButton.frame=CGRectMake(278, 3, 35, 33);
    [publishButton setBackgroundImage:[UIImage imageNamed:@"fabu"] forState:UIControlStateNormal];
    [publishButton addTarget:self action:@selector(updateSelfMassage) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:publishButton];
    
    self.tableV = [[UITableView alloc]initWithFrame:CGRectMake(0, 44, 320, self.view.frame.size.height-44)];
    _tableV.delegate = self;
    _tableV.dataSource = self.friendCircleDS;
    [self.view addSubview:_tableV];
    
    self.headV = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 240.5)];
    _headV.backgroundColor = [UIColor whiteColor];
    self.tableV.tableHeaderView = _headV;
    
    EGOImageView* imageV = [[EGOImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 220.5)];
    imageV.placeholderImage = [UIImage imageNamed:@"morenbeijing"];
    imageV.userInteractionEnabled = YES;
    imageV.imageURL = [NSURL URLWithString:@""];
    [_headV addSubview:imageV];
    
    NSDictionary* dic = [DataStoreManager queryMyInfo];
    
    UILabel* nameL = [[UILabel alloc]initWithFrame:CGRectMake(170, 190, 60, 20)];
    nameL.font = [UIFont systemFontOfSize:16];
    nameL.backgroundColor = [UIColor clearColor];
    nameL.textColor = [UIColor whiteColor];
    [imageV addSubview:nameL];
    
    UIImageView * photoIV = [[UIImageView alloc]initWithFrame:CGRectMake(230, 160, 80, 80)];
    photoIV.image = [UIImage imageNamed:@"touxiangbeijing"];
    [imageV addSubview:photoIV];
    photoIV.userInteractionEnabled = YES;
    
    EGOImageButton*headIV = [[EGOImageButton alloc]initWithPlaceholderImage:[UIImage imageNamed:@"moren_people.png"]];
    headIV.frame = CGRectMake(5, 5, 70, 70);
    [photoIV addSubview:headIV];
    [headIV addTarget:self action:@selector(headAct) forControlEvents:UIControlEventTouchUpInside];
    
    nameL.text = [dic objectForKey:@"nickname"];
    CGSize size = [nameL.text sizeWithFont:[UIFont systemFontOfSize:16.0] constrainedToSize:CGSizeMake(220, 20) lineBreakMode:NSLineBreakByWordWrapping];
    nameL.frame = CGRectMake(220-size.width, 190, size.width, 20);
    NSString * imageID = [DataStoreManager queryFirstHeadImageForUser:[SFHFKeychainUtils getPasswordForUsername:ACCOUNT andServiceName:LOCALACCOUNT error:nil]];
    headIV.imageURL = [NSURL URLWithString:[NSString stringWithFormat:BaseImageUrl"%@",imageID]];
    
    UILabel*signatureL  = [[UILabel alloc]initWithFrame:CGRectMake(0, 220.5, 320, 20)];
    signatureL.font = [UIFont systemFontOfSize:16];
    signatureL.backgroundColor = [UIColor clearColor];
    signatureL.textColor = [UIColor blackColor];
    signatureL.text = [dic objectForKey:@"signature"];
    [_headV addSubview:signatureL];
    
    [self reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - button action
-(void)headAct
{
    
}
-(void)backButton
{
    [[TempData sharedInstance] Panned:NO];
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)updateSelfMassage
{
    EditDynamicViewController* editVC = [[EditDynamicViewController alloc]init];
    [self.navigationController pushViewController:editVC animated:YES];
}
#pragma mark - tableView delegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [DynamicCell heightForRowWithDynamic:self.friendCircleDS.dataSourceArray[indexPath.row]];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    OnceDynamicViewController * odVC = [[OnceDynamicViewController alloc]init];
    odVC.dynamic = self.friendCircleDS.dataSourceArray[indexPath.row];
    [self.navigationController pushViewController:odVC animated:YES];
}
#pragma mark - dynamic cell delegate
-(void)dynamicCellPressNameButtonOrHeadButtonAtIndexPath:(NSIndexPath *)indexPath
{
    
}
-(void)dynamicCellPressZanButtonAtIndexPath:(NSIndexPath *)indexPath
{
    
}
-(void)dynamicCellPressReplyButtonAtIndexPath:(NSIndexPath *)indexPath
{
    
}
-(void)dynamicCellPressZhuangFaButtonAtIndexPath:(NSIndexPath *)indexPath
{
    
}
-(void)dynamicCellPressImageButtonWithSmallImageArray:(NSArray*)smallImageArray andImageIDArray:(NSArray*)idArray
{
    
}
#pragma mark - load data
-(void)reloadData
{
    [_friendCircleDS reloadDataSuccess:^{
        [self.tableV reloadData];
    } failure:^{
        
    }];
}
-(void)loadMoreData
{
    [_friendCircleDS loadMoreDataSuccess:^{
        [self.tableV reloadData];
    } failure:^{
        
    }];
}
@end
