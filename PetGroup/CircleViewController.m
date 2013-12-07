//
//  CircleViewController.m
//  PetGroup
//
//  Created by 阿铛 on 13-10-11.
//  Copyright (c) 2013年 Tolecen. All rights reserved.
//

#import "CircleViewController.h"
#import "SRRefreshView.h"
#import "AttentionDataSource.h"
#import "GoodArticleDataSource.h"
#import "NewReplyArticleDataSource.h"
#import "NewPublishArticleDataSource.h"
#import "SearchViewController.h"
#import "TempData.h"
#import "CustomTabBar.h"
#import "FriendCircleViewController.h"
#import "hotPintsDataSource.h"
#import "OnceCircleViewController.h"
#import "CircleClassify.h"
#import "ArticleViewController.h"
#import "EditArticleViewController.h"
#import "Article.h"
#import "AppDelegate.h"
#import "XMPPHelper.h"
#import "CircleFooterView.h"
#import "CircleHeaderView.h"
#import "MJRefresh.h"
#import "CircleCell.h"
#define sectionFooterHeight 30

@interface CircleViewController ()<UITableViewDelegate,SRRefreshDelegate,OnceCircleViewControllerDelegate,CircleFooterViewDelegate,MJRefreshBaseViewDelegate,UISearchBarDelegate,CircleCellDelegate>
{
    UIButton* attentionB;
    UIButton* hotPintsB;
    UIButton* goodB;
    
    UILabel * numberLabel;
    float diffH;
}
@property (nonatomic,retain)NSString* myUserID;
@property (nonatomic,retain)UIView* pageV;
@property (nonatomic,retain)UIScrollView* backGroundV;

@property (nonatomic,retain)UITableView* goodV;
@property (nonatomic,retain)UITableView* hotPintsV;
@property (nonatomic,retain)UITableView* attentionV;

@property (nonatomic,retain)SRRefreshView* goodrefreshView;
@property (nonatomic,retain)SRRefreshView* slimeView;
@property (nonatomic,retain)SRRefreshView* refreshView;

@property (nonatomic,retain)MJRefreshFooterView* goodFooter;
@property (nonatomic,retain)MJRefreshFooterView* hotPintsFooter;

@property (nonatomic,retain)UISearchBar* goodSearchBar;
@property (nonatomic,retain)UISearchBar* hotPintsSearchBar;

@property (nonatomic,retain)AttentionDataSource* attentionDS;
@property (nonatomic,retain)GoodArticleDataSource* goodArticleDS;
@property (nonatomic,retain)NewReplyArticleDataSource* publishArticleDS;

@property (strong,nonatomic) AppDelegate * appDel;
@end

@implementation CircleViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
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
    self.hidesBottomBarWhenPushed = YES;
    
    diffH = [Common diffHeight:self];
    
    UIImageView *TopBarBGV=[[UIImageView alloc]initWithImage:[UIImage imageNamed:diffH==0?@"topBar1.png":@"topBar2.png"]];
    [TopBarBGV setFrame:CGRectMake(0, 0, 320, 44+diffH)];
    [self.view addSubview:TopBarBGV];
    
    UILabel *  titleLabel=[[UILabel alloc] initWithFrame:CGRectMake(50, 2+diffH, 220, 40)];
    titleLabel.backgroundColor=[UIColor clearColor];
    [titleLabel setText:@"圈子"];
    [titleLabel setFont:[UIFont boldSystemFontOfSize:18]];
    titleLabel.textAlignment=NSTextAlignmentCenter;
    titleLabel.textColor=[UIColor whiteColor];
    [self.view addSubview:titleLabel];
    
    UIButton * nextB = [UIButton buttonWithType:UIButtonTypeCustom];
    nextB.frame = CGRectMake(278, 7+diffH, 35, 33);
    [nextB setBackgroundImage:[UIImage imageNamed:@"fabu"] forState:UIControlStateNormal];
    [nextB addTarget:self action:@selector(toPublishPage) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:nextB];

    
    UIImageView * tabIV = [[UIImageView alloc]initWithFrame:CGRectMake(0, 44+diffH, 320, 31.5)];
//    tabIV.image = [UIImage imageNamed:@"biaotidd"];
    tabIV.backgroundColor = [UIColor colorWithRed:0.87 green:0.87 blue:0.87 alpha:1];
