//
//  DiscoverViewController.m
//  PetGroup
//
//  Created by wangxr on 13-11-26.
//  Copyright (c) 2013年 Tolecen. All rights reserved.
//

#import "DiscoverViewController.h"
#import "NearByViewController.h"
#import "DPBusinessListViewController.h"
#import "PinterestViewController.h"
#import "PetknowledgeViewController.h"
#import "TempData.h"
#import "CustomTabBar.h"
@interface DiscoverViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,retain)UITableView* tableV;
@property (nonatomic,retain)NSArray*nameArray;
@property (nonatomic,retain)NSArray*iconNameArray;
@end

@implementation DiscoverViewController
-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.nameArray = @[@"附近的人",@"宠物周边",@"宠物美图",@"宠物百科"];
        self.iconNameArray = @[@"fujin.png",@"zhoubian.png",@"meitu.png",@"baike.png"];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.hidesBottomBarWhenPushed = YES;
    [self.view setBackgroundColor:[UIColor colorWithRed:0.90 green:0.90 blue:0.90 alpha:1]];
	// Do any additional setup after loading the view.
    float diffH = [Common diffHeight:self];
    
    UIImageView *TopBarBGV=[[UIImageView alloc]initWithImage:[UIImage imageNamed:diffH==0?@"topBar1.png":@"topBar2.png"]];
    [TopBarBGV setFrame:CGRectMake(0, 0, 320, 44+diffH)];
    [self.view addSubview:TopBarBGV];
    
    UILabel *  titleLabel=[[UILabel alloc] initWithFrame:CGRectMake(50, 2+diffH, 220, 40)];
    titleLabel.backgroundColor=[UIColor clearColor];
    [titleLabel setText:@"发现"];
    [titleLabel setFont:[UIFont boldSystemFontOfSize:18]];
    titleLabel.textAlignment=NSTextAlignmentCenter;
    titleLabel.textColor=[UIColor whiteColor];
    [self.view addSubview:titleLabel];
    self.tableV = [[UITableView alloc]initWithFrame:CGRectMake(0, 44+diffH, 320, self.view.frame.size.height-44-diffH) style:UITableViewStyleGrouped];
    _tableV.delegate = self;
    _tableV.dataSource = self;
    _tableV.backgroundView = nil;
    [self.view addSubview:_tableV];
}
-(void)viewWillAppear:(BOOL)animated
{
    if ([[TempData sharedInstance] needChat]) {
        [self.customTabBarController setSelectedPage:2];
        return;
    }
    if ([[TempData sharedInstance] ifPanned]) {
        [self.customTabBarController hidesTabBar:NO animated:NO];
    }
    else
    {
        [self.customTabBarController hidesTabBar:NO animated:YES];
        [[TempData sharedInstance] Panned:YES];
    }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)backButton
{
    [[TempData sharedInstance] Panned:NO];
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"cell1";
    MoreCell *cell = (MoreCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[MoreCell alloc] initWithStyle:UITableViewCellStyleSubtitle  reuseIdentifier:cellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }

//    if (cell == nil) {@property (strong,nonatomic) UIImageView * notiBgV;
//        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
//        cell.selectionStyle = UITableViewCellSelectionStyleGray;
//        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    cell.headImageV.image = [UIImage imageNamed:_iconNameArray[indexPath.section]];
    [cell.headImageV setFrame:CGRectMake(10, 7.5, 35, 35)];
//    [cell.imageView setFrame:CGRectMake(cell.imageView.frame.origin.x, cell.imageView.frame.origin.y, 35, 35)];
    cell.titleLabel.text = _nameArray[indexPath.row+indexPath.section];
//    [cell.titleLabel setFont:[UIFont systemFontOfSize:17]];
    [cell.titleLabel setFrame:CGRectMake(60, 15, 100, 20)];
    [cell.arrow setFrame:CGRectMake(287, 18.5, 8.5, 12.5)];
    
    return cell;
}
#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row+indexPath.section) {
        case 0:{
            NearByViewController* nearByVC = [[NearByViewController alloc]init];
            [self.navigationController pushViewController:nearByVC animated:YES];
        }break;
        case 1:{
            DPBusinessListViewController* businessVC = [[DPBusinessListViewController alloc]init];
            [self.navigationController pushViewController:businessVC animated:YES];
        }break;
        case 2:{
            PinterestViewController* pinterestVC = [[PinterestViewController alloc]init];
            [self.navigationController pushViewController:pinterestVC animated:YES];
        }break;
        case 3:{
            PetknowledgeViewController* pinterestVC = [[PetknowledgeViewController alloc]init];
            [self.navigationController pushViewController:pinterestVC animated:YES];
        }break;
        default:
            break;
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.customTabBarController hidesTabBar:YES animated:YES];
}
@end
