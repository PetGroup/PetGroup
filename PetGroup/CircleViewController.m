//
//  CircleViewController.m
//  PetGroup
//
//  Created by 阿铛 on 13-10-11.
//  Copyright (c) 2013年 Tolecen. All rights reserved.
//

#import "CircleViewController.h"
#import "CircleCell.h"
#import "FriendCircleCell.h"
#import "FriendHeaderView.h"
#import "HeaderView.h"
#import "FooterView.h"
#import "SRRefreshView.h"
#import "AttentionDataSource.h"
#import "GoodArticleDataSource.h"
#import "NewReplyArticleDataSource.h"
#import "NewPublishArticleDataSource.h"
#import "FriendHeaderView.h"
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
@interface CircleViewController ()<UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UITableViewDelegate,FooterViewDelegate,FriendHeaderViewDelegate,SRRefreshDelegate,OnceCircleViewControllerDelegate>
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
@property (nonatomic,retain)UICollectionView* attentionV;

@property (nonatomic,retain)SRRefreshView* goodrefreshView;
@property (nonatomic,retain)SRRefreshView* slimeView;
@property (nonatomic,retain)SRRefreshView* refreshView;

@property (nonatomic,retain)AttentionDataSource* attentionDS;
@property (nonatomic,retain)GoodArticleDataSource* goodArticleDS;
@property (nonatomic,retain)NewPublishArticleDataSource* publishArticleDS;

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
    tabIV.image = [UIImage imageNamed:@"biaotidd"];
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
    [hotPintsB setTitle:@"最新发表" forState:UIControlStateNormal];
    [tabIV addSubview:hotPintsB];
    [hotPintsB addTarget:self action:@selector(hotPintsAct) forControlEvents:UIControlEventTouchUpInside];
    
    goodB = [UIButton buttonWithType:UIButtonTypeCustom];
    [goodB setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    goodB.frame = CGRectMake(0, 0, 106.666, 31.5);
    [goodB setTitle:@"精华" forState:UIControlStateNormal];
    [goodB addTarget:self action:@selector(changeDataSource) forControlEvents:UIControlEventTouchUpInside];
    [tabIV addSubview:goodB];
    
    self.pageV = [[UIView alloc]initWithFrame:CGRectMake(106.666, 29, 106.666, 2.5)];
    _pageV.backgroundColor = [UIColor orangeColor];
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
    _hotPintsV.rowHeight = 100;
    _hotPintsV.delegate = self;
    [_backGroundV addSubview:_hotPintsV];
    
    self.publishArticleDS = [[NewPublishArticleDataSource alloc]init];
    _hotPintsV.dataSource = _publishArticleDS;
    _publishArticleDS.myController = self;
    [self reloadHotPintsData];
    
    self.goodV = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, 320, self.view.frame.size.height-124.5-diffH)];
    _goodV.rowHeight = 100;
    _goodV.delegate = self;
    [_backGroundV addSubview:_goodV];
    
    self.goodArticleDS = [[GoodArticleDataSource alloc]init];
    _goodV.dataSource = _goodArticleDS;
    _goodArticleDS.myController = self;
    [self reloadGoodArticleData];
    
    UICollectionViewFlowLayout* cv = [[UICollectionViewFlowLayout alloc]init];
    cv.minimumLineSpacing = 5.0;
    cv.minimumInteritemSpacing = 5.0;
    cv.sectionInset = UIEdgeInsetsMake(5, 5, 5, 5);
    cv.headerReferenceSize = CGSizeMake(320, 26);
    cv.scrollDirection = UICollectionViewScrollDirectionVertical;
    self.attentionV = [[UICollectionView alloc]initWithFrame:CGRectMake(640, 0, 320, self.view.frame.size.height-124.5-diffH) collectionViewLayout:cv];
    _attentionV.delegate = self;
    _attentionV.backgroundColor = [UIColor whiteColor];
    [_attentionV registerClass:[CircleCell class] forCellWithReuseIdentifier:@"cell"];
    [_attentionV registerClass:[FriendCircleCell class] forCellWithReuseIdentifier:@"friend"];
    [_attentionV registerClass:[HeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header"];
    [_attentionV registerClass:[FooterView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"footer"];
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
    self.appDel.xmppHelper.commentDelegate = self;
    [self readNewNoti];
    if ([[TempData sharedInstance] needChat]) {
        [self.customTabBarController setSelectedPage:1];
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
//    editAVC.forumId = self.circleEntity.circleID;
//    editAVC.forumName = self.circleEntity.name;
//    editAVC.delegate = self;
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
#pragma mark - table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == _hotPintsV) {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        ArticleViewController * articleVC = [[ArticleViewController alloc]init];
        articleVC.articleID = ((Article*)_publishArticleDS.dataSourceArray[indexPath.row]).articleID;
        [self.navigationController pushViewController:articleVC animated:YES];
        [self.customTabBarController hidesTabBar:YES animated:YES];
    }
    if (tableView == _goodV) {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        ArticleViewController * articleVC = [[ArticleViewController alloc]init];
        articleVC.articleID = ((Article*)_goodArticleDS.dataSourceArray[indexPath.row]).articleID;
        [self.navigationController pushViewController:articleVC animated:YES];
        [self.customTabBarController hidesTabBar:YES animated:YES];
    }
}

#pragma mark - collection view delegate flow layout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
//    if (indexPath.section == 0) {
//        return CGSizeMake(310, 70);
//    }else
//    if(indexPath.section == 0 &&((CircleClassify*) _attentionDS.dataSourceArray[0]).circleArray.count==0){
//        return CGSizeMake(310, 70);
//    }else
        return CGSizeMake(152.5, 80);
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
{
//    if (section == 0) {
//        return CGSizeZero;
//    }
    return CGSizeMake(320, 26);
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
//    if (section == 0) {
//        return CGSizeMake(320, 62.5);
//    }
    return CGSizeMake(320, 26);
}
#pragma mark - collection view delegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            FriendCircleViewController* friendCircleVC = [[FriendCircleViewController alloc]init];
            [self.navigationController pushViewController:friendCircleVC animated:YES];
            [self.customTabBarController hidesTabBar:YES animated:YES];
        }else{
            OnceCircleViewController* onceCircleVC = [[OnceCircleViewController alloc]init];
            onceCircleVC.circleEntity = ((CircleClassify*)self.attentionDS.dataSourceArray[indexPath.section]).circleArray[indexPath.row-1];
            onceCircleVC.delegate = self;
            [self.navigationController pushViewController:onceCircleVC animated:YES];
            [self.customTabBarController hidesTabBar:YES animated:YES];
        }
    }else{
        OnceCircleViewController* onceCircleVC = [[OnceCircleViewController alloc]init];
        onceCircleVC.circleEntity = ((CircleClassify*)self.attentionDS.dataSourceArray[indexPath.section]).circleArray[indexPath.row];
        onceCircleVC.delegate = self;
        [self.navigationController pushViewController:onceCircleVC animated:YES];
        [self.customTabBarController hidesTabBar:YES animated:YES];
    }
}
#pragma mark - footer view delegate
-(void)footerView:(FooterView*)footerV didSelectUnfoldBAtIndexPath:(NSIndexPath *)indexPath
{
    
    ((CircleClassify*)_attentionDS.dataSourceArray[indexPath.section]).zhankai = !((CircleClassify*)_attentionDS.dataSourceArray[indexPath.section]).zhankai;
    [self.attentionV reloadData];
    
    
}
#pragma mark - header view delegate
-(void)didSelectSearchBAtFriendHeaderView:(FriendHeaderView*)friendHeaderV
{
    [self showSearchView];
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
-(void)joinOrQuitCircle
{
    [self reloadAttentionData];
}
-(void)reloadAttentionData
{
    [_attentionDS reloadDataSuccess:^{
        [self.attentionV reloadData];
        [_slimeView endRefresh];
    } failure:^{
        [_slimeView endRefresh];
    }];
}
-(void)reloadGoodArticleData
{
    [_goodArticleDS reloadDataSuccess:^{
        [self.goodV reloadData];
        [_goodrefreshView endRefresh];
    } failure:^{
        [_goodrefreshView endRefresh];
    }];
}
-(void)reloadHotPintsData
{
    [_publishArticleDS reloadDataSuccess:^{
        [self.hotPintsV reloadData];
        [_refreshView endRefresh];
    } failure:^{
        [_refreshView endRefresh];
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
