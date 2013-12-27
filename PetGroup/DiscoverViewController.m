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
#import "EGOImageButton.h"
#import "WebViewViewController.h"
@interface DiscoverViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,retain)UITableView* tableV;
@property (nonatomic,retain)NSArray*nameArray;
@property (nonatomic,retain)NSArray*iconNameArray;
@property (nonatomic,retain)NSArray* advertisementArray;
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
    diffH = [Common diffHeight:self];
    
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
    self.tableV = [[UITableView alloc]initWithFrame:CGRectMake(0, 44+diffH, 320, self.view.frame.size.height-44-diffH) style:UITableViewStylePlain];
    _tableV.delegate = self;
    _tableV.dataSource = self;
    _tableV.backgroundView = nil;
    [self.view addSubview:_tableV];
    
    [self loadAdvertisement];
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
    [self advertisement];
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
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row==4) {
        return self.view.frame.size.height-44-diffH-240-49;
    }
    return 60;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row!=4) {
        static NSString *cellIdentifier = @"cell1";
        MoreCell *cell = (MoreCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell == nil) {
            cell = [[MoreCell alloc] initWithStyle:UITableViewCellStyleSubtitle  reuseIdentifier:cellIdentifier];
            cell.selectionStyle = UITableViewCellSelectionStyleGray;
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        cell.headImageV.hidden = NO;
        cell.titleLabel.hidden = NO;
        cell.arrow.hidden = NO;
        cell.headImageV.image = [UIImage imageNamed:_iconNameArray[indexPath.row]];
        [cell.headImageV setFrame:CGRectMake(10, 7.5, 45, 45)];
        //    [cell.imageView setFrame:CGRectMake(cell.imageView.frame.origin.x, cell.imageView.frame.origin.y, 35, 35)];
        cell.titleLabel.text = _nameArray[indexPath.row];
        //    [cell.titleLabel setFont:[UIFont systemFontOfSize:17]];
        [cell.titleLabel setFrame:CGRectMake(70, 20, 100, 20)];
        [cell.arrow setFrame:CGRectMake(287, 18.5, 8.5, 12.5)];
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        return cell;
    }else{
        static NSString *cellIdentifier = @"advertisementCell";
        UITableViewCell* cell =(UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle  reuseIdentifier:cellIdentifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        return cell;
    }
}
#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
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
            return;
            break;
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.customTabBarController hidesTabBar:YES animated:YES];
}
#pragma mark - advertisement
//生成广告条,如果视图条目增加,增加TableView.from的修改逻辑
-(void)advertisement
{
    if (![self.view viewWithTag:2013]) {
        UIScrollView * sc = [[UIScrollView alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height-(diffH?49:0)-60, 320, 60)];
//        sc.backgroundColor = [UIColor blackColor];
//        sc.contentSize = CGSizeMake(320*_advertisementArray.count, 60);
//        for (int i = 0;i<_advertisementArray.count;i++) {
            UIButton * button = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 320, 60)];
//            button.tag = 100+i;
//            button.imageURL = [NSURL URLWithString:_advertisementArray[0]];
            [button setBackgroundImage:[UIImage imageNamed:@"ab"] forState:UIControlStateNormal];
            [button addTarget:self action:@selector(readAdvertisement:) forControlEvents:UIControlEventTouchUpInside];
            [sc addSubview:button];
//        }
        sc.tag = 2014;
        sc.pagingEnabled = YES;
        [self.view addSubview:sc];
        UIButton * deleteB  = [UIButton buttonWithType:UIButtonTypeCustom];
        deleteB.tag = 2013;
        deleteB.frame = CGRectMake(260, self.view.frame.size.height-(diffH?49:0)-60, 60, 60);
        [deleteB setBackgroundImage:[UIImage imageNamed:@"delete"] forState:UIControlStateNormal];
        [deleteB addTarget:self action:@selector(removeadvertisement) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:deleteB];
    }
}
-(void)removeadvertisement
{
    [[self.view viewWithTag:2013] removeFromSuperview];
    [[self.view viewWithTag:2014] removeFromSuperview];
}
-(void)readAdvertisement:(UIButton*)button
{
    WebViewViewController* web = [[WebViewViewController alloc]init];
    web.addressURL = [NSURL URLWithString:@"http://www.52pet.net"];
    [self presentViewController:web animated:YES completion:nil];
    
}
-(void)loadAdvertisement
{//未来实现广告接口的请求，在viewDidLoad中调用，请求返回后调用advertisement方法并修改里面的实现细节
    
}
@end
