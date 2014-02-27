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
#import "KKChatController.h"
#import "ReconnectionManager.h"
@interface MessageViewController ()
{
    BOOL canProcess;
}
@end

@implementation MessageViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        allMsgArray = [NSMutableArray array];
        allMsgUnreadArray = [NSMutableArray array];
        newReceivedMsgArray = [NSMutableArray array];
        allNickNameArray = [NSMutableArray array];
        allHeadImgArray = [NSMutableArray array];
        pyChineseArray = [NSMutableArray array];
        searchResultArray = [NSArray array];
        
        firstOpen = YES;
    }
    return self;
}
-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.hidesBottomBarWhenPushed = YES;
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    
    
    diffH = [Common diffHeight:self];
    
    [AFImageRequestOperation addAcceptableContentTypes:[NSSet setWithObject:@"multipart/form-data"]];
    
    
    TopBarBGV=[[UIImageView alloc]initWithImage:[UIImage imageNamed:diffH==0?@"topBar1.png":@"topBar2.png"]];
    [TopBarBGV setFrame:CGRectMake(0, 0, 320, 44+diffH)];
    [self.view addSubview:TopBarBGV];

    titleLabel=[[UILabel alloc] initWithFrame:CGRectMake(50, 2+diffH, 220, 40)];
    titleLabel.backgroundColor=[UIColor clearColor];
    
    [titleLabel setFont:[UIFont boldSystemFontOfSize:18]];
    titleLabel.textAlignment=NSTextAlignmentCenter;
    titleLabel.textColor=[UIColor whiteColor];
    [self.view addSubview:titleLabel];
    [titleLabel setText:@"消息"];
    
    self.messageTable = [[UITableView alloc] initWithFrame:CGRectMake(0, diffH+44, 320, self.view.frame.size.height-(49+44+diffH)) style:UITableViewStylePlain];
    [self.view addSubview:self.messageTable];
//    UIView * iuiu = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
//    [iuiu setBackgroundColor:[UIColor redColor]];
//    self.messageTable.tableHeaderView = iuiu;
    //    UIView *backgroundView = [[UIView alloc] initWithFrame:self.messageTable.bounds];
    //    backgroundView.backgroundColor = [UIColor clearColor];
    //    self.messageTable.backgroundView = backgroundView;
    self.messageTable.dataSource = self;
    self.messageTable.delegate = self;
    self.messageTable.contentOffset = CGPointMake(0, 44);
    searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 20, 320, 44)];
    searchBar.autocorrectionType = UITextAutocorrectionTypeNo;
    searchBar.autocapitalizationType = UITextAutocapitalizationTypeNone;
    searchBar.placeholder = @"搜索最近联系人";
    //searchBar.keyboardType = UIKeyboardTypeAlphabet;
    self.messageTable.tableHeaderView = searchBar;
//    [self.view addSubview:searchBar];
    searchBar.delegate = self;


    
    searchDisplay = [[UISearchDisplayController alloc] initWithSearchBar:searchBar contentsController:self];
    searchDisplay.delegate = self;
    searchDisplay.searchResultsDataSource = self;
    searchDisplay.searchResultsDelegate = self;
//    searchDisplay.displaysSearchBarInNavigationBar = YES;
    
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
    
    judgeDrawmood = [[JudgeDrawMood alloc] initWithArrays];

    self.appDel = [[UIApplication sharedApplication] delegate];
    reV = [ReconnectionManager sharedInstance];
    
    noNetLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 44+diffH, 320, 30)];
    [noNetLabel setText:@"暂时没有检测到网络，请检查网络连接"];
    [noNetLabel setFont:[UIFont systemFontOfSize:14]];
    [noNetLabel setBackgroundColor:[UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1]];
    [noNetLabel setTextColor:[UIColor grayColor]];
    [noNetLabel setTextAlignment:NSTextAlignmentCenter];
    [self.view addSubview:noNetLabel];
    noNetLabel.hidden = YES;

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(makeScrollToTheTop:) name:@"Notification_makeSrollTop" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(catchStatus:) name:@"Notification_catchStatus" object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(inspectNewSubject) name:@"inspectNewSubject" object:nil];
//    [self inspectNewSubject];
}

-(void)viewDidDisappear:(BOOL)animated
{
    [self.mlNavigationController setGestureEnableYES];
}
-(void)viewDidAppear:(BOOL)animated
{
    if (diffH==20.0f) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    canProcess = YES;
    
    if (!reV.networkAvailable){
        titleLabel.text = @"消息(未连接)";
        noNetLabel.hidden = NO;
        [self.messageTable setFrame:CGRectMake(0, diffH+44+30, 320, self.view.frame.size.height-(49+44+diffH))];
    }
    else {
        noNetLabel.hidden = YES;
        [self.messageTable setFrame:CGRectMake(0, diffH+44, 320, self.view.frame.size.height-(49+44+diffH))];
    }
//    [SFHFKeychainUtils storeUsername:ACCOUNT andPassword:@"england" forServiceName:LOCALACCOUNT updateExisting:YES error:nil];
//    [SFHFKeychainUtils storeUsername:PASSWORD andPassword:@"111111" forServiceName:LOCALACCOUNT updateExisting:YES error:nil];
//    [SFHFKeychainUtils storeUsername:LOCALTOKEN andPassword:@"f073afc6-dfbe-402c-9af1-8bad1eae6c49" forServiceName:LOCALACCOUNT updateExisting:YES error:nil];
//    [SFHFKeychainUtils storeUsername:USERNICKNAME andPassword:@"ewew" forServiceName:LOCALACCOUNT updateExisting:YES error:nil];
    if (![SFHFKeychainUtils getPasswordForUsername:LOCALTOKEN andServiceName:LOCALACCOUNT error:nil]) {
        firstOpen = YES;
        [self toLoginPage];
    }
    else
    {
        [DataStoreManager setDefaultDataBase:[SFHFKeychainUtils getPasswordForUsername:ACCOUNT andServiceName:LOCALACCOUNT error:nil] AndDefaultModel:@"LocalStore"];
        if (![self.appDel.xmppHelper isConnected]&&![titleLabel.text isEqualToString:@"消息(连接中...)"]&&reV.networkAvailable) {
            if ([[TempData sharedInstance] ifOpened]) {
                [self logInToChatServer];
            }
            else
                [self logInToServer];
           // [self getMyUserInfoFromNet];
        }
        
//        [self tempMakeSomeData];
//        [self performSelector:@selector(displayMsgsForDefaultView) withObject:nil afterDelay:4];
        [self displayMsgsForDefaultView];
        if (firstOpen) {
            [self.customTabBarController setSelectedPage:0];
            firstOpen = NO;
        }
//        NSUserDefaults * userDefault = [NSUserDefaults standardUserDefaults];
//        NSMutableArray * replyArray = [NSMutableArray arrayWithArray:[userDefault objectForKey:NewComment]];
//        int unreadComment = 0;
//        if (replyArray) {
//            unreadComment = replyArray.count;
//        }
//        else
//            unreadComment = 0;
//        if (unreadComment>0) {
//            [self.customTabBarController notificationWithNumber:YES AndTheNumber:unreadComment OrDot:NO WithButtonIndex:4];
//        }
//        else
//            [self.customTabBarController removeNotificatonOfIndex:4];
        
//        [self readNewNoti];
    }

}
//-(void)readNewNoti
//{
//    NSUserDefaults * defaultUserD = [NSUserDefaults standardUserDefaults];
//    NSString * notiKey = [NSString stringWithFormat:@"%@_%@",NewComment,[SFHFKeychainUtils getPasswordForUsername:ACCOUNT andServiceName:LOCALACCOUNT error:nil]];
//    NSArray * tempNewNotiArray = [defaultUserD objectForKey:notiKey];
//    if (tempNewNotiArray) {
//        if (tempNewNotiArray.count>0) {
//            [self.customTabBarController notificationWithNumber:YES AndTheNumber:tempNewNotiArray.count OrDot:NO WithButtonIndex:4];
//        }
//        else{
//            [self.customTabBarController removeNotificatonOfIndex:4];
//        }
//    }
//    
//}

