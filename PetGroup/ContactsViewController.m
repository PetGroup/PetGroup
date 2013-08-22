//
//  ContactsViewController.m
//  NewXMPPTest
//
//  Created by Tolecen on 13-6-26.
//  Copyright (c) 2013年 Tolecen. All rights reserved.
//

#import "ContactsViewController.h"
#import "CustomTabBar.h"
#import "AppDelegate.h"
#import "XMPPHelper.h"
#import "JSON.h"
@interface ContactsViewController ()

@end

@implementation ContactsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization

    }
    return self;
}
-(void)viewWillAppear:(BOOL)animated
{
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"needchat"]) {
        [self.customTabBarController setSelectedPage:0];
        return;
    }
    if ([[TempData sharedInstance] ifPanned]) {
        [self.customTabBarController hidesTabBar:NO animated:NO];
    }
    else
    {
        [self.customTabBarController hidesTabBar:NO animated:YES];
        [[TempData sharedInstance] Panned:YES];
    }

}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.hidesBottomBarWhenPushed = YES;
    [self.view setBackgroundColor:[UIColor whiteColor]];
    UIImageView *TopBarBGV=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"topBG.png"]];
    [TopBarBGV setFrame:CGRectMake(0, 0, 320, 44)];
    [self.view addSubview:TopBarBGV];
    
    UILabel *titleLabel=[[UILabel alloc] initWithFrame:CGRectMake(100, 2, 120, 40)];
    titleLabel.backgroundColor=[UIColor clearColor];
    titleLabel.text=@"联系人";
    [titleLabel setFont:[UIFont boldSystemFontOfSize:18]];
    titleLabel.textAlignment=UITextAlignmentCenter;
    titleLabel.textColor=[UIColor whiteColor];
    [self.view addSubview:titleLabel];
    
    UIButton *addButton=[UIButton buttonWithType:UIButtonTypeCustom];
    addButton.frame=CGRectMake(275, 6, 40, 30);
    [addButton setBackgroundImage:[UIImage imageNamed:@"tianjia.png"] forState:UIControlStateNormal];
    //   [backButton setTitle:@" 返回" forState:UIControlStateNormal];
    [addButton.titleLabel setFont:[UIFont boldSystemFontOfSize:15]];
    [self.view addSubview:addButton];
    [addButton addTarget:self action:@selector(addButton:) forControlEvents:UIControlEventTouchUpInside];
 
    self.contactsTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 44, 320, self.view.frame.size.height-88) style:UITableViewStylePlain];
    [self.view addSubview:self.contactsTable];
    self.contactsTable.dataSource = self;
    self.contactsTable.delegate = self;
    searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 44, 320, 44)];
    searchBar.autocorrectionType = UITextAutocorrectionTypeNo;
    searchBar.autocapitalizationType = UITextAutocapitalizationTypeNone;
    //searchBar.keyboardType = UIKeyboardTypeAlphabet;
    self.contactsTable.tableHeaderView = searchBar;
    searchBar.delegate = self;
    
    searchDisplay = [[UISearchDisplayController alloc] initWithSearchBar:searchBar contentsController:self];
    searchDisplay.searchResultsDataSource = self;
    searchDisplay.searchResultsDelegate = self;

//    [self arrayToPY];
    
    self.appDel = [[UIApplication sharedApplication] delegate];
 
    
//    [self getFriendsList];
	// Do any additional setup after loading the view.
}
-(void)addButton:(UIButton *)sender
{
    AddContactViewController * addV = [[AddContactViewController alloc] init];
    [self.navigationController pushViewController:addV animated:YES];
    [self.customTabBarController hidesTabBar:YES animated:YES];
}
-(NSString *)convertChineseToPinYin:(NSString *)chineseName
{
    NSMutableString * theName = [NSMutableString stringWithString:chineseName];
    NSLog(@"hhhh0:%@",theName);
    CFRange range = CFRangeMake(0, theName.length);
    CFStringTransform((CFMutableStringRef)theName, &range, kCFStringTransformToLatin, NO);
    NSLog(@"hhhh1:%@",theName);
    range = CFRangeMake(0, theName.length);
    CFStringTransform((CFMutableStringRef)theName, &range, kCFStringTransformStripCombiningMarks, NO);
    NSLog(@"hhhh:%@",theName);
    NSString * dd = [theName stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    NSLog(@"hhhh3:%@",dd);
    return dd;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
       [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 0;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section;
{
    return @"";
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
