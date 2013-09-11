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
#define AppID  @"564710616" //temp ID
@interface SettingViewController ()

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

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    UIImageView *TopBarBGV=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"topBG.png"]];
    [TopBarBGV setFrame:CGRectMake(0, 0, 320, 44)];
    [self.view addSubview:TopBarBGV];
    
    UIButton *backButton=[UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame=CGRectMake(0, 0, 80, 44);
    [backButton setBackgroundImage:[UIImage imageNamed:@"back2.png"] forState:UIControlStateNormal];
    [self.view addSubview:backButton];
    [backButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *titleLabel=[[UILabel alloc] initWithFrame:CGRectMake(100, 2, 120, 40)];
    titleLabel.backgroundColor=[UIColor clearColor];
    titleLabel.text=@"设置";
    [titleLabel setFont:[UIFont boldSystemFontOfSize:18]];
    titleLabel.textAlignment=UITextAlignmentCenter;
    titleLabel.textColor=[UIColor whiteColor];
    [self.view addSubview:titleLabel];
    
    titlesArray=[[NSMutableArray alloc]initWithObjects:@"评价一下",@"意见反馈",@"关于宠物圈", nil];
    
    self.settingTV = [[UITableView alloc] initWithFrame:CGRectMake(0,44, 320, self.view.frame.size.height-44) style:UITableViewStyleGrouped];
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
            [self.navigationController pushViewController:report animated:YES];
            
        }
        if (indexPath.row==2) {
            AboutAppViewController * aboutV = [[AboutAppViewController alloc] init];
            [self.navigationController pushViewController:aboutV animated:YES];
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
        [SFHFKeychainUtils deleteItemForUsername:ACCOUNT andServiceName:LOCALACCOUNT error:nil];
        [SFHFKeychainUtils deleteItemForUsername:PASSWORD andServiceName:LOCALACCOUNT error:nil];
        [SFHFKeychainUtils deleteItemForUsername:LOCALTOKEN andServiceName:LOCALACCOUNT error:nil];
        AppDelegate* app = [[UIApplication sharedApplication] delegate];
        [app.xmppHelper disconnect];
        [self.navigationController popViewControllerAnimated:NO];
    }
}
@end