//    [UIImage imageNamed:@"table_bg"];
    tabIV.userInteractionEnabled = YES;
    [self.view addSubview:tabIV];
    
    attentionB = [UIButton buttonWithType:UIButtonTypeCustom];
    attentionB.frame = CGRectMake(106.666*2, 0, 106.666, 31.5);
    [attentionB setTitle:@"关注" forState:UIControlStateNormal];
    [attentionB setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [tabIV addSubview:attentionB];
    [attentionB addTarget:self action:@selector(attentionAct) forControlEvents:UIControlEventTouchUpInside];
    
    hotPintsB = [UIButton buttonWithType:UIButtonTypeCustom];
    [hotPintsB setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    hotPintsB.frame = CGRectMake(106.666, 0, 106.666, 31.5);
    [hotPintsB setTitle:@"最新" forState:UIControlStateNormal];
    [tabIV addSubview:hotPintsB];
    [hotPintsB addTarget:self action:@selector(hotPintsAct) forControlEvents:UIControlEventTouchUpInside];
    
    goodB = [UIButton buttonWithType:UIButtonTypeCustom];
    [goodB setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    goodB.frame = CGRectMake(0, 0, 106.666, 31.5);
    [goodB setTitle:@"精华" forState:UIControlStateNormal];
    [goodB addTarget:self action:@selector(changeDataSource) forControlEvents:UIControlEventTouchUpInside];
    [tabIV addSubview:goodB];
    
    self.pageV = [[UIView alloc]initWithFrame:CGRectMake(106.666, 29, 106.666, 2.5)];
    _pageV.backgroundColor = [UIColor colorWithRed:0.5 green:0.83 blue:0.4 alpha:1];
    [tabIV addSubview:_pageV];
    
    self.backGroundV = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 75.5+diffH, 320, self.view.frame.size.height-124.5-diffH)];
    _backGroundV.delegate = self;
    _backGroundV.contentSize = CGSizeMake(960, self.view.frame.size.height-124.5-diffH);
    _backGroundV.contentOffset = CGPointMake(320, 0);
    _backGroundV.pagingEnabled=YES;
	_backGroundV.showsHorizontalScrollIndicator=NO;
	_backGroundV.showsVerticalScrollIndicator=NO;
    _backGroundV.bounces = NO;
    [self.view addSubview:_backGroundV];
    
    self.hotPintsV = [[UITableView alloc]initWithFrame:CGRectMake(320, 0, 320, self.view.frame.size.height-124.5-diffH)];
    _hotPintsV.rowHeight = 80;
    _hotPintsV.delegate = self;
    [_backGroundV addSubview:_hotPintsV];
    
    self.publishArticleDS = [[NewReplyArticleDataSource alloc]init];
    _hotPintsV.dataSource = _publishArticleDS;
    _publishArticleDS.myController = self;
    [self reloadHotPintsData];
    
    self.goodV = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, 320, self.view.frame.size.height-124.5-diffH)];
    _goodV.rowHeight = 80;
    _goodV.delegate = self;
    [_backGroundV addSubview:_goodV];
    
    self.goodArticleDS = [[GoodArticleDataSource alloc]init];
    _goodV.dataSource = _goodArticleDS;
    _goodArticleDS.myController = self;
    [self reloadGoodArticleData];
    
    self.attentionV = [[UITableView alloc]initWithFrame:CGRectMake(640, 0, 320, self.view.frame.size.height-124.5-diffH)];
    _attentionV.contentInset = UIEdgeInsetsMake(0, 0, -sectionFooterHeight, 0);
    _attentionV.delegate = self;
    _attentionV.backgroundView = nil;
    _attentionV.rowHeight = 80;
    [_backGroundV addSubview:_attentionV];
    
    self.attentionDS = [[AttentionDataSource alloc]init];
    _attentionDS.myController = self;
    _attentionV.dataSource = _attentionDS;
    [self loadHistory];
    
    self.slimeView = [[SRRefreshView alloc] init];
    _slimeView.delegate = self;
    _slimeView.upInset = 0;
    _slimeView.slimeMissWhenGoingBack = YES;
    _slimeView.slime.bodyColor = [UIColor colorWithRed:0.7 green:0.7 blue:0.7 alpha:1];
    _slimeView.slime.skinColor = [UIColor whiteColor];
    _slimeView.slime.lineWith = 1;
    _slimeView.slime.shadowBlur = 4;
    _slimeView.slime.shadowColor = [UIColor colorWithRed:0.7 green:0.7 blue:0.7 alpha:1];
    [self.attentionV addSubview:_slimeView];
    
    self.refreshView = [[SRRefreshView alloc] init];
    _refreshView.delegate = self;
    _refreshView.upInset = 0;
    _refreshView.slimeMissWhenGoingBack = YES;
    _refreshView.slime.bodyColor = [UIColor colorWithRed:0.7 green:0.7 blue:0.7 alpha:1];
    _refreshView.slime.skinColor = [UIColor whiteColor];
    _refreshView.slime.lineWith = 1;
    _refreshView.slime.shadowBlur = 4;
    _refreshView.slime.shadowColor = [UIColor colorWithRed:0.7 green:0.7 blue:0.7 alpha:1];
    [self.hotPintsV addSubview:_refreshView];
    
    self.goodrefreshView = [[SRRefreshView alloc] init];
    _goodrefreshView.delegate = self;
    _goodrefreshView.upInset = 0;
    _goodrefreshView.slimeMissWhenGoingBack = YES;
    _goodrefreshView.slime.bodyColor = [UIColor colorWithRed:0.7 green:0.7 blue:0.7 alpha:1];
    _goodrefreshView.slime.skinColor = [UIColor whiteColor];
    _goodrefreshView.slime.lineWith = 1;
    _goodrefreshView.slime.shadowBlur = 4;
    _goodrefreshView.slime.shadowColor = [UIColor colorWithRed:0.7 green:0.7 blue:0.7 alpha:1];
    [self.goodV addSubview:_goodrefreshView];
    
    self.goodFooter = [[MJRefreshFooterView alloc] init];
    _goodFooter.delegate = self;
    _goodFooter.scrollView = self.goodV;
    
    self.hotPintsFooter = [[MJRefreshFooterView alloc] init];
    _hotPintsFooter.delegate = self;
    _hotPintsFooter.scrollView = self.hotPintsV;
    
    self.goodSearchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 20, 320, 44)];
    _goodSearchBar.autocorrectionType = UITextAutocorrectionTypeNo;
    _goodSearchBar.autocapitalizationType = UITextAutocapitalizationTypeNone;
    _goodSearchBar.placeholder = @"搜索精华帖";
    self.goodV.tableHeaderView = _goodSearchBar;
    _goodV.contentOffset = CGPointMake(0, 44);
    _goodSearchBar.delegate = self;
    
    self.hotPintsSearchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 20, 320, 44)];
    _hotPintsSearchBar.autocorrectionType = UITextAutocorrectionTypeNo;
    _hotPintsSearchBar.autocapitalizationType = UITextAutocapitalizationTypeNone;
    _hotPintsSearchBar.placeholder = @"搜索最新帖";
    self.hotPintsV.tableHeaderView = _hotPintsSearchBar;
    _hotPintsV.contentOffset = CGPointMake(0, 44);
    _hotPintsSearchBar.delegate = self;
    
    UIView * dd = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    [dd setBackgroundColor:[UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1]];
    [_goodSearchBar insertSubview:dd atIndex:1];
    UIView * cc = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    [cc setBackgroundColor:[UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1]];
    [_hotPintsSearchBar insertSubview:cc atIndex:1];
    
    self.appDel = [[UIApplication sharedApplication] delegate];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillAppear:(BOOL)animated
{
//    if (![self.myUserID isEqualToString:[[TempData sharedInstance] getMyUserID]]) {
//        [self reloadAttentionData];
//        self.myUserID =[[TempData sharedInstance] getMyUserID];
//    }
    if ([[TempData sharedInstance] ifPanned]) {
        [self.customTabBarController hidesTabBar:NO animated:NO];
    }
    else
    {
        [self.customTabBarController hidesTabBar:NO animated:YES];
        [[TempData sharedInstance] Panned:YES];
    }
//    self.appDel.xmppHelper.commentDelegate = self;
//    [self readNewNoti];
    if ([[TempData sharedInstance] needChat]) {
        [self.customTabBarController setSelectedPage:2];
        return;
    }
}

