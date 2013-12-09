//
//  ExperienceListViewController.m
//  PetGroup
//
//  Created by Tolecen on 13-11-28.
//  Copyright (c) 2013年 Tolecen. All rights reserved.
//

#import "ExperienceListViewController.h"

@interface ExperienceListViewController ()

@end

@implementation ExperienceListViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        thePage = 0;
        canLoadMore = YES;
        self.listArray = [NSMutableArray array];
    }
    return self;
}
-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}
- (void)dealloc
{
    [_footer free];
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
    [titleLabel setText:@"养宠经验"];

    
    [titleLabel setFont:[UIFont boldSystemFontOfSize:18]];
    titleLabel.textAlignment=NSTextAlignmentCenter;
    titleLabel.textColor=[UIColor whiteColor];
    [self.view addSubview:titleLabel];
    self.listTableV = [[UITableView alloc]initWithFrame:CGRectMake(0, 44+diffH, 320, self.view.frame.size.height-44-diffH) style:UITableViewStylePlain];
    self.listTableV.delegate = self;
    self.listTableV.dataSource = self;
    self.listTableV.backgroundView = nil;
    [self.view addSubview:self.listTableV];
    
    self.footer = [[MJRefreshFooterView alloc] init];
    _footer.delegate = self;
    _footer.scrollView = self.listTableV;
    
    self.refreshView = [[SRRefreshView alloc] init];
    _refreshView.delegate = self;
    _refreshView.upInset = 0;
    _refreshView.slimeMissWhenGoingBack = YES;
    _refreshView.slime.bodyColor = [UIColor colorWithRed:0.7 green:0.7 blue:0.7 alpha:1];
    _refreshView.slime.skinColor = [UIColor whiteColor];
    _refreshView.slime.lineWith = 1;
    _refreshView.slime.shadowBlur = 4;
    _refreshView.slime.shadowColor = [UIColor colorWithRed:0.7 green:0.7 blue:0.7 alpha:1];
    
    [self.listTableV addSubview:_refreshView];
    
    [self getChildList];
	// Do any additional setup after loading the view.
}
- (void)refreshViewBeginRefreshing:(MJRefreshBaseView *)refreshView
{
    if (refreshView == _footer) {
        if (canLoadMore) {
            [self getChildList];
        }
        else
        {
            [self performSelector:@selector(makeFooterEnd) withObject:nil afterDelay:1];
        }
        
        return;
    }
}
-(void)makeFooterEnd
{
    [_footer endRefreshing];
}
#pragma mark - slimeRefresh delegate

- (void)slimeRefreshStartRefresh:(SRRefreshView *)refreshView
{
    thePage = 0;
    [self.listArray removeAllObjects];
    if (refreshView == _refreshView) {
        [self getChildList];
    }
}
#pragma mark - scroll view delegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if(scrollView == _listTableV){
        [_refreshView scrollViewDidScroll];
    }
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (scrollView == _listTableV) {
        [_refreshView scrollViewDidEndDraging];
    }
}
-(void)getChildList
{
    NSMutableDictionary * locationDict = [NSMutableDictionary dictionary];
    NSMutableDictionary * postDict = [NSMutableDictionary dictionary];
    [locationDict setObject:[NSString stringWithFormat:@"%d",thePage] forKey:@"pageNo"];
    [locationDict setObject:@"20" forKey:@"pageSize"];
    [locationDict setObject:self.rootID forKey:@"pid"];
    [postDict setObject:@"1" forKey:@"channel"];
    [postDict setObject:@"getExperList" forKey:@"method"];
    [postDict setObject:@"service.uri.pet_exper" forKey:@"service"];
    [postDict setObject:[SFHFKeychainUtils getPasswordForUsername:LOCALTOKEN andServiceName:LOCALACCOUNT error:nil] forKey:@"token"];
    [postDict setObject:locationDict forKey:@"params"];
    NSTimeInterval cT = [[NSDate date] timeIntervalSince1970];
    long long a = (long long)(cT*1000);
    [postDict setObject:[NSString stringWithFormat:@"%lld",a] forKey:@"connectTime"];
    [NetManager requestWithURLStr:BaseClientUrl Parameters:postDict TheController:self success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"petKnowledge:%@",responseObject);
        if ([[responseObject objectForKey:@"data"] count]>=20) {
            canLoadMore = YES;
            thePage++;
        }
        else
        {
            canLoadMore = NO;
        }
        [self.listArray addObjectsFromArray:[responseObject objectForKey:@"data"]];
        
        [self.listTableV reloadData];
        [_refreshView endRefresh];
        [_footer endRefreshing];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [_refreshView endRefresh];
        [_footer endRefreshing];
    }];
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.listArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"cell";
    UITableViewCell*cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier ];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    cell.textLabel.text = [[self.listArray objectAtIndex:indexPath.row] objectForKey:@"name"];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    ContentDetailViewController * cv = [[ContentDetailViewController alloc] init];
    cv.contentType = contentTypeTextView;
    cv.articleID = [[self.listArray objectAtIndex:indexPath.row] objectForKey:@"id"];
    cv.typeName = @"养宠经验";
    [self.navigationController pushViewController:cv animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
-(void)backButton
{
    [[TempData sharedInstance] Panned:NO];
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
