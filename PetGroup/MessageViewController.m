//
//  MessageViewController.m
//  NewXMPPTest
//
//  Created by Tolecen on 13-6-26.
//  Copyright (c) 2013年 Tolecen. All rights reserved.
//
#import "MessageViewController.h"
#import "XMPPHelper.h"
#import "CustomTabBar.h"
#import "JSON.h"
#import "DeviceIdentifier.h"
#import "KKChatController.h"
@interface MessageViewController ()

@end

@implementation MessageViewController

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
    [self.view setBackgroundColor:[UIColor whiteColor]];

    UIImageView *TopBarBGV=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"topBG.png"]];
    [TopBarBGV setFrame:CGRectMake(0, 0, 320, 44)];
    [self.view addSubview:TopBarBGV];
    
    titleLabel=[[UILabel alloc] initWithFrame:CGRectMake(50, 2, 220, 40)];
    titleLabel.backgroundColor=[UIColor clearColor];
    
    [titleLabel setFont:[UIFont boldSystemFontOfSize:18]];
    titleLabel.textAlignment=UITextAlignmentCenter;
    titleLabel.textColor=[UIColor whiteColor];
    [self.view addSubview:titleLabel];
    [titleLabel setText:@"消息"];
    
    self.messageTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 44, 320, self.view.frame.size.height-88) style:UITableViewStylePlain];
    [self.view addSubview:self.messageTable];
    self.messageTable.dataSource = self;
    self.messageTable.delegate = self;
    self.messageTable.contentOffset = CGPointMake(0, 44);
    searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 44, 320, 44)];
    searchBar.autocorrectionType = UITextAutocorrectionTypeNo;
    searchBar.autocapitalizationType = UITextAutocapitalizationTypeNone;
    //searchBar.keyboardType = UIKeyboardTypeAlphabet;
    self.messageTable.tableHeaderView = searchBar;
    searchBar.delegate = self;
    
    searchDisplay = [[UISearchDisplayController alloc] initWithSearchBar:searchBar contentsController:self];
    searchDisplay.searchResultsDataSource = self;
    searchDisplay.searchResultsDelegate = self;
    
    _slimeView = [[SRRefreshView alloc] init];
    _slimeView.delegate = self;
    _slimeView.upInset = 0;
    _slimeView.slimeMissWhenGoingBack = YES;
    _slimeView.slime.bodyColor = [UIColor colorWithRed:0.7 green:0.7 blue:0.7 alpha:1];
    _slimeView.slime.skinColor = [UIColor whiteColor];
    _slimeView.slime.lineWith = 1;
    _slimeView.slime.shadowBlur = 4;
    _slimeView.slime.shadowColor = [UIColor colorWithRed:0.7 green:0.7 blue:0.7 alpha:1];
    
    [self.messageTable addSubview:_slimeView];

    self.appDel = [[UIApplication sharedApplication] delegate];

}
-(void)viewDidDisappear:(BOOL)animated
{
    [self.mlNavigationController setGestureEnableYES];
}
-(void)viewDidAppear:(BOOL)animated
{
    [SFHFKeychainUtils storeUsername:ACCOUNT andPassword:@"7kela" forServiceName:LOCALACCOUNT updateExisting:YES error:nil];
    [SFHFKeychainUtils storeUsername:PASSWORD andPassword:@"111111" forServiceName:LOCALACCOUNT updateExisting:YES error:nil];
    [SFHFKeychainUtils storeUsername:LOCALTOKEN andPassword:@"40664d5d-56b2-43cb-a8f6-9fabe8222c5e" forServiceName:LOCALACCOUNT updateExisting:YES error:nil];
    [SFHFKeychainUtils storeUsername:USERNICKNAME andPassword:@"ewew" forServiceName:LOCALACCOUNT updateExisting:YES error:nil];
    if (![SFHFKeychainUtils getPasswordForUsername:LOCALTOKEN andServiceName:LOCALACCOUNT error:nil]) {
        [self toLoginPage];
    }
    else
    {
        [DataStoreManager setDefaultDataBase:[SFHFKeychainUtils getPasswordForUsername:ACCOUNT andServiceName:LOCALACCOUNT error:nil] AndDefaultModel:@"LocalStore"];
        [self logInToServer];
    }
}
-(void)viewWillAppear:(BOOL)animated{
    [self.mlNavigationController setGestureEnableNO];
    if ([[TempData sharedInstance] ifPanned]) {
        [self.customTabBarController hidesTabBar:NO animated:NO];
    }
    else
    {
        [self.customTabBarController hidesTabBar:NO animated:YES];
        [[TempData sharedInstance] Panned:YES];
    }
}

-(void)notConnectted
{
    titleLabel.text=@"消息(未连接)";
 //   [self connectChatServer];
   // NSLog(@"ddddd");
}

-(NSString *)convertChineseToPinYin:(NSString *)chineseName
{
    NSMutableString * theName = [NSMutableString stringWithString:chineseName];
    CFRange range = CFRangeMake(0, theName.length);
    CFStringTransform((CFMutableStringRef)theName, &range, kCFStringTransformToLatin, NO);
    range = CFRangeMake(0, theName.length);
    CFStringTransform((CFMutableStringRef)theName, &range, kCFStringTransformStripCombiningMarks, NO);
    NSString * dd = [theName stringByReplacingOccurrencesOfString:@" " withString:@""];
    return dd;
}
-(void)newAddReq:(NSDictionary *)userInfo
{
    //检查本地是否已有这个打招呼的人，有了就不存，没有就存
    if (![DataStoreManager ifSayHellosHaveThisPerson:[userInfo objectForKey:@"fromUser"]]) {
        [DataStoreManager addPersonToReceivedHellos:userInfo];
    }
    //检查打招呼这个人有没有详细信息，没有去请求详细信息
    if([DataStoreManager checkSayHelloPersonIfHaveNickNameForUsername:[userInfo objectForKey:@"fromUser"]]){
        
    }

}
-(void)processFriend:(XMPPPresence *)processFriend{
    
}

