//
//  NewCircleViewController.m
//  PetGroup
//
//  Created by wangxr on 14-2-20.
//  Copyright (c) 2014年 Tolecen. All rights reserved.
//

#import "NewCircleViewController.h"
#import "SRRefreshView.h"
#import "MJRefresh.h"
#import "NewArticleListDataSource.h"
#import "NewArticleCell.h"
#import "ArticleViewController.h"
#import "CustomTabBar.h"
#import "TempData.h"
#import "PhotoViewController.h"
#import "SearchViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "EditArticleViewController.h"
#import "SubjectViewController.h"
#import "TouchView.h"
typedef  enum
{
    stateTypeOpen = 0,
    stateTypeOpening,
    stateTypeClose,
    stateTypeClosing
}StateType;
@interface NewCircleViewController ()<UITableViewDelegate,UISearchBarDelegate,SRRefreshDelegate,MJRefreshBaseViewDelegate,DynamicCellDelegate,TouchViewDelegate,EditArticleViewDelegate>
{
    float diffH;
    CGPoint centerPoint;
    
    StateType stateType;
    
    UIButton* allB;
    UIButton* shareB;
    UIButton* helpB;
    UIButton* marryB;
    UIButton* exB;
    NewArticleListDataSource* _dataSource;
    
    int _lastPosition;
    
    UIImageView * subNotiV;
}
@property (nonatomic,retain)UITableView* tableV;
@property (nonatomic,retain)SRRefreshView* refreshView;
@property (nonatomic,retain)MJRefreshFooterView* footerView;
@property (nonatomic,retain)NSMutableArray* buttonArray;
@property (nonatomic,retain)NSMutableArray* labelArray;
@property (nonatomic,retain)NewArticleListDataSource * allListDS;
@property (nonatomic,retain)NewArticleListDataSource * shareListDS;
@property (nonatomic,retain)NewArticleListDataSource * helpListDS;
@property (nonatomic,retain)NewArticleListDataSource * marryListDS;
@property (nonatomic,retain)NewArticleListDataSource * exListDS;
@property (nonatomic,retain)TouchView * touchV;
@end

