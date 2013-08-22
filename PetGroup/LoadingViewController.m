//
//  LoadingViewController.m
//  PetGroup
//
//  Created by Tolecen on 13-8-20.
//  Copyright (c) 2013年 Tolecen. All rights reserved.
//

#import "LoadingViewController.h"
#import "CustomTabBar.h"
#import "MessageViewController.h"
#import "DynamicViewController.h"
#import "NearByViewController.h"
#import "ContactsViewController.h"
#import "PersonalCenterViewController.h"
@interface LoadingViewController ()

@end

@implementation LoadingViewController

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
    NSString * openImgStr = [[NSUserDefaults standardUserDefaults] objectForKey:@"OpenImg"];
    if (openImgStr) {
        
        NSData * nsData= [NSData dataWithContentsOfFile:openImgStr];
        UIImage * openPic= [UIImage imageWithData:nsData];
        if (iPhone5) {
            splashImageView=[[UIImageView alloc]initWithImage:openPic];
            splashImageView.frame=CGRectMake(0, 0, 320, self.view.frame.size.height);
        }
        else
        {
            splashImageView=[[UIImageView alloc]initWithImage:openPic];
            splashImageView.frame=CGRectMake(0, 0, 320, self.view.frame.size.height);
        }
    }
    else
    {
        if (iPhone5) {
            splashImageView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"568screen.png"]];
            splashImageView.frame=CGRectMake(0, 0, 320, self.view.frame.size.height);
        }
        else
        {
            splashImageView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"normalScreen.png"]];
            splashImageView.frame=CGRectMake(0, 0, 320, self.view.frame.size.height);
        }
    }
    [self.view addSubview:splashImageView];
    [self performSelector:@selector(toMainView) withObject:nil afterDelay:2];

	// Do any additional setup after loading the view.
}
-(void)toMainView
{
    DynamicViewController * dynamicV = [[DynamicViewController alloc] init];
    self.NaviDynamic = [[MLNavigationController alloc] initWithRootViewController:dynamicV];
    NearByViewController * nearbyV = [[NearByViewController alloc] init];
    self.NaviNearBy = [[MLNavigationController alloc] initWithRootViewController:nearbyV];
    ContactsViewController * contactsV = [[ContactsViewController alloc] init];
    self.NaviContacts = [[MLNavigationController alloc] initWithRootViewController:contactsV];
    //    MoreViewController * moreV = [[MoreViewController alloc] init];
    PersonalCenterViewController* mpVC = [[PersonalCenterViewController alloc]init];
    self.NaviMore = [[MLNavigationController alloc] initWithRootViewController:mpVC];
    
    //为什么message放最后，因为message页面需要滑动删除cell，与MLNavigationController的手势冲突，放在最后一个当修改的时候才能修改到最后一个的页面，如果其他页面也需要这功能，暂时没想到好办法，在写一个类似于MLNavigationController的类吧...
    messageV = [[MessageViewController alloc] init];
    self.NaviMessage = [[MLNavigationController alloc] initWithRootViewController:messageV];
    
    self.NaviMessage.delegate = (id)self;
    self.NaviMessage.navigationBarHidden = YES;
    self.NaviNearBy.navigationBarHidden = YES;
    self.NaviContacts.navigationBarHidden = YES;
    self.NaviMore.navigationBarHidden = YES;
    self.NaviDynamic.navigationBarHidden = YES;
    
    NSArray * views = [NSArray arrayWithObjects:self.NaviMessage,self.NaviDynamic,self.NaviNearBy,self.NaviContacts,self.NaviMore, nil];
    NSArray * normalPic = [NSArray arrayWithObjects:@"normal_02.png",@"normal_03.png",@"normal_04.png",@"normal_05.png",@"normal_06", nil];
    NSArray * selectPic = [NSArray arrayWithObjects:@"select_02.png", @"select_03.png",@"select_04.png",@"select_05.png",@"select_06",nil];
    self.tabBarC = [[CustomTabBar alloc] initWithImages:normalPic AndSelected:selectPic AndControllers:views];
    
    [self presentModalViewController:self.tabBarC animated:NO];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
