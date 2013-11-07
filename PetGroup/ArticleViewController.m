//
//  ArticleViewController.m
//  PetGroup
//
//  Created by 阿铛 on 13-10-22.
//  Copyright (c) 2013年 Tolecen. All rights reserved.
//

#import "ArticleViewController.h"
#import "TempData.h"
#import "OwenrCell.h"
#import "AriticleContent.h"
#import "PhotoViewController.h"
#import "WebViewViewController.h"
#import "EditReplyViewController.h"
#import "NoteReply.h"
#import "FollowerCell.h"
#import "SomeOneDynamicViewController.h"
#import "HostInfo.h"
#import "PersonDetailViewController.h"
@interface ArticleViewController ()<UITableViewDataSource,UITableViewDelegate,OwenrCellDelegate,followerCellDelegate,EditReplyViewDelegate>
{
    UIButton * nextB;
    UIButton* showB ;
}
@property (nonatomic,retain)NSMutableArray* dataSourceArray;
@property (nonatomic,retain)NSMutableArray* replyHighArray;
@property (nonatomic,retain)NSString* owenrCellHigh;
@property (nonatomic,retain)AriticleContent* ariticle;
@property (nonatomic,retain)UITableView*tableV;
@property (nonatomic,assign)int pageNo;
@property (nonatomic,retain)NSAttributedString* content;
@property (nonatomic,retain)UIView* pageV;
@end