//-(void)tempMakeSomeData
//{
//    for (int i = 0; i<100; i++) {
//        NSTimeInterval nowT = [[NSDate date] timeIntervalSince1970];
//        NSString * timeStr = [NSString stringWithFormat:@"%f",nowT];
//        NSDictionary * dict = [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"message_%d",i],@"msg",[NSString stringWithFormat:@"sender_%d@test.com",i],@"sender",timeStr,@"time", nil];
//        NSDictionary * dict2 = [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"addtional message_%d",i],@"addtionMsg",[NSString stringWithFormat:@"sender_%d@test.com",i],@"fromUser", nil];
////        [DataStoreManager storeNewMsgs:dict senderType:COMMONUSER];
//        [DataStoreManager addPersonToReceivedHellos:dict2];
//       // [DataStoreManager deleteReceivedHelloWithUserName:[NSString stringWithFormat:@"sender_%d@test.com",i]];
//        //[DataStoreManager deleteMsgsWithSender:[NSString stringWithFormat:@"sender_%d",i]];
//    }
//    [self displayMsgsForDefaultView];
//}
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
    if (![self.appDel.xmppHelper ifXMPPConnected]) {
        titleLabel.text = @"消息(未连接)";
    }
    self.appDel.xmppHelper.buddyListDelegate = self;
    self.appDel.xmppHelper.chatDelegate = self;
    self.appDel.xmppHelper.processFriendDelegate = self;
    self.appDel.xmppHelper.addReqDelegate = self;
    self.appDel.xmppHelper.commentDelegate = self;
    
    
    [self performSelector:@selector(toChatPage) withObject:nil afterDelay:0.1];
//    [self.customTabBarController setSelectedPage:1];
//    self.appDel.xmppHelper.notConnect = self;
}

-(void)toChatPage
{
    if ([[TempData sharedInstance] needChat]) {
        NSDictionary * theDict = (NSDictionary *)[DataStoreManager queryOneFriendInfoWithUserName:[[TempData sharedInstance] getNeedChatUser]];
        KKChatController * kkchat = [[KKChatController alloc] init];
        kkchat.chatWithUser = [theDict objectForKey:@"username"];
        kkchat.nickName = [[theDict objectForKey:@"nickname"] length]>1?[theDict objectForKey:@"nickname"]:[theDict objectForKey:@"username"];
        kkchat.chatUserImg = [DataStoreManager queryFirstHeadImageForUser:[theDict objectForKey:@"username"]];
        [self.navigationController pushViewController:kkchat animated:YES];
        kkchat.msgDelegate = self;
        [self.customTabBarController hidesTabBar:YES animated:YES];
        [[TempData sharedInstance] setNeedChatNO];
    }
}
-(void)catchStatus:(NSNotification*) notification
{dispatch_async(dispatch_get_main_queue(), ^{
    NSString * theType = [notification object];
    //        [reV reconnectionAttemptIfSuccess:^{
    //            [[TempData sharedInstance] setOpened:YES];
    //            [self.appDel.xmppHelper checkToServerifSubscibe];
    //            [self endRefresh];
    //            titleLabel.text = @"消息";
    //        } Failure:^{
    //            titleLabel.text = @"消息(未连接)";
    //            [self endRefresh];
    //        }];
    if ([theType isEqualToString:@"connected"]) {
//            [[TempData sharedInstance] setOpened:YES];
            [self.appDel.xmppHelper checkToServerifSubscibe];
            [self endRefresh];
            titleLabel.text = @"消息";
    }
    else if ([theType isEqualToString:@"disconnect"]){
        titleLabel.text = @"消息(未连接)";
    }
    else if ([theType isEqualToString:@"failed"]){
        titleLabel.text = @"消息(未连接)";
        [self endRefresh];
    }
    else if ([theType isEqualToString:@"connecting"]){
        titleLabel.text = @"消息(连接中...)";
//        [self endRefresh];
    }
    else if ([theType isEqualToString:@"noNet"]){
        titleLabel.text = @"消息(未连接)";
        noNetLabel.hidden = NO;
        [self.messageTable setFrame:CGRectMake(0, diffH+44+30, 320, self.view.frame.size.height-(49+44+diffH))];
    }
    else if ([theType isEqualToString:@"haveNet"]){
        noNetLabel.hidden = YES;
        [self.messageTable setFrame:CGRectMake(0, diffH+44, 320, self.view.frame.size.height-(49+44+diffH))];
    }
//    if ([self.appDel.xmppHelper isDisconnected]) {
//        titleLabel.text = @"消息(未连接)";
//    }
 
//    if ([TempData sharedInstance].appActive) {
//        titleLabel.text = @"消息(连接中...)";
//        [[ReconnectionManager sharedInstance] reconnectionAttemptController:self IfSuccess:^{
//            [[TempData sharedInstance] setOpened:YES];
//            [self.appDel.xmppHelper checkToServerifSubscibe];
//            [self endRefresh];
//
//            titleLabel.text = @"消息";
//        } Failure:^{
//            titleLabel.text = @"消息(未连接)";
//        }];
//    }
});
}
-(void)notConnectted
{
//    [[ReconnectionManager sharedInstance] reconnectionAttemptIfSuccess:^{
//        
//    }];
//    [self.appDel.xmppHelper disconnect];
    if ([self.appDel.xmppHelper isDisconnected]) {
        titleLabel.text = @"消息(未连接)";
    }
//    if ([TempData sharedInstance].appActive) {
//        titleLabel.text = @"消息(连接中...)";
//        [[ReconnectionManager sharedInstance] reconnectionAttemptIfSuccess:^{
//            [[TempData sharedInstance] setOpened:YES];
//            [self.appDel.xmppHelper checkToServerifSubscibe];
//            [self endRefresh];
//
//            titleLabel.text = @"消息";
//        } Failure:^{
//            titleLabel.text = @"消息(未连接)";
//        }];
//    }
//    if ([TempData sharedInstance].appActive&&[SFHFKeychainUtils getPasswordForUsername:LOCALTOKEN andServiceName:LOCALACCOUNT error:nil]) {
//        titleLabel.text = @"消息(连接中...)";
//        [[ReconnectionManager sharedInstance] reconnectionAttemptIfSuccess:^{
//            titleLabel.text = @"消息";
//        }];
//    }

 //   [self connectChatServer];
   // NSLog(@"ddddd");
}

-(void)reConnectChatServer
{
    
}

-(void)makeScrollToTheTop:(NSNumber *)index
{
    if (self.customTabBarController.selectedIndex!=2) {
        return;
    }
    if (allMsgArray.count>0) {
        [self.messageTable scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition: UITableViewScrollPositionTop animated:YES];
    }
    
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
    NSString * fromUser = [userInfo objectForKey:@"sender"];
    NSRange range = [fromUser rangeOfString:@"@"];
    fromUser = [fromUser substringToIndex:range.location];
//    if (![DataStoreManager ifSayHellosHaveThisPerson:fromUser]) {
//        AudioServicesPlayAlertSound(1007);
//        [DataStoreManager addPersonToReceivedHellos:userInfo];
//        //检查打招呼这个人有没有详细信息，没有去请求详细信息
//        if(![DataStoreManager checkSayHelloPersonIfHaveNickNameForUsername:[userInfo objectForKey:@"fromUser"]]){
//            [self requestPeopleInfoWithName:[userInfo objectForKey:@"fromUser"] ForType:0];
//        }
        [self requestPeopleInfoWithName:fromUser ForType:0 Msg:[userInfo objectForKey:@"msg"]];
//    }
//    else
//    {
//        NSDictionary * uDict = [NSDictionary dictionaryWithObjectsAndKeys:fromUser,@"fromUser",[userInfo objectForKey:@"msg"],@"addtionMsg", nil];
//        [DataStoreManager addPersonToReceivedHellos:uDict];
//    }
//    [self displayMsgsForDefaultView];
}
-(void)processFriend:(XMPPPresence *)processFriend{
    NSString *username=[[processFriend from] user];
    [self requestPeopleInfoWithName:username ForType:1 Msg:nil];
}
-(void)newCommentReceived:(NSDictionary *)theDict
{
    
 //   [self requestOneStateByStateID:[theDict objectForKey:@"dynamicID"] WithDict:theDict];
    [self storeReceivedNotification:theDict];
}

