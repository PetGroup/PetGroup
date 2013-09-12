//
//  ContactsViewController.m
//  NewXMPPTest
//
//  Created by Tolecen on 13-6-26.
//  Copyright (c) 2013年 Tolecen. All rights reserved.
//

#import "selectContactPage.h"
#import "CustomTabBar.h"
#import "AppDelegate.h"
#import "XMPPHelper.h"
#import "JSON.h"
@interface selectContactPage ()

@end

@implementation selectContactPage

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        friendDict = [NSMutableDictionary dictionary];
        sectionArray = [NSMutableArray array];
        rowsArray = [NSMutableArray array];
        sectionIndexArray = [NSMutableArray array];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.hidesBottomBarWhenPushed = YES;
    self.appDel = [[UIApplication sharedApplication] delegate];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    UIImageView *TopBarBGV=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"topBG.png"]];
    [TopBarBGV setFrame:CGRectMake(0, 0, 320, 44)];
    [self.view addSubview:TopBarBGV];
    
    UILabel *titleLabel=[[UILabel alloc] initWithFrame:CGRectMake(100, 2, 120, 40)];
    titleLabel.backgroundColor=[UIColor clearColor];
    titleLabel.text=@"选择联系人";
    [titleLabel setFont:[UIFont boldSystemFontOfSize:18]];
    titleLabel.textAlignment=UITextAlignmentCenter;
    titleLabel.textColor=[UIColor whiteColor];
    [self.view addSubview:titleLabel];
    