@implementation NewCircleViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        stateType = stateTypeClose;
        self.buttonArray = [NSMutableArray array];
        self.labelArray = [NSMutableArray array];
    }
    return self;
}
-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}
- (void)viewWillDisappear:(BOOL)animated
{
    [self close];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.hidesBottomBarWhenPushed = YES;
    
    diffH = [Common diffHeight:self];
    
    centerPoint = CGPointMake(290, self.view.frame.size.height - 100);
    
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
    
//    UIButton * subBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    subBtn.frame = CGRectMake(0, 0+diffH, 44, 44);
//    [subBtn setBackgroundImage:[UIImage imageNamed:@"newsub"] forState:UIControlStateNormal];
//    [subBtn.titleLabel setFont:[UIFont systemFontOfSize:15]];
//    //    [nextB setTitle:@"新话题" forState:UIControlStateNormal];
//    [subBtn addTarget:self action:@selector(toSubjectPage) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:subBtn];
//    
    UIButton * nextB = [UIButton buttonWithType:UIButtonTypeCustom];
    nextB.frame = CGRectMake(276, 0+diffH, 44, 44);
    [nextB setBackgroundImage:[UIImage imageNamed:@"topsearch"] forState:UIControlStateNormal];
    [nextB.titleLabel setFont:[UIFont systemFontOfSize:15]];
//    [nextB setTitle:@"新话题" forState:UIControlStateNormal];
    [nextB addTarget:self action:@selector(toSearchPage) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:nextB];
    
    UIImageView * tabIV = [[UIImageView alloc]initWithFrame:CGRectMake(0, 44+diffH, 320, 49)];
    tabIV.image = [UIImage imageNamed:@"top_btn_bg"];
    tabIV.userInteractionEnabled = YES;
    [self.view addSubview:tabIV];
    
    UIButton* publishB = [UIButton buttonWithType:UIButtonTypeCustom];
    publishB.frame = CGRectMake(6.5, 6, 187.5, 38);
    [publishB setBackgroundImage:[UIImage imageNamed:@"fabu_normal"] forState:UIControlStateNormal];
    [publishB addTarget:self action:@selector(toPublishPage) forControlEvents:UIControlEventTouchUpInside];
    [tabIV addSubview:publishB];
    
    UIButton* subjectB = [UIButton buttonWithType:UIButtonTypeCustom];
    subjectB.frame = CGRectMake(202.5, 6, 111, 38);
    [subjectB setBackgroundImage:[UIImage imageNamed:@"zhuanti_normal"] forState:UIControlStateNormal];
    [subjectB addTarget:self action:@selector(toSubjectPage) forControlEvents:UIControlEventTouchUpInside];
    [tabIV addSubview:subjectB];
    
    subNotiV = [[UIImageView alloc] initWithFrame:CGRectMake(90, 5, 15, 15)];
    [subNotiV setImage:[UIImage imageNamed:@"redpot.png"]];
    [subjectB addSubview:subNotiV];
    subNotiV.hidden = YES;
    
    self.tableV = [[UITableView alloc]initWithFrame:CGRectMake(0, 93+diffH, 320, self.view.frame.size.height-142-diffH)];
    _tableV.delegate = self;
    _tableV.showsVerticalScrollIndicator = NO;
    
//    UISearchBar* searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 20, 320, 44)];
//    searchBar.autocorrectionType = UITextAutocorrectionTypeNo;
//    searchBar.autocapitalizationType = UITextAutocapitalizationTypeNone;
//    searchBar.placeholder = @"搜索精华帖";
//    self.tableV.tableHeaderView = searchBar;
//    _tableV.contentOffset = CGPointMake(0, 44);
//    UIView * dd = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
//    [dd setBackgroundColor:[UIColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:1]];
//    
//    [searchBar insertSubview:dd atIndex:1];
//    searchBar.delegate = self;
    
    self.refreshView = [[SRRefreshView alloc] init];
    _refreshView.delegate = self;
    _refreshView.upInset = 0;
    _refreshView.slimeMissWhenGoingBack = YES;
    _refreshView.slime.bodyColor = [UIColor colorWithRed:0.7 green:0.7 blue:0.7 alpha:1];
    _refreshView.slime.skinColor = [UIColor whiteColor];
    _refreshView.slime.lineWith = 1;
    _refreshView.slime.shadowBlur = 4;
    _refreshView.slime.shadowColor = [UIColor colorWithRed:0.7 green:0.7 blue:0.7 alpha:1];
    [self.tableV addSubview:_refreshView];
    
    self.footerView = [[MJRefreshFooterView alloc] init];
    _footerView.delegate = self;
    _footerView.scrollView = self.tableV;
    
    [self.view addSubview:_tableV];
    
    self.touchV = [[TouchView alloc]initWithFrame:CGRectMake(0, 44+diffH, 320, self.view.frame.size.height-93-diffH)];
    [self.view addSubview:_touchV];
    _touchV.hidden = YES;
    _touchV.delegate = self;
    
    marryB = [UIButton buttonWithType:UIButtonTypeCustom];
    marryB.hidden = YES;
    [marryB setBackgroundImage:[UIImage imageNamed:@"other_normal"] forState:UIControlStateNormal];
    marryB.frame = CGRectMake(0, 0, 50, 50);
    marryB.center = centerPoint;
    [marryB addTarget:self action:@selector(open:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:marryB];
    [_buttonArray addObject:marryB];
    
    helpB = [UIButton buttonWithType:UIButtonTypeCustom];
    helpB.hidden = YES;
    [helpB setBackgroundImage:[UIImage imageNamed:@"faqiuzhu"] forState:UIControlStateNormal];
    helpB.frame = CGRectMake(0, 0, 50, 50);
    helpB.center = centerPoint;
    [helpB addTarget:self action:@selector(open:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:helpB];
    [_buttonArray addObject:helpB];
    
    exB = [UIButton buttonWithType:UIButtonTypeCustom];
    exB.hidden = YES;
    [exB setBackgroundImage:[UIImage imageNamed:@"qijingyan"] forState:UIControlStateNormal];
    exB.frame = CGRectMake(0, 0, 50, 50);
    exB.center = centerPoint;
    [exB addTarget:self action:@selector(open:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:exB];
    [_buttonArray addObject:exB];
    
    shareB = [UIButton buttonWithType:UIButtonTypeCustom];
    shareB.hidden = YES;
    [shareB setBackgroundImage:[UIImage imageNamed:@"shaiingfu"] forState:UIControlStateNormal];
    shareB.frame = CGRectMake(0, 0, 50, 50);
    shareB.center = centerPoint;
    [shareB addTarget:self action:@selector(open:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:shareB];
    [_buttonArray addObject:shareB];
    
    allB = [UIButton buttonWithType:UIButtonTypeCustom];
    allB.alpha = 0.5;
    [allB setBackgroundImage:[UIImage imageNamed:@"quanbu"] forState:UIControlStateNormal];
    allB.frame = CGRectMake(0, 0, 50, 50);
    allB.center = centerPoint;
    [allB addTarget:self action:@selector(open:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:allB];
    [_buttonArray insertObject:allB atIndex:0];
    
    for (int i = 0; i<4; i++) {
        UILabel* label = [[UILabel alloc]initWithFrame:CGRectMake(25+i*60, centerPoint.y + 25, 50, 20)];
        label.hidden = YES;
        label.font = [UIFont systemFontOfSize:14];
        label.textColor = [UIColor whiteColor];
        label.backgroundColor = [UIColor blackColor];
        label.alpha = 0.85;
        label.textAlignment = NSTextAlignmentCenter;
        label.layer.cornerRadius = 3;
        label.layer.masksToBounds = YES;
        
        [self.view addSubview:label];
        [_labelArray addObject:label];
    }
    
    self.allListDS = [[NewArticleListDataSource alloc]initWithAssortID:@"ALL"];
    _allListDS.myController = self;
    [self setDataSource:_allListDS];
    [self loadHistory];
    
    [NewArticleListDataSource viewController:self loadTagListSuccess:^(NSArray *tagArray) {
        self.shareListDS = [[NewArticleListDataSource alloc]initWithAssortID:tagArray[0]];  //晒幸福
        _shareListDS.myController = self;
        self.exListDS = [[NewArticleListDataSource alloc]initWithAssortID:tagArray[1]];   //求经验
        _exListDS.myController = self;
        self.marryListDS = [[NewArticleListDataSource alloc]initWithAssortID:tagArray[2]];  //其他
        _marryListDS.myController = self;
        self.helpListDS = [[NewArticleListDataSource alloc]initWithAssortID:tagArray[3]];   //发求助
        _helpListDS.myController = self;
    } failure:^{
        
    }];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(makeScrollToTheTop:) name:@"Notification_makeSrollTop" object:nil];
}
-(void)makeScrollToTheTop:(NSNumber *)index
{
    if (_dataSource.dataSourceArray.count>0) {
        [self.tableV scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition: UITableViewScrollPositionTop animated:YES];
    }

}
-(void)toSubjectPage
{
    SubjectViewController* subjectVC = [[SubjectViewController alloc]init];
    [self.navigationController pushViewController:subjectVC animated:YES];
    [self.customTabBarController hidesTabBar:YES animated:YES];
    [[NSUserDefaults standardUserDefaults] setObject:@"YES" forKey:[NSString stringWithFormat:@"%@_%@",@"bbs_special_subject",[SFHFKeychainUtils getPasswordForUsername:ACCOUNT andServiceName:LOCALACCOUNT error:nil]]];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
-(void)toPublishPage
{
    EditArticleViewController* editAVC = [[EditArticleViewController alloc]init];
    editAVC.delegate = self;
    [self presentViewController:editAVC animated:YES completion:^{
        
    }];
}
-(void)viewDidAppear:(BOOL)animated
{
    NSString * subIfRead = [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"%@_%@",@"bbs_special_subject",[SFHFKeychainUtils getPasswordForUsername:ACCOUNT andServiceName:LOCALACCOUNT error:nil]]];
    if (subIfRead) {
        if ([subIfRead isEqualToString:@"YES"]) {
            subNotiV.hidden = YES;
            [self.customTabBarController removeNotificatonOfIndex:0];
            
        }
        else
        {
            subNotiV.hidden = NO;
            [self.customTabBarController notificationWithNumber:NO AndTheNumber:0 OrDot:YES WithButtonIndex:0];
        }
    }
    else
    {
        subNotiV.hidden = YES;
        [self.customTabBarController removeNotificatonOfIndex:0];
    }
}
-(void)viewWillAppear:(BOOL)animated
{
    if ([TempData sharedInstance].changeUser) {
        [TempData sharedInstance].changeUser = NO;
        [_buttonArray removeObject:allB];
        for (UIButton* button in _buttonArray) {
            button.hidden = YES;
        }
        [_buttonArray insertObject:allB atIndex:0];
        [self.view bringSubviewToFront:allB];
        allB.hidden = NO;
        allB.alpha = 0.5;
        [self setDataSource:_allListDS];
        [self reloadData];
        
    }
    if ([[TempData sharedInstance] ifPanned]) {
        [self.customTabBarController hidesTabBar:NO animated:NO];
    }
    else
    {
        [self.customTabBarController hidesTabBar:NO animated:YES];
        [[TempData sharedInstance] Panned:YES];
    }
    if ([[TempData sharedInstance] needChat]) {
        [self.customTabBarController setSelectedPage:2];
        return;
    }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - button action
- (void)reloadData
{
    [_refreshView setLoadingWithexpansion];
    _refreshView.slime.hidden = YES;
    [self reloadDataSource];
}
- (void)setDataSource:(NewArticleListDataSource*)dataSource
{
    if (_dataSource != dataSource) {
        _dataSource = dataSource;
    }
    self.tableV.dataSource = dataSource;
}
- (void)publishNewArticle
{
    
}
- (void)showSubject
{
    
}
-(void)open:(UIButton*)button
{
    NSLog(@"%f",button.center.x);
    if (stateType == stateTypeClose) {
        [self openButtons];
    }
    if (stateType == stateTypeOpen)
    {
        [self closeWithButton:button Completion:^{
            if (button == allB) {
                [self setDataSource:_allListDS];
            }
            if (button == shareB) {
                [self setDataSource:_shareListDS];
            }
            if (button == exB) {
                [self setDataSource:_exListDS];
            }
            if (button == marryB) {
                [self setDataSource:_marryListDS];
            }
            if (button == helpB) {
                [self setDataSource:_helpListDS];
            }
            [self reloadData];
        }];
    }
}
- (void)close
{
    if (stateType == stateTypeOpen) {
        [self closeWithButton:_buttonArray[0] Completion:nil];
    }
    
}
- (void)closeWithButton:(UIButton*)button Completion:(void (^)(void))completion
{
    stateType = stateTypeClosing;
    if (button) {
        [_buttonArray removeObject:button];
        [_buttonArray insertObject:button atIndex:0];
        [self.view bringSubviewToFront:button];
    }
    for (UILabel * label in _labelArray) {
        label.hidden = YES;
    }
    [UIView animateWithDuration:0.3
                     animations:^{
                         if (button) {
                             for (int i = 0; i<_buttonArray.count; i++) {
                                 ((UIView*)_buttonArray[i]).center  = CGPointMake(button.center.x, button.center.y);
                             }
                         }
                     } completion:^(BOOL finished) {
                         for (UIButton* button in _buttonArray) {
                             button.hidden = YES;
                         }
                         ((UIButton*)_buttonArray[0]).hidden = NO;
                         [UIView animateWithDuration:0.2
                                          animations:^{
                                              ((UIButton*)_buttonArray[0]).alpha = 0.5;
                                              for (int i = 0; i<_buttonArray.count; i++) {
                                                  ((UIView*)_buttonArray[i]).center  = centerPoint;
                                              }
                                          } completion:^(BOOL finished) {
                                              stateType = stateTypeClose;
                                              _touchV.hidden = YES;
                                              if (completion) {
                                                   completion();
                                              }
                                             
                                          }];
                     }];
}
- (void)openButtons
{
    stateType = stateTypeOpening;
    for (UIButton* button in _buttonArray) {
        button.alpha = 1;
        button.hidden = NO;
    }
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0){
        [UIView animateWithDuration:0.3
                              delay:0.0
             usingSpringWithDamping:0.45
              initialSpringVelocity:7.5
                            options:UIViewAnimationOptionCurveEaseIn
                         animations:^{
                             for (int i = 0; i<_buttonArray.count; i++) {
                                 ((UIView*)_buttonArray[i]).center  = CGPointMake(((UIView*)_buttonArray[i]).center.x-i*60, ((UIView*)_buttonArray[i]).center.y);
                             }
                         }
                         completion:^(BOOL finished){
                             [self setTextForLabrls];
                              stateType = stateTypeOpen;
                              _touchV.hidden = NO;
                         }];
    }else{
        [UIView animateWithDuration:0.2
                         animations:^{
                             for (int i = 0; i<_buttonArray.count; i++) {
                                 ((UIView*)_buttonArray[i]).center  = CGPointMake(((UIView*)_buttonArray[i]).center.x-i*60, ((UIView*)_buttonArray[i]).center.y);
                             }
                         } completion:^(BOOL finished) {
                             
                             [self setTextForLabrls];
                             stateType = stateTypeOpen;
                             _touchV.hidden = NO;
                         }];
    }
}
- (void)setTextForLabrls
{
    for (int i  = 0;i < 4;i++) {
        ((UILabel*)_labelArray[i]).hidden = NO;
        if (_buttonArray[4-i]  == allB) {
            ((UILabel*)_labelArray[i]).text = @"全部";
        }
        if (_buttonArray[4-i]  == shareB) {
            ((UILabel*)_labelArray[i]).text = @"晒幸福";
        }
        if (_buttonArray[4-i]  == helpB) {
            ((UILabel*)_labelArray[i]).text = @"发求助";
        }
        if (_buttonArray[4-i]  == exB) {
            ((UILabel*)_labelArray[i]).text = @"求经验";
        }
        if (_buttonArray[4-i]  == marryB) {
            ((UILabel*)_labelArray[i]).text = @"其他";
        }
    }
}
#pragma mark - touchView delegate
-(void)TouchViewBeginTouch:(TouchView*)touchView
{
    [self close];
}
#pragma mark - tableView delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    ArticleViewController * articleVC = [[ArticleViewController alloc]init];
    articleVC.articleID = ((Article*)_dataSource.dataSourceArray[indexPath.row]).articleID;
    [self.navigationController pushViewController:articleVC animated:YES];
    [self.customTabBarController hidesTabBar:YES animated:YES];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [NewArticleCell heightForRowWithArticle:_dataSource.dataSourceArray[indexPath.row]];
}
#pragma mark - MJRefreshBaseView delegate
- (void)refreshViewBeginRefreshing:(MJRefreshBaseView *)refreshView
{
    [self loadMoreDataSource];
}
#pragma mark - slimeRefresh delegate

- (void)slimeRefreshStartRefresh:(SRRefreshView *)refreshView
{
    [self reloadDataSource];
}
#pragma mark - scroll view delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if(scrollView == _tableV){
        int currentPostion = scrollView.contentOffset.y;
        if (currentPostion - _lastPosition > 20  && currentPostion > 0) {        //这个地方加上 currentPostion > 0 即可)
            _lastPosition = currentPostion;
            NSLog(@"ScrollUp now");
            if (_tableV.frame.origin.y != 44+diffH) {
                [UIView animateWithDuration:0.2 animations:^{
                    _tableV.frame = CGRectMake(0, 44+diffH, 320, _tableV.frame.size.height+49);
                }];
            }
            
            
        }
        
        else if ((_lastPosition - currentPostion > 20) && (currentPostion  <= scrollView.contentSize.height-scrollView.bounds.size.height-20) ) //这个地方加上后边那个即可，也不知道为什么，再减20才行
        {
            _lastPosition = currentPostion;
            NSLog(@"ScrollDown now");
            if (_tableV.frame.origin.y != 93+diffH) {
                [UIView animateWithDuration:0.2 animations:^{
                    _tableV.frame = CGRectMake(0, 93+diffH, 320, _tableV.frame.size.height-49);
                }];
            }
        }
        [_refreshView scrollViewDidScroll];
    }
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (scrollView == _tableV) {
        [_refreshView scrollViewDidEndDraging];
    }
}
#pragma mark - dynamicCell delegate
-(void)dynamicCellPressImageButtonWithSmallImageArray:(NSArray*)smallImageArray andImageIDArray:(NSArray*)idArray indext:(int)indext
{
    PhotoViewController* vc = [[PhotoViewController alloc]initWithSmallImages:smallImageArray images:idArray indext:indext];
    [self presentViewController:vc animated:NO completion:nil];
}
#pragma mark - UISearchBar delegate
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    SearchViewController* searchVC = [[SearchViewController alloc]init];
    searchVC.searchType = searchTypeNew;
    [self.navigationController pushViewController:searchVC animated:YES];
    [self.customTabBarController hidesTabBar:YES animated:YES];
    return NO;
}