-(void)storeReceivedNotification:(NSDictionary *)theDict
{
    NSUserDefaults * defaultUserD = [NSUserDefaults standardUserDefaults];
    AudioServicesPlayAlertSound(1003);
    if ([theDict[@"contentType"] isEqualToString:@"bbs_special_subject"]) {
        [[NSUserDefaults standardUserDefaults] setObject:@"NO" forKey:[NSString stringWithFormat:@"%@_%@",@"bbs_special_subject",[SFHFKeychainUtils getPasswordForUsername:ACCOUNT andServiceName:LOCALACCOUNT error:nil]]];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"Notification_received_bbs_special_subject" object:@1 userInfo:nil];
        return;
    }
    NSString * notiKey = [NSString stringWithFormat:@"%@_%@",NewComment,[SFHFKeychainUtils getPasswordForUsername:ACCOUNT andServiceName:LOCALACCOUNT error:nil]];
    NSArray * tempNewNotiArray = [defaultUserD objectForKey:notiKey];
    NSMutableArray * newNotiArray;
    if (tempNewNotiArray) {
        newNotiArray = [NSMutableArray arrayWithArray:tempNewNotiArray];
        [newNotiArray insertObject:theDict atIndex:0];
        if (newNotiArray.count>50) {
            [newNotiArray removeLastObject];
        }
    }
    else
        newNotiArray = [NSMutableArray arrayWithObject:theDict];
    
    [defaultUserD setObject:newNotiArray forKey:notiKey];
    [defaultUserD synchronize];
//    if (newNotiArray.count>0) {
//        [self.customTabBarController notificationWithNumber:YES AndTheNumber:newNotiArray.count OrDot:NO WithButtonIndex:4];
//    }
//    else{
//        [self.customTabBarController removeNotificatonOfIndex:4];
//    }
}

