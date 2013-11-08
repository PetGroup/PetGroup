//
//  OnceCircleViewController.m
//  PetGroup
//
//  Created by 阿铛 on 13-10-15.
//  Copyright (c) 2013年 Tolecen. All rights reserved.
//

#import "OnceCircleViewController.h"
#import "TempData.h"
#import "articleCell.h"
#import "BHExpandingTextView.h"
#import "EGOImageView.h"
#import "EditArticleViewController.h"
#import "MJRefresh.h"
#import "SearchViewController.h"
#import "hotPintsDataSource.h"
#import "AllArticleDataSource.h"
#import "GoodArticleDataSource.h"
#import "NewReplyArticleDataSource.h"
#import "NewPublishArticleDataSource.h"
#import "ArticleViewController.h"
#import "MJRefresh.h"
#import "SRRefreshView.h"

@interface OnceCircleViewController ()<UITableViewDelegate,BHExpandingTextViewDelegate,MJRefreshBaseViewDelegate,SRRefreshDelegate>
{
    UIButton* joinB;
    hotPintsDataSource* hotPintsDS;
}
@property (nonatomic,retain)UIImageView* screenV;
@property (nonatomic,retain)UITableView* tableV;
@property (nonatomic,retain)SRRefreshView* refreshView;
@property (strong,nonatomic) MJRefreshFooterView *footer;
@property (nonatomic,retain)AllArticleDataSource* allArticleDS;
@property (nonatomic,retain)GoodArticleDataSource* goodArticleDS;
@property (nonatomic,retain)NewReplyArticleDataSource* replyArticleDS;
@property (nonatomic,retain)NewPublishArticleDataSource* publishArticleDS;
@end

