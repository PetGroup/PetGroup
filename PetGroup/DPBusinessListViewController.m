//
//  DPBusinessListViewController.m
//  PetGroup
//
//  Created by wangxr on 13-11-25.
//  Copyright (c) 2013年 Tolecen. All rights reserved.
//

#import "DPBusinessListViewController.h"
#import "MJRefresh.h"
#import "SRRefreshView.h"
#import "DPNetManager.h"
#import "TempData.h"
#import "Business.h"
#import "BusinessCell.h"
#import "MBProgressHUD.h"
@interface DPBusinessListViewController ()<UITableViewDataSource,UITableViewDelegate,DPNetManagerDelegate,SRRefreshDelegate,MJRefreshBaseViewDelegate>
{
    BOOL free;
    MBProgressHUD* hud;
}
@property (nonatomic,retain)UITableView* tableV;
@property (nonatomic,retain)DPNetManager* netManager;
@property (nonatomic,assign)int pageNo;
@property (nonatomic,retain)NSMutableArray* dataSourceArray;
@property (nonatomic,retain)MJRefreshFooterView* footer;
@property (nonatomic,retain)SRRefreshView* refreshView;
@end

@implementation DPBusinessListViewController
-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.dataSourceArray = [NSMutableArray array];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    float diffH = [Common diffHeight:self];
    
    UIImageView *TopBarBGV=[[UIImageView alloc]initWithImage:[UIImage imageNamed:diffH==0?@"topBar1.png":@"topBar2.png"]];
    [TopBarBGV setFrame:CGRectMake(0, 0, 320, 44+diffH)];
    [self.view addSubview:TopBarBGV];
    
    UIButton *backButton=[UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame=CGRectMake(0, 0+diffH, 80, 44);
    [backButton setBackgroundImage:diffH==0.0f?[UIImage imageNamed:@"back2.png"]:[UIImage imageNamed:@"backnew.png"] forState:UIControlStateNormal];
    [self.view addSubview:backButton];
    [backButton addTarget:self action:@selector(backButton) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *  titleLabel=[[UILabel alloc] initWithFrame:CGRectMake(50, 2+diffH, 220, 40)];
    titleLabel.backgroundColor=[UIColor clearColor];
    [titleLabel setText:@"周边商户"];
    [titleLabel setFont:[UIFont boldSystemFontOfSize:18]];
    titleLabel.textAlignment=NSTextAlignmentCenter;
    titleLabel.textColor=[UIColor whiteColor];
    [self.view addSubview:titleLabel];
    self.tableV = [[UITableView alloc]initWithFrame:CGRectMake(0, 44+diffH, 320, self.view.frame.size.height-44-diffH)];
    _tableV.delegate = self;
    _tableV.dataSource = self;
    _tableV.rowHeight = 100;
    [self.view addSubview:_tableV];
    
    self.refreshView = [[SRRefreshView alloc] init];
    _refreshView.delegate = self;
    _refreshView.upInset = 0;
    _refreshView.slimeMissWhenGoingBack = YES;
    _refreshView.slime.bodyColor = [UIColor colorWithRed:250/255.0 green:128/255.0 blue:010/255.0 alpha:1];
    _refreshView.slime.skinColor = [UIColor whiteColor];
    _refreshView.slime.lineWith = 1;
    _refreshView.slime.shadowBlur = 4;
    _refreshView.slime.shadowColor = [UIColor colorWithRed:0.7 green:0.7 blue:0.7 alpha:0.0];
    
    [self.tableV addSubview:_refreshView];
    
    self.footer = [[MJRefreshFooterView alloc]init];
    _footer.delegate = self;
    _footer.scrollView = self.tableV;
    
    hud = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:hud];
    hud.labelText = @"搜索中...";
    
    [self reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewDidAppear:(BOOL)animated
{
    free = YES;
}
-(void)viewWillDisappear:(BOOL)animated
{
    if (free) {
        [_footer free];
        [self.netManager cancel];
    }
}
#pragma mark - button action
-(void)backButton
{
    [[TempData sharedInstance] Panned:NO];
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - slimeRefresh delegate

- (void)slimeRefreshStartRefresh:(SRRefreshView *)refreshView
{
    if (refreshView == _refreshView) {
        [self reloadData];
    }
}
#pragma mark - scroll view delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if(scrollView == _tableV){
        [_refreshView scrollViewDidScroll];
    }
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (scrollView == _tableV) {
        [_refreshView scrollViewDidEndDraging];
    }
}
#pragma mark MJRefreshBaseView delegate
- (void)refreshViewBeginRefreshing:(MJRefreshBaseView *)refreshView
{
    if (refreshView == _footer) {
        [self loadMoreData];
    }
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataSourceArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"cell";
    BusinessCell*cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier ];
    if (cell == nil) {
        cell = [[BusinessCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    }
    cell.business = self.dataSourceArray[indexPath.row];
    return cell;
}
#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    free = NO;
    
}
#pragma mark - DPNetManager Delegate
-(void)DPNetManagerDidFinishLoading:(NSArray*)array
{
    if(_pageNo == 1)
    {
        [hud hide:YES];
        [_refreshView endRefresh];
        [self.dataSourceArray removeAllObjects];
    }else{
       [_footer endRefreshing]; 
    }
    if (array.count>0) {
        for (NSDictionary* dic in array) {
            Business* bus = [[Business alloc]initWithDictionary:dic];
            [self.dataSourceArray addObject:bus];
        }
        [self.tableV reloadData];
        self.pageNo++;
    }
    
}
-(void)DPNetManagerdidFailWithError:(NSError *)error
{
    if(_pageNo == 1)
    {
        [hud hide:YES];
        [_refreshView endRefresh];
    }else{
        [_footer endRefreshing];
    }
}
#pragma mark - loadData
-(void)reloadData
{
    self.pageNo = 1;
    [self loadMoreData];
}
-(void)loadMoreData
{
    if ([[TempData sharedInstance] returnLat]&&[[TempData sharedInstance] returnLon]) {
        NSMutableDictionary* dic = [NSMutableDictionary dictionary];
        [dic setObject:[NSString stringWithFormat:@"%d",_pageNo] forKey:@"page"];
        [dic setObject:[NSString stringWithFormat:@"%f",[[TempData sharedInstance] returnLat]] forKey:@"latitude"];
        [dic setObject:[NSString stringWithFormat:@"%f",[[TempData sharedInstance] returnLon]] forKey:@"longitude"];
        [dic setObject:@"宠物" forKey:@"category"];
        [dic setObject:[NSString stringWithFormat:@"%d",2] forKey:@"platform"];
        NSString* url = [DPNetManager serializeURL:@"http://api.dianping.com/v1/business/find_businesses_by_coordinate" params:dic];
        NSLog(@"%@",url);
        self.netManager = [[DPNetManager alloc]initWithURL:url delegate:self];
        [hud show:YES];
    }else{
        UIAlertView* alertView = [[UIAlertView alloc]initWithTitle:nil message:@"此功能需要使用您的地理位置，请允许《宠物圈》获得您的位置" delegate:self cancelButtonTitle:@"知道啦" otherButtonTitles: nil];
        [alertView show];
    }
}
@end