-(void)requestOneStateByStateID:(NSString *)theID WithDict:(NSDictionary *)theDict
{
    NSMutableDictionary * postDict = [NSMutableDictionary dictionary];
    NSMutableDictionary * locationDict = [NSMutableDictionary dictionary];
    [locationDict setObject:theID forKey:@"stateid"];
    [postDict setObject:@"1" forKey:@"channel"];
    [postDict setObject:@"findOneState" forKey:@"method"];
    [postDict setObject:[SFHFKeychainUtils getPasswordForUsername:LOCALTOKEN andServiceName:LOCALACCOUNT error:nil] forKey:@"token"];
    [postDict setObject:locationDict forKey:@"params"];
    NSTimeInterval cT = [[NSDate date] timeIntervalSince1970];
    long long a = (long long)(cT*1000);
    [postDict setObject:[NSString stringWithFormat:@"%lld",a] forKey:@"connectTime"];
    [NetManager requestWithURLStr:BaseClientUrl Parameters:postDict TheController:self success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *receiveStr = [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSDictionary * recDict = [receiveStr JSONValue];
        NSLog(@"rrrrrrrr:%@",recDict);
        
        
        NSUserDefaults * userDefault = [NSUserDefaults standardUserDefaults];
        
        NSMutableDictionary * mydynamicDict = [NSMutableDictionary dictionaryWithDictionary:[userDefault objectForKey:MyDynamic]];
        if (!mydynamicDict) {
            mydynamicDict = [NSMutableDictionary dictionary];
        }
        [mydynamicDict setObject:recDict forKey:theID];
        
        
        NSMutableArray * replyArray = [NSMutableArray arrayWithArray:[userDefault objectForKey:NewComment]];
        if (!replyArray) {
            replyArray = [NSMutableArray array];
        }
        int unreadOfComment = replyArray.count+1;
        [self.customTabBarController notificationWithNumber:YES AndTheNumber:unreadOfComment OrDot:NO WithButtonIndex:4];
        NSMutableDictionary * replyDict = [NSMutableDictionary dictionary];
        [replyDict setObject:[theDict objectForKey:@"sender"] forKey:@"username"];
        [replyDict setObject:[theDict objectForKey:@"msg"] forKey:@"replyContent"];
        [replyDict setObject:theID forKey:@"dynamicID"];
        [replyDict setObject:[theDict objectForKey:@"time"] forKey:@"time"];
        [replyDict setObject:[theDict objectForKey:@"msgType"] forKey:@"theType"];
        [replyDict setObject:[theDict objectForKey:@"fromNickname"] forKey:@"fromNickname"];
        [replyDict setObject:[theDict objectForKey:@"fromHeadImg"] forKey:@"fromHeadImg"];
        [replyArray insertObject:replyDict atIndex:0];
        [userDefault setObject:replyArray forKey:NewComment];
        [userDefault setObject:mydynamicDict forKey:MyDynamic];
        [userDefault synchronize];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];

}

-(void)newMessageReceived:(NSDictionary *)messageContent
{
    NSRange range = [[messageContent objectForKey:@"sender"] rangeOfString:@"@"];
    NSString * sender = [[messageContent objectForKey:@"sender"] substringToIndex:range.location];
    if (![DataStoreManager ifHaveThisFriend:sender]&&[[messageContent objectForKey:@"msgType"] isEqualToString:@"normalchat"]) {
        [self requestPeopleInfoWithName:sender ForType:1 Msg:nil];
    }
    
    [self storeNewMessage:messageContent];
    [self displayMsgsForDefaultView];
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
    NSString * type = [messageContent objectForKey:@"msgType"];
    type = type?type:@"notype";
    if ([type isEqualToString:@"reply"]||[type isEqualToString:@"zanDynamic"]) {
        [DataStoreManager storeNewMsgs:messageContent senderType:SYSTEMNOTIFICATION];
    }
    else if ([type isEqualToString:@"notice"]||[type isEqualToString:@"ency"]||[type isEqualToString:@"exper"]||[type isEqualToString:@"bbs_note"]){
        [DataStoreManager storeNewMsgs:messageContent senderType:SYSTEMNOTIFICATION];
    }
    else if ([type isEqualToString:@"bbs_special_subject"]){
//        [DataStoreManager storeNewMsgs:messageContent senderType:NewSpecialSubject];
    }
    else if([type isEqualToString:@"normalchat"])
    {
        AudioServicesPlayAlertSound(1007);
        [DataStoreManager storeNewMsgs:messageContent senderType:COMMONUSER];
        [self drawMoodWithString:[messageContent objectForKey:@"msg"]];
    }
//    NSRange range = [[messageContent objectForKey:@"sender"] rangeOfString:@"@"];
//    NSString * sender = [[messageContent objectForKey:@"sender"] substringToIndex:range.location];
}

-(void)drawMoodWithString:(NSString *)msgContent
{
    [judgeDrawmood isExsitKeyWordsInTheSentence:msgContent ExsitYES:^void(NSString * theType) {
        NSLog(@"exsit:%@",theType);
        NSArray * pArray;
        if ([theType isEqualToString:@"NewYear"]) {
            pArray = @[@"🎉",@"🎁",@"✨"];
        }
        else if ([theType isEqualToString:@"Christmas"]){
            pArray = @[@"🔔",@"🎄"];
        }
        else if ([theType isEqualToString:@"Birthday"]){
            pArray = @[@"🎁",@"🎂"];
        }
        UIWindow * uWin;
        if ([[UIApplication sharedApplication].windows count] > 1 )
        {
            uWin=[[UIApplication sharedApplication].windows objectAtIndex:1];
            
        }
        else
        {
            uWin = [UIApplication sharedApplication].keyWindow;
        }
        
        [[AnimationStoreManager sharedManager] doAnimationWithTypeArray:pArray view:uWin];
    } ExsitNO:^void() {
        NSLog(@"not exsit");
    }];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag==301) {
        if (buttonIndex==0) {
            TempData * tp = [TempData sharedInstance];
            tp.needToQRCodePage = YES;
            [self.customTabBarController setSelectedPage:1];
        }
        else if (buttonIndex==2){
            NSString * theLink = @"http://www.52pet.net/XXX";
            if (appStoreURL&&![appStoreURL isKindOfClass:[NSNull class]]) {
                NSURL * theURL = [NSURL URLWithString:theLink];
                if ([[UIApplication sharedApplication] canOpenURL:theURL]) {
                    [[UIApplication sharedApplication] openURL:theURL];
                }
            }
        }
    }
    else{
        if (buttonIndex==0) {
            NSString * appLink = appStoreURL;
            if (appStoreURL&&![appStoreURL isKindOfClass:[NSNull class]]) {
                NSURL *url = [NSURL URLWithString:appLink];
                if([[UIApplication sharedApplication] canOpenURL:url])
                {
                    [[UIApplication sharedApplication] openURL:url];
                }
            }
    }
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSPredicate *resultPredicate = [NSPredicate predicateWithFormat:@"SELF contains[cd] %@",searchBar.text];
    NSLog(@"%@",searchBar.text);
    
    searchResultArray = [pyChineseArray filteredArrayUsingPredicate:resultPredicate ]; //注意retain
    NSLog(@"%@",searchResultArray);
    if ([tableView isEqual:self.searchDisplayController.searchResultsTableView]) {
        return [searchResultArray count];
    }
    else
        return allMsgArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 65;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"userCell";
    MessageCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[MessageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    if (indexPath.row==0) {
        cell.headImageV.placeholderImage = [UIImage imageNamed:@"newfriend.png"];
    }
    else
    {
        cell.headImageV.placeholderImage = [UIImage imageNamed:@"placeholderman.png"];
    }
    if ([tableView isEqual:self.searchDisplayController.searchResultsTableView]) {
        NSString * thisOne = [searchResultArray objectAtIndex:indexPath.row];
        NSInteger theIndex = [pyChineseArray indexOfObject:thisOne];
        NSURL * theUrl = [NSURL URLWithString:[BaseImageUrl stringByAppendingFormat:@"%@",[allHeadImgArray objectAtIndex:theIndex]]];
        if ([[[allMsgArray objectAtIndex:theIndex] objectForKey:@"sender"] isEqualToString:@"123456789"]) {
            [cell.headImageV setImage:[UIImage imageNamed:@"noti.png"]];
        }
        else if ([[[allMsgArray objectAtIndex:theIndex] objectForKey:@"sender"] isEqualToString:@"bbs_special_subject"]){
            [cell.headImageV setImage:[UIImage imageNamed:@"special_subject"]];
        }
        else
            cell.headImageV.imageURL = theUrl;
//        [cell.headImageV setImageWithURL:theUrl placeholderImage:[UIImage imageNamed:[BaseImageUrl stringByAppendingFormat:@"%@",[allHeadImgArray objectAtIndex:theIndex]]]];
        if ([[allMsgUnreadArray objectAtIndex:theIndex] intValue]>0) {
            cell.unreadCountLabel.hidden = NO;
            cell.notiBgV.hidden = NO;
            [cell.unreadCountLabel setText:[allMsgUnreadArray objectAtIndex:theIndex]];
            if ([[allMsgUnreadArray objectAtIndex:theIndex] intValue]>99) {
                [cell.unreadCountLabel setText:@"99"];
            }
        }
        else
        {
            cell.unreadCountLabel.hidden = YES;
            cell.notiBgV.hidden = YES;
        }
//        cell.nameLabel.text = [[allMsgArray objectAtIndex:theIndex] objectForKey:@"sender"];
//        if (![[allNickNameArray objectAtIndex:theIndex] isEqualToString:@"no"]) {
            cell.nameLabel.text = [allNickNameArray objectAtIndex:theIndex];
//        }
        cell.contentLabel.text = [[allMsgArray objectAtIndex:theIndex] objectForKey:@"msg"];
        cell.timeLabel.text = [Common CurrentTime:[Common getCurrentTime] AndMessageTime:[[allMsgArray objectAtIndex:theIndex] objectForKey:@"time"]];

    }
    else
    {
        NSURL * theUrl = [NSURL URLWithString:[BaseImageUrl stringByAppendingFormat:@"%@",[allHeadImgArray objectAtIndex:indexPath.row]]];
        if ([[[allMsgArray objectAtIndex:indexPath.row] objectForKey:@"sender"] isEqualToString:@"123456789"]) {
            [cell.headImageV setImage:[UIImage imageNamed:@"noti.png"]];
        }
        else if ([[[allMsgArray objectAtIndex:indexPath.row] objectForKey:@"sender"] isEqualToString:@"bbs_special_subject"]){
            [cell.headImageV setImage:[UIImage imageNamed:@"special_subject"]];
        }
        else
            cell.headImageV.imageURL = theUrl;
//        [cell.headImageV setImageWithURL:theUrl placeholderImage:[UIImage imageNamed:[BaseImageUrl stringByAppendingFormat:@"%@",[allHeadImgArray objectAtIndex:indexPath.row]]]];
        if ([[allMsgUnreadArray objectAtIndex:indexPath.row] intValue]>0) {
            cell.unreadCountLabel.hidden = NO;
            cell.notiBgV.hidden = NO;
            [cell.unreadCountLabel setText:[allMsgUnreadArray objectAtIndex:indexPath.row]];
            if ([[allMsgUnreadArray objectAtIndex:indexPath.row] intValue]>99) {
                [cell.unreadCountLabel setText:@"99"];
            }
        }
        else
        {
            cell.unreadCountLabel.hidden = YES;
            cell.notiBgV.hidden = YES;
        }
//        cell.nameLabel.text = [[allMsgArray objectAtIndex:indexPath.row] objectForKey:@"sender"];
//        if (![[allNickNameArray objectAtIndex:indexPath.row] isEqualToString:@"no"]) {
            cell.nameLabel.text = [allNickNameArray objectAtIndex:indexPath.row];
//        }
        cell.contentLabel.text = [[allMsgArray objectAtIndex:indexPath.row] objectForKey:@"msg"]; 
        cell.timeLabel.text = [Common CurrentTime:[Common getCurrentTime] AndMessageTime:[[allMsgArray objectAtIndex:indexPath.row] objectForKey:@"time"]];
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if ([tableView isEqual:self.searchDisplayController.searchResultsTableView]) {
        [searchDisplay setActive:NO animated:NO];
        NSString * thisOne = [searchResultArray objectAtIndex:indexPath.row];
        NSInteger theIndex = [pyChineseArray indexOfObject:thisOne];
        if ([[allNickNameArray objectAtIndex:theIndex] isEqualToString:ZhaoHuLan]) {
            FriendsReqsViewController * friq = [[FriendsReqsViewController alloc] init];
            [self.navigationController pushViewController:friq animated:YES];
            [searchDisplay setActive:NO animated:NO];
            [tableView deselectRowAtIndexPath:indexPath animated:YES];
            [self.customTabBarController hidesTabBar:YES animated:YES];
            return;
        }
        if ([[[allMsgArray objectAtIndex:theIndex] objectForKey:@"sender"] isEqualToString:@"123456789"]) {
            NotificationViewController * notiV = [[NotificationViewController alloc] init];
            [self.navigationController pushViewController:notiV animated:YES];
            [self.customTabBarController hidesTabBar:YES animated:YES];
            return;
        }
        else if ([[[allMsgArray objectAtIndex:theIndex] objectForKey:@"sender"] isEqualToString:@"bbs_special_subject"]) {
            canProcess = NO;
            SubjectViewController* subjectVC = [[SubjectViewController alloc]init];
            [self.navigationController pushViewController:subjectVC animated:YES];
            [self.customTabBarController hidesTabBar:YES animated:YES];
            return;
        }
        KKChatController * kkchat = [[KKChatController alloc] init];
        kkchat.chatWithUser = [[allMsgArray objectAtIndex:theIndex] objectForKey:@"sender"];
        kkchat.nickName = [allNickNameArray objectAtIndex:theIndex];
        kkchat.chatUserImg = [allHeadImgArray objectAtIndex:theIndex];
        [self.navigationController pushViewController:kkchat animated:YES];
        kkchat.msgDelegate = self;
        
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        [self.customTabBarController hidesTabBar:YES animated:YES];
        return;
    }
    if ([[allNickNameArray objectAtIndex:indexPath.row] isEqualToString:ZhaoHuLan]) {
        FriendsReqsViewController * friq = [[FriendsReqsViewController alloc] init];
        [self.navigationController pushViewController:friq animated:YES];
        [searchDisplay setActive:NO animated:NO];
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        [self.customTabBarController hidesTabBar:YES animated:YES];
        return;
    }
    if ([[[allMsgArray objectAtIndex:indexPath.row] objectForKey:@"sender"] isEqualToString:@"123456789"]) {
        NotificationViewController * notiV = [[NotificationViewController alloc] init];
        [self.navigationController pushViewController:notiV animated:YES];
        [self.customTabBarController hidesTabBar:YES animated:YES];
        return;
    }
    else if ([[[allMsgArray objectAtIndex:indexPath.row] objectForKey:@"sender"] isEqualToString:@"bbs_special_subject"]) {
        canProcess = NO;
        SubjectViewController* subjectVC = [[SubjectViewController alloc]init];
        [self.navigationController pushViewController:subjectVC animated:YES];
        [self.customTabBarController hidesTabBar:YES animated:YES];
        return;
    }
    KKChatController * kkchat = [[KKChatController alloc] init];
    kkchat.chatWithUser = [[allMsgArray objectAtIndex:indexPath.row] objectForKey:@"sender"];
    kkchat.nickName = [allNickNameArray objectAtIndex:indexPath.row];
    kkchat.chatUserImg = [allHeadImgArray objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:kkchat animated:YES];
    kkchat.msgDelegate = self;
    [searchDisplay setActive:NO animated:NO];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.customTabBarController hidesTabBar:YES animated:YES];
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row==0) {
        return NO;
    }
    return YES;
}
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle==UITableViewCellEditingStyleDelete)
    {
       // [DataStoreManager deleteMsgsWithSender:[[allMsgArray objectAtIndex:indexPath.row] objectForKey:@"sender"] Type:COMMONUSER];
        [DataStoreManager deleteThumbMsgWithSender:[[allMsgArray objectAtIndex:indexPath.row] objectForKey:@"sender"]];
        [allMsgArray removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationRight];
        [self displayMsgsForDefaultView];
        
        
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
//    [self performSelector:@selector(endRefresh)
//                     withObject:nil afterDelay:2
//                        inModes:[NSArray arrayWithObject:NSRunLoopCommonModes]];
    if (![self.appDel.xmppHelper isConnected]&&![titleLabel.text isEqualToString:@"消息(连接中...)"]&&reV.networkAvailable) {
        if ([[TempData sharedInstance] ifOpened]) {
            [self logInToChatServer];
        }
        else
            [self logInToServer];
        // [self getMyUserInfoFromNet];
    }
    else
    {
        [self performSelector:@selector(endRefresh)
                              withObject:nil afterDelay:1
                                 inModes:[NSArray arrayWithObject:NSRunLoopCommonModes]];

    }
    
}
-(void)endRefresh
{
    [_slimeView endRefreshFinish:^{
        [UIView animateWithDuration:0.3 animations:^{
            self.messageTable.contentOffset = CGPointMake(0, 44);
        }];
    }];
}
-(void)getMyUserInfoFromNet
{
    NSTimeInterval cT = [[NSDate date] timeIntervalSince1970];
    long long a = (long long)(cT*1000);
    NSMutableDictionary* body = [[NSMutableDictionary alloc]init];
    [body setObject:@"1" forKey:@"channel"];
    [body setObject:[SFHFKeychainUtils getPasswordForUsername:LOCALTOKEN andServiceName:LOCALACCOUNT error:nil] forKey:@"token"];
    [body setObject:@"iphone" forKey:@"imei"];
    [body setObject:@"getUserinfo" forKey:@"method"];
    [body setObject:@"service.uri.pet_user" forKey:@"service"];
    [body setObject:[NSString stringWithFormat:@"%lld",a] forKey:@"connectTime"];
    [NetManager requestWithURLStr:BaseClientUrl Parameters:body TheController:self success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self saveMyInfo:responseObject];
        
        [self getMyPetInfoFromNet];
    }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];

}
-(void)getFriendByHttp
{
    //    NSMutableDictionary * paramDict = [NSMutableDictionary dictionary];
    NSMutableDictionary * postDict = [NSMutableDictionary dictionary];
    //    [paramDict setObject:userName forKey:@"username"];
    //    [postDict setObject:paramDict forKey:@"params"];
    [postDict setObject:@"1" forKey:@"channel"];
    [postDict setObject:@"service.uri.pet_user" forKey:@"service"];
    [postDict setObject:[SFHFKeychainUtils getPasswordForUsername:LOCALTOKEN andServiceName:LOCALACCOUNT error:nil] forKey:@"token"];
    [postDict setObject:[SFHFKeychainUtils getPasswordForUsername:MACADDRESS andServiceName:LOCALACCOUNT error:nil] forKey:@"mac"];
    [postDict setObject:@"iphone" forKey:@"imei"];
    NSTimeInterval cT = [[NSDate date] timeIntervalSince1970];
    long long a = (long long)(cT*1000);
    [postDict setObject:[NSString stringWithFormat:@"%lld",a] forKey:@"connectTime"];
    [postDict setObject:@"getFriendList" forKey:@"method"];
    [NetManager requestWithURLStr:BaseClientUrl Parameters:postDict TheController:self success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //        NSString *receiveStr = [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
        //        NSDictionary * recDict = [receiveStr JSONValue];
        //        [DataStoreManager saveUserInfo:responseObject];
        //        [self refreshFriendList];
        TempData * uu = [TempData sharedInstance];
        uu.haveGotFriends = YES;
        [self parseFriendsList:responseObject];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
    
}
-(void)parseFriendsList:(NSArray *)friendsList
{
    dispatch_queue_t queue = dispatch_queue_create("com.pet.StoreFriends", NULL);
     dispatch_async(queue, ^{
    for (NSDictionary * dict in friendsList) {
       
            [DataStoreManager saveUserInfo:dict];
 
    }
         dispatch_async(dispatch_get_main_queue(), ^{
             
         });
     });

}

-(void)getMyPetInfoFromNet
{
    NSTimeInterval cT = [[NSDate date] timeIntervalSince1970];
    long long a = (long long)(cT*1000);
    NSMutableDictionary* body = [[NSMutableDictionary alloc]init];
    [body setObject:@"1" forKey:@"channel"];
    [body setObject:[SFHFKeychainUtils getPasswordForUsername:LOCALTOKEN andServiceName:LOCALACCOUNT error:nil] forKey:@"token"];
    [body setObject:@"iphone" forKey:@"imei"];
    [body setObject:@"getPetinfo" forKey:@"method"];
    [body setObject:@"service.uri.pet_user" forKey:@"service"];
    [body setObject:[NSString stringWithFormat:@"%lld",a] forKey:@"connectTime"];
    [NetManager requestWithURLStr:BaseClientUrl Parameters:body TheController:self success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSArray * petsArray = responseObject;
        for (NSDictionary * dict in petsArray) {
            [DataStoreManager storeOnePetInfo:dict];
        }
        if (petsArray.count>0) {
//            NSString * bindedQRcode = [[NSUserDefaults standardUserDefaults] objectForKey:@"bindedQR"];
//            if (!bindedQRcode) {
//                [[NSUserDefaults standardUserDefaults] setObject:@"yes" forKey:@"bindedQR"];
//                [[NSUserDefaults standardUserDefaults] synchronize];
//                UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"检测到您已经添加了宠物，要不要将您的宠物绑定一个防丢失二维码呢？" delegate:self cancelButtonTitle:@"去绑定" otherButtonTitles:@"不用了",@"那是什么？", nil];
//                alert.tag = 301;
//                [alert show];
//            }
        }
        [self getFriendByHttp];
    }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self getFriendByHttp];
    }];
}

