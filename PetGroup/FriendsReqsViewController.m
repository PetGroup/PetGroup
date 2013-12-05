//
//  FriendsReqsViewController.m
//  PetGroup
//
//  Created by Tolecen on 13-8-27.
//  Copyright (c) 2013年 Tolecen. All rights reserved.
//

#import "FriendsReqsViewController.h"
#import "AppDelegate.h"
#import "XMPPHelper.h"
#import "JSON.h"
@interface FriendsReqsViewController ()

@end

@implementation FriendsReqsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        receivedHellos = [NSArray array];
    }
    return self;
}
-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.appDel = [[UIApplication sharedApplication] delegate];
    float diffH = [Common diffHeight:self];
    
    [AFImageRequestOperation addAcceptableContentTypes:[NSSet setWithObject:@"multipart/form-data"]];
    
    UIImageView *TopBarBGV=[[UIImageView alloc]initWithImage:[UIImage imageNamed:diffH==0?@"topBar1.png":@"topBar2.png"]];
    [TopBarBGV setFrame:CGRectMake(0, 0, 320, 44+diffH)];
    [self.view addSubview:TopBarBGV];
    
    UIButton *backButton=[UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame=CGRectMake(0, 0+diffH, 80, 44);
    [backButton setBackgroundImage:[UIImage imageNamed:@"backnew.png"] forState:UIControlStateNormal];
    [self.view addSubview:backButton];
    [backButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    
    
    UILabel *titleLabel=[[UILabel alloc] initWithFrame:CGRectMake(100, 2+diffH, 120, 40)];
    titleLabel.backgroundColor=[UIColor clearColor];
    titleLabel.text=@"添加好友请求";
    [titleLabel setFont:[UIFont boldSystemFontOfSize:18]];
    titleLabel.textAlignment=NSTextAlignmentCenter;
    titleLabel.textColor=[UIColor whiteColor];
    [self.view addSubview:titleLabel];
    
    

    self.reqTableV = [[UITableView alloc] initWithFrame:CGRectMake(0, 44+diffH, 320, self.view.frame.size.height-(44+diffH)) style:UITableViewStylePlain];
    [self.view addSubview:self.reqTableV];
    self.reqTableV.dataSource = self;
    self.reqTableV.delegate = self;
    
    [self loadTableviewData];
    [DataStoreManager blankReceivedHellosUnreadCount];
	// Do any additional setup after loading the view.
}
-(void)viewWillAppear:(BOOL)animated
{
    self.appDel.xmppHelper.addReqDelegate = self;
    self.appDel.xmppHelper.chatDelegate = self;
}
-(void)newAddReq:(NSDictionary *)userInfo
{
    NSString * fromUser = [userInfo objectForKey:@"sender"];
    NSRange range = [fromUser rangeOfString:@"@"];
    fromUser = [fromUser substringToIndex:range.location];
    [self requestPeopleInfoWithName:fromUser ForType:0 Msg:[userInfo objectForKey:@"msg"]];

}
-(void)requestPeopleInfoWithName:(NSString *)userName ForType:(int)type Msg:(NSString *)msg
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
    
    [NetManager requestWithURLStr:BaseClientUrl Parameters:postDict TheController:self success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *receiveStr = [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSDictionary * recDict = [receiveStr JSONValue];
        if (type==0) {
            NSDictionary * uDict = [NSDictionary dictionaryWithObjectsAndKeys:[recDict objectForKey:@"username"],@"fromUser",[recDict objectForKey:@"nickname"],@"fromNickname",msg,@"addtionMsg",[recDict objectForKey:@"img"],@"headID", nil];
            [DataStoreManager addPersonToReceivedHellos:uDict];
            [self loadTableviewData];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}

-(void)newMessageReceived:(NSDictionary *)messageCotent{
    
    AudioServicesPlayAlertSound(1003);

//    NSRange range = [[messageCotent objectForKey:@"sender"] rangeOfString:@"@"];
//    NSString * sender = [[messageCotent objectForKey:@"sender"] substringToIndex:range.location];
    [DataStoreManager storeNewMsgs:messageCotent senderType:COMMONUSER];
}

-(void)viewDidAppear:(BOOL)animated
{
    [self loadTableviewData];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return receivedHellos.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * stringCell3 = @"cellreq";
    addFriendCell * cell = [tableView dequeueReusableCellWithIdentifier:stringCell3];
    if (!cell) {
        cell = [[addFriendCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:stringCell3];
    }
    if ([[[receivedHellos objectAtIndex:indexPath.row] objectForKey:@"unread"] intValue]>0) {
        cell.unreadCountLabel.hidden = NO;
        cell.notiBgV.hidden = NO;
        [cell.unreadCountLabel setText:[[receivedHellos objectAtIndex:indexPath.row] objectForKey:@"unread"]];
        if ([[[receivedHellos objectAtIndex:indexPath.row] objectForKey:@"unread"] intValue]>99) {
            [cell.unreadCountLabel setText:@"99"];
        }
    }
    else
    {
        cell.unreadCountLabel.hidden = YES;
        cell.notiBgV.hidden = YES;
    }

    cell.headImageV.placeholderImage = [UIImage imageNamed:@"moren_people.png"];
    cell.headImageV.imageURL = [NSURL URLWithString:[BaseImageUrl stringByAppendingFormat:@"%@",[self getHead:[[receivedHellos objectAtIndex:indexPath.row] objectForKey:@"headImgID"]]]];
    cell.headImageV.tag = indexPath.row+1;
    [cell.headImageV addTarget:self action:@selector(toDetailPage:) forControlEvents:UIControlEventTouchUpInside];
//    [cell.headImageV setImageWithURL:[NSURL URLWithString:[BaseImageUrl stringByAppendingFormat:@"%@",[[receivedHellos objectAtIndex:indexPath.row] objectForKey:@"headImgID"]]] placeholderImage:[UIImage imageNamed:[BaseImageUrl stringByAppendingFormat:@"%@",[[receivedHellos objectAtIndex:indexPath.row] objectForKey:@"headImgID"]]]];
    cell.nameLabel.text = [[receivedHellos objectAtIndex:indexPath.row] objectForKey:@"nickName"];
    cell.msgLabel.text = [[receivedHellos objectAtIndex:indexPath.row] objectForKey:@"addtionMsg"];
    cell.agreeBtn.tag = indexPath.row+1;
    cell.rejectBtn.tag = indexPath.row+1;
    [cell.agreeBtn addTarget:self action:@selector(acceptAddReq:) forControlEvents:UIControlEventTouchUpInside];
    [cell.rejectBtn addTarget:self action:@selector(rejectAddreq:) forControlEvents:UIControlEventTouchUpInside];
    if ([[[receivedHellos objectAtIndex:indexPath.row] objectForKey:@"acceptStatus"] isEqualToString:@"accept"]) {
        cell.selectionStyle = UITableViewCellSelectionStyleBlue;
        cell.agreeBtn.hidden = YES;
        [cell.rejectBtn setTitle:@"已同意" forState:UIControlStateNormal];
        [cell.rejectBtn setEnabled:NO];
    }
    else if([[[receivedHellos objectAtIndex:indexPath.row] objectForKey:@"acceptStatus"] isEqualToString:@"rejected"]){
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.agreeBtn.hidden = YES;
        [cell.rejectBtn setTitle:@"已拒绝" forState:UIControlStateNormal];
        [cell.rejectBtn setEnabled:NO];
    }
    else if([[[receivedHellos objectAtIndex:indexPath.row] objectForKey:@"acceptStatus"] isEqualToString:@"waiting"]){
        cell.selectionStyle = UITableViewCellSelectionStyleBlue;
        cell.agreeBtn.hidden = NO;
        cell.rejectBtn.hidden = NO;
        [cell.rejectBtn setTitle:@"拒绝" forState:UIControlStateNormal];
    }
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (![[[receivedHellos objectAtIndex:indexPath.row] objectForKey:@"acceptStatus"] isEqualToString:@"rejected"]) {
        [DataStoreManager blankUnreadCountReceivedHellosForUser:[[receivedHellos objectAtIndex:indexPath.row] objectForKey:@"userName"]];
        KKChatController * kkchat = [[KKChatController alloc] init];
        kkchat.chatWithUser = [[receivedHellos objectAtIndex:indexPath.row] objectForKey:@"userName"];
        kkchat.nickName = [[receivedHellos objectAtIndex:indexPath.row] objectForKey:@"nickName"];
        kkchat.chatUserImg = [self getHead:[[receivedHellos objectAtIndex:indexPath.row] objectForKey:@"headImgID"]];
        kkchat.friendStatus = [[receivedHellos objectAtIndex:indexPath.row] objectForKey:@"acceptStatus"];
        [self.navigationController pushViewController:kkchat animated:YES];
        [tableView deselectRowAtIndexPath:indexPath animated:YES];

    }
    
}
-(void)toDetailPage:(EGOImageButton *)sender
{
    [DataStoreManager blankUnreadCountReceivedHellosForUser:[[receivedHellos objectAtIndex:(sender.tag-1)] objectForKey:@"userName"]];
    PersonDetailViewController * detailV = [[PersonDetailViewController alloc] init];
    HostInfo * hostInfo = [[HostInfo alloc] initWithHostInfo:[NSDictionary dictionaryWithObjectsAndKeys:[[receivedHellos objectAtIndex:(sender.tag-1)] objectForKey:@"nickName"],@"nickname", nil]];
    detailV.hostInfo = hostInfo;
    detailV.friendStatus = [[receivedHellos objectAtIndex:(sender.tag-1)] objectForKey:@"acceptStatus"];
    detailV.hostInfo.userName = [[receivedHellos objectAtIndex:(sender.tag-1)] objectForKey:@"userName"];
    detailV.needRequest = YES;
    [self.navigationController pushViewController:detailV animated:YES];
}
-(void)acceptAddReq:(UIButton *)sender
{
    NSXMLElement *body = [NSXMLElement elementWithName:@"body"];
    [body setStringValue:[NSString stringWithFormat:@"我是%@，我们已经是朋友啦!",[DataStoreManager queryNickNameForUser:[SFHFKeychainUtils getPasswordForUsername:ACCOUNT andServiceName:LOCALACCOUNT error:nil]]]];
    
    //生成XML消息文档
    NSXMLElement *mes = [NSXMLElement elementWithName:@"message"];
    //   [mes addAttributeWithName:@"nickname" stringValue:@"aaaa"];
    //消息类型
    [mes addAttributeWithName:@"type" stringValue:@"chat"];
    
    //发送给谁
    [mes addAttributeWithName:@"to" stringValue:[[[receivedHellos objectAtIndex:(sender.tag-1)] objectForKey:@"userName"] stringByAppendingString:[[TempData sharedInstance] getDomain]]];
    //   NSLog(@"chatWithUser:%@",chatWithUser);
    //由谁发送
    [mes addAttributeWithName:@"from" stringValue:[[SFHFKeychainUtils getPasswordForUsername:ACCOUNT andServiceName:LOCALACCOUNT error:nil] stringByAppendingString:[[TempData sharedInstance] getDomain]]];
    
    [mes addAttributeWithName:@"msgtype" stringValue:@"normalchat"];
    [mes addAttributeWithName:@"fileType" stringValue:@"text"];  //如果发送图片音频改这里
    [mes addAttributeWithName:@"msgTime" stringValue:[Common getCurrentTime]];
    [mes addChild:body];
    if (![self.appDel.xmppHelper sendMessage:mes]) {
        [KGStatusBar showSuccessWithStatus:@"网络有点问题，稍后再试吧" Controller:self];
        //Do something when send failed...
        return;
    }
    [DataStoreManager blankUnreadCountReceivedHellosForUser:[[receivedHellos objectAtIndex:(sender.tag-1)] objectForKey:@"userName"]];
    [self.appDel.xmppHelper addOrDenyFriend:YES user:[[receivedHellos objectAtIndex:(sender.tag-1)] objectForKey:@"userName"]];
    [DataStoreManager addFriendToLocal:[[receivedHellos objectAtIndex:(sender.tag-1)] objectForKey:@"userName"]];
    [DataStoreManager updateReceivedHellosStatus:@"accept" ForPerson:[[receivedHellos objectAtIndex:(sender.tag-1)] objectForKey:@"userName"]];
    [self loadTableviewData];
    
}
-(NSString *)getHead:(NSString *)headImgStr
{
    NSMutableArray * littleHeadArray = [NSMutableArray array];
    NSArray* i = [headImgStr componentsSeparatedByString:@","];
    if (i.count>1) {
        for (NSString* a in i) {
            NSArray *arr = [a componentsSeparatedByString:@"_"];
            if (arr.count>1) {
                [littleHeadArray addObject:arr[0]];
            }
        }
    }//动态大图ID数组和小图ID数组
    return littleHeadArray.count>0?littleHeadArray[0]:@"no";
}
-(void)rejectAddreq:(UIButton *)sender
{
    [DataStoreManager blankUnreadCountReceivedHellosForUser:[[receivedHellos objectAtIndex:(sender.tag-1)] objectForKey:@"userName"]];
    [self.appDel.xmppHelper addOrDenyFriend:NO user:[[receivedHellos objectAtIndex:(sender.tag-1)] objectForKey:@"userName"]];
    [DataStoreManager updateReceivedHellosStatus:@"rejected" ForPerson:[[receivedHellos objectAtIndex:(sender.tag-1)] objectForKey:@"userName"]];
    [self loadTableviewData];
}
-(void)loadTableviewData
{
    receivedHellos = [DataStoreManager queryAllReceivedHellos];
    [self.reqTableV reloadData];
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
