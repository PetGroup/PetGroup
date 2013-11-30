//
//  PinterestViewController.m
//  Pinterest
//
//  Created by wangxr on 13-11-18.
//  Copyright (c) 2013年 wangxr. All rights reserved.
//

#import "PinterestViewController.h"
#import "TMQuiltView.h"
#import "BeautifulImageCell.h"
#import "TempData.h"
#import "MJRefresh.h"
#import "SRRefreshView.h"
#import "PhotoViewController.h"
#import "BeautifulImage.h"
@interface PinterestViewController ()<TMQuiltViewDataSource,TMQuiltViewDelegate,BeautifulImageCellDelegate,SRRefreshDelegate,MJRefreshBaseViewDelegate>
{
    BOOL free;
}
@property (nonatomic,assign) int pageNo;
@property (nonatomic,retain) NSMutableArray* imageArray;
@property (nonatomic,retain)TMQuiltView *tmQuiltView;
@property (nonatomic,retain)MJRefreshFooterView* footer;
@property (nonatomic,retain)SRRefreshView* refreshView;
@end

@implementation PinterestViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.imageArray = [NSMutableArray array];
    }
    return self;
}
-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    float diffH = [Common diffHeight:self];
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIImageView *TopBarBGV=[[UIImageView alloc]initWithImage:[UIImage imageNamed:diffH==0?@"topBar1.png":@"topBar2.png"]];
    [TopBarBGV setFrame:CGRectMake(0, 0, 320, 44+diffH)];
    [self.view addSubview:TopBarBGV];
    
    UIButton *backButton=[UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame=CGRectMake(0, 0+diffH, 80, 44);
    [backButton setBackgroundImage:diffH==0.0f?[UIImage imageNamed:@"back2.png"]:[UIImage imageNamed:@"backnew.png"] forState:UIControlStateNormal];
    [self.view addSubview:backButton];
    [backButton addTarget:self action:@selector(backButton) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *titleLabel=[[UILabel alloc] initWithFrame:CGRectMake(50, 2+diffH, 220, 40)];
    titleLabel.backgroundColor=[UIColor clearColor];
    titleLabel.text=@"美图";
    [titleLabel setFont:[UIFont boldSystemFontOfSize:18]];
    titleLabel.textAlignment=NSTextAlignmentCenter;
    titleLabel.textColor=[UIColor whiteColor];
    [self.view addSubview:titleLabel];
    _tmQuiltView = [[TMQuiltView alloc] init];
    _tmQuiltView.frame = CGRectMake(0, 44+diffH, 320, self.view.frame.size.height-44-diffH);
    _tmQuiltView.delegate = self;
    _tmQuiltView.dataSource = self;
    
    [self.view addSubview:_tmQuiltView];
    
    self.refreshView = [[SRRefreshView alloc] init];
    _refreshView.delegate = self;
    _refreshView.upInset = 0;
    _refreshView.slimeMissWhenGoingBack = YES;
    _refreshView.slime.bodyColor = [UIColor colorWithRed:250/255.0 green:128/255.0 blue:010/255.0 alpha:1];
    _refreshView.slime.skinColor = [UIColor whiteColor];
    _refreshView.slime.lineWith = 1;
    _refreshView.slime.shadowBlur = 4;
    _refreshView.slime.shadowColor = [UIColor colorWithRed:0.7 green:0.7 blue:0.7 alpha:0.0];
    
    [self.tmQuiltView addSubview:_refreshView];
    
    self.footer = [[MJRefreshFooterView alloc]init];
    _footer.delegate = self;
    _footer.scrollView = self.tmQuiltView;
    
    [self reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillAppear:(BOOL)animated
{
    free = YES;
}
-(void)viewDidDisappear:(BOOL)animated
{
    if (free) {
        [_footer free];
    }
}
-(void)backButton
{
    [[TempData sharedInstance] Panned:NO];
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark -
#pragma mark TMQuiltViewDataSource
-(NSInteger)quiltViewNumberOfCells:(TMQuiltView *)TMQuiltView
{
    return [self.imageArray count];
}

-(TMQuiltViewCell *)quiltView:(TMQuiltView *)quiltView cellAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *identifierStr = @"photoIdentifier";
    BeautifulImageCell *cell = (BeautifulImageCell *)[quiltView dequeueReusableCellWithReuseIdentifier:identifierStr];
    if (!cell)
    {
        cell = [[BeautifulImageCell alloc] initWithReuseIdentifier:identifierStr];
    }
    NSString* URLStrng =[NSString stringWithFormat:BaseImageUrl"%@/300",[_imageArray[indexPath.row] objectForKey:@"id"]];
    cell.imageView.imageURL = [NSURL URLWithString:URLStrng];
    cell.titleL.text = @"1234";
    cell.indexPath = indexPath;
    cell.delegate = self;
    return cell;
}
#pragma mark -
#pragma mark TMQuiltViewDelegate
//列数
- (NSInteger)quiltViewNumberOfColumns:(TMQuiltView *)quiltView
{
    return 2;
}
//单元高度
- (CGFloat)quiltView:(TMQuiltView *)quiltView heightForCellAtIndexPath:(NSIndexPath *)indexPath {
    
    float height = ([[_imageArray[indexPath.row] objectForKey:@"height"] floatValue] / [[_imageArray[indexPath.row] objectForKey:@"width"] floatValue])*152.5;
    return height;
}
- (void)quiltView:(TMQuiltView *)quiltView didSelectCellAtIndexPath:(NSIndexPath *)indexPath
{
    free = NO;
    PhotoViewController* vc = [[PhotoViewController alloc]initWithSmallImages:@[((BeautifulImageCell*)[quiltView cellAtIndexPath:indexPath]).imageView.image] images:@[[_imageArray[indexPath.row] objectForKey:@"id"]] indext:indexPath.row];
    [self presentViewController:vc animated:NO completion:nil];
}
-(void)beautifulImageCellPressZanButtonAtIndexPath:(NSIndexPath*)indexPath
{
    
}
#pragma mark - load
-(void)reloadData
{
    self.pageNo = 0;
    NSTimeInterval cT = [[NSDate date] timeIntervalSince1970];
    long long a = (long long)(cT*1000);
    NSMutableDictionary* params = [NSMutableDictionary dictionary];
    [params setObject:[NSString stringWithFormat:@"%d",_pageNo] forKey:@"pageNo"];
    [params setObject:@"20" forKey:@"pageSize"];
    NSMutableDictionary* body = [NSMutableDictionary dictionary];
    [body setObject:@"service.uri.pet_albums" forKey:@"service"];
    [body setObject:params forKey:@"params"];
    [body setObject:@"getPublicPhotos" forKey:@"method"];
    [body setObject:@"1" forKey:@"channel"];
    [body setObject:[SFHFKeychainUtils getPasswordForUsername:MACADDRESS andServiceName:LOCALACCOUNT error:nil] forKey:@"mac"];
    [body setObject:@"iphone" forKey:@"imei"];
    [body setObject:[NSString stringWithFormat:@"%lld",a] forKey:@"connectTime"];
    [body setObject:[SFHFKeychainUtils getPasswordForUsername:LOCALTOKEN andServiceName:LOCALACCOUNT error:nil] forKey:@"token"];
    [NetManager requestWithURLStr:BaseClientUrl Parameters:body TheController:self success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@",responseObject);
        NSArray*array = [responseObject objectForKey:@"data"];
        [self.imageArray removeAllObjects];
        if (array.count>0) {
            self.pageNo++;
            [self.imageArray addObjectsFromArray:array];
        }
        [self.tmQuiltView reloadData];
        [self.refreshView endRefresh];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self.refreshView endRefresh];
    }];
}
-(void)loadMoreData
{
    NSTimeInterval cT = [[NSDate date] timeIntervalSince1970];
    long long a = (long long)(cT*1000);
    NSMutableDictionary* params = [NSMutableDictionary dictionary];
    [params setObject:[NSString stringWithFormat:@"%d",_pageNo] forKey:@"pageNo"];
    [params setObject:@"20" forKey:@"pageSize"];
    NSMutableDictionary* body = [NSMutableDictionary dictionary];
    [body setObject:@"service.uri.pet_albums" forKey:@"service"];
    [body setObject:params forKey:@"params"];
    [body setObject:@"getPublicPhotos" forKey:@"method"];
    [body setObject:@"1" forKey:@"channel"];
    [body setObject:[SFHFKeychainUtils getPasswordForUsername:MACADDRESS andServiceName:LOCALACCOUNT error:nil] forKey:@"mac"];
    [body setObject:@"iphone" forKey:@"imei"];
    [body setObject:[NSString stringWithFormat:@"%lld",a] forKey:@"connectTime"];
    [body setObject:[SFHFKeychainUtils getPasswordForUsername:LOCALTOKEN andServiceName:LOCALACCOUNT error:nil] forKey:@"token"];
    [NetManager requestWithURLStr:BaseClientUrl Parameters:body TheController:self success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@",responseObject);
        NSArray*array = [responseObject objectForKey:@"data"];
        if (array.count>0) {
            self.pageNo++;
            [self.imageArray addObjectsFromArray:array];
        }
        [self.tmQuiltView reloadData];
        [self.footer endRefreshing];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self.footer endRefreshing];
    }];
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
    if(scrollView == _tmQuiltView){
        [_refreshView scrollViewDidScroll];
    }
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (scrollView == _tmQuiltView) {
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
@end
