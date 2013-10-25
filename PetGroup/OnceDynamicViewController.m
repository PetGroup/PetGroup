//
//  OnceDynamicViewController.m
//  PetGroup
//
//  Created by 阿铛 on 13-10-25.
//  Copyright (c) 2013年 Tolecen. All rights reserved.
//

#import "OnceDynamicViewController.h"
#import "PullingRefreshTableView.h"
#import "TempData.h"
@interface OnceDynamicViewController ()<UITableViewDataSource,UITableViewDelegate,PullingRefreshTableViewDelegate,UIActionSheetDelegate,UIAlertViewDelegate>
@property (strong,nonatomic) PullingRefreshTableView * tableV;
@property (strong,nonatomic) NSMutableArray * resultArray;
@property (strong,nonatomic) UIActionSheet* delAction;
@property (strong,nonatomic) UIActionSheet* reportAction;
@property (strong,nonatomic) UIAlertView* delAlert;
@property (strong,nonatomic) UIAlertView* reportAlert;
@end

@implementation OnceDynamicViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.resultArray = [[NSMutableArray alloc]init];
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
    [titleLabel setText:@"朋友圈"];
    [titleLabel setFont:[UIFont boldSystemFontOfSize:18]];
    titleLabel.textAlignment=NSTextAlignmentCenter;
    titleLabel.textColor=[UIColor whiteColor];
    [self.view addSubview:titleLabel];
    
    UIButton *moveButton=[UIButton buttonWithType:UIButtonTypeCustom];
    moveButton.frame=CGRectMake(278, 3, 35, 33);
    [moveButton setBackgroundImage:[UIImage imageNamed:@"gengduoxinxi"] forState:UIControlStateNormal];
    [moveButton addTarget:self action:@selector(showActionShoot) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:moveButton];
    
    self.tableV = [[PullingRefreshTableView alloc]initWithFrame:CGRectMake(0, 44, 320, self.view.frame.size.height-44)];
    _tableV.delegate = self;
    _tableV.dataSource = self;
    _tableV.pullingDelegate = self;
    [self.view addSubview:_tableV];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - button action
-(void)backButton
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)showActionShoot
{
    if ([self.dynamic.userID isEqualToString:[[TempData sharedInstance] getMyUserID]]) {
        self.delAction = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"删除" otherButtonTitles: nil];
        [_delAction showInView:self.view];
    }else{
        self.reportAction = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"举报" otherButtonTitles: nil];
        [_reportAction showInView:self.view];
    }
}
#pragma mark -
#pragma mark TableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 1;
    }else{
        return self.resultArray.count;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"NearbyCell";
    UITableViewCell*cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier ];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}
#pragma mark - ScrollDelegate

//刷新必须调用ScrollViewDelegate方法（从写的方法）

- (void)scrollViewDidScroll:(UIScrollView*)scrollView{
    if (self.resultArray.count>0) {
        [self.tableV tableViewDidScroll:scrollView];
    }
}


- (void)scrollViewDidEndDragging:(UIScrollView*)scrollView willDecelerate:(BOOL)decelerate{
    
    if (self.resultArray.count>0) {
        [self.tableV tableViewDidEndDragging:scrollView];
    }
}




#pragma mark -
#pragma mark - PullingRefreshTableViewDelegate
- (void)pullingTableViewDidStartRefreshing:(PullingRefreshTableView *)tableView
{
    
}

- (void)pullingTableViewDidStartLoading:(PullingRefreshTableView *)tableView
{
    
}

- (NSDate *)pullingTableViewRefreshingFinishedDate
{
    NSDateFormatter *df = [[NSDateFormatter alloc] init ];
    df.dateFormat = @"yyyy-MM-dd HH:mm";
    NSDate *date = [df dateFromString:@"2012-05-03 10:10"];
    return date;
}
#pragma mark - actionSheet delegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        if (actionSheet == _delAction) {
            self.delAlert = [[UIAlertView alloc]initWithTitle:nil message:@"确定删除这条动态?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            [_delAlert show];
        }
        if (actionSheet == _reportAction) {
            self.reportAlert = [[UIAlertView alloc]initWithTitle:nil message:@"确定举报这条动态?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            [_reportAlert show];
        }
    }
}
#pragma mark - alertView delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (!buttonIndex == 0) {
        if (alertView == _delAlert) {
            
        }
        if (alertView == _reportAlert) {
            
        }
    }
}
@end
