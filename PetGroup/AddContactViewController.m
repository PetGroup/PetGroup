//
//  AddContactViewController.m
//  NewXMPPTest
//
//  Created by Tolecen on 13-7-18.
//  Copyright (c) 2013年 Tolecen. All rights reserved.
//

#import "AddContactViewController.h"


@interface AddContactViewController ()

@end

@implementation AddContactViewController

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
    self.hidesBottomBarWhenPushed = YES;

    UIImageView * bgV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, self.view.frame.size.height)];
    [bgV setImage:[UIImage imageNamed:@"chat_bg.png"]];
    [self.view addSubview:bgV];

    UIImageView *TopBarBGV=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"topBG.png"]];
    [TopBarBGV setFrame:CGRectMake(0, 0, 320, 44)];
    [self.view addSubview:TopBarBGV];
    
    UIButton *backButton=[UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame=CGRectMake(0, 0, 80, 44);
    [backButton setBackgroundImage:[UIImage imageNamed:@"back2.png"] forState:UIControlStateNormal];
    //   [backButton setTitle:@" 返回" forState:UIControlStateNormal];
    [backButton.titleLabel setFont:[UIFont boldSystemFontOfSize:15]];
    [self.view addSubview:backButton];
    [backButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    
    
    UILabel * titleLabel=[[UILabel alloc] initWithFrame:CGRectMake(100, 2, 120, 40)];
    titleLabel.backgroundColor=[UIColor clearColor];
    titleLabel.text=@"添加联系人";
    [titleLabel setFont:[UIFont boldSystemFontOfSize:18]];
    titleLabel.textAlignment=UITextAlignmentCenter;
    titleLabel.textColor=[UIColor whiteColor];
    [self.view addSubview:titleLabel];
    
    self.resultTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 44, 320, self.view.frame.size.height-44) style:UITableViewStylePlain];
    [self.view addSubview:self.resultTable];
    self.resultTable.dataSource = self;
    self.resultTable.delegate = self;
    self.resultTable.rowHeight = 60;
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
    
    __weak AddContactViewController *weakSelf = self;
    [self.resultTable addInfiniteScrollingWithActionHandler:^{
        if (1) {
            
        }
        else
        {
            [weakSelf.resultTable.infiniteScrollingView stopAnimating];
        }
        
    }];
    // Do any additional setup after loading the view.
}
#pragma mark -
#pragma mark TableView 

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 10;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * stringCell = @"cell";
    ContactsCell * cell = [tableView dequeueReusableCellWithIdentifier:stringCell];
    if (!cell) {
        cell = [[ContactsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:stringCell];
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
    }

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
    self.pageIndex = 0;
    if (![hud superview]) {
        hud = [[MBProgressHUD alloc] initWithView:self.view];
        [self.view addSubview:hud];
        hud.delegate = self;
        hud.labelText = @"搜索中...";
    }

    [hud show:YES];
    
    [asearchBar resignFirstResponder];

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

@end