@implementation OnceCircleViewController

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
    float diffH = [Common diffHeight:self];
    UIImageView *TopBarBGV=[[UIImageView alloc]initWithImage:[UIImage imageNamed:diffH==0?@"topBar1.png":@"topBar2.png"]];
    [TopBarBGV setFrame:CGRectMake(0, 0, 320, 44+diffH)];
    [self.view addSubview:TopBarBGV];
    
    UIButton *backButton=[UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame=CGRectMake(0, 0+diffH, 80, 44);
    [backButton setBackgroundImage:[UIImage imageNamed:@"back2.png"] forState:UIControlStateNormal];
    [self.view addSubview:backButton];
    [backButton addTarget:self action:@selector(backButton) forControlEvents:UIControlEventTouchUpInside];
    
    CGSize size = [self.circleEntity.name sizeWithFont:[UIFont systemFontOfSize:18]];
    UILabel *  titleLabel=[[UILabel alloc] initWithFrame:CGRectMake((320-size.width-15)/2, (44-size.height)/2+diffH, size.width, size.height)];
    titleLabel.backgroundColor=[UIColor clearColor];
    [titleLabel setText:self.circleEntity.name];
    [titleLabel setFont:[UIFont boldSystemFontOfSize:18]];
    titleLabel.textAlignment=NSTextAlignmentCenter;
    titleLabel.textColor=[UIColor whiteColor];
    [self.view addSubview:titleLabel];
    
    UIImageView* xialaIV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"xiala_bg"]];
    xialaIV.frame = CGRectMake(titleLabel.frame.origin.x+size.width, 0+diffH, 15, 44);
    [self.view addSubview:xialaIV];
    
    UIButton* xialaB = [UIButton buttonWithType:UIButtonTypeCustom];
    xialaB.frame = CGRectMake(titleLabel.frame.origin.x, diffH, titleLabel.frame.origin.x+size.width+15, 44);
    [xialaB addTarget:self action:@selector(screen) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:xialaB];
    
    UIButton *publishButton=[UIButton buttonWithType:UIButtonTypeCustom];
    publishButton.frame=CGRectMake(278, 3+diffH, 35, 33);
    [publishButton setBackgroundImage:[UIImage imageNamed:@"fabu"] forState:UIControlStateNormal];
    [publishButton addTarget:self action:@selector(updateSelfMassage) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:publishButton];
    
    UIView* headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 100)];
    headView.backgroundColor = [UIColor colorWithRed:238.0/255 green:238.0/255 blue:238.0/255 alpha:1];
    
    UILabel* lineL = [[UILabel alloc]initWithFrame:CGRectMake(0, 99, 320, 1)];
    lineL.backgroundColor = [UIColor grayColor];
    lineL.alpha = 0.3;
    [headView addSubview:lineL];
    
    EGOImageView* imageV = [[EGOImageView alloc]initWithFrame:CGRectMake(10, 10, 80, 80)];
    imageV.placeholderImage = [UIImage imageNamed:@"headbg"];
    imageV.imageURL = [NSURL URLWithString:[NSString stringWithFormat:BaseImageUrl"%@",self.circleEntity.imageID]];
    [headView addSubview:imageV];
    
    UILabel * nameL = [[UILabel alloc]initWithFrame:CGRectMake(100, 20, 100, 20)];
    nameL.backgroundColor = [UIColor clearColor];
    nameL.font = [UIFont boldSystemFontOfSize:18];
    nameL.backgroundColor = [UIColor clearColor];
    nameL.text = self.circleEntity.name;
    [headView addSubview:nameL];
    
    UILabel * huatiL = [[UILabel alloc]initWithFrame:CGRectMake(200, 30, 60, 10)];
    huatiL.backgroundColor = [UIColor clearColor];
    huatiL.font = [UIFont systemFontOfSize:10];
    huatiL.textColor = [UIColor grayColor];
    huatiL.text = [NSString stringWithFormat:@"话题:%@",self.circleEntity.totalCount];
    [headView addSubview:huatiL];
    
    UILabel * replyL = [[UILabel alloc]initWithFrame:CGRectMake(260, 30, 60, 10)];
    replyL.backgroundColor = [UIColor clearColor];
    replyL.font = [UIFont systemFontOfSize:10];
    replyL.textColor = [UIColor grayColor];
    replyL.text = [NSString stringWithFormat:@"回复:%@",self.circleEntity.totalReply];
    [headView addSubview:replyL];
    
    UIImageView* personIV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"ren"]];
    personIV.frame = CGRectMake(100, 65, 13.5, 8.5);
    [headView addSubview:personIV];
    UILabel* personL = [[UILabel alloc]initWithFrame:CGRectMake(113.5, 65, 100, 10)];
    personL.backgroundColor = [UIColor clearColor];
    personL.font = [UIFont systemFontOfSize:10];
    personL.textColor = [UIColor grayColor];
    personL.text = [NSString stringWithFormat:@"%@人",self.circleEntity.totalAtte];
    [headView addSubview:personL];
    
    joinB = [UIButton buttonWithType:UIButtonTypeCustom];
    joinB.frame = CGRectMake(240, 60, 71, 20);
    if (self.circleEntity.atte) {
        [joinB setBackgroundImage:[UIImage imageNamed:@"yijiaru"] forState:UIControlStateNormal];
    }else{
        [joinB setBackgroundImage:[UIImage imageNamed:@"jiaru"] forState:UIControlStateNormal];
    }
    [joinB addTarget:self action:@selector(joinOnceCircle) forControlEvents:UIControlEventTouchUpInside];
    [headView addSubview:joinB];
    
    self.tableV = [[UITableView alloc]initWithFrame:CGRectMake(0, 44+diffH, 320, self.view.frame.size.height-44-diffH)];
    _tableV.delegate = self;
    _tableV.rowHeight = 100;
    _tableV.tableHeaderView = headView;
    [self.view addSubview:_tableV];
    
    self.allArticleDS = [[AllArticleDataSource alloc]init];
    _allArticleDS.forumPid = self.circleEntity.circleID;
    _allArticleDS.myController = self;
    _tableV.dataSource = _allArticleDS;
    hotPintsDS = _allArticleDS;
    [self reloadData];
    
    self.screenV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"shaixuan_bg"]];
    _screenV.frame = CGRectMake(0, 32+diffH, 320, 152);
    _screenV.userInteractionEnabled = YES;
    _screenV.hidden = YES;
    _screenV.alpha = 0;
    [self.view addSubview:_screenV];
    
    UIButton *allB = [UIButton buttonWithType:UIButtonTypeCustom];
    [allB setTitle:@"全部" forState:UIControlStateNormal];
    [allB setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    [allB setBackgroundImage:[UIImage imageNamed:@"shaixuan_normal"] forState:UIControlStateNormal];
    [allB setBackgroundImage:[UIImage imageNamed:@"shaixuan_click"] forState:UIControlStateHighlighted];
    allB.frame = CGRectMake(19, 20, 131.5, 32);
    allB.tag = 1;
    [allB addTarget:self action:@selector(changeDataSource:) forControlEvents:UIControlEventTouchUpInside];
    [_screenV addSubview:allB];
    
    UIButton *goodB = [UIButton buttonWithType:UIButtonTypeCustom];
    [goodB setTitle:@"精华" forState:UIControlStateNormal];
    [goodB setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [goodB setBackgroundImage:[UIImage imageNamed:@"shaixuan_normal"] forState:UIControlStateNormal];
    [goodB setBackgroundImage:[UIImage imageNamed:@"shaixuan_click"] forState:UIControlStateHighlighted];
    goodB.frame = CGRectMake(169.5, 20, 131.5, 32);
    goodB.tag = 2;
    [goodB addTarget:self action:@selector(changeDataSource:) forControlEvents:UIControlEventTouchUpInside];
    [_screenV addSubview:goodB];
    
    UIButton *latestReply = [UIButton buttonWithType:UIButtonTypeCustom];
    [latestReply setTitle:@"最新回复" forState:UIControlStateNormal];
    [latestReply setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [latestReply setBackgroundImage:[UIImage imageNamed:@"shaixuan_normal"] forState:UIControlStateNormal];
    [latestReply setBackgroundImage:[UIImage imageNamed:@"shaixuan_click"] forState:UIControlStateHighlighted];
    latestReply.frame = CGRectMake(19, 70, 131.5, 32);
    latestReply.tag = 3;
    [latestReply addTarget:self action:@selector(changeDataSource:) forControlEvents:UIControlEventTouchUpInside];
    [_screenV addSubview:latestReply];
    
    UIButton *latestPublish = [UIButton buttonWithType:UIButtonTypeCustom];
    [latestPublish setTitle:@"最新发布" forState:UIControlStateNormal];
    [latestPublish setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [latestPublish setBackgroundImage:[UIImage imageNamed:@"shaixuan_normal"] forState:UIControlStateNormal];
    [latestPublish setBackgroundImage:[UIImage imageNamed:@"shaixuan_click"] forState:UIControlStateHighlighted];
    latestPublish.frame = CGRectMake(169.5, 70, 131.5, 32);
    latestPublish.tag = 4;
    [latestPublish addTarget:self action:@selector(changeDataSource:) forControlEvents:UIControlEventTouchUpInside];
    [_screenV addSubview:latestPublish];
    
    UIButton * searchB = [UIButton buttonWithType:UIButtonTypeCustom];
    searchB.frame = CGRectMake(0, 107, 320, 45);
    [searchB setBackgroundImage:[UIImage imageNamed:@"search_bg"] forState:UIControlStateNormal];
    [searchB addTarget:self action:@selector(showSearchView) forControlEvents:UIControlEventTouchUpInside];
    [_screenV addSubview:searchB];
    
    self.footer = [[MJRefreshFooterView alloc] init];
    _footer.delegate = self;
    _footer.scrollView = self.tableV;
    
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
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - button action
-(void)backButton
{
    [_footer free];
    [[TempData sharedInstance] Panned:NO];
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)updateSelfMassage
{
    EditArticleViewController* editAVC = [[EditArticleViewController alloc]init];
    editAVC.forumId = self.circleEntity.circleID;
    editAVC.forumName = self.circleEntity.name;
    [self.navigationController pushViewController:editAVC animated:YES];

}
-(void)joinOnceCircle
{
    self.circleEntity.atte = !self.circleEntity.atte;
    if (self.circleEntity.atte) {
        [joinB setBackgroundImage:[UIImage imageNamed:@"yijiaru"] forState:UIControlStateNormal];
        NSTimeInterval cT = [[NSDate date] timeIntervalSince1970];
        long long a = (long long)(cT*1000);
        NSMutableDictionary* params = [NSMutableDictionary dictionary];
        [params setObject:self.circleEntity.circleID forKey:@"forumId"];
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
        [joinB setBackgroundImage:[UIImage imageNamed:@"jiaru"] forState:UIControlStateNormal];
        NSTimeInterval cT = [[NSDate date] timeIntervalSince1970];
        long long a = (long long)(cT*1000);
        NSMutableDictionary* params = [NSMutableDictionary dictionary];
        [params setObject:self.circleEntity.circleID forKey:@"forumId"];
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
-(void)screen
{
    if (_screenV.hidden) {
        _screenV.hidden = NO;
        [UIView animateWithDuration:0.3 animations:^{
            _screenV.alpha = 1;
        }];
    }else{
        [UIView animateWithDuration:0.3 animations:^{
            _screenV.alpha = 0;
        } completion:^(BOOL finished) {
            _screenV.hidden = YES;
        }];
    }
}
-(void)changeDataSource:(UIButton*)button
{
    for (UIButton* b in _screenV.subviews) {
        if (button.tag==b.tag) {
            [b setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
        }else
            [b setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }
    switch (button.tag) {
        case 1:{
            if (self.allArticleDS == nil) {
                self.allArticleDS = [[AllArticleDataSource alloc]init];
                _allArticleDS.forumPid = self.circleEntity.circleID;
                _allArticleDS.myController = self;
                _tableV.dataSource = _allArticleDS;
                hotPintsDS = _allArticleDS;
                [self reloadData];
            }else{
                _tableV.dataSource = _allArticleDS;
                hotPintsDS = _allArticleDS;
                [self.tableV reloadData];
            }
        }break;
        case 2:{
            if (self.goodArticleDS == nil) {
                self.goodArticleDS = [[GoodArticleDataSource alloc]init];
                _goodArticleDS.forumPid = self.circleEntity.circleID;
                _goodArticleDS.myController = self;
                _tableV.dataSource = _goodArticleDS;
                hotPintsDS = _goodArticleDS;
                [self reloadData];
            }else{
                _tableV.dataSource = _goodArticleDS;
                hotPintsDS = _goodArticleDS;
                [self.tableV reloadData];
            }
        }break;
        case 3:{
            if (self.replyArticleDS == nil) {
                self.replyArticleDS = [[NewReplyArticleDataSource alloc]init];
                _replyArticleDS.forumPid = self.circleEntity.circleID;
                _replyArticleDS.myController = self;
                _tableV.dataSource = _replyArticleDS;
                hotPintsDS = _replyArticleDS;
                [self reloadData];
            }else{
                _tableV.dataSource = _replyArticleDS;
                hotPintsDS = _replyArticleDS;
                [self.tableV reloadData];
            }
        }break;
        case 4:{
            if (self.publishArticleDS == nil) {
                self.publishArticleDS = [[NewPublishArticleDataSource alloc]init];
                _publishArticleDS.forumPid = self.circleEntity.circleID;
                _publishArticleDS.myController = self;
                _tableV.dataSource = _publishArticleDS;
                hotPintsDS = _publishArticleDS;
                [self reloadData];
            }else{
                _tableV.dataSource = _publishArticleDS;
                hotPintsDS = _publishArticleDS;
                [self.tableV reloadData];
            }
        }break;
            
        default:
            break;
    }
    [self screen];
}
-(void)showSearchView
{
    SearchViewController* searchVC = [[SearchViewController alloc]init];
    searchVC.forumPid = self.circleEntity.circleID;
    [self.navigationController pushViewController:searchVC animated:YES];
}
#pragma mark - table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    ArticleViewController * articleVC = [[ArticleViewController alloc]init];
    articleVC.articleID = ((Article*)hotPintsDS.dataSourceArray[indexPath.row]).articleID;
    [self.navigationController pushViewController:articleVC animated:YES];
}
#pragma mark MJRefreshBaseView delegate
- (void)refreshViewBeginRefreshing:(MJRefreshBaseView *)refreshView
{
    if (refreshView == _footer) {
        [self loadMoreData];
        return;
    }
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
#pragma mark - load data
-(void)reloadData
{
    [hotPintsDS reloadDataSuccess:^{
        [self.tableV reloadData];
        [_refreshView endRefresh];
    } failure:^{
        [_refreshView endRefresh];
    }];
}
-(void)loadMoreData
{
    [hotPintsDS loadMoreDataSuccess:^{
        [self.tableV reloadData];
        [_footer endRefreshing];
    } failure:^{
        [_footer endRefreshing];
    }];
}
@end