@implementation ArticleViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.dataSourceArray = [NSMutableArray array];
        self.replyHighArray =[NSMutableArray array];
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
    
    nextB = [UIButton buttonWithType:UIButtonTypeCustom];
    nextB.frame = CGRectMake(245, 5+diffH, 70, 34);
    [nextB setTitle:@"只看楼主" forState:UIControlStateNormal];
    nextB.titleLabel.font = [UIFont systemFontOfSize:14];
    if (diffH==0) {
        [nextB setBackgroundImage:[UIImage imageNamed:@"youshangjiao_normal"] forState:UIControlStateNormal];
        [nextB setBackgroundImage:[UIImage imageNamed:@"youshangjiao_click"] forState:UIControlStateHighlighted];
        
    }
    [nextB addTarget:self action:@selector(next) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:nextB];
    
    UILabel *  titleLabel=[[UILabel alloc] initWithFrame:CGRectMake(50, 2+diffH, 220, 40)];
    titleLabel.backgroundColor=[UIColor clearColor];
    [titleLabel setText:@"帖子详情"];
    [titleLabel setFont:[UIFont boldSystemFontOfSize:18]];
    titleLabel.textAlignment=NSTextAlignmentCenter;
    titleLabel.textColor=[UIColor whiteColor];
    [self.view addSubview:titleLabel];
    
    self.tableV = [[UITableView alloc]initWithFrame:CGRectMake(0, 44+diffH, 320, self.view.frame.size.height-93-diffH)];
    _tableV.delegate = self;
    _tableV.dataSource = self;
    [self.view addSubview:_tableV];
    
    UIImageView* bottomIV = [[UIImageView alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height-49, 320, 49)];
    bottomIV.image = [UIImage imageNamed:@"dibuanniu_bg"];
    bottomIV.userInteractionEnabled = YES;
    [self.view addSubview:bottomIV];
    
    showB = [UIButton buttonWithType:UIButtonTypeCustom];
    [showB setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [showB setTitle:@"分页" forState:UIControlStateNormal];
    showB.frame = CGRectMake(10, 4.5, 60, 40);
    [showB addTarget:self action:@selector(changePageView) forControlEvents:UIControlEventTouchUpInside];
    showB.userInteractionEnabled = NO;
    [bottomIV addSubview:showB];
    
    UIButton* replyB = [UIButton  buttonWithType:UIButtonTypeCustom];
    [replyB setTitle:@"回复" forState:UIControlStateNormal];
    [replyB setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [replyB addTarget:self action:@selector(owenrCellPressReplyButton) forControlEvents:UIControlEventTouchUpInside];
    replyB.frame = CGRectMake(80, 4.5, 240, 40);
    [bottomIV addSubview:replyB];
    
    NSTimeInterval cT = [[NSDate date] timeIntervalSince1970];
    long long a = (long long)(cT*1000);
    NSMutableDictionary* params = [NSMutableDictionary dictionary];
    [params setObject:self.articleID forKey:@"noteId"];
    NSMutableDictionary* body = [NSMutableDictionary dictionary];
    [body setObject:params forKey:@"params"];
    [body setObject:@"getNoteById" forKey:@"method"];
    [body setObject:@"service.uri.pet_bbs" forKey:@"service"];
    [body setObject:@"1" forKey:@"channel"];
    [body setObject:[SFHFKeychainUtils getPasswordForUsername:MACADDRESS andServiceName:LOCALACCOUNT error:nil] forKey:@"mac"];
    [body setObject:@"iphone" forKey:@"imei"];
    [body setObject:[NSString stringWithFormat:@"%lld",a] forKey:@"connectTime"];
    [body setObject:[SFHFKeychainUtils getPasswordForUsername:LOCALTOKEN andServiceName:LOCALACCOUNT error:nil] forKey:@"token"];
    [NetManager requestWithURLStr:BaseClientUrl Parameters:body TheController:self success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@",responseObject);
        self.ariticle = [[AriticleContent alloc]initWithDictionnary:responseObject];
        self.owenrCellHigh = [NSString stringWithFormat:@"%f",[OwenrCell heightForRowWithArticle:self.ariticle]];
        [self.tableV reloadData];
        if ([self.ariticle.replyCount integerValue]%20?[self.ariticle.replyCount integerValue]/20+1:[self.ariticle.replyCount integerValue]/20>1) {
            showB.userInteractionEnabled = YES;
        }
        else{
            showB.userInteractionEnabled = NO;
        }
        self.pageNo = 0;
        [self loadMoreData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - button action
-(void)next
{
    if ([nextB.titleLabel.text isEqualToString:@"只看楼主"]) {
        [nextB setTitle:@"查看全部" forState:UIControlStateNormal];
        self.pageNo = 0;
        [self loadMoreData];
        if ([self.ariticle.cTotalReply integerValue]%20?[self.ariticle.cTotalReply integerValue]/20+1:[self.ariticle.cTotalReply integerValue]/20>1) {
            showB.userInteractionEnabled = YES;
        }
        else{
            showB.userInteractionEnabled = NO;
        }
    }else{
        [nextB setTitle:@"只看楼主" forState:UIControlStateNormal];
        self.pageNo = 0;
        [self loadMoreData];
        if ([self.ariticle.replyCount integerValue]%20?[self.ariticle.replyCount integerValue]/20+1:[self.ariticle.replyCount integerValue]/20>1) {
            showB.userInteractionEnabled = YES;
        }
        else{
            showB.userInteractionEnabled = NO;
        }
    }
}
-(void)backButton
{
    [[TempData sharedInstance] Panned:NO];
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)changePageView
{
    if ([self.view.subviews containsObject:self.pageV]) {
        [UIView animateWithDuration:0.3 animations:^{
            _pageV.frame = CGRectMake(0, self.view.frame.size.height, 320, 44);
        }completion:^(BOOL finished) {
            [_pageV removeFromSuperview];
        }];
        return;
    }
    self.pageV = [[UIView alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height, 320, 44)];
    [self.view addSubview:_pageV];
    _pageV.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
    UIScrollView* scV = [[UIScrollView alloc]initWithFrame:CGRectMake(60, 0, 200, 44)];
    [_pageV addSubview:scV];
    int a = 0;
    if ([nextB.titleLabel.text isEqualToString:@"只看楼主"]) {
        a =[self.ariticle.replyCount intValue]%20?[self.ariticle.replyCount intValue]/20+1:[self.ariticle.replyCount intValue]/20;
    }else{
        a =[self.ariticle.cTotalReply intValue]%20?[self.ariticle.cTotalReply intValue]/20+1:[self.ariticle.cTotalReply intValue]/20;
    }
    scV.contentSize = CGSizeMake(a*40, 44);
    float x = 0;
    for (int i = 1; i<=a; i++) {
        UIButton * pageB = [UIButton buttonWithType:UIButtonTypeCustom];
        pageB.tag = i;
        [pageB setTitle:[NSString stringWithFormat:@"%d",i] forState:UIControlStateNormal];
        pageB.frame = CGRectMake(x, 0, 40, 44);
        x+=40;
        [scV addSubview:pageB];
        if (i != self.pageNo+1) {
            [pageB addTarget:self action:@selector(pageSelect:) forControlEvents:UIControlEventTouchUpInside];
        }
    }
    UIButton * liftB = [UIButton buttonWithType:UIButtonTypeCustom];
    liftB.frame = CGRectMake(0, 0, 60, 44);
    [liftB setTitle:@"左" forState:UIControlStateNormal];
    [_pageV addSubview:liftB];
    if (self.pageNo > 0) {
        [liftB addTarget:self action:@selector(pageUp) forControlEvents:UIControlEventTouchUpInside];
    }
    UIButton * rightB = [UIButton buttonWithType:UIButtonTypeCustom];
    rightB.frame = CGRectMake(260, 0, 60, 44);
    [rightB setTitle:@"右" forState:UIControlStateNormal];
    [_pageV addSubview:rightB];
    if (self.pageNo < a-1) {
        [rightB addTarget:self action:@selector(pageDown) forControlEvents:UIControlEventTouchUpInside];
    }
    [self.view insertSubview:_pageV aboveSubview:_tableV];
    [UIView animateWithDuration:0.3 animations:^{
        _pageV.frame = CGRectMake(0, self.view.frame.size.height-88, 320, 44);
    }];
    
}
-(void)pageUp
{
    [UIView animateWithDuration:0.3 animations:^{
        _pageV.frame = CGRectMake(0, self.view.frame.size.height, 320, 44);
    }completion:^(BOOL finished) {
        [_pageV removeFromSuperview];
    }];
    self.pageNo--;
    [self loadMoreData];
}
-(void)pageDown
{
    [UIView animateWithDuration:0.3 animations:^{
        _pageV.frame = CGRectMake(0, self.view.frame.size.height, 320, 44);
    }completion:^(BOOL finished) {
        [_pageV removeFromSuperview];
    }];
    self.pageNo++;
    [self loadMoreData];
}
-(void)pageSelect:(UIButton*)but
{
    [UIView animateWithDuration:0.3 animations:^{
        _pageV.frame = CGRectMake(0, self.view.frame.size.height, 320, 44);
    }completion:^(BOOL finished) {
        [_pageV removeFromSuperview];
    }];
    self.pageNo = but.tag-1;
    [self loadMoreData];
}
#pragma mark - table view delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return [self.owenrCellHigh floatValue];
    }
    return [self.replyHighArray[indexPath.row] floatValue];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

}
#pragma mark - table view data source
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    }else
        return self.dataSourceArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        static NSString *cellIdentifier = @"OwnerCell";
        OwenrCell*cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier ];
        if (cell == nil) {
            cell = [[OwenrCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
            cell.delegate = self;
        }
        cell.article = self.ariticle;
        return cell;
    }
    static NSString *cellIdentifier = @"Cell";
    FollowerCell*cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier ];
    if (cell == nil) {
        cell = [[FollowerCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
        cell.delegate = self;
    }
    cell.reply = self.dataSourceArray[indexPath.row];
    cell.indexPath = indexPath;
    return cell;
}
#pragma mark - OwenrCell Delegate
-(void)owenrCellPressReplyButton//回复
{
    EditReplyViewController* replyVC = [[EditReplyViewController alloc]init];
    replyVC.articleID = self.articleID;
    replyVC.delegate = self;
    [self presentViewController:replyVC animated:YES completion:nil];
}
-(void)owenrCellPressReportButton//举报
{//
    NSTimeInterval cT = [[NSDate date] timeIntervalSince1970];
    long long a = (long long)(cT*1000);
    NSMutableDictionary* params = [NSMutableDictionary dictionary];
    [params setObject:self.articleID forKey:@"noteId"];
    NSMutableDictionary* body = [NSMutableDictionary dictionary];
    [body setObject:params forKey:@"params"];
    [body setObject:@"reportNote" forKey:@"method"];
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
}
-(void)owenrCellPressImageWithID:(NSString*)imageID//查看大图
{
    PhotoViewController* photoVC = [[PhotoViewController alloc]initWithSmallImages:nil images:@[imageID] indext:0];
    [self presentViewController:photoVC animated:NO completion:nil];
}
-(void)owenrCellPressWithURL:(NSURL*)URL
{
    WebViewViewController* webVC = [[WebViewViewController alloc]init];
    webVC.addressURL = URL;
    [self.navigationController pushViewController:webVC animated:YES];
    
}
-(void)owenrCellPressNameButtonOrHeadButton
{
    if ([self.ariticle.userId isEqualToString:[[TempData sharedInstance] getMyUserID]]) {
        SomeOneDynamicViewController* sodVC = [[SomeOneDynamicViewController alloc]init];
        sodVC.userInfo = [[HostInfo alloc]initWithNewHostInfo:[DataStoreManager queryMyInfo] PetsArray:nil];
        [self.navigationController pushViewController:sodVC animated:YES];
        return;
    }
    PersonDetailViewController* personDVC = [[PersonDetailViewController alloc]init];
    personDVC.hostInfo = [[HostInfo alloc]init];
    personDVC.hostInfo.userId = self.ariticle.userId;
    personDVC.needRequest = YES;
    personDVC.needRequestPet = YES;
    [self.navigationController pushViewController:personDVC animated:YES];
}
#pragma mark -  followerCellDelegate
-(void)followerCellPressNameButtonOrHeadButtonAtIndexPath:(NSIndexPath *)indexPath
{
    if ([((NoteReply*)self.dataSourceArray[indexPath.row]).userID isEqualToString:[[TempData sharedInstance] getMyUserID]]) {
        SomeOneDynamicViewController* sodVC = [[SomeOneDynamicViewController alloc]init];
        sodVC.userInfo = [[HostInfo alloc]initWithNewHostInfo:[DataStoreManager queryMyInfo] PetsArray:nil];
        [self.navigationController pushViewController:sodVC animated:YES];
        return;
    }
    PersonDetailViewController* personDVC = [[PersonDetailViewController alloc]init];
    personDVC.hostInfo = [[HostInfo alloc]init];
    personDVC.hostInfo.userId = ((NoteReply*)self.dataSourceArray[indexPath.row]).userID;
    personDVC.needRequest = YES;
    personDVC.needRequestPet = YES;
    [self.navigationController pushViewController:personDVC animated:YES];
}
-(void)followerCellPressReplyButtonAtIndexPath:(NSIndexPath *)indexPath
{
    EditReplyViewController* replyVC = [[EditReplyViewController alloc]init];
    replyVC.articleID = self.articleID;
    replyVC.delegate = self;
    replyVC.row = [((NoteReply*)self.dataSourceArray[indexPath.row]).seq intValue]+1;
    replyVC.replyID = ((NoteReply*)self.dataSourceArray[indexPath.row]).replyID;
    [self presentViewController:replyVC animated:YES completion:nil];
}
-(void)followerCellPressReportButtonAtIndexPath:(NSIndexPath *)indexPath
{
    NSTimeInterval cT = [[NSDate date] timeIntervalSince1970];
    long long a = (long long)(cT*1000);
    NSMutableDictionary* params = [NSMutableDictionary dictionary];
    [params setObject:((NoteReply*)self.dataSourceArray[indexPath.row]).replyID forKey:@"replyId"];
    
    NSMutableDictionary* body = [NSMutableDictionary dictionary];
    [body setObject:params forKey:@"params"];
    [body setObject:@"reportNote" forKey:@"method"];
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
}
-(void)followerCellPressImageWithID:(NSString*)imageID
{
    PhotoViewController* photoVC = [[PhotoViewController alloc]initWithSmallImages:nil images:@[imageID] indext:0];
    [self presentViewController:photoVC animated:NO completion:nil];
}
-(void)followerCellPressWithURL:(NSURL*)URL
{
    WebViewViewController* webVC = [[WebViewViewController alloc]init];
    webVC.addressURL = URL;
    [self.navigationController pushViewController:webVC animated:YES];
}
#pragma mark - load data
-(void)loadMoreData
{
    NSTimeInterval cT = [[NSDate date] timeIntervalSince1970];
    long long a = (long long)(cT*1000);
    NSMutableDictionary* params = [NSMutableDictionary dictionary];
    if (![nextB.titleLabel.text isEqualToString:@"只看楼主"]) {
        [params setObject:self.ariticle.userId forKey:@"userId"];
    }
    [params setObject:[NSString stringWithFormat:@"%d",self.pageNo] forKey:@"pageNo"];
    [params setObject:self.articleID forKey:@"noteId"];
    [params setObject:@"20" forKey:@"pageSize"];
    NSMutableDictionary* body = [NSMutableDictionary dictionary];
    [body setObject:params forKey:@"params"];
    [body setObject:@"getReplyList" forKey:@"method"];
    [body setObject:@"service.uri.pet_bbs" forKey:@"service"];
    [body setObject:@"1" forKey:@"channel"];
    [body setObject:[SFHFKeychainUtils getPasswordForUsername:MACADDRESS andServiceName:LOCALACCOUNT error:nil] forKey:@"mac"];
    [body setObject:@"iphone" forKey:@"imei"];
    [body setObject:[NSString stringWithFormat:@"%lld",a] forKey:@"connectTime"];
    [body setObject:[SFHFKeychainUtils getPasswordForUsername:LOCALTOKEN andServiceName:LOCALACCOUNT error:nil] forKey:@"token"];
    [NetManager requestWithURLStr:BaseClientUrl Parameters:body TheController:self success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@",responseObject);
        [self.dataSourceArray removeAllObjects];
        NSArray* array = [responseObject objectForKey:@"data"];
        if (array.count>0) {
            for (NSDictionary* dic in array) {
                NoteReply* rep = [[NoteReply alloc]initWithDictionnary:dic];
                [self.dataSourceArray addObject:rep];
            }
            [self.replyHighArray removeAllObjects];
            for (NoteReply* rep in self.dataSourceArray) {
                float high = [FollowerCell heightForRowWithArticle:rep];
                [self.replyHighArray addObject:[NSString stringWithFormat:@"%f",high]];
            }
        }
        [self.tableV reloadData];
        if (array.count>0) {
            if (self.pageNo == 0) {
                [_tableV scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition: UITableViewScrollPositionTop animated:YES];
            }else{
                [_tableV scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1] atScrollPosition: UITableViewScrollPositionTop animated:YES];
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}
-(void)editReplyViewDidEdit
{
    self.pageNo = 0;
    [self loadMoreData];
}
@end
