//
//  SubjectViewController.m
//  PetGroup
//
//  Created by wangxr on 14-1-2.
//  Copyright (c) 2014年 Tolecen. All rights reserved.
//

#import "SubjectViewController.h"
#import "TempData.h"
#import "RootCell.h"
#import "Subject.h"
#import "MJRefresh.h"
#import "SRRefreshView.h"

#define MySubject @"52petMySubject"
@interface SubjectViewController ()<UITableViewDataSource,UITableViewDelegate,MJRefreshBaseViewDelegate,SRRefreshDelegate>
@property (nonatomic,retain)UITableView* tableview;
@property (nonatomic,retain)NSMutableArray* array;
@property (nonatomic,retain)SRRefreshView* refreshView;
@property (strong,nonatomic)MJRefreshFooterView *footer;
@property (nonatomic,assign)int pageNo;
@end

@implementation SubjectViewController
- (void)dealloc
{
    [_footer free];
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.array = [NSMutableArray array];
    }
    return self;
}
-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor colorWithRed:0.90 green:0.90 blue:0.90 alpha:1]];
	// Do any additional setup after loading the view.
    float diffH = [Common diffHeight:self];
    UIImageView *TopBarBGV=[[UIImageView alloc]initWithImage:[UIImage imageNamed:diffH==0?@"topBar1.png":@"topBar2.png"]];
    [TopBarBGV setFrame:CGRectMake(0, 0, 320, 44+diffH)];
    [self.view addSubview:TopBarBGV];
    UIButton *backButton=[UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame=CGRectMake(0, 0+diffH, 80, 44);
    [backButton setBackgroundImage:[UIImage imageNamed:@"backnew.png"] forState:UIControlStateNormal];
    [self.view addSubview:backButton];
    [backButton addTarget:self action:@selector(backButton) forControlEvents:UIControlEventTouchUpInside];
    UILabel *  titleLabel=[[UILabel alloc] initWithFrame:CGRectMake(50, 2+diffH, 220, 40)];
    titleLabel.backgroundColor=[UIColor clearColor];
    [titleLabel setText:@"专题推荐"];
    [titleLabel setFont:[UIFont boldSystemFontOfSize:18]];
    titleLabel.textAlignment=NSTextAlignmentCenter;
    titleLabel.textColor=[UIColor whiteColor];
    [self.view addSubview:titleLabel];
    self.tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 44+diffH, 320, self.view.frame.size.height-44-diffH) style:UITableViewStylePlain];
    _tableview.delegate = self;
    _tableview.dataSource = self;
    _tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableview.backgroundColor = [UIColor colorWithRed:0.90 green:0.90 blue:0.90 alpha:1];
    [self.view addSubview:_tableview];
    
    self.footer = [[MJRefreshFooterView alloc] init];
    _footer.delegate = self;
    _footer.scrollView = self.tableview;
    
    self.refreshView = [[SRRefreshView alloc] init];
    _refreshView.delegate = self;
    _refreshView.upInset = 0;
    _refreshView.slimeMissWhenGoingBack = YES;
    _refreshView.slime.bodyColor = [UIColor colorWithRed:0.7 green:0.7 blue:0.7 alpha:1];
    _refreshView.slime.skinColor = [UIColor whiteColor];
    _refreshView.slime.lineWith = 1;
    _refreshView.slime.shadowBlur = 4;
    _refreshView.slime.shadowColor = [UIColor colorWithRed:0.7 green:0.7 blue:0.7 alpha:1];
    [self.tableview addSubview:_refreshView];
    [DataStoreManager blankMsgUnreadCountForUser:@"bbs_special_subject"];
    [self loadHistorySubject];
    
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
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [RootCell heightForRowWithArrayCount:((NSArray*)_array[indexPath.row]).count];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return _array.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    RootCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[RootCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.viewC = self;
    }
    cell.array = _array[indexPath.row];
    return cell;
}
#pragma mark - scroll view delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [_refreshView scrollViewDidScroll];
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [_refreshView scrollViewDidEndDraging];
}
#pragma mark MJRefreshBaseView delegate
- (void)refreshViewBeginRefreshing:(MJRefreshBaseView *)refreshView
{
    [self loadMoreSubject];
}
#pragma mark - slimeRefresh delegate