#pragma mark - button action
-(void)next
{
    NotificationViewController * notiV = [[NotificationViewController alloc] init];
    [self.navigationController pushViewController:notiV animated:YES];
    [self.customTabBarController hidesTabBar:YES animated:YES];
}
-(void)toPublishPage
{
    EditArticleViewController* editAVC = [[EditArticleViewController alloc]init];
    editAVC.CircleTree = self.attentionDS.dataSourceArray;
    if (((CircleClassify*)self.attentionDS.dataSourceArray[0]).circleArray.count>0) {
        editAVC.indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    }else{
        editAVC.indexPath = [NSIndexPath indexPathForRow:0 inSection:1];
    }
    [self presentViewController:editAVC animated:YES completion:^{
        
    }];
}
-(void)showSearchView
{
    SearchViewController* searchVC = [[SearchViewController alloc]init];
    [self.navigationController pushViewController:searchVC animated:YES];
    [self.customTabBarController hidesTabBar:YES animated:YES];
}
-(void)attentionAct
{
    [_backGroundV scrollRectToVisible:CGRectMake(640, 0, 320, _backGroundV.frame.size.height) animated:YES];
}
-(void)hotPintsAct
{
    [_backGroundV scrollRectToVisible:CGRectMake(320, 0, 320, _backGroundV.frame.size.height) animated:YES];
}
-(void)changeDataSource
{
    [_backGroundV scrollRectToVisible:CGRectMake(0, 0, 320, _backGroundV.frame.size.height) animated:YES];
}
#pragma mark - onceCircleViewController delegate
-(void)joinOneCircle:(CircleEntity*)circleEntity
{
    [((CircleClassify*)self.attentionDS.dataSourceArray[0]).circleArray addObject:circleEntity];
    [self.attentionV reloadData];
}
-(void)quitOneCircle:(CircleEntity*)circleEntity
{
    if ([((CircleClassify*)self.attentionDS.dataSourceArray[0]).circleArray containsObject:circleEntity]) {
        [((CircleClassify*)self.attentionDS.dataSourceArray[0]).circleArray removeObject:circleEntity];
        [self.attentionV reloadData];
        return;
    }
    NSArray* array = [((CircleClassify*)self.attentionDS.dataSourceArray[0]).circleArray mutableCopy];
    for (CircleEntity* cir  in array) {
        if ([cir.circleID isEqualToString:circleEntity.circleID]) {
            [((CircleClassify*)self.attentionDS.dataSourceArray[0]).circleArray removeObject:cir];
            [self.attentionV reloadData];
            break;
        }
    }
}
#pragma mark - circle cell delegate
-(void)circleCellPressJoinBWithIndexPath:(NSIndexPath*)indexPath
{
    CircleEntity* circle = ((CircleClassify*)self.attentionDS.dataSourceArray[indexPath.section]).circleArray[indexPath.row];
    circle.atte = !circle.atte;
    if (circle.atte) {
        [self joinOneCircle:circle];
        NSTimeInterval cT = [[NSDate date] timeIntervalSince1970];
        long long a = (long long)(cT*1000);
        NSMutableDictionary* params = [NSMutableDictionary dictionary];
        [params setObject:circle.circleID forKey:@"forumId"];
        [params setObject:[[TempData sharedInstance] getMyUserID] forKey:@"userId"];
        NSMutableDictionary* body = [NSMutableDictionary dictionary];
        [body setObject:params forKey:@"params"];
        [body setObject:@"attentionForum" forKey:@"method"];
        [body setObject:@"service.uri.pet_bbs" forKey:@"service"];
        [body setObject:@"1" forKey:@"channel"];
        [body setObject:[SFHFKeychainUtils getPasswordForUsername:MACADDRESS andServiceName:LOCALACCOUNT error:nil] forKey:@"mac"];
        [body setObject:@"iphone" forKey:@"imei"];
        [body setObject:[NSString stringWithFormat:@"%lld",a] forKey:@"connectTime"];
        [body setObject:[SFHFKeychainUtils getPasswordForUsername:LOCALTOKEN andServiceName:LOCALACCOUNT error:nil] forKey:@"token"];
        [NetManager requestWithURLStr:BaseClientUrl Parameters:body TheController:self success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"%@",responseObject);
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
        }];
    }else{
        [self quitOneCircle:circle];
        NSTimeInterval cT = [[NSDate date] timeIntervalSince1970];
        long long a = (long long)(cT*1000);
        NSMutableDictionary* params = [NSMutableDictionary dictionary];
        [params setObject:circle.circleID forKey:@"forumId"];
        [params setObject:[[TempData sharedInstance] getMyUserID] forKey:@"userId"];
        NSMutableDictionary* body = [NSMutableDictionary dictionary];
        [body setObject:params forKey:@"params"];
        [body setObject:@"service.uri.pet_bbs" forKey:@"service"];
        [body setObject:@"quitForum" forKey:@"method"];
        [body setObject:@"1" forKey:@"channel"];
        [body setObject:[SFHFKeychainUtils getPasswordForUsername:MACADDRESS andServiceName:LOCALACCOUNT error:nil] forKey:@"mac"];
        [body setObject:@"iphone" forKey:@"imei"];
        [body setObject:[NSString stringWithFormat:@"%lld",a] forKey:@"connectTime"];
        [body setObject:[SFHFKeychainUtils getPasswordForUsername:LOCALTOKEN andServiceName:LOCALACCOUNT error:nil] forKey:@"token"];
        [NetManager requestWithURLStr:BaseClientUrl Parameters:body TheController:self success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"%@",responseObject);
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
        }];
    }
}
#pragma mark - table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (tableView == _hotPintsV) {
        ArticleViewController * articleVC = [[ArticleViewController alloc]init];
        articleVC.articleID = ((Article*)_publishArticleDS.dataSourceArray[indexPath.row]).articleID;
        [self.navigationController pushViewController:articleVC animated:YES];
        [self.customTabBarController hidesTabBar:YES animated:YES];
    }
    if (tableView == _goodV) {
        ArticleViewController * articleVC = [[ArticleViewController alloc]init];
        articleVC.articleID = ((Article*)_goodArticleDS.dataSourceArray[indexPath.row]).articleID;
        [self.navigationController pushViewController:articleVC animated:YES];
        [self.customTabBarController hidesTabBar:YES animated:YES];
    }
    if (tableView == _attentionV) {
        if (indexPath.section == 0) {
            if (indexPath.row == 0) {
                FriendCircleViewController* friendCircleVC = [[FriendCircleViewController alloc]init];
                [self.navigationController pushViewController:friendCircleVC animated:YES];
                [self.customTabBarController hidesTabBar:YES animated:YES];
            }else{
                OnceCircleViewController* onceCircleVC = [[OnceCircleViewController alloc]init];
                onceCircleVC.CircleTree = self.attentionDS.dataSourceArray;
                onceCircleVC.indexPath = [NSIndexPath indexPathForRow:indexPath.row-1 inSection:indexPath.section];
                onceCircleVC.delegate = self;
                [self.navigationController pushViewController:onceCircleVC animated:YES];
                [self.customTabBarController hidesTabBar:YES animated:YES];
            }
        }else{
            OnceCircleViewController* onceCircleVC = [[OnceCircleViewController alloc]init];
            onceCircleVC.CircleTree = self.attentionDS.dataSourceArray;
            onceCircleVC.indexPath = indexPath;
            onceCircleVC.delegate = self;
            [self.navigationController pushViewController:onceCircleVC animated:YES];
            [self.customTabBarController hidesTabBar:YES animated:YES];
        }
    }
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (tableView == _attentionV) {
        static NSString *cellIdentifier = @"headerView";
        CircleHeaderView * view = [tableView dequeueReusableHeaderFooterViewWithIdentifier:cellIdentifier];
        if (view == nil) {
            view = [[CircleHeaderView alloc]initWithReuseIdentifier:cellIdentifier];
        }
        view.titleL.text = ((CircleClassify*)self.attentionDS.dataSourceArray[section]).name;
        return view;
    }
    return nil;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (tableView == _attentionV&&section != 0 && ((CircleClassify*)self.attentionDS.dataSourceArray[section]).circleArray.count>2) {
        static NSString *cellIdentifier = @"footerView";
        CircleFooterView * view = [tableView dequeueReusableHeaderFooterViewWithIdentifier:cellIdentifier];
        if (view == nil) {
            view = [[CircleFooterView alloc]initWithReuseIdentifier:cellIdentifier];
            view.delegate = self;
        }
        view.section = section;
        if (!((CircleClassify*)self.attentionDS.dataSourceArray[section]).zhankai) {
            [view.button setTitle:@"+更多" forState:UIControlStateNormal];
        }else{
            [view.button setTitle:@"-收起" forState:UIControlStateNormal];
        }
        return view;
    }
    return nil;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (tableView == _attentionV) {
        return 30;
    }
    return 0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (tableView == _attentionV && section != 0 && ((CircleClassify*)self.attentionDS.dataSourceArray[section]).circleArray.count>2) {
        return sectionFooterHeight;
    }
    return 0;
}
#pragma mark - circleFooterView delegate
-(void)circleFooterViewPressButtonWithIndexPath:(NSInteger)section
{
    ((CircleClassify*)self.attentionDS.dataSourceArray[section]).zhankai = !((CircleClassify*)self.attentionDS.dataSourceArray[section]).zhankai;
    [self.attentionV reloadData];
}
#pragma mark - MJRefreshBaseView delegate
- (void)refreshViewBeginRefreshing:(MJRefreshBaseView *)refreshView
{
    if (refreshView == _goodFooter) {
        [self loadMoreGoodArticleData];
    }
    if (refreshView == _hotPintsFooter) {
        [self loadMoreHotPintsData];
    }
}
#pragma mark - slimeRefresh delegate

