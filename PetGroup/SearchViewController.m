//
//  SearchViewController.m
//  PetGroup
//
//  Created by 阿铛 on 13-10-14.
//  Copyright (c) 2013年 Tolecen. All rights reserved.
//

#import "SearchViewController.h"
#import "PullingRefreshTableView.h"
#import "TempData.h"
#import "Article.h"
#import "articleCell.h"

@interface SearchViewController ()<PullingRefreshTableViewDelegate>
{
    UISearchBar * asearchBar;
    UISearchDisplayController * searchDisplay;
}
@property (strong,nonatomic) PullingRefreshTableView * resultTable;
@property (strong,nonatomic) NSMutableArray * resultArray;
@property (strong,nonatomic) NSString* notename;
@property (assign,nonatomic) int pageNo;
@end

@implementation SearchViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.forumPid = @"0";
        self.resultArray = [NSMutableArray array];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    UIImageView *TopBarBGV=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"topBG.png"]];
    [TopBarBGV setFrame:CGRectMake(0, 0, 320, 44)];
    [self.view addSubview:TopBarBGV];
    
    UIButton *backButton=[UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame=CGRectMake(0, 0, 80, 44);
    [backButton setBackgroundImage:[UIImage imageNamed:@"back2.png"] forState:UIControlStateNormal];
    [self.view addSubview:backButton];
    [backButton addTarget:self action:@selector(backButton) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *  titleLabel=[[UILabel alloc] initWithFrame:CGRectMake(50, 2, 220, 40)];
    titleLabel.backgroundColor=[UIColor clearColor];
    [titleLabel setText:@"搜索"];
    [titleLabel setFont:[UIFont boldSystemFontOfSize:18]];
    titleLabel.textAlignment=UITextAlignmentCenter;
    titleLabel.textColor=[UIColor whiteColor];
    [self.view addSubview:titleLabel];
    
    self.resultTable = [[PullingRefreshTableView alloc] initWithFrame:CGRectMake(0, 44, 320, self.view.frame.size.height-44) style:UITableViewStylePlain];
    [self.view addSubview:self.resultTable];
    self.resultTable.footerOnly = YES;
    self.resultTable.pullingDelegate = self;
    self.resultTable.dataSource = self;
    self.resultTable.delegate = self;
    self.resultTable.rowHeight = 100;
    asearchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 44, 320, 44)];
    asearchBar.autocorrectionType = UITextAutocorrectionTypeNo;
    asearchBar.autocapitalizationType = UITextAutocapitalizationTypeNone;
    asearchBar.placeholder = @"用户名或昵称";
    //searchBar.keyboardType = UIKeyboardTypeAlphabet;
    self.resultTable.tableHeaderView = asearchBar;
    // asearchBar.barStyle = UIBarStyleBlackTranslucent;
    UIView * dd = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    [dd setBackgroundColor:[UIColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:1]];
    
    [asearchBar insertSubview:dd atIndex:1];
    asearchBar.delegate = self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)loadMoreData
{
    self.pageNo++;
    [self searchBarData];
}
-(void)searchBarData
{
    //body={"method":"searchNote","token":"","params":{"forumid":"0","notename":"我","pageNo":"1","pageSize":"10"}}
    NSTimeInterval cT = [[NSDate date] timeIntervalSince1970];
    long long a = (long long)(cT*1000);
    NSMutableDictionary* params = [NSMutableDictionary dictionary];
    [params setObject:self.notename forKey:@"notename"];
    [params setObject:self.forumPid forKey:@"forumid"];
    [params setObject:[NSString stringWithFormat:@"%d",self.pageNo] forKey:@"pageNo"];
    [params setObject:@"20" forKey:@"pageSize"];
    NSMutableDictionary* body = [NSMutableDictionary dictionary];
    [body setObject:params forKey:@"params"];
    [body setObject:@"searchNote" forKey:@"method"];
    [body setObject:@"1" forKey:@"channel"];
    [body setObject:[SFHFKeychainUtils getPasswordForUsername:MACADDRESS andServiceName:LOCALACCOUNT error:nil] forKey:@"mac"];
    [body setObject:@"iphone" forKey:@"imei"];
    [body setObject:[NSString stringWithFormat:@"%lld",a] forKey:@"connectTime"];
    [body setObject:[SFHFKeychainUtils getPasswordForUsername:LOCALTOKEN andServiceName:LOCALACCOUNT error:nil] forKey:@"token"];
    [NetManager requestWithURLStr:BaseClientUrl Parameters:body TheController:self success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@",[[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding]);
        NSDictionary*dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NSArray* array = [dic objectForKey:@"entity"];
        if (self.pageNo == 1) {
            [self.resultArray removeAllObjects];
        }
        if ([[dic objectForKey:@"success"] boolValue] && array.count > 0) {
            for (NSDictionary* dic in array) {
                Article* a = [[Article alloc]initWithDictionnary:dic];
                [self.resultArray addObject:a];
            }
        }
        [self.resultTable reloadData];
        [self.resultTable tableViewDidFinishedLoading];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self.resultTable tableViewDidFinishedLoading];
    }];
}
#pragma mark - button action
-(void)backButton
{
    [[TempData sharedInstance] Panned:NO];
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark -
#pragma mark TableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.resultArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"NearbyCell";
    articleCell*cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier ];
    if (cell == nil) {
        cell = [[articleCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    }
    cell.article = self.resultArray[indexPath.row];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

#pragma mark -
#pragma mark searchBar Delegate
-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    if (searchBar.text.length>0) {
        self.pageNo = 1;
        self.notename = searchBar.text;
        [self searchBarData];
        [asearchBar resignFirstResponder];
    }
    
}
#pragma mark - ScrollDelegate

//刷新必须调用ScrollViewDelegate方法（从写的方法）

- (void)scrollViewDidScroll:(UIScrollView*)scrollView{
    if (self.resultArray.count>0) {
        [self.resultTable tableViewDidScroll:scrollView];
    }
}


- (void)scrollViewDidEndDragging:(UIScrollView*)scrollView willDecelerate:(BOOL)decelerate{
    
    if (self.resultArray.count>0) {
        [self.resultTable tableViewDidEndDragging:scrollView];
    }
}




#pragma mark -
#pragma mark - PullingRefreshTableViewDelegate
- (void)pullingTableViewDidStartRefreshing:(PullingRefreshTableView *)tableView
{
    
}

- (void)pullingTableViewDidStartLoading:(PullingRefreshTableView *)tableView
{
    [self loadMoreData];
}

- (NSDate *)pullingTableViewRefreshingFinishedDate
{
    NSDateFormatter *df = [[NSDateFormatter alloc] init ];
    df.dateFormat = @"yyyy-MM-dd HH:mm";
    NSDate *date = [df dateFromString:@"2012-05-03 10:10"];
    return date;
}


@end
