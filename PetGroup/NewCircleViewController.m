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
@interface NewCircleViewController ()<UITableViewDelegate,SRRefreshDelegate,MJRefreshBaseViewDelegate>
{
    float diffH;
    CGPoint centerPoint;
    
    BOOL open;
    
    UIButton* allB;
    UIButton* shareB;
    UIButton* helpB;
    UIButton* marryB;
    UIButton* exB;
    NewArticleListDataSource* _dataSource;
}
@property (nonatomic,retain)UITableView* tableV;
@property (nonatomic,retain)SRRefreshView* refreshView;
@property (nonatomic,retain)MJRefreshFooterView* footerView;
@property (nonatomic,retain)NSMutableArray* buttonArray;
@property (nonatomic,retain)NewArticleListDataSource * allListDS;
@property (nonatomic,retain)NewArticleListDataSource * shareListDS;
@property (nonatomic,retain)NewArticleListDataSource * helpListDS;
@property (nonatomic,retain)NewArticleListDataSource * marryListDS;
@property (nonatomic,retain)NewArticleListDataSource * exListDS;
@end

@implementation NewCircleViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        open = NO;
        self.buttonArray = [NSMutableArray array];
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
    
    UIButton * subBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    subBtn.frame = CGRectMake(0, 0+diffH, 44, 44);
    [subBtn setBackgroundImage:[UIImage imageNamed:@"newsub"] forState:UIControlStateNormal];
    [subBtn.titleLabel setFont:[UIFont systemFontOfSize:15]];
    //    [nextB setTitle:@"新话题" forState:UIControlStateNormal];
    [subBtn addTarget:self action:@selector(toPublishPage) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:subBtn];
    
    UIButton * nextB = [UIButton buttonWithType:UIButtonTypeCustom];
    nextB.frame = CGRectMake(276, 0+diffH, 44, 44);
    [nextB setBackgroundImage:[UIImage imageNamed:@"newpublish2"] forState:UIControlStateNormal];
    [nextB.titleLabel setFont:[UIFont systemFontOfSize:15]];