- (void)slimeRefreshStartRefresh:(SRRefreshView *)refreshView
{
    if (refreshView== _slimeView) {
        [self reloadAttentionData];
    }
    if (refreshView == _refreshView) {
        [self reloadHotPintsData];
    }
    if (refreshView == _goodrefreshView) {
        [self reloadGoodArticleData];
    }
}
#pragma mark - scroll view delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView == _backGroundV) {
        _pageV.frame = CGRectMake((scrollView.contentOffset.x/320)*106.666, 29, 106.666, 2.5);
    }
    if (scrollView == _attentionV) {
        [_slimeView scrollViewDidScroll];
        if (scrollView.contentSize.height-scrollView.contentOffset.y-scrollView.frame.size.height<=sectionFooterHeight&&scrollView.contentSize.height-scrollView.contentOffset.y-scrollView.frame.size.height>=0) {
            scrollView.contentInset = UIEdgeInsetsMake(0, 0, -(scrollView.contentSize.height-scrollView.contentOffset.y-scrollView.frame.size.height), 0);
        } else if (scrollView.contentSize.height-scrollView.contentOffset.y-scrollView.frame.size.height>=sectionFooterHeight) {
            scrollView.contentInset = UIEdgeInsetsMake(scrollView.contentInset.top, 0, -sectionFooterHeight, 0);
        }
    }
    if(scrollView == _hotPintsV){
        [_refreshView scrollViewDidScroll];
    }
    if(scrollView == _goodV){
        [_goodrefreshView scrollViewDidScroll];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (scrollView == _attentionV) {
        [_slimeView scrollViewDidEndDraging];
    }
    if (scrollView == _hotPintsV) {
        [_refreshView scrollViewDidEndDraging];
    }
    if (scrollView == _goodV) {
        [_goodrefreshView scrollViewDidEndDraging];
    }
}
#pragma mark - load data
#pragma mark -
-(void)reloadAttentionData
{
    [_attentionDS reloadDataSuccess:^{
        [self.attentionV reloadData];
        [_slimeView endRefresh];
    } failure:^{
        [_slimeView endRefresh];
    }];
}
-(void)loadHistory
{
    [_attentionDS loadHistorySuccess:^{
        [self.attentionV reloadData];
        [self reloadAttentionData];
    } failure:^{
        
    }];
}
#pragma mark -
-(void)reloadGoodArticleData
{
    [_goodArticleDS reloadDataSuccess:^{
        [self.goodV reloadData];
        [_goodrefreshView endRefreshFinish:^{
            [UIView animateWithDuration:0.3 animations:^{
                self.goodV.contentOffset = CGPointMake(0, 44);
            }];
        }];
    } failure:^{
        [_goodrefreshView endRefreshFinish:^{
            [UIView animateWithDuration:0.3 animations:^{
                self.goodV.contentOffset = CGPointMake(0, 44);
            }];
        }];
    }];
}
-(void)loadMoreGoodArticleData
{
    [_goodArticleDS loadMoreDataSuccess:^{
        [_goodV reloadData];
        [_goodFooter endRefreshing];
    } failure:^{
        [_goodFooter endRefreshing];
    }];
}
#pragma mark -
-(void)reloadHotPintsData
{
    [_publishArticleDS reloadDataSuccess:^{
        [self.hotPintsV reloadData];
        [_refreshView endRefreshFinish:^{
            [UIView animateWithDuration:0.3 animations:^{
                self.hotPintsV.contentOffset = CGPointMake(0, 44);
            }];
        }];
    } failure:^{
        [_refreshView endRefreshFinish:^{
            [UIView animateWithDuration:0.3 animations:^{
                self.hotPintsV.contentOffset = CGPointMake(0, 44);
            }];
        }];
    }];
}
-(void)loadMoreHotPintsData
{
    [_publishArticleDS loadMoreDataSuccess:^{
        [self.hotPintsV reloadData];
        [_hotPintsFooter endRefreshing];
    } failure:^{
        [_hotPintsFooter endRefreshing];
    }];
}
-(void)readNewNoti
{
    NSUserDefaults * defaultUserD = [NSUserDefaults standardUserDefaults];
    NSString * notiKey = [NSString stringWithFormat:@"%@_%@",NewComment,[SFHFKeychainUtils getPasswordForUsername:ACCOUNT andServiceName:LOCALACCOUNT error:nil]];
    NSArray * tempNewNotiArray = [defaultUserD objectForKey:notiKey];
    if (tempNewNotiArray) {
        if (tempNewNotiArray.count>0) {
            [self.customTabBarController notificationWithNumber:YES AndTheNumber:tempNewNotiArray.count OrDot:NO WithButtonIndex:4];
//            notiBgV.hidden = NO;
//            numberLabel.text = [NSString stringWithFormat:@"%d",tempNewNotiArray.count];
        }
        else{
            [self.customTabBarController removeNotificatonOfIndex:4];
//            notiBgV.hidden = YES;
        }
    }
    else{
        [self.customTabBarController removeNotificatonOfIndex:4];
//        notiBgV.hidden = YES;
    }

}
#pragma mark - searchBar
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    if (searchBar==self.hotPintsSearchBar) {
        SearchViewController* searchVC = [[SearchViewController alloc]init];
        searchVC.searchType = searchTypeNew;
        [self.navigationController pushViewController:searchVC animated:YES];
        [self.customTabBarController hidesTabBar:YES animated:YES];
    }
    else if (searchBar==self.goodSearchBar){
        SearchViewController* searchVC = [[SearchViewController alloc]init];
        searchVC.searchType = searchTypeEute;
        [self.navigationController pushViewController:searchVC animated:YES];
        [self.customTabBarController hidesTabBar:YES animated:YES];
    }

    return NO;
}
#pragma mark - xmpp delegate
-(void)newCommentReceived:(NSDictionary *)theDict
{
    [self storeReceivedNotification:theDict];
}
-(void)storeReceivedNotification:(NSDictionary *)theDict
{
    NSUserDefaults * defaultUserD = [NSUserDefaults standardUserDefaults];
    NSString * notiKey = [NSString stringWithFormat:@"%@_%@",NewComment,[SFHFKeychainUtils getPasswordForUsername:ACCOUNT andServiceName:LOCALACCOUNT error:nil]];
    NSArray * tempNewNotiArray = [defaultUserD objectForKey:notiKey];
    NSMutableArray * newNotiArray;
    if (tempNewNotiArray) {
        newNotiArray = [NSMutableArray arrayWithArray:tempNewNotiArray];
        [newNotiArray insertObject:theDict atIndex:0];
    }
    else
        newNotiArray = [NSMutableArray arrayWithObject:theDict];
    AudioServicesPlayAlertSound(1003);
    [defaultUserD setObject:newNotiArray forKey:notiKey];
    [defaultUserD synchronize];
    if (newNotiArray.count>0) {
        [self.customTabBarController notificationWithNumber:YES AndTheNumber:newNotiArray.count OrDot:NO WithButtonIndex:4];
//        notiBgV.hidden = NO;
//        numberLabel.text = [NSString stringWithFormat:@"%d",newNotiArray.count];
    }
    else{
        [self.customTabBarController removeNotificatonOfIndex:4];
//        notiBgV.hidden = YES;
    }
}
@end