//    UIButton *addButton=[UIButton buttonWithType:UIButtonTypeCustom];
//    addButton.frame=CGRectMake(275, 6, 40, 30);
//    [addButton setBackgroundImage:[UIImage imageNamed:@"tianjia.png"] forState:UIControlStateNormal];
//    //   [backButton setTitle:@" 返回" forState:UIControlStateNormal];
//    [addButton.titleLabel setFont:[UIFont boldSystemFontOfSize:15]];
//    [self.view addSubview:addButton];
//    [addButton addTarget:self action:@selector(addButton:) forControlEvents:UIControlEventTouchUpInside];
    
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
    
    
    //   [self getFriendsList];
	// Do any additional setup after loading the view.
}
-(void)viewWillAppear:(BOOL)animated
{
    if ([[TempData sharedInstance] needChat]) {
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
-(void)viewDidAppear:(BOOL)animated
{
    
    [self refreshFriendList];
    
    //   [self getFriendInfo:@"england"];
}

-(void)refreshFriendList
{
    friendDict = [DataStoreManager queryAllFriends];
    sectionArray = [DataStoreManager querySections];
    [sectionIndexArray removeAllObjects];
    for (int i = 0; i<sectionArray.count; i++) {
        [sectionIndexArray addObject:[[sectionArray objectAtIndex:i] objectAtIndex:0]];
    }
    
    friendsArray = [NSMutableArray arrayWithArray:[friendDict allKeys]];
    [friendsArray sortUsingSelector:@selector(compare:)];
    [self.contactsTable reloadData];
    NSMutableArray * tempF = [DataStoreManager queryAllFriendsNickname];
    for (int i = 0; i<tempF.count; i++) {
        //        if ([[[friendDict objectForKey:[friendsArray objectAtIndex:i]] objectForKey:@"nickName"] length]<1) {
        //            [self getFriendInfo:[[friendDict objectForKey:[friendsArray objectAtIndex:i]] objectForKey:@"userName"] withIndex:i];
        //        }
        if ([[[tempF objectAtIndex:i] objectAtIndex:0] length]<=1) {
            [self getFriendInfo:[[tempF objectAtIndex:i] objectAtIndex:1] withIndex:i];
        }
    }
}
-(void)getFriendInfo:(NSString *)userName withIndex:(int)index
{
    NSMutableDictionary * paramDict = [NSMutableDictionary dictionary];
    NSMutableDictionary * postDict = [NSMutableDictionary dictionary];
    [paramDict setObject:userName forKey:@"username"];
    [postDict setObject:paramDict forKey:@"params"];
    [postDict setObject:@"1" forKey:@"channel"];
    [postDict setObject:@"selectUserViewByUserName" forKey:@"method"];
    [postDict setObject:[SFHFKeychainUtils getPasswordForUsername:LOCALTOKEN andServiceName:LOCALACCOUNT error:nil] forKey:@"token"];
    [postDict setObject:[SFHFKeychainUtils getPasswordForUsername:MACADDRESS andServiceName:LOCALACCOUNT error:nil] forKey:@"mac"];
    [postDict setObject:@"iphone" forKey:@"imei"];
    NSTimeInterval cT = [[NSDate date] timeIntervalSince1970];
    long long a = (long long)(cT*1000);
    [postDict setObject:[NSString stringWithFormat:@"%lld",a] forKey:@"connectTime"];
    
    [NetManager requestWithURLStr:BaseClientUrl Parameters:postDict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *receiveStr = [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSDictionary * recDict = [receiveStr JSONValue];
        [DataStoreManager saveUserInfo:recDict];
        [self refreshFriendList];
    }];
    
}
-(void)getFriendsList
{
    NSMutableDictionary * postDict = [NSMutableDictionary dictionary];
    NSDictionary * getFriendDict = [NSDictionary dictionaryWithObjectsAndKeys:@"0",@"pageIndex", nil];
    [postDict setObject:@"1" forKey:@"channel"];
    [postDict setObject:@"getFriends" forKey:@"method"];
    [postDict setObject:[SFHFKeychainUtils getPasswordForUsername:LOCALTOKEN andServiceName:LOCALACCOUNT error:nil] forKey:@"token"];
    [postDict setObject:getFriendDict forKey:@"params"];
    NSTimeInterval cT = [[NSDate date] timeIntervalSince1970];
    long long a = (long long)(cT*1000);
    [postDict setObject:[NSString stringWithFormat:@"%lld",a] forKey:@"connectTime"];
    [NetManager requestWithURLStr:BaseClientUrl Parameters:postDict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *receiveStr = [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSDictionary * recDict = [receiveStr JSONValue];
        NSLog(@"%@",recDict);
    }];
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
    NSPredicate *resultPredicate = [NSPredicate predicateWithFormat:@"SELF contains[cd] %@",searchBar.text];
    NSLog(@"%@",searchBar.text);
    
    searchResultArray = [friendsArray filteredArrayUsingPredicate:resultPredicate ]; //注意retain
    NSLog(@"%@",searchResultArray);
    if ([tableView isEqual:self.searchDisplayController.searchResultsTableView]) {
        return [searchResultArray count];
    }
    
    return [[[sectionArray objectAtIndex:section] objectAtIndex:1] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * stringCell3 = @"cell33";
    ContactsCell * cell = [tableView dequeueReusableCellWithIdentifier:stringCell3];
    if (!cell) {
        cell = [[ContactsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:stringCell3];
    }
    NSDictionary * tempDict;
    if ([tableView isEqual:self.searchDisplayController.searchResultsTableView]) {
        tempDict = [friendDict objectForKey:[searchResultArray objectAtIndex:indexPath.row]];
    }
    else
        tempDict = [friendDict objectForKey:[[[sectionArray objectAtIndex:indexPath.section] objectAtIndex:1] objectAtIndex:indexPath.row]];
    cell.headImageV.placeholderImage = [UIImage imageNamed:@"moren_people.png"];
    cell.headImageV.imageURL = [NSURL URLWithString:[BaseImageUrl stringByAppendingString:[tempDict objectForKey:@"img"]]];
    cell.nameLabel.text = [tempDict objectForKey:@"displayName"];
    cell.signatureLabel.text = [tempDict objectForKey:@"signature"];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSDictionary * tempDict;
    if ([tableView isEqual:self.searchDisplayController.searchResultsTableView]) {
        tempDict = [friendDict objectForKey:[searchResultArray objectAtIndex:indexPath.row]];
    }
    else
    {
        tempDict = [friendDict objectForKey:[[[sectionArray objectAtIndex:indexPath.section] objectAtIndex:1] objectAtIndex:indexPath.row]];
    }
    [self.contactDelegate getContact:tempDict];
    [self dismissModalViewControllerAnimated:YES];
//    PersonDetailViewController * detailV = [[PersonDetailViewController alloc] init];
//    HostInfo * hostInfo = [[HostInfo alloc] initWithHostInfo:tempDict];
//    detailV.hostInfo = hostInfo;
//    detailV.needRequest = YES;
//    [self.navigationController pushViewController:detailV animated:YES];
//    [self.customTabBarController hidesTabBar:YES animated:YES];
    
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if ([tableView isEqual:self.searchDisplayController.searchResultsTableView]) {
        return 1;
    }
    
    return sectionArray.count;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section;
{
    if ([tableView isEqual:self.searchDisplayController.searchResultsTableView]) {
        return @"";
    }
    return [[sectionArray objectAtIndex:section] objectAtIndex:0];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}
- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    return sectionIndexArray;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