-(void)logInToServer
{

    titleLabel.text = @"消息(连接中...)";
    NSMutableDictionary * userInfoDict = [NSMutableDictionary dictionary];
    NSMutableDictionary * postDict = [NSMutableDictionary dictionary];
//    [userInfoDict setObject:[SFHFKeychainUtils getPasswordForUsername:ACCOUNT andServiceName:LOCALACCOUNT error:nil] forKey:@"username"];
//    [userInfoDict setObject:[SFHFKeychainUtils getPasswordForUsername:PASSWORD andServiceName:LOCALACCOUNT error:nil] forKey:@"password"];
//    [userInfoDict setObject:@"31" forKey:@"imgId"];
//    [userInfoDict setObject:@"2" forKey:@"type"];
    [userInfoDict setObject:@"open" forKey:@"action"];
//    NSString * version = [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString *)kCFBundleVersionKey];
//    [userInfoDict setObject:version forKey:@"version"];
    [postDict setObject:userInfoDict forKey:@"params"];
    [postDict setObject:@"1" forKey:@"channel"];
    [postDict setObject:@"token" forKey:@"method"];
    [postDict setObject:@"service.uri.pet_sso" forKey:@"service"];
    [postDict setObject:[SFHFKeychainUtils getPasswordForUsername:LOCALTOKEN andServiceName:LOCALACCOUNT error:nil] forKey:@"token"];
    [postDict setObject:[SFHFKeychainUtils getPasswordForUsername:MACADDRESS andServiceName:LOCALACCOUNT error:nil] forKey:@"mac"];
    [postDict setObject:@"iphone" forKey:@"imei"];

    NSTimeInterval cT = [[NSDate date] timeIntervalSince1970];
    long long a = (long long)(cT*1000);
    [postDict setObject:[NSString stringWithFormat:@"%lld",a] forKey:@"connectTime"];
    
    [NetManager requestWithURLStr:BaseClientUrl Parameters:postDict TheController:self success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        NSString *receiveStr = [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
//        NSDictionary * recDict = [receiveStr JSONValue];
//        if ([[recDict objectForKey:@"token"] length]>3) {
            [self logInServerSuccessWithInfo:responseObject];
//        }
//        else
//        {
//            titleLabel.text = @"消息(未连接)";
//        }
     
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self makeLogFailurePrompt];
    }];
}

