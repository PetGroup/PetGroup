//
//  SearchViewController.m
//  PetGroup
//
//  Created by 阿铛 on 13-10-14.
//  Copyright (c) 2013年 Tolecen. All rights reserved.
//

#import "SearchViewController.h"
#import "MJRefresh.h"
#import "TempData.h"
#import "Article.h"
#import "articleCell.h"
#import "ArticleViewController.h"

@interface SearchViewController ()<MJRefreshBaseViewDelegate>
{
    UISearchBar * asearchBar;
    UISearchDisplayController * searchDisplay;
    BOOL free;
}
@property (strong,nonatomic) UITableView * resultTable;
@property (strong,nonatomic) MJRefreshFooterView *footer;
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
-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
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
    [backButton setBackgroundImage:diffH==0.0f?[UIImage imageNamed:@"back2.png"]:[UIImage imageNamed:@"backnew.png"] forState:UIControlStateNormal];
    [self.view addSubview:backButton];
    [backButton addTarget:self action:@selector(backButton) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *  titleLabel=[[UILabel alloc] initWithFrame:CGRectMake(50, 2+diffH, 220, 40)];
    titleLabel.backgroundColor=[UIColor clearColor];
    [titleLabel setText:@"搜索"];
    [titleLabel setFont:[UIFont boldSystemFontOfSize:18]];
    titleLabel.textAlignment=NSTextAlignmentCenter;
    titleLabel.textColor=[UIColor whiteColor];
    [self.view addSubview:titleLabel];
    
    self.resultTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 44+diffH, 320, self.view.frame.size.height-44-diffH) style:UITableViewStylePlain];
    [self.view addSubview:self.resultTable];
    self.resultTable.dataSource = self;
    self.resultTable.delegate = self;
    self.resultTable.rowHeight = 100;
    self.footer = [[MJRefreshFooterView alloc] init];
    _footer.delegate = self;
    _footer.scrollView = self.resultTable;
    asearchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 44, 320, 44)];
    asearchBar.autocorrectionType = UITextAutocorrectionTypeNo;
    asearchBar.autocapitalizationType = UITextAutocapitalizationTypeNone;
    asearchBar.placeholder = @"输入关键字搜索帖子";
    //searchBar.keyboardType = UIKeyboardTypeAlphabet;
    self.resultTable.tableHeaderView = asearchBar;
    // asearchBar.barStyle = UIBarStyleBlackTranslucent;
    UIView * dd = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    [dd setBackgroundColor:[UIColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:1]];
    
    [asearchBar insertSubview:dd atIndex:1];
    asearchBar.delegate = self;
    
    noResultLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, 150+diffH, 200, 80)];
    [noResultLabel setTextAlignment:NSTextAlignmentCenter];
    noResultLabel.text = @"找不到你要搜索的内容呢，换个关键词试试呗！";
    [noResultLabel setLineBreakMode:NSLineBreakByWordWrapping];
    noResultLabel.font = [UIFont systemFontOfSize:15];
    [noResultLabel setNumberOfLines:0];
    //    noResultLabel.adjustsFontSizeToFitWidth = YES;
    noResultLabel.backgroundColor = [UIColor clearColor];
    noResultLabel.textColor = [UIColor grayColor];
    [self.view addSubview:noResultLabel];
    noResultLabel.hidden = YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)loadMoreData
{
//    noResultLabel.hidden = YES;
    if (self.notename.length>0) {
        self.pageNo++;
        [self searchBarData];
        return;
    }
    [_footer endRefreshing];
}
-(void)searchBarData
{
    noResultLabel.hidden = YES;
    NSTimeInterval cT = [[NSDate date] timeIntervalSince1970];
    long long a = (long long)(cT*1000);
    NSMutableDictionary* params = [NSMutableDictionary dictionary];
    [params setObject:self.notename forKey:@"condition"];
    [params setObject:@"SEARCH" forKey:@"action"];
    [params setObject:@"false" forKey:@"withTop"];
    [params setObject:self.forumPid forKey:@"forumId"];
    [params setObject:[NSString stringWithFormat:@"%d",self.pageNo] forKey:@"pageNo"];
    [params setObject:@"20" forKey:@"pageSize"];
    NSMutableDictionary* body = [NSMutableDictionary dictionary];
    [body setObject:params forKey:@"params"];
    [body setObject:@"service.uri.pet_bbs" forKey:@"service"];
    [body setObject:@"getNoteList" forKey:@"method"];
    [body setObject:@"1" forKey:@"channel"];
    [body setObject:[SFHFKeychainUtils getPasswordForUsername:MACADDRESS andServiceName:LOCALACCOUNT error:nil] forKey:@"mac"];
    [body setObject:@"iphone" forKey:@"imei"];
    [body setObject:[NSString stringWithFormat:@"%lld",a] forKey:@"connectTime"];
    [body setObject:[SFHFKeychainUtils getPasswordForUsername:LOCALTOKEN andServiceName:LOCALACCOUNT error:nil] forKey:@"token"];
    [NetManager requestWithURLStr:BaseClientUrl Parameters:body TheController:self success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@",responseObject);
        NSArray* array =  responseObject;
        if (self.pageNo == 0) {
            [self.resultArray removeAllObjects];
        }
        if (array.count > 0) {
            for (NSDictionary* dic in array) {
                Article* a = [[Article alloc]initWithDictionnary:dic];
                [self.resultArray addObject:a];
            }
        }
        else
        {
            if (self.pageNo == 0) {
                noResultLabel.hidden = NO;
            }
        }
        [self.resultTable reloadData];
        [_footer endRefreshing];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [_footer endRefreshing];
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
    free = NO;
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    ArticleViewController * articleVC = [[ArticleViewController alloc]init];
    articleVC.articleID = ((Article*)self.resultArray[indexPath.row]).articleID;
    [self.navigationController pushViewController:articleVC animated:YES];
}

#pragma mark -
#pragma mark searchBar Delegate
-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    if (searchBar.text.length>0) {
        self.pageNo = 0;
        self.notename = searchBar.text;
        [self searchBarData];
        [asearchBar resignFirstResponder];
    }
}
#pragma mark MJRefreshBaseView delegate
- (void)refreshViewBeginRefreshing:(MJRefreshBaseView *)refreshView
{
    if (refreshView == _footer) {
        [self loadMoreData];
        return;
    }
}
@end