- (void)slimeRefreshStartRefresh:(SRRefreshView *)refreshView
{
    [self reloadSubject];
}
- (void)loadHistorySubject
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSArray* array = [userDefaults objectForKey:MySubject];
    if (array.count > 0) {
        [_array removeAllObjects];
        for (NSArray* ar in array) {
            NSMutableArray * arr = [NSMutableArray array];
            for (NSDictionary * dic in ar) {
                Subject* sub = [[Subject alloc]initWithNSDictionary:dic];
                [arr addObject:sub];
            }
            [_array addObject:arr];
        }
        [_tableview reloadData];
    }
    [self reloadSubject];
}
- (void)reloadSubject
{
    self.pageNo = 0;
    NSTimeInterval cT = [[NSDate date] timeIntervalSince1970];
    long long a = (long long)(cT*1000);
    NSMutableDictionary* params = [NSMutableDictionary dictionary];
    [params setObject:[NSString stringWithFormat:@"%d",self.pageNo] forKey:@"pageNo"];
    [params setObject:@"10" forKey:@"pageSize"];
    NSMutableDictionary* body = [NSMutableDictionary dictionary];
    [body setObject:params forKey:@"params"];
    [body setObject:@"getSpecialSubjectList" forKey:@"method"];
    [body setObject:@"service.uri.pet_bbs" forKey:@"service"];
    [body setObject:@"1" forKey:@"channel"];
    [body setObject:[SFHFKeychainUtils getPasswordForUsername:MACADDRESS andServiceName:LOCALACCOUNT error:nil] forKey:@"mac"];
    [body setObject:@"iphone" forKey:@"imei"];
    [body setObject:[NSString stringWithFormat:@"%lld",a] forKey:@"connectTime"];
    [body setObject:[SFHFKeychainUtils getPasswordForUsername:LOCALTOKEN andServiceName:LOCALACCOUNT error:nil] forKey:@"token"];
    [NetManager requestWithURLStr:BaseClientUrl Parameters:body TheController:self success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@",responseObject);
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        [userDefaults setObject:responseObject forKey:MySubject];
        [userDefaults synchronize];
        if (((NSArray*)responseObject).count>0) {
            _pageNo++;
            [_array removeAllObjects];
            for (NSArray* array in responseObject) {
                NSMutableArray * arr = [NSMutableArray array];
                for (NSDictionary * dic in array) {
                    Subject* sub = [[Subject alloc]initWithNSDictionary:dic];
                    [arr addObject:sub];
                }
                [_array addObject:arr];
            }
            [_tableview reloadData];
        }
        [_refreshView endRefresh];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [_refreshView endRefresh];
    }];
}
- (void)loadMoreSubject
{
    NSTimeInterval cT = [[NSDate date] timeIntervalSince1970];
    long long a = (long long)(cT*1000);
    NSMutableDictionary* params = [NSMutableDictionary dictionary];
    [params setObject:[NSString stringWithFormat:@"%d",self.pageNo] forKey:@"pageNo"];
    [params setObject:@"10" forKey:@"pageSize"];
    NSMutableDictionary* body = [NSMutableDictionary dictionary];
    [body setObject:params forKey:@"params"];
    [body setObject:@"getSpecialSubjectList" forKey:@"method"];
    [body setObject:@"service.uri.pet_bbs" forKey:@"service"];
    [body setObject:@"1" forKey:@"channel"];
    [body setObject:[SFHFKeychainUtils getPasswordForUsername:MACADDRESS andServiceName:LOCALACCOUNT error:nil] forKey:@"mac"];
    [body setObject:@"iphone" forKey:@"imei"];
    [body setObject:[NSString stringWithFormat:@"%lld",a] forKey:@"connectTime"];
    [body setObject:[SFHFKeychainUtils getPasswordForUsername:LOCALTOKEN andServiceName:LOCALACCOUNT error:nil] forKey:@"token"];
    [NetManager requestWithURLStr:BaseClientUrl Parameters:body TheController:self success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@",responseObject);
        if (((NSArray*)responseObject).count>0) {
            _pageNo++;
            for (NSArray* array in responseObject) {
                NSMutableArray * arr = [NSMutableArray array];
                for (NSDictionary * dic in array) {
                    Subject* sub = [[Subject alloc]initWithNSDictionary:dic];
                    [arr addObject:sub];
                }
                [_array addObject:arr];
            }
            [_tableview reloadData];
        }
        [_footer endRefreshing];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [_footer endRefreshing];
    }];
}
@end