//-(void)authenticToken
//{
//    
//}

-(void)logInServerSuccessWithInfo:(NSDictionary *)dict
{
    [[TempData sharedInstance] setOpened:YES];
//    NSString * version = [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString *)kCFBundleVersionKey];
//
//    if ([[[dict objectForKey:@"version"] objectForKey:@"petVersion"] floatValue]>[version floatValue]) {
////        appStoreURL = [dict objectForKey:@"iosurl"];
////        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"检测到新版本，您的版本已低于最低版本需求，请立即升级" delegate:self cancelButtonTitle:@"立即升级" otherButtonTitles: nil];
////        alert.tag = 20;
////        [alert show];
//        appStoreURL = [[dict objectForKey:@"version"] objectForKey:@"iosurl"];
//        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"检测到新版本，您要升级吗" delegate:self cancelButtonTitle:@"立刻升级" otherButtonTitles:@"取消", nil];
//        alert.tag = 21;
//        [alert show];
//    }
//    else if ([[dict objectForKey:@"needUpdate"] intValue]>0) {
//        appStoreURL = [dict objectForKey:@"iosurl"];
//        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"检测到新版本，您要升级吗" delegate:self cancelButtonTitle:@"立刻升级" otherButtonTitles:@"取消", nil];
//        alert.tag = 21;
//        [alert show];
//    }
    [SFHFKeychainUtils storeUsername:LOCALTOKEN andPassword:[[dict objectForKey:@"authenticationToken"] objectForKey:@"token"] forServiceName:LOCALACCOUNT updateExisting:YES error:nil];
    [SFHFKeychainUtils storeUsername:ACCOUNT andPassword:[[dict objectForKey:@"authenticationToken"] objectForKey:@"username"] forServiceName:LOCALACCOUNT updateExisting:YES error:nil];
    [DataStoreManager storeMyUserID:[[dict objectForKey:@"authenticationToken"] objectForKey:@"userid"]];
    TempData * tp = [TempData sharedInstance];
    tp.hostPort = [[dict objectForKey:@"chatserver"] objectForKey:@"port"]?[[dict objectForKey:@"chatserver"] objectForKey:@"port"]:@"5222";
    [tp SetServer:[[dict objectForKey:@"chatserver"] objectForKey:@"address"] TheDomain:[[dict objectForKey:@"chatserver"] objectForKey:@"name"]];
    
//    NSString * receivedImgStr = [dict objectForKey:@"firstImage"];
//    NSString * openImgStr = [[NSUserDefaults standardUserDefaults] objectForKey:@"OpenImg"];
//    if (!openImgStr||![receivedImgStr isEqualToString:openImgStr]) {
//        [self downloadImageWithID:receivedImgStr Type:@"open" PicName:nil];
//    }
//    [self saveMyInfo:[dict objectForKey:@"petUserView"]];
//    NSString * openImgId = [NSString stringWithFormat:@"%@",[[dict objectForKey:@"petUserView"] objectForKey:@"imgId"]];
////    if (iPhone5) {
////        openImgId = [openImgId stringByAppendingString:@"+ios+320#480"];
////    }
//    NSString *path = [RootDocPath stringByAppendingPathComponent:@"OpenImages"];
//    NSString  *openImgPath = [NSString stringWithFormat:@"%@/openImage_%@.jpg",path,openImgId];
//    NSFileManager *file_manager = [NSFileManager defaultManager];
//    if (![file_manager fileExistsAtPath:openImgPath]) {
//        [self downloadImageWithID:openImgId Type:@"open" PicName:nil];
//    }
    [self getMyUserInfoFromNet];
    [self logInToChatServer];
}
-(void)downloadImageWithID:(NSString *)imageId Type:(NSString *)theType PicName:(NSString *)picName
{
    [NetManager downloadImageWithBaseURLStr:imageId ImageId:@"" success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
        if ([theType isEqualToString:@"open"]) {
            NSString *path = [RootDocPath stringByAppendingPathComponent:@"OpenImages"];
            NSFileManager *fm = [NSFileManager defaultManager];
            if([fm fileExistsAtPath:path] == NO)
            {
                [fm createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
            }
            NSString  *openImgPath = [NSString stringWithFormat:@"%@/openImage.jpg",path];

            
            if ([UIImageJPEGRepresentation(image, 1.0) writeToFile:openImgPath atomically:YES]) {
                NSLog(@"success///");
                [[NSUserDefaults standardUserDefaults] setObject:imageId forKey:@"OpenImg"];
                [[NSUserDefaults standardUserDefaults] synchronize];
            }
            else
            {
                NSLog(@"fail");
            }
//            NSFileManager *file_manager = [NSFileManager defaultManager];
//            if ([file_manager fileExistsAtPath:[[NSUserDefaults standardUserDefaults]objectForKey:@"OpenImg"]]) {
//                [file_manager removeItemAtPath:[[NSUserDefaults standardUserDefaults]objectForKey:@"OpenImg"] error:nil];
//            }
            
        }
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
        
    }];
}
-(void)setTheTitleLabelText
{
    if ([self.appDel.xmppHelper isConnected]) {
        titleLabel.text = @"消息";
    }
    else if ([self.appDel.xmppHelper isConnecting]){
        titleLabel.text = @"消息(连接中...)";
    }
//    else if([self.appDel.xmppHelper isDisconnected]){
//        titleLabel.text = @"消息(未连接)";
//    }
}
-(void)logInToChatServer
{
    if ([self.appDel.xmppHelper isConnected]||[self.appDel.xmppHelper isConnecting]) {
        return;
    }

//    titleLabel.text = @"消息(连接中...)";
//    self.appDel.xmppHelper.notConnect = self;
    self.appDel.xmppHelper.xmpptype = login;
//    [[ReconnectionManager sharedInstance] reconnectionAttemptIfSuccess:^{
////        NSLog(@"登陆成功xmpp");
////        self.appDel.xmppHelper.buddyListDelegate = self;
////        self.appDel.xmppHelper.chatDelegate = self;
////        self.appDel.xmppHelper.processFriendDelegate = self;
////        self.appDel.xmppHelper.addReqDelegate = self;
////        self.appDel.xmppHelper.commentDelegate = self;
//        titleLabel.text = @"消息";
//        [[TempData sharedInstance] setOpened:YES];
//        [self.appDel.xmppHelper checkToServerifSubscibe];
////        [self.appDel.xmppHelper realSubscribeToServer];
//    }];
    
    
//    [self.appDel.xmppHelper connect:[[SFHFKeychainUtils getPasswordForUsername:ACCOUNT andServiceName:LOCALACCOUNT error:nil]stringByAppendingString:[[TempData sharedInstance] getDomain]] password:[SFHFKeychainUtils getPasswordForUsername:LOCALTOKEN andServiceName:LOCALACCOUNT error:nil] host:[[TempData sharedInstance] getServer] success:^(void){
//        NSLog(@"登陆成功xmpp");
//        titleLabel.text = @"消息";
//        [[TempData sharedInstance] setOpened:YES];
//        [self.appDel.xmppHelper checkToServerifSubscibe];
//        [self endRefresh];
//        if (self.regerTimer != nil) {
//            if( [self.regerTimer isValid])
//            {
//                [self.regerTimer invalidate];
//            }
//            self.regerTimer = nil;
//        }
//    }fail:^(NSError *result){
//        titleLabel.text = @"消息(未连接)";
//        [self endRefresh];
//    }];
    
    
    if (!reV.isRunning) {
        [reV reconnectionAttempt];
//        [reV reconnectionAttemptIfSuccess:^{
//            [[TempData sharedInstance] setOpened:YES];
//            [self.appDel.xmppHelper checkToServerifSubscibe];
//            [self endRefresh];
//            titleLabel.text = @"消息";
//        } Failure:^{
//            titleLabel.text = @"消息(未连接)";
//            [self endRefresh];
//        }];
    }

}
-(void)regetXMPPServerAddress
{
    NSMutableDictionary * postDict = [NSMutableDictionary dictionary];
    //    [paramDict setObject:userName forKey:@"username"];
    //    [postDict setObject:paramDict forKey:@"params"];
    [postDict setObject:@"1" forKey:@"channel"];
    [postDict setObject:@"service.uri.pet_sso" forKey:@"service"];
    [postDict setObject:[SFHFKeychainUtils getPasswordForUsername:LOCALTOKEN andServiceName:LOCALACCOUNT error:nil] forKey:@"token"];
    [postDict setObject:[SFHFKeychainUtils getPasswordForUsername:MACADDRESS andServiceName:LOCALACCOUNT error:nil] forKey:@"mac"];
    [postDict setObject:@"iphone" forKey:@"imei"];
    NSTimeInterval cT = [[NSDate date] timeIntervalSince1970];
    long long a = (long long)(cT*1000);
    [postDict setObject:[NSString stringWithFormat:@"%lld",a] forKey:@"connectTime"];
    [postDict setObject:@"getChatServer" forKey:@"method"];
    [NetManager requestWithURLStr:BaseClientUrl Parameters:postDict TheController:self success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary * dict = responseObject;
        TempData * tp = [TempData sharedInstance];
        [tp SetServer:[[dict objectForKey:@"chatserver"] objectForKey:@"address"] TheDomain:[[dict objectForKey:@"chatserver"] objectForKey:@"name"]];
        tp.hostPort = [dict objectForKey:@"port"];
        [self logInToChatServer];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
    
}

-(void)toLoginPage
{

    WelcomeViewController * welcomeV = [[WelcomeViewController alloc] init];
        UINavigationController * navi = [[UINavigationController alloc] initWithRootViewController:welcomeV];
//    [self presentModalViewController:navi animated:NO];
    [self presentViewController:navi animated:NO completion:^{
        
    }];
}
-(void)saveMyInfo:(NSDictionary *)dict
{
    [DataStoreManager saveUserInfo:dict];
}

-(void)searchDisplayControllerWillBeginSearch:(UISearchDisplayController *)controller
{
    if (diffH==20.0f) {
        searchBar.backgroundImage = [UIImage imageNamed:@"topBar1.png"];
        [TopBarBGV setImage:[UIImage imageNamed:@"topBar1.png"]];
        [UIView animateWithDuration:0.3 animations:^{
            [self.messageTable setFrame:CGRectMake(0, 20, 320, self.view.frame.size.height-(49+44+diffH))];
        } completion:^(BOOL finished) {
            
        }];
    }


}

-(void)searchDisplayControllerWillEndSearch:(UISearchDisplayController *)controller
{
    if (diffH==20.0f) {
        
    }
    
}
-(void)searchDisplayControllerDidEndSearch:(UISearchDisplayController *)controller
{
    if (diffH==20.0f) {
        [UIView animateWithDuration:0.2 animations:^{
            [TopBarBGV setImage:[UIImage imageNamed:diffH==0?@"topBar1.png":@"topBar2.png"]];
            [self.messageTable setFrame:CGRectMake(0, reV.networkAvailable?(44+diffH):(44+diffH+30), 320, self.view.frame.size.height-(49+44+diffH))];
        } completion:^(BOOL finished) {
            searchBar.backgroundImage = nil;
            

        }];
    }

    
}
-(void)searchDisplayController:(UISearchDisplayController *)controller willShowSearchResultsTableView:(UITableView *)tableView
{

    if (diffH==20.0f) {
        [tableView setFrame:CGRectMake(0, 20, 320, self.view.frame.size.height-(49+diffH))];
        [tableView setContentOffset:CGPointMake(0, 20)];
    }


}
-(void)requestPeopleInfoWithName:(NSString *)userName ForType:(int)type Msg:(NSString *)msg
{
    NSMutableDictionary * paramDict = [NSMutableDictionary dictionary];
    NSMutableDictionary * postDict = [NSMutableDictionary dictionary];
    [paramDict setObject:userName forKey:@"username"];
    [postDict setObject:paramDict forKey:@"params"];
    [postDict setObject:@"1" forKey:@"channel"];
    [postDict setObject:@"getUserinfo" forKey:@"method"];
    [postDict setObject:@"service.uri.pet_user" forKey:@"service"];
    [postDict setObject:[SFHFKeychainUtils getPasswordForUsername:LOCALTOKEN andServiceName:LOCALACCOUNT error:nil] forKey:@"token"];
    [postDict setObject:[SFHFKeychainUtils getPasswordForUsername:MACADDRESS andServiceName:LOCALACCOUNT error:nil] forKey:@"mac"];
    [postDict setObject:@"iphone" forKey:@"imei"];
    NSTimeInterval cT = [[NSDate date] timeIntervalSince1970];
    long long a = (long long)(cT*1000);
    [postDict setObject:[NSString stringWithFormat:@"%lld",a] forKey:@"connectTime"];
    
    [NetManager requestWithURLStr:BaseClientUrl Parameters:postDict TheController:self success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        NSString *receiveStr = [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSDictionary * recDict = responseObject;
        if (type==0) {
            AudioServicesPlayAlertSound(1007);
            NSDictionary * uDict = [NSDictionary dictionaryWithObjectsAndKeys:[recDict objectForKey:@"username"],@"fromUser",[recDict objectForKey:@"nickname"],@"fromNickname",msg,@"addtionMsg",[recDict objectForKey:@"img"],@"headID", nil];
            [DataStoreManager addPersonToReceivedHellos:uDict];
            [self displayMsgsForDefaultView];
        }
        else if (type==1){
//            AudioServicesPlayAlertSound(1007);
            [DataStoreManager saveUserInfo:recDict];
//            NSString * theMsg = [NSString stringWithFormat:@"我是%@，我们已经是朋友啦!",[recDict objectForKey:@"nickname"]];
//            NSString * ctime = [NSString stringWithFormat:@"%f",[[NSDate date] timeIntervalSince1970]];
//            NSMutableDictionary * newM = [NSMutableDictionary dictionaryWithObjectsAndKeys:theMsg,@"msg",[NSString stringWithFormat:@"%@%@",[recDict objectForKey:@"username"],[[TempData sharedInstance] getDomain]],@"sender",ctime,@"time", nil];
//            [self storeNewMessage:newM];
//            [self displayMsgsForDefaultView];
        }

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}

-(void)displayMsgsForDefaultView
{
    allMsgArray = (NSMutableArray *)[DataStoreManager qureyAllThumbMessages];
    //暂时只有打招呼，所以insert打招呼一个...
    [allMsgArray insertObject:[DataStoreManager qureyLastReceivedHello] atIndex:0];
    [self readAllnickNameAndImage];
    allMsgUnreadArray = (NSMutableArray *)[DataStoreManager queryUnreadCountForCommonMsg];
    [allMsgUnreadArray insertObject:[DataStoreManager qureyUnreadForReceivedHellos] atIndex:0];
//    [allMsgArray insertObject:[DataStoreManager queryLastPublicMsg] atIndex:0];
    [self.messageTable reloadData];
    [self displayTabbarNotification];
}
-(void)readAllnickNameAndImage
{
    NSMutableArray * nickName = [NSMutableArray array];
    NSMutableArray * headimg = [NSMutableArray array];
    NSMutableArray * pinyin = [NSMutableArray array];
    for (int i = 0; i<allMsgArray.count; i++) {
        NSString * nickName2 = [DataStoreManager queryNickNameForUser:[[allMsgArray objectAtIndex:i] objectForKey:@"sender"]];
        [nickName addObject:nickName2];
        NSString * pinyin2 = [self convertChineseToPinYin:nickName2];
        [pinyin addObject:[pinyin2 stringByAppendingFormat:@"+%@",nickName2]];
        [headimg addObject:[DataStoreManager queryFirstHeadImageForUser:[[allMsgArray objectAtIndex:i] objectForKey:@"sender"]]];
    }
    allNickNameArray = nickName;
    allHeadImgArray = headimg;
    pyChineseArray = pinyin;
    NSLog(@"hhhhhhead:%@",allHeadImgArray);
}
-(void)displayTabbarNotification
{
    int allUnread = 0;
    for (int i = 0; i<allMsgUnreadArray.count; i++) {
        allUnread = allUnread+[[allMsgUnreadArray objectAtIndex:i] intValue];
    }
    if (allUnread>0) {
        [self.customTabBarController notificationWithNumber:YES AndTheNumber:allUnread OrDot:NO WithButtonIndex:2];
        if (allUnread>99) {
            [self.customTabBarController notificationWithNumber:YES AndTheNumber:99 OrDot:NO WithButtonIndex:2];
        }
    }
    else
    {
        [self.customTabBarController removeNotificatonOfIndex:2];
    }
 
}
-(void)makeLogFailurePrompt
{
    titleLabel.text = @"消息(未连接)";
    [self endRefresh];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)inspectNewSubject
{
  if ([SFHFKeychainUtils getPasswordForUsername:LOCALTOKEN andServiceName:LOCALACCOUNT error:nil] && canProcess) {
      NSTimeInterval cT = [[NSDate date] timeIntervalSince1970];
      long long a = (long long)(cT*1000);
      NSMutableDictionary* params = [NSMutableDictionary dictionary];
      [params setObject:@"0" forKey:@"pageNo"];
      [params setObject:@"1" forKey:@"pageSize"];
      NSMutableDictionary* body = [NSMutableDictionary dictionary];
      [body setObject:params forKey:@"params"];
      [body setObject:@"getSpecialSubjectList" forKey:@"method"];
      [body setObject:@"service.uri.pet_bbs" forKey:@"service"];
      [body setObject:@"1" forKey:@"channel"];
      [body setObject:[SFHFKeychainUtils getPasswordForUsername:MACADDRESS andServiceName:LOCALACCOUNT error:nil] forKey:@"mac"];
      [body setObject:@"iphone" forKey:@"imei"];
      [body setObject:[NSString stringWithFormat:@"%lld",a] forKey:@"connectTime"];
      [body setObject:[SFHFKeychainUtils getPasswordForUsername:LOCALTOKEN andServiceName:LOCALACCOUNT error:nil] forKey:@"token"];
      [NetManager requestWithURLStr:BaseClientUrl Parameters:body TheController:self success:^(AFHTTPRequestOperation *operation, id responseObject) {
          NSLog(@"%@",responseObject);
          if (!((NSArray*)responseObject).count>0) {
              return ;
          }
          NSString * str = ((NSDictionary*)((NSArray*)responseObject[0])[0])[@"id"];
          NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
          NSMutableArray* array = [NSMutableArray arrayWithArray:[userDefaults objectForKey:@"52petMySubject"]];
          if (array.count>0) {
              NSString * str2 = ((NSDictionary*)((NSArray*)array[0])[0])[@"id"];
              if (![str isEqualToString:str2]) {
                  [array insertObject:responseObject[0] atIndex:0];
                  [userDefaults setObject:array forKey:@"52petMySubject"];
                  [userDefaults synchronize];
                  NSMutableDictionary* dic = [NSMutableDictionary dictionary];
                  [dic setObject:((NSDictionary*)((NSArray*)responseObject[0])[0])[@"name"] forKey:@"msg"];
                  [dic setObject:[Common getCurrentTime] forKey:@"time"];
                  [dic setObject:@"bbs_special_subject" forKey:@"contentType"];
                  [dic setObject:@"bbs_special_subject" forKey:@"msgType"];
                  [dic setObject:@"bbs_special_subject@xxx.com" forKey:@"sender"];
                  AudioServicesPlayAlertSound(1003);
                  [self newMessageReceived:dic];
              }
          }
          else if ([self timeIsToday:((NSDictionary*)((NSArray*)responseObject[0])[0])[@"et"]])
          {
              [array insertObject:responseObject[0] atIndex:0];
              [userDefaults setObject:array forKey:@"52petMySubject"];
              [userDefaults synchronize];
              NSMutableDictionary* dic = [NSMutableDictionary dictionary];
              [dic setObject:((NSDictionary*)((NSArray*)responseObject[0])[0])[@"name"] forKey:@"msg"];
              [dic setObject:[Common getCurrentTime] forKey:@"time"];
              [dic setObject:@"bbs_special_subject" forKey:@"contentType"];
              [dic setObject:@"bbs_special_subject" forKey:@"msgType"];
              [dic setObject:@"bbs_special_subject@xxx.com" forKey:@"sender"];
              AudioServicesPlayAlertSound(1003);
              [self newMessageReceived:dic];
          }
      } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
          
      }];
  }
}
-(BOOL)timeIsToday:(NSString*)time
{
    NSTimeInterval nowTime = [[NSDate date] timeIntervalSince1970];
    NSDateFormatter * dateF= [[NSDateFormatter alloc]init];
    dateF.dateFormat = @"yyyy-MM-dd";
    NSString * today = [dateF stringFromDate:[NSDate dateWithTimeIntervalSince1970:nowTime]];
    if ([[time substringToIndex:10] isEqualToString:today]) {
        return YES;
    }
    return NO;
}
@end
