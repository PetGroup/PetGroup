//
//  SettingViewController.m
//  NewXMPPTest
//
//  Created by Tolecen on 13-7-10.
//  Copyright (c) 2013年 Tolecen. All rights reserved.
//

#import "SettingViewController.h"
#import "AppDelegate.h"
#import "XMPPHelper.h"
#import "EGOCache.h"
#define AppID  @"686838840" //temp ID
@interface SettingViewController ()<UIAlertViewDelegate>

@end

@implementation SettingViewController

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
    self.view.backgroundColor = [UIColor whiteColor];
    float diffH = [Common diffHeight:self];
    
    UIImageView *TopBarBGV=[[UIImageView alloc]initWithImage:[UIImage imageNamed:diffH==0?@"topBar1.png":@"topBar2.png"]];
    [TopBarBGV setFrame:CGRectMake(0, 0, 320, 44+diffH)];
    [self.view addSubview:TopBarBGV];
    
    UIButton *backButton=[UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame=CGRectMake(0, 0+diffH, 80, 44);
    [backButton setBackgroundImage:[UIImage imageNamed:@"back2.png"] forState:UIControlStateNormal];
    [self.view addSubview:backButton];
    [backButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *titleLabel=[[UILabel alloc] initWithFrame:CGRectMake(100, 2+diffH, 120, 40)];
    titleLabel.backgroundColor=[UIColor clearColor];
    titleLabel.text=@"设置";
    [titleLabel setFont:[UIFont boldSystemFontOfSize:18]];
    titleLabel.textAlignment=NSTextAlignmentCenter;
    titleLabel.textColor=[UIColor whiteColor];
    [self.view addSubview:titleLabel];
    
    titlesArray=[[NSMutableArray alloc]initWithObjects:@"评价一下",@"意见反馈",@"关于宠物圈",@"清除缓存", nil];
    
    self.settingTV = [[UITableView alloc] initWithFrame:CGRectMake(0,44+diffH, 320, self.view.frame.size.height-44-diffH) style:UITableViewStyleGrouped];
    [self.view addSubview:self.settingTV];
    self.settingTV.backgroundView = nil;
    self.settingTV.dataSource = self;
    self.settingTV.delegate = self;

	// Do any additional setup after loading the view.
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return section==0?titlesArray.count:1;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"profileCell";
    
    UITableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    if (indexPath.section==0) {
        cell.textLabel.text = [titlesArray objectAtIndex:indexPath.row];
    }
    else
    {
        cell.textLabel.text = @"退出登录";
    }
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
        if (indexPath.row==0) {
            NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"itms-apps://ax.itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=%@",AppID]];
            if([[UIApplication sharedApplication] canOpenURL:url])
            {
                [[UIApplication sharedApplication] openURL:url];
            }
        }
        if (indexPath.row==1) {
            ReportViewController * report = [[ReportViewController alloc] init];
            report.theTitle = @"意见反馈";
            report.maxCount = 100;
            report.realReport = YES;
            [self.navigationController pushViewController:report animated:YES];
            
        }
        if (indexPath.row==2) {
            AboutAppViewController * aboutV = [[AboutAppViewController alloc] init];
            [self.navigationController pushViewController:aboutV animated:YES];
        }
        if (indexPath.row == 3) {
            UIAlertView * alert = [[UIAlertView alloc]initWithTitle:nil message:@"确认要清除所有的缓存吗?" delegate:self cancelButtonTitle:@"点错啦" otherButtonTitles:@"确定", nil];
            [alert show];
        }
    }
    if (indexPath.section==1) {
//        LoginViewController * loginV = [[LoginViewController alloc] init];
//        UINavigationController * logNavi = [[UINavigationController alloc] initWithRootViewController:loginV];
//        logNavi.navigationBarHidden = YES;
//        // loginV.logDelegate = self;
//        [self presentModalViewController:logNavi animated:YES];
        //退出
        
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        UIActionSheet *myActionSheet=[[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"退出" otherButtonTitles: nil];
        [myActionSheet showInView:self.view];
        
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
-(void)back
{
    [[TempData sharedInstance] Panned:NO];
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        [self logoutFromServer];
        [SFHFKeychainUtils deleteItemForUsername:ACCOUNT andServiceName:LOCALACCOUNT error:nil];
        [SFHFKeychainUtils deleteItemForUsername:PASSWORD andServiceName:LOCALACCOUNT error:nil];
        [SFHFKeychainUtils deleteItemForUsername:LOCALTOKEN andServiceName:LOCALACCOUNT error:nil];
        
        AppDelegate* app = [[UIApplication sharedApplication] delegate];
        TempData * tempData = [TempData sharedInstance];
        tempData.myUserID = nil;
        NSUserDefaults * userDefault = [NSUserDefaults standardUserDefaults];
        [userDefault removeObjectForKey:NewComment];
        [userDefault removeObjectForKey:MyDynamic];
        [userDefault synchronize];
        [app.xmppHelper disconnect];
        [self.navigationController popViewControllerAnimated:NO];
    }
}
-(void)logoutFromServer
{
  //  NSMutableDictionary* params = [[NSMutableDictionary alloc]init];
    NSTimeInterval cT = [[NSDate date] timeIntervalSince1970];
    long long a = (long long)(cT*1000);
    NSMutableDictionary* body = [[NSMutableDictionary alloc]init];
    [body setObject:@"1" forKey:@"channel"];
    [body setObject:[SFHFKeychainUtils getPasswordForUsername:LOCALTOKEN andServiceName:LOCALACCOUNT error:nil] forKey:@"token"];
    [body setObject:@"iphone" forKey:@"imei"];
//    [body setObject:params forKey:@"params"];
    [body setObject:@"logout" forKey:@"method"];
    [body setObject:@"service.uri.pet_sso" forKey:@"service"];
    [body setObject:[NSString stringWithFormat:@"%lld",a] forKey:@"connectTime"];
    [body setObject:[SFHFKeychainUtils getPasswordForUsername:LOCALTOKEN andServiceName:LOCALACCOUNT error:nil] forKey:@"token"];
    
    [NetManager requestWithURLStr:BaseClientUrl Parameters:body TheController:self success:^(AFHTTPRequestOperation *operation, id responseObject) {
  
        
    }failure:^(AFHTTPRequestOperation *operation, NSError *error) {

    }];

}
-(void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        [[EGOCache globalCache] clearCache];
        NSFileManager *file_manager = [NSFileManager defaultManager];
        NSString *path = [RootDocPath stringByAppendingPathComponent:@"tempImage"];
        [file_manager removeItemAtPath:path error:nil];
    }
}
@end