//    [nextB setTitle:@"新话题" forState:UIControlStateNormal];
    [nextB addTarget:self action:@selector(toPublishPage) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:nextB];
    
    UIImageView * tabIV = [[UIImageView alloc]initWithFrame:CGRectMake(0, 44+diffH, 320, 49)];
    tabIV.image = [UIImage imageNamed:@"top_btn_bg"];
    tabIV.userInteractionEnabled = YES;
    [self.view addSubview:tabIV];
    
    UIButton* publishB = [UIButton buttonWithType:UIButtonTypeCustom];
    publishB.frame = CGRectMake(6.5, 6, 190.5, 37.5);
    [publishB setBackgroundImage:[UIImage imageNamed:@"punlishmain"] forState:UIControlStateNormal];
    [publishB addTarget:self action:@selector(publishNewArticle) forControlEvents:UIControlEventTouchUpInside];
    [tabIV addSubview:publishB];
    
    UIButton* subjectB = [UIButton buttonWithType:UIButtonTypeCustom];
    subjectB.frame = CGRectMake(202.5, 6, 111, 37.5);
    [subjectB setBackgroundImage:[UIImage imageNamed:@"subjectmain"] forState:UIControlStateNormal];
    [subjectB addTarget:self action:@selector(showSubject) forControlEvents:UIControlEventTouchUpInside];
    [tabIV addSubview:subjectB];
    
    self.tableV = [[UITableView alloc]initWithFrame:CGRectMake(0, 93+diffH, 320, self.view.frame.size.height-142-diffH)];
    _tableV.delegate = self;
    
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
    
    shareB = [UIButton buttonWithType:UIButtonTypeCustom];
    [shareB setBackgroundImage:[UIImage imageNamed:@"shaiingfu"] forState:UIControlStateNormal];
    shareB.frame = CGRectMake(0, 0, 50, 50);
    shareB.center = centerPoint;
    [shareB addTarget:self action:@selector(open:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:shareB];
    [_buttonArray addObject:shareB];
    
    helpB = [UIButton buttonWithType:UIButtonTypeCustom];
    [helpB setBackgroundImage:[UIImage imageNamed:@"faqiuzhu"] forState:UIControlStateNormal];
    helpB.frame = CGRectMake(0, 0, 50, 50);
    helpB.center = centerPoint;
    [helpB addTarget:self action:@selector(open:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:helpB];
    [_buttonArray addObject:helpB];
    
    marryB = [UIButton buttonWithType:UIButtonTypeCustom];
    [marryB setBackgroundImage:[UIImage imageNamed:@"qiuhunpei"] forState:UIControlStateNormal];
    marryB.frame = CGRectMake(0, 0, 50, 50);
    marryB.center = centerPoint;
    [marryB addTarget:self action:@selector(open:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:marryB];
    [_buttonArray addObject:marryB];
    
    exB = [UIButton buttonWithType:UIButtonTypeCustom];
    [exB setBackgroundImage:[UIImage imageNamed:@"qijingyan"] forState:UIControlStateNormal];
    exB.frame = CGRectMake(0, 0, 50, 50);
    exB.center = centerPoint;
    [exB addTarget:self action:@selector(open:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:exB];
    [_buttonArray addObject:exB];
    
    allB = [UIButton buttonWithType:UIButtonTypeCustom];
    [allB setBackgroundImage:[UIImage imageNamed:@"quanbu"] forState:UIControlStateNormal];
    allB.frame = CGRectMake(0, 0, 50, 50);
    allB.center = centerPoint;
    [allB addTarget:self action:@selector(open:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:allB];
    [_buttonArray insertObject:allB atIndex:0];
    
    self.allListDS = [[NewArticleListDataSource alloc]initWithAssortID:@"ALL"];
    _allListDS.myController = self;
    [self setDataSource:_allListDS];
    
    [NewArticleListDataSource viewController:self loadTagListSuccess:^(NSArray *tagArray) {
        self.shareListDS = [[NewArticleListDataSource alloc]initWithAssortID:tagArray[0]];
        _shareListDS.myController = self;
        self.exListDS = [[NewArticleListDataSource alloc]initWithAssortID:tagArray[1]];
        _exListDS.myController = self;
        self.marryListDS = [[NewArticleListDataSource alloc]initWithAssortID:tagArray[2]];
        _marryListDS.myController = self;
        self.helpListDS = [[NewArticleListDataSource alloc]initWithAssortID:tagArray[3]];
        _helpListDS.myController = self;
    } failure:^{
        
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - button action
- (void)reloadData
{
    if (_dataSource.dataSourceArray.count >0) {
        [_tableV reloadData];
    }else
    {
        [_refreshView setLoadingWithexpansion];
        [self reloadDataSource];
    }
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
    if (!open) {
        [self openButtons];
    }else{
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
    open = !open;
}
- (void)close
{
    if (open) {
        [self closeWithButton:nil Completion:nil];
        open = !open;
    }
    
}
- (void)closeWithButton:(UIButton*)button Completion:(void (^)(void))completion
{
    if (button) {
        [_buttonArray removeObject:button];
        [_buttonArray insertObject:button atIndex:0];
        [self.view bringSubviewToFront:button];
    }
    [UIView animateWithDuration:0.3
                     animations:^{
                         if (button) {
                             for (int i = 0; i<_buttonArray.count; i++) {
                                 ((UIView*)_buttonArray[i]).center  = CGPointMake(button.center.x, button.center.y);
                             }
                         }
                     } completion:^(BOOL finished) {
                         [UIView animateWithDuration:0.2
                                          animations:^{
                                              for (int i = 0; i<_buttonArray.count; i++) {
                                                  ((UIView*)_buttonArray[i]).center  = centerPoint;
                                              }
                                          } completion:^(BOOL finished) {
                                              if (completion) {
                                                   completion();
                                              }
                                             
                                          }];
                     }];
}
- (void)openButtons
{
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
                             
                         }];
    }else{
        [UIView animateWithDuration:0.3
                         animations:^{
                             for (int i = 0; i<_buttonArray.count; i++) {
                                 ((UIView*)_buttonArray[i]).center  = CGPointMake(((UIView*)_buttonArray[i]).center.x-i*60, ((UIView*)_buttonArray[i]).center.y);
                             }
                         } completion:^(BOOL finished) {
                             
                             
                         }];
    }
}
#pragma mark - tableView delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
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
        [_refreshView scrollViewDidScroll];
        [self close];
    }
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (scrollView == _tableV) {
        [_refreshView scrollViewDidEndDraging];
    }
}
#pragma mark - load data
- (void)loadHistory
{
    
}
- (void)reloadDataSource
{
    [_dataSource reloadDataSuccess:^{
        [_refreshView endRefresh];
        [_tableV reloadData];
    } failure:^{
        [_refreshView endRefresh];
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