-(void)newMessageReceived:(NSDictionary *)messageContent
{
    [self storeNewMessage:messageContent];
    
}

-(void)receiveOfficalMsg
{

}

-(void)makeMsgVStoreMsg:(NSDictionary *)messageContent
{
    [self storeNewMessage:messageContent];
}

-(void)storeNewMessage:(NSDictionary *)messageContent
{
    AudioServicesPlayAlertSound(1007);

//    NSRange range = [[messageContent objectForKey:@"sender"] rangeOfString:@"@"];
//    NSString * sender = [[messageContent objectForKey:@"sender"] substringToIndex:range.location];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"userCell";
    MessageCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[MessageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    KKChatController * kkchat = [[KKChatController alloc] init];
    [self.navigationController pushViewController:kkchat animated:YES];
    [self.customTabBarController hidesTabBar:YES animated:YES];
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return YES;
}
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle==UITableViewCellEditingStyleDelete)
    {

    }
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [_slimeView scrollViewDidScroll];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [_slimeView scrollViewDidEndDraging];
}

#pragma mark - slimeRefresh delegate

- (void)slimeRefreshStartRefresh:(SRRefreshView *)refreshView
{
    [_slimeView performSelector:@selector(endRefresh)
                     withObject:nil afterDelay:2
                        inModes:[NSArray arrayWithObject:NSRunLoopCommonModes]];
}



-(void)logInToServer
{
    NSMutableDictionary * userInfoDict = [NSMutableDictionary dictionary];
    NSMutableDictionary * postDict = [NSMutableDictionary dictionary];
    [userInfoDict setObject:[SFHFKeychainUtils getPasswordForUsername:ACCOUNT andServiceName:LOCALACCOUNT error:nil] forKey:@"username"];
    [userInfoDict setObject:[SFHFKeychainUtils getPasswordForUsername:PASSWORD andServiceName:LOCALACCOUNT error:nil] forKey:@"password"];
    [userInfoDict setObject:@"31" forKey:@"imgId"];
    [userInfoDict setObject:@"2" forKey:@"type"];
    [postDict setObject:userInfoDict forKey:@"params"];
    [postDict setObject:@"1" forKey:@"channel"];
    [postDict setObject:@"open" forKey:@"method"];
    [postDict setObject:[SFHFKeychainUtils getPasswordForUsername:LOCALTOKEN andServiceName:LOCALACCOUNT error:nil] forKey:@"token"];
    [postDict setObject:[SFHFKeychainUtils getPasswordForUsername:MACADDRESS andServiceName:LOCALACCOUNT error:nil] forKey:@"mac"];
    [postDict setObject:@"iphone" forKey:@"imei"];
    NSTimeInterval cT = [[NSDate date] timeIntervalSince1970];
    long long a = (long long)(cT*1000);
    [postDict setObject:[NSString stringWithFormat:@"%lld",a] forKey:@"connectTime"];
    
    [NetManager requestWithURLStr:BaseClientUrl Parameters:postDict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *receiveStr = [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSDictionary * recDict = [receiveStr JSONValue];
        [self logInServerSuccessWithInfo:recDict];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self makeLogFailurePrompt];
    }];
}

-(void)logInServerSuccessWithInfo:(NSDictionary *)dict
{
    if ([[dict objectForKey:@"forceUpdate"] intValue]>0) {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"检测到新版本，您的版本已低于最低版本需求，请立即升级" delegate:self cancelButtonTitle:@"立即升级" otherButtonTitles: nil];
        alert.tag = 20;
        [alert show];
    }
    else if ([[dict objectForKey:@"needUpdate"] intValue]>0) {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"检测到新版本，您要升级吗" delegate:self cancelButtonTitle:@"立刻升级" otherButtonTitles:@"取消", nil];
        alert.tag = 21;
        [alert show];
    }
    [self saveMyInfo:[dict objectForKey:@"petUserView"]];
    [self logInToChatServer];
}

-(void)logInToChatServer
{
    self.appDel.xmppHelper.xmpptype = login;
    [self.appDel.xmppHelper connect:[[SFHFKeychainUtils getPasswordForUsername:ACCOUNT andServiceName:LOCALACCOUNT error:nil]stringByAppendingString:Domain] password:[SFHFKeychainUtils getPasswordForUsername:LOCALTOKEN andServiceName:LOCALACCOUNT error:nil] host:Host success:^(void){
        NSLog(@"登陆成功xmpp");
        self.appDel.xmppHelper.buddyListDelegate = self;
        self.appDel.xmppHelper.chatDelegate = self;
        self.appDel.xmppHelper.processFriendDelegate = self;
        self.appDel.xmppHelper.addReqDelegate = self;
        titleLabel.text = @"消息";    
    }fail:^(NSError *result){
        
    }];
}

-(void)toLoginPage
{

    WelcomeViewController * welcomeV = [[WelcomeViewController alloc] init];
        UINavigationController * navi = [[UINavigationController alloc] initWithRootViewController:welcomeV];
    [self presentModalViewController:navi animated:NO];
}
-(void)saveMyInfo:(NSDictionary *)dict
{
    [DataStoreManager saveMyInfo:dict];
}

-(void)requestPeopleInfoWithName:(NSString *)userName
{
    
}
-(void)makeLogFailurePrompt
{
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