-(void)toSearchPage
{
    SearchViewController* searchVC = [[SearchViewController alloc]init];
    searchVC.searchType = searchTypeNew;
    [self.navigationController pushViewController:searchVC animated:YES];
    [self.customTabBarController hidesTabBar:YES animated:YES];
}
#pragma mark - load data
- (void)loadHistory
{
    [_allListDS loadHistorySuccess:^{
        [_tableV reloadData];
        [self reloadData];
    } failure:^{
        
    }];
}
- (void)reloadDataSource
{
    [_dataSource reloadDataSuccess:^{
        [_refreshView endRefreshFinish:^{
            [UIView animateWithDuration:0.3 animations:^{
                self.tableV.contentOffset = CGPointMake(0, 0);
            }];
            _refreshView.slime.hidden = NO;
        }];
        [_tableV reloadData];
    } failure:^{
        [_refreshView endRefreshFinish:^{
            [UIView animateWithDuration:0.3 animations:^{
                self.tableV.contentOffset = CGPointMake(0, 0);
            }];
            _refreshView.slime.hidden = NO;
        }];
    }];
}
- (void)loadMoreDataSource
{
    [_dataSource loadMoreDataSuccess:^{
        [_footerView endRefreshing];
        [_tableV reloadData];
    } failure:^{
        [_footerView endRefreshing];
    }];
}
#pragma mark - edit article view delegate
-(void)editArticleViewDidEdit:(Article*)aricle
{
    ArticleViewController * articleVC = [[ArticleViewController alloc]init];
    articleVC.articleID = aricle.articleID;
    [self.navigationController pushViewController:articleVC animated:YES];
    [self.customTabBarController hidesTabBar:YES animated:YES];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
