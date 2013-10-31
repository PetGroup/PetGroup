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

@interface CircleViewController ()<UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UITableViewDelegate,FooterViewDelegate,FriendHeaderViewDelegate,SRRefreshDelegate>
{
    UIButton* attentionB;
    UIButton* hotPintsB;
    
    UIButton* goodB;
    UIButton* newReplyB;
    UIButton* newPublishB;
    
    hotPintsDataSource* hotPintsDS;
}
@property (nonatomic,retain)NSString* myUserID;
@property (nonatomic,retain)UICollectionView* attentionV;
@property (nonatomic,retain)UITableView* hotPintsV;
@property (nonatomic,retain)SRRefreshView* slimeView;
@property (nonatomic,retain)SRRefreshView* refreshView;
@property (nonatomic,retain)AttentionDataSource* attentionDS;

@property (nonatomic,retain)GoodArticleDataSource* goodArticleDS;
@property (nonatomic,retain)NewReplyArticleDataSource* replyArticleDS;
@property (nonatomic,retain)NewPublishArticleDataSource* publishArticleDS;

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
    
    float diffH = [Common diffHeight:self];
    
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
    nextB.frame = CGRectMake(245, 0+diffH, 80, 44);
    [nextB setBackgroundImage:[UIImage imageNamed:@"mail"] forState:UIControlStateNormal];
    [nextB addTarget:self action:@selector(next) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:nextB];
    
    UIImageView * tabIV = [[UIImageView alloc]initWithFrame:CGRectMake(0, 44+diffH, 320, 31.5)];
    tabIV.image = [UIImage imageNamed:@"table_bg"];
    tabIV.userInteractionEnabled = YES;
    [self.view addSubview:tabIV];
    
    attentionB = [UIButton buttonWithType:UIButtonTypeCustom];
    attentionB.frame = CGRectMake(6.5, 2, 153.5, 29.5);
    [attentionB setTitle:@"关注" forState:UIControlStateNormal];
    [attentionB setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [attentionB setBackgroundImage:[UIImage imageNamed:@"table_click"] forState:UIControlStateNormal];
    [tabIV addSubview:attentionB];
    [attentionB addTarget:self action:@selector(attentionAct) forControlEvents:UIControlEventTouchUpInside];
    
    hotPintsB = [UIButton buttonWithType:UIButtonTypeCustom];
    [hotPintsB setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    hotPintsB.frame = CGRectMake(160, 2, 153.5, 29.5);
    [hotPintsB setTitle:@"热点" forState:UIControlStateNormal];
    [tabIV addSubview:hotPintsB];
    [hotPintsB addTarget:self action:@selector(hotPintsAct) forControlEvents:UIControlEventTouchUpInside];
    
    
    self.hotPintsV = [[UITableView alloc]initWithFrame:CGRectMake(0, 75.5+diffH, 320, self.view.frame.size.height-124.5-diffH)];
    _hotPintsV.rowHeight = 100;
    _hotPintsV.delegate = self;
    [self.view addSubview:_hotPintsV];
    
    UIView* headV = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 62.5)];
    UIButton * searchB = [UIButton buttonWithType:UIButtonTypeCustom];
    searchB.frame = CGRectMake(0, 0, 320, 45);
    [searchB setBackgroundImage:[UIImage imageNamed:@"search_bg"] forState:UIControlStateNormal];
    [searchB addTarget:self action:@selector(showSearchView) forControlEvents:UIControlEventTouchUpInside];
    [headV addSubview:searchB];
    
    UIImageView* tableHeadView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 36.5, 320, 26)];
    tableHeadView.image = diffH==0.0f?[UIImage imageNamed:@"biaoti"]:[UIImage imageNamed:@"biaoti2"];
    tableHeadView.userInteractionEnabled = YES;
    
    goodB = [UIButton buttonWithType:UIButtonTypeCustom];
    goodB.frame = CGRectMake(0, 0, 320/3, 26);
    goodB.titleLabel.font = [UIFont systemFontOfSize:14];
    goodB.tag = 2;
    [goodB setTitle:@"精华" forState:UIControlStateNormal];
    [goodB setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [goodB addTarget:self action:@selector(changeDataSource:) forControlEvents:UIControlEventTouchUpInside];
    [tableHeadView addSubview:goodB];
    
    newReplyB = [UIButton buttonWithType:UIButtonTypeCustom];
    newReplyB.frame = CGRectMake(320/3, 0, 320/3, 26);
    newReplyB.titleLabel.font = [UIFont systemFontOfSize:14];
    newReplyB.tag = 3;
    [newReplyB setTitle:@"最新回复" forState:UIControlStateNormal];
    [newReplyB setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [newReplyB addTarget:self action:@selector(changeDataSource:) forControlEvents:UIControlEventTouchUpInside];
    [tableHeadView addSubview:newReplyB];
    
    newPublishB = [UIButton buttonWithType:UIButtonTypeCustom];
    newPublishB.frame = CGRectMake(2*320/3, 0, 320/3, 26);
    newPublishB.titleLabel.font = [UIFont systemFontOfSize:14];
    newPublishB.tag = 4;
    [newPublishB setTitle:@"最新发表" forState:UIControlStateNormal];
    [newPublishB setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [newPublishB addTarget:self action:@selector(changeDataSource:) forControlEvents:UIControlEventTouchUpInside];
    [tableHeadView addSubview:newPublishB];
    
    [headV addSubview:tableHeadView];
    
    _hotPintsV.tableHeaderView = headV;
    
    UICollectionViewFlowLayout* cv = [[UICollectionViewFlowLayout alloc]init];
    cv.minimumLineSpacing = 5.0;
    cv.minimumInteritemSpacing = 5.0;
    cv.sectionInset = UIEdgeInsetsMake(5, 5, 5, 5);
    cv.headerReferenceSize = CGSizeMake(320, 26);
    cv.scrollDirection = UICollectionViewScrollDirectionVertical;
    self.attentionV = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 75.5+diffH, 320, self.view.frame.size.height-124.5-diffH) collectionViewLayout:cv];
    _attentionV.delegate = self;
    _attentionV.backgroundColor = [UIColor whiteColor];
    [_attentionV registerClass:[CircleCell class] forCellWithReuseIdentifier:@"cell"];
    [_attentionV registerClass:[FriendCircleCell class] forCellWithReuseIdentifier:@"friend"];
    [_attentionV registerClass:[FriendHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"friendHeader"];
    [_attentionV registerClass:[HeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header"];
    [_attentionV registerClass:[FooterView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"footer"];
    [self.view addSubview:_attentionV];
    
    self.attentionDS = [[AttentionDataSource alloc]init];
    _attentionDS.myController = self;
    _attentionV.dataSource = _attentionDS;
    
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
    
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    NSArray* array = [defaults objectForKey:MyCircle];
    if (array.count>0) {
        [self loadHistory];
        self.myUserID =[[TempData sharedInstance] getMyUserID];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillAppear:(BOOL)animated
{
    if (![self.myUserID isEqualToString:[[TempData sharedInstance] getMyUserID]]) {
        [self reloadAttentionData];
        self.myUserID =[[TempData sharedInstance] getMyUserID];
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

#pragma mark - button action
-(void)next
{
    EditArticleViewController * editV = [[EditArticleViewController alloc] init];
    [self presentViewController:editV animated:YES completion:^{
        
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
    [attentionB setBackgroundImage:[UIImage imageNamed:@"table_click"] forState:UIControlStateNormal];
    [hotPintsB setBackgroundImage:nil forState:UIControlStateNormal];
    [self.view bringSubviewToFront:_attentionV];
}
-(void)hotPintsAct
{
    [attentionB setBackgroundImage:nil forState:UIControlStateNormal];
    [hotPintsB setBackgroundImage:[UIImage imageNamed:@"table_click"] forState:UIControlStateNormal];
    [self.view bringSubviewToFront:_hotPintsV];
    if (self.goodArticleDS == nil) {
        self.goodArticleDS = [[GoodArticleDataSource alloc]init];
        _hotPintsV.dataSource = _goodArticleDS;
        hotPintsDS = _goodArticleDS;
        _goodArticleDS.myController = self;
        [self reloadHotPintsData];
    }
}
-(void)changeDataSource:(UIButton*)button
{
    switch (button.tag) {
        case 2:{
            if (self.hotPintsV.dataSource!=_goodArticleDS) {
                [goodB setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                [newReplyB setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
                [newPublishB setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
                if (_goodArticleDS == nil) {
                    self.goodArticleDS = [[GoodArticleDataSource alloc]init];
                    _hotPintsV.dataSource = _goodArticleDS;
                    hotPintsDS = _goodArticleDS;
                    _goodArticleDS.myController = self;
                    [self reloadHotPintsData];
                }else{
                    _hotPintsV.dataSource = _goodArticleDS;
                    hotPintsDS = _goodArticleDS;
                    [_hotPintsV reloadData];
                }
            }
            
        }break;
        case 3:{
            if (self.hotPintsV.dataSource!=_replyArticleDS) {
                [goodB setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
                [newReplyB setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                [newPublishB setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
                if (_replyArticleDS == nil) {
                    self.replyArticleDS = [[NewReplyArticleDataSource alloc]init];
                    _hotPintsV.dataSource = _replyArticleDS;
                    hotPintsDS = _replyArticleDS;
                    _replyArticleDS.myController = self;
                    [self reloadHotPintsData];
                }else{
                    _hotPintsV.dataSource = _replyArticleDS;
                    hotPintsDS = _replyArticleDS;
                    [_hotPintsV reloadData];
                }
            }
            
        }break;
        case 4:{
            if (self.hotPintsV.dataSource!= _publishArticleDS) {
                [goodB setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
                [newReplyB setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
                [newPublishB setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                if (_publishArticleDS == nil) {
                    self.publishArticleDS = [[NewPublishArticleDataSource alloc]init];
                    _hotPintsV.dataSource = _publishArticleDS;
                    hotPintsDS = _publishArticleDS;
                    _publishArticleDS.myController = self;
                    [self reloadHotPintsData];
                }else{
                    _hotPintsV.dataSource = _publishArticleDS;
                    hotPintsDS = _publishArticleDS;
                    [_hotPintsV reloadData];
                }
                
            }
            
        }break;
        default:
            break;
    }
}
#pragma mark - table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    ArticleViewController * articleVC = [[ArticleViewController alloc]init];
    articleVC.article = hotPintsDS.dataSourceArray[indexPath.row];
    [self.navigationController pushViewController:articleVC animated:YES];
}

#pragma mark - collection view delegate flow layout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return CGSizeMake(310, 70);
    }else return CGSizeMake(152.5, 100);
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
{
    if (section == 0) {
        return CGSizeZero;
    }
    return CGSizeMake(320, 26);
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return CGSizeMake(320, 62.5);
    }
    return CGSizeMake(320, 26);
}
#pragma mark - collection view delegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        FriendCircleViewController* friendCircleVC = [[FriendCircleViewController alloc]init];
        [self.navigationController pushViewController:friendCircleVC animated:YES];
        [self.customTabBarController hidesTabBar:YES animated:YES];
    }else{
        OnceCircleViewController* onceCircleVC = [[OnceCircleViewController alloc]init];
        onceCircleVC.circleEntity = ((CircleClassify*)self.attentionDS.dataSourceArray[indexPath.section-1]).circleArray[indexPath.row];
        [self.navigationController pushViewController:onceCircleVC animated:YES];
        [self.customTabBarController hidesTabBar:YES animated:YES];
    }
}
#pragma mark - footer view delegate
-(void)footerView:(FooterView*)footerV didSelectUnfoldBAtIndexPath:(NSIndexPath *)indexPath
{
    
    ((CircleClassify*)_attentionDS.dataSourceArray[indexPath.section-1]).zhankai = !((CircleClassify*)_attentionDS.dataSourceArray[indexPath.section-1]).zhankai;
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
}
#pragma mark - scroll view delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView == _attentionV) {
        [_slimeView scrollViewDidScroll];
    }else if(scrollView == _hotPintsV){
        [_refreshView scrollViewDidScroll];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (scrollView == _attentionV) {
        [_slimeView scrollViewDidEndDraging];
    }else if (scrollView == _hotPintsV) {
        [_refreshView scrollViewDidEndDraging];
    }
}
#pragma mark - load data
-(void)reloadAttentionData
{
    [_attentionDS reloadDataSuccess:^{
        [self.attentionV reloadData];
        [_slimeView endRefresh];
    } failure:^{
        [_slimeView endRefresh];
    }];
}
-(void)reloadHotPintsData
{
    [hotPintsDS reloadDataSuccess:^{
        [self.hotPintsV reloadData];
        [_refreshView endRefresh];
    } failure:^{
        [_slimeView endRefresh];
    }];
}
-(void)loadHistory
{
    [_attentionDS loadHistorySuccess:^{
        [self.attentionV reloadData];
        [_slimeView endRefresh];
    } failure:^{
        [_slimeView endRefresh];
    }];
}
@end
