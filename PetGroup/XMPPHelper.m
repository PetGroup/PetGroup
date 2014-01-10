//
//  XMPPHelper.m
//  NewXMPPTest
//
//  Created by Tolecen on 13-6-26.
//  Copyright (c) 2013年 Tolecen. All rights reserved.
//

#import "XMPPHelper.h"
#import "XMPP.h"
#import "BuddyListDelegate.h"
#import "ChatDelegate.h"
#import "AddReqDelegate.h"
#import "CommentDelegate.h"
#import "NotConnectDelegate.h"
#import "Common.h"
#import "XMPPRoster.h"
#import "XMPPReconnect.h"
#import "XMPPAutoPing.h"
#import "XMPPRosterMemoryStorage.h"
#import "XMPPvCardTemp.h"
#import "XMPPvCardTempModule.h"
#import "XMPPvCardCoreDataStorage.h"
#import "XMPPRosterMemoryStorage.h"
#import "XMPPJID.h"
#import "TempData.h"

#define localServerPushedMessageIDs  @"localServerPushedMessageIDs"
@implementation XMPPHelper
//@synthesize xmppStream,xmppvCardStorage,xmppvCardTempModule,xmppvCardAvatarModule,xmppvCardTemp,account,password,buddyListDelegate,chatDelegate,xmpprosterDelegate,processFriendDelegate,xmpptype,success,fail,regsuccess,regfail,xmppRosterscallback,myVcardTemp,xmppRosterMemoryStorage,xmppRoster;


-(void)setupStream
{
    self.xmppStream = [[XMPPStream alloc] init];
    [self.xmppStream addDelegate:self delegateQueue:dispatch_get_main_queue()];
    self.xmppRosterMemoryStorage = [[XMPPRosterMemoryStorage alloc] init];
    self.xmppRoster = [[XMPPRoster alloc] initWithRosterStorage:self.xmppRosterMemoryStorage];
    [self.xmppRoster addDelegate:self delegateQueue:dispatch_get_main_queue()];
    [self.xmppRoster activate:self.xmppStream];
    [self.xmppRoster setAutoFetchRoster:NO];
    self.xmppStream.enableBackgroundingOnSocket = YES;
    self.xmppReconnect = [[XMPPReconnect alloc] initWithDispatchQueue:dispatch_get_main_queue()];
    [self.xmppReconnect addDelegate:self delegateQueue:dispatch_get_main_queue()];
    [self.xmppReconnect activate:self.xmppStream];
    self.xmppAutoPing = [[XMPPAutoPing alloc] initWithDispatchQueue:dispatch_get_main_queue()];
    self.xmppAutoPing.pingInterval = 25.f; // default is 60
    self.xmppAutoPing.pingTimeout = 10.f; // default is 10
    [self.xmppAutoPing addDelegate:self delegateQueue:dispatch_get_main_queue()];
    [self.xmppAutoPing activate:self.xmppStream];
}
- (void)goOnline {
	XMPPPresence *presence = [XMPPPresence presence];
	[[self xmppStream] sendElement:presence];
}

- (void)goOffline {
	XMPPPresence *presence = [XMPPPresence presenceWithType:@"unavailable"];
	[[self xmppStream] sendElement:presence];
}
-(BOOL)connect:(NSString *)theaccount password:(NSString *)thepassword host:(NSString *)host success:(CallBackBlock)Success fail:(CallBackBlockErr)Fail{
    [self setupStream];
    self.password=thepassword;
    self.success=Success;
    
    self.fail=Fail;
    if (![self.xmppStream isDisconnected]) {
        return YES;
    }

    
    if (theaccount == nil) {
        return NO;
    }
    
    [self.xmppStream setMyJID:[XMPPJID jidWithString:theaccount]];
    [self.xmppStream setHostName:host];
    
    //连接服务器
    NSError *err = nil;
    if (![self.xmppStream connectWithTimeout:30 error:&err]) {
        NSLog(@"cant connect %@", host);
        Fail(err);
        return NO;
    }
    
    return YES;
}

-(void) reg:(NSString *)theaccount password:(NSString *)thepassword host:(NSString *)host success:(CallBackBlock)thesuccess fail:(CallBackBlockErr)thefail{
    self.xmpptype=reg;
    self.account=[theaccount stringByAppendingString:[[TempData sharedInstance] getDomain]];
    self.password=thepassword;
    self.regsuccess=thesuccess;
    self.regfail=thefail;
    [self connect:self.account password:thepassword host:host success:thesuccess fail:thefail];
}

-(void)disconnect{
    [self goOffline];
    [self.xmppStream disconnect];
}
-(BOOL)ifXMPPConnected
{
    return [self.xmppStream getStateOfXMPP];
}
-(BOOL)isDisconnected
{
    return [self.xmppStream isDisconnected];
}
-(BOOL)isConnecting
{
    return [self.xmppStream isConnecting];
}
-(BOOL)isConnected
{
    return [self.xmppStream isConnected];
}
//获取所有联系人
-(void)getCompleteRoster:(XMPPRosterMemoryStorageCallBack)callback{
    self.xmppRosterscallback=callback;
    [self.xmppRoster fetchRoster];
}
-(void)getIt
{
    NSXMLElement *query = [NSXMLElement elementWithName:@"query" xmlns:@"jabber:iq:roster"];
    
    NSXMLElement *iq = [NSXMLElement elementWithName:@"iq"];
    XMPPJID *myJID = self.xmppStream.myJID;
    [iq addAttributeWithName:@"from" stringValue:myJID.description];
    [iq addAttributeWithName:@"to" stringValue:myJID.domain];
//    [iq addAttributeWithName:@"id" stringValue:[self generateID]];
    [iq addAttributeWithName:@"type" stringValue:@"get"];
    [iq addChild:query];
    [self.xmppStream sendElement:iq];
}

-(void)getAllSubscribedMsg
{
//    NSXMLElement *query = [NSXMLElement elementWithName:@"query" xmlns:@"jabber:iq:roster"];
    NSXMLElement *pubsub = [NSXMLElement elementWithName:@"pubsub" xmlns:@"http://jabber.org/protocol/pubsub"];
    NSXMLElement * items = [NSXMLElement elementWithName:@"items"];
    [items addAttributeWithName:@"node" stringValue:@"princely_musings"];
    [items addAttributeWithName:@"max_items" stringValue:@"4"];
    NSXMLElement *iq = [NSXMLElement elementWithName:@"iq"];
    XMPPJID *myJID = self.xmppStream.myJID;
    [iq addAttributeWithName:@"from" stringValue:myJID.description];
    [iq addAttributeWithName:@"to" stringValue:[NSString stringWithFormat:@"pubsub.%@", [[TempData sharedInstance] getRealDomain]]];
    //    [iq addAttributeWithName:@"id" stringValue:[self generateID]];
    [iq addAttributeWithName:@"type" stringValue:@"get"];
    [pubsub addChild:items];
    [iq addChild:pubsub];
    [self.xmppStream sendElement:iq];
}
-(void)checkToServerifSubscibe
{
    NSXMLElement *pubsub = [NSXMLElement elementWithName:@"pubsub" xmlns:@"http://jabber.org/protocol/pubsub"];
    NSXMLElement * sub = [NSXMLElement elementWithName:@"subscriptions"];
    NSXMLElement *iq = [NSXMLElement elementWithName:@"iq"];
    XMPPJID *myJID = self.xmppStream.myJID;
    [iq addAttributeWithName:@"from" stringValue:myJID.description];
    [iq addAttributeWithName:@"to" stringValue:[NSString stringWithFormat:@"pubsub.%@", [[TempData sharedInstance] getRealDomain]]];
    //    [iq addAttributeWithName:@"id" stringValue:[self generateID]];
    [iq addAttributeWithName:@"type" stringValue:@"get"];
    [pubsub addChild:sub];
    [iq addChild:pubsub];
    [self.xmppStream sendElement:iq];
}
-(void)realSubscribeToServer
{
    NSXMLElement *pubsub = [NSXMLElement elementWithName:@"pubsub" xmlns:@"http://jabber.org/protocol/pubsub"];
    NSXMLElement * sub = [NSXMLElement elementWithName:@"subscribe"];

    NSXMLElement *iq = [NSXMLElement elementWithName:@"iq"];
    XMPPJID *myJID = self.xmppStream.myJID;
    [sub addAttributeWithName:@"node" stringValue:@"princely_musings"];
    [sub addAttributeWithName:@"jid" stringValue:myJID.description];
    [iq addAttributeWithName:@"from" stringValue:myJID.description];
    [iq addAttributeWithName:@"to" stringValue:[NSString stringWithFormat:@"pubsub.%@", [[TempData sharedInstance] getRealDomain]]];
//    [iq addAttributeWithName:@"xmlns" stringValue:@"http://jabber.org/protocol/pubsub"];
    //    [iq addAttributeWithName:@"id" stringValue:[self generateID]];
    [iq addAttributeWithName:@"type" stringValue:@"set"];
    [pubsub addChild:sub];
    [iq addChild:pubsub];
    [self.xmppStream sendElement:iq];
}


- (void)updateVCard:(XMPPvCardTemp *)vcard success:(CallBackBlock)thesuccess fail:(CallBackBlockErr)thefail{
    self.success=thesuccess;
    self.fail=thefail;
    [self.xmppvCardTempModule addDelegate:self delegateQueue:dispatch_get_main_queue()];
    [self.xmppvCardTempModule updateMyvCardTemp:vcard];
    
}

-(XMPPvCardTemp *)getmyvcard{
    self.xmppvCardTemp =[self.xmppvCardTempModule myvCardTemp];
    return self.xmppvCardTemp;
}

-(XMPPvCardTemp *)getvcard:(NSString *)Account{
    [self.xmppvCardTempModule fetchvCardTempForJID:[XMPPJID jidWithString:[Account stringByAppendingString:[[TempData sharedInstance] getDomain]]]];
    return [self.xmppvCardTempModule vCardTempForJID:[XMPPJID jidWithString:[Account stringByAppendingString:[[TempData sharedInstance] getDomain]]] shouldFetch:YES];
}

- (void)xmppvCardTempModule:(XMPPvCardTempModule *)vCardTempModule
        didReceivevCardTemp:(XMPPvCardTemp *)vCardTemp
                     forJID:(XMPPJID *)jid
{
    NSLog(@"%@",vCardTemp);
}

- (void)xmppvCardTempModuleDidUpdateMyvCard:(XMPPvCardTempModule *)vCardTempModule{
    NSLog(@"%@",vCardTempModule);
    self.success();
}

- (void)xmppvCardTempModule:(XMPPvCardTempModule *)vCardTempModule failedToUpdateMyvCard:(NSXMLElement *)error{
    NSLog(@"%@",error);
    NSError *err=[[NSError alloc] initWithDomain:[[TempData sharedInstance] getDomain] code:-1000 userInfo:nil];
    self.fail(err);
}

//添加好友
-(BOOL)addFriend:(NSString *)user{
    if (![self ifXMPPConnected]) {
        return NO;
    }
    else
    {
        NSString * nickName = [SFHFKeychainUtils getPasswordForUsername:USERNICKNAME andServiceName:LOCALACCOUNT error:nil];
        [self.xmppRoster addUser:[XMPPJID jidWithString:[user stringByAppendingString:[[TempData sharedInstance] getDomain]]] withNickname:nickName];
        return YES;
    }
    
}
-(void)addFriend:(NSString *)user WithMsg:(NSString *)msg HeadID:(NSString *)headID{
    NSString * nickName = [SFHFKeychainUtils getPasswordForUsername:USERNICKNAME andServiceName:LOCALACCOUNT error:nil];
    [self.xmppRoster addUser:[XMPPJID jidWithString:[user stringByAppendingString:[[TempData sharedInstance] getDomain]]] withNickname:nickName Msg:msg HeadID:headID];
}
//删除好友
-(void)delFriend:(NSString *)user{
    [self.xmppRoster removeUser:[XMPPJID jidWithString:[user stringByAppendingString:[[TempData sharedInstance] getDomain]]]];
}

//处理加好友
-(void)addOrDenyFriend:(Boolean)issubscribe user:(NSString *)user{
    XMPPJID *jid=[XMPPJID jidWithString:[NSString stringWithFormat:@"%@%@",user,[[TempData sharedInstance] getDomain]]];
    if(issubscribe){
        [self.xmppRoster acceptPresenceSubscriptionRequestFrom:jid andAddToRoster:YES];
    }else{
        [self.xmppRoster rejectPresenceSubscriptionRequestFrom:jid];
    }
}
//===========XMPP委托事件============

//此方法在stream开始连接服务器的时候调用
- (void)xmppStreamDidConnect:(XMPPStream *)sender{
    NSLog(@"connected");
    NSError *error = nil;
    
    if(self.xmpptype==reg){
        [[self xmppStream] setMyJID:[XMPPJID jidWithString:self.account]];
        NSError *error=nil;
        if (![[self xmppStream] registerWithPassword:self.password error:&error])
        {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"创建帐号失败"
                                                                message:[error localizedDescription]
                                                               delegate:nil
                                                      cancelButtonTitle:@"Ok"
                                                      otherButtonTitles:nil];
            [alertView show];
        }
        
        
    }else{
        //验证密码
        [[self xmppStream] authenticateWithPassword:self.password error:&error];
        if(error!=nil)
        {
            self.fail(error);
        }
    }
}

//此方法在stream连接断开的时候调用
- (void)xmppStreamDidDisconnect:(XMPPStream *)sender withError:(NSError *)error{
    NSLog(@"disconnected。。。：%@",error);
    [self.notConnect notConnectted];
}

// 2.关于验证的
//验证失败后调用
- (void)xmppStream:(XMPPStream *)sender didNotAuthenticate:(NSXMLElement *)error{
    NSLog(@"not authenticated");
    NSError *err=[[NSError alloc] initWithDomain:@"WeShare" code:-100 userInfo:@{@"detail": @"ot-authorized"}];
    self.fail(err);
 //   [self.notConnect notConnectted];
}


//验证成功后调用
- (void)xmppStreamDidAuthenticate:(XMPPStream *)sender{
    
    self.xmppvCardStorage=[XMPPvCardCoreDataStorage sharedInstance];
    self.xmppvCardTempModule=[[XMPPvCardTempModule alloc]initWithvCardStorage:self.xmppvCardStorage];
    self.xmppvCardAvatarModule = [[XMPPvCardAvatarModule alloc]initWithvCardTempModule:self.xmppvCardTempModule];
    [self.xmppvCardTempModule   activate:self.xmppStream];
    [self.xmppvCardAvatarModule activate:self.xmppStream];
    [self getmyvcard];
    NSLog(@"authenticated");
    [self goOnline];
    self.success();
}

-(BOOL)sendMessage:(NSXMLElement *)message
{
    if (![self isConnected]) {
        return NO;
    }
    else
    {
        [self.xmppStream sendElement:message];
        return YES;
    }
}

- (void)xmppRosterDidChange:(XMPPRosterMemoryStorage *)sender
{
//	DDLogVerbose(@"%@: %@", THIS_FILE, THIS_METHOD);
//	
//	roster = [sender sortedUsersByAvailabilityName];
}
- (BOOL)xmppStream:(XMPPStream *)sender didReceiveIQ:(XMPPIQ *)iq {
//    if (!self.rosters) {
//        self.rosters = [NSMutableArray array];
//    }
//    [self.rosters removeAllObjects];
    if ([@"result" isEqualToString:iq.type]) {
        NSXMLElement *query = iq.childElement;
//        NSArray * iqChildrenArray = [iq children];
        if ([@"query" isEqualToString:query.name]) {
//            NSArray *items = [query children];
//            for (NSXMLElement *item in items) {
//                NSString *jid = [item attributeStringValueForName:@"jid"];
//                NSRange range = [jid rangeOfString:@"@"];
//                NSString * sender = [jid substringToIndex:range.location];
//               // XMPPJID *xmppJID = [XMPPJID jidWithString:jid];
//                if ([[item attributeStringValueForName:@"subscription"] isEqualToString:@"both"]||[[item attributeStringValueForName:@"subscription"] isEqualToString:@"to"]) {
//                    [self.rosters addObject:sender];
////                    NSDictionary * dict = [NSDictionary dictionaryWithObjectsAndKeys:sender,@"username", nil];
////                    [DataStoreManager addFriendToLocal:sender];
//                    //[DataStoreManager saveUserInfo:dict];
//                }
//            }
        }
        else if ([@"pubsub" isEqualToString:query.name]){
            NSXMLElement *subscriptions = [query elementForName:@"subscriptions"];
            NSArray * subscriptionArray = [subscriptions children];
            if (subscriptionArray) {
                if (subscriptionArray.count>0) {
                    NSLog(@"subscribed");
                    [self getAllSubscribedMsg];
                }
                else
                {
                    NSLog(@"none subscribed");
                    [self realSubscribeToServer];
                }
            }
            NSXMLElement *items = [query elementForName:@"items"];
            NSArray * itemsArray = [items children];
            if (itemsArray) {
                if (itemsArray.count>0) {
                    NSLog(@"messages delayed:%@",itemsArray);
                    NSString * pushedkey = [NSString stringWithFormat:@"%@_%@",[SFHFKeychainUtils getPasswordForUsername:ACCOUNT andServiceName:LOCALACCOUNT error:nil],localServerPushedMessageIDs];
                    NSArray * localServerPushed = [[NSUserDefaults standardUserDefaults] objectForKey:pushedkey];
                    NSMutableArray * olocalServerPushed;
                    if (localServerPushed) {
                        olocalServerPushed = [NSMutableArray arrayWithArray:localServerPushed];
                    }
                    else
                        olocalServerPushed = [NSMutableArray array];
                    for (int i = 0; i<itemsArray.count; i++) {
                        NSMutableDictionary * dict = [NSMutableDictionary dictionary];
                        NSXMLElement * oitem = [itemsArray objectAtIndex:i];
                        NSXMLElement * item = [oitem elementForName:@"entry"];
                        NSLog(@"ITEM ID iq:%@",[oitem attributeStringValueForName:@"id"]);
                        if (![olocalServerPushed containsObject:[oitem attributeStringValueForName:@"id"]]) {
                            [olocalServerPushed addObject:[oitem attributeStringValueForName:@"id"]];
                            [[NSUserDefaults standardUserDefaults] setObject:olocalServerPushed forKey:pushedkey];
                            [[NSUserDefaults standardUserDefaults] synchronize];
                            [self parseItem:item withDict:dict];
                        }
                        
                    }
                }
            }
        }
        
    }
    return YES;
}
// 3.关于通信的
//收到消息后调用
- (void)xmppStream:(XMPPStream *)sender didReceiveMessage:(XMPPMessage *)message{
    NSString *msgtype = [[message attributeForName:@"msgtype"] stringValue];
     NSString *msg = @"";
    if (![msgtype isEqualToString:@"zanDynamic"]) {
        msg=[[message elementForName:@"body"] stringValue]?[[message elementForName:@"body"] stringValue]:@"nocontent";
        NSLog(@"body:=====%@",msg);
    }
    NSString *from = [[message attributeForName:@"from"] stringValue];
    NSString *type = [[message attributeForName:@"type"] stringValue];
   
    NSString *msgTime = [[message attributeForName:@"msgTime"] stringValue];
    NSString *receiver = [[message attributeForName:@"to"] stringValue];
   // NSString * fromNickName = [[message attributeForName:@"nickname"] stringValue];
    if(msg!=nil){
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        [dict setObject:msg forKey:@"msg"];
        [dict setObject:from forKey:@"sender"];
        //[dict setObject:fromNickName forKey:@"nickname"];
        //消息接收到的时间
        
        
        //消息委托(这个后面讲)
        NSLog(@"theDict%@",dict);
        if ([type isEqualToString:@"chat"]) {
            if ([msgtype isEqualToString:@"normalchat"]||!msgtype) {
                [dict setObject:@"normalchat" forKey:@"msgType"];
                [dict setObject:msgTime  forKey:@"time"];
                NSString * fileType = [[message attributeForName:@"fileType"] stringValue];
                [dict setObject:fileType?fileType:@"text" forKey:@"fileType"];
                if (fileType) {
                    if (![fileType isEqualToString:@"text"]) {
                        [dict setObject:@"NO" forKey:@"readed"];
                    }
                }
                [self.chatDelegate newMessageReceived:dict];
            }
            else if ([msgtype isEqualToString:@"sayHello"]){
                [dict setObject:msgTime  forKey:@"time"];
                [self.addReqDelegate newAddReq:dict];
            }
            else {
                [dict setObject:[NSString stringWithFormat:@"%lld",[msgTime longLongValue]/1000]  forKey:@"time"];
                //此处时间应该message里携带，暂时没有，使用当前时间
                [dict setObject:msgtype forKey:@"msgType"];
//                msgTime = [NSString stringWithFormat:@"%.0f",[msgTime doubleValue]/1000];
//                [dict setObject:msgTime forKey:@"time"];
                if (![from isEqualToString:receiver]&&([msgtype isEqualToString:@"reply"]||[msgtype isEqualToString:@"zanDynamic"])) {
                    [dict setObject:[[message attributeForName:@"contentType"] stringValue] forKey:@"contentType"];
                    [dict setObject:[[message attributeForName:@"content"] stringValue] forKey:@"content"];
                    [dict setObject:[[message attributeForName:@"picID"] stringValue] forKey:@"picID"];
                    [dict setObject:[[message attributeForName:@"contentID"] stringValue] forKey:@"contentID"];
                    [dict setObject:[[message attributeForName:@"fromNickname"] stringValue] forKey:@"fromNickname"];
                    [dict setObject:[[message attributeForName:@"fromHeadImg"] stringValue] forKey:@"fromHeadImg"];
                    
                    if ([msgtype isEqualToString:@"reply"]) {
                        if ([[[message attributeForName:@"contentType"] stringValue] isEqualToString:@"dynamic"]) {
                            [dict setObject:[NSString stringWithFormat:@"在动态中评论了你:%@",msg] forKey:@"replyContent"];
                            [dict setObject:@"no" forKey:@"floor"];
                            [dict setObject:[NSString stringWithFormat:@"%@在动态中评论了你:%@",[[message attributeForName:@"fromNickname"] stringValue],msg] forKey:@"msg"];
//                            [dict setObject:@"123456789@chongwuquan.com" forKey:@"sender"];
                            [self.chatDelegate newMessageReceived:dict];
                        }
                        else
                        {
                            [dict setObject:msg forKey:@"floor"];
                            [dict setObject:[NSString stringWithFormat:@"在帖子《%@》%d楼中评论了你",[[message attributeForName:@"content"] stringValue],[msg intValue]+1] forKey:@"replyContent"];
                            
                            [dict setObject:[NSString stringWithFormat:@"%@在帖子《%@》%d楼中评论了你",[[message attributeForName:@"fromNickname"] stringValue],[[message attributeForName:@"content"] stringValue],[msg intValue]+1] forKey:@"msg"];
//                            [dict setObject:@"123456789@chongwuquan.com" forKey:@"sender"];
                            [self.chatDelegate newMessageReceived:dict];
                        }
                        
                    }
                    else
                    {
                        [dict setObject:@"赞了你的动态" forKey:@"replyContent"];
                        [dict setObject:@"no" forKey:@"floor"];
                        [dict setObject:[NSString stringWithFormat:@"%@赞了你的动态",[[message attributeForName:@"fromNickname"] stringValue]] forKey:@"msg"];
//                        [dict setObject:@"123456789@chongwuquan.com" forKey:@"sender"];
                        [self.chatDelegate newMessageReceived:dict];
                    }
                    [dict setObject:@"no" forKey:@"ifRead"];
                    [self.commentDelegate newCommentReceived:dict];
                }
                else if ([msgtype isEqualToString:@"zanPeople"]){
                    
                }
                else if ([msgtype isEqualToString:@"zanPet"]){
                    
                }
                
                
                //评论，回复，赞，在这里解析，或者通用newMessageReceived，在那个方法里解析dict,赞人赞宠物后面处理...
                
            }
        }
        else if ([type isEqualToString:@"headline"]){
            NSXMLElement *items = [[message elementForName:@"event"] elementForName:@"items"];
            NSArray * itemsArray = [items children];
            if (itemsArray) {
                if (itemsArray.count>0) {
                    NSXMLElement * item = [[itemsArray objectAtIndex:0] elementForName:@"entry"];
                    if (!item) {
                        return;
                    }
                    NSXMLElement * oitem = [itemsArray objectAtIndex:0];
                    NSString * pushedkey = [NSString stringWithFormat:@"%@_%@",[SFHFKeychainUtils getPasswordForUsername:ACCOUNT andServiceName:LOCALACCOUNT error:nil],localServerPushedMessageIDs];
                    NSArray * localServerPushed = [[NSUserDefaults standardUserDefaults] objectForKey:pushedkey];
                    NSMutableArray * olocalServerPushed;
                    if (localServerPushed) {
                        olocalServerPushed = [NSMutableArray arrayWithArray:localServerPushed];
                    }
                    else
                        olocalServerPushed = [NSMutableArray array];
                    NSLog(@"ITEM ID msg:%@",[oitem attributeStringValueForName:@"id"]);
                    [olocalServerPushed addObject:[oitem attributeStringValueForName:@"id"]];
                    [[NSUserDefaults standardUserDefaults] setObject:olocalServerPushed forKey:pushedkey];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                    [self parseItem:item withDict:dict];
                }
            }
        }
        
    
    }
}

-(void)parseItem:(NSXMLElement *)item withDict:(NSMutableDictionary *)dict
{
    NSString * notiType = [[item elementForName:@"type"] stringValue];
    NSString * notiID = [[item elementForName:@"id"] stringValue];
    NSString * notiContent = [[item elementForName:@"body"] stringValue];
    NSString * title = @"";
    if ([notiType isEqualToString:@"notice"]) {
        title = @"系统通知";
        [dict setObject:@"123456789@xxx.com" forKey:@"sender"];
        [dict setObject:@"圈子通知" forKey:@"fname"];
    }
    else if ([notiType isEqualToString:@"bbs_special_subject"]){
        title = @"专题推荐";
        [dict setObject:@"专题推荐" forKey:@"fname"];
        [dict setObject:@"bbs_special_subject@xxx.com" forKey:@"sender"];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"inspectNewSubject" object:self];//检查新专题
        return;
    }
    else{
        title = @"小编推荐";
        [dict setObject:@"圈子通知" forKey:@"fname"];
        [dict setObject:@"123456789@xxx.com" forKey:@"sender"];
    }
    [dict setObject:[NSString stringWithFormat:@"%@:%@",title,notiContent] forKey:@"msg"];
    if ([notiType isEqualToString:@"bbs_special_subject"]){
        [dict setObject:[NSString stringWithFormat:@"%@",notiContent] forKey:@"msg"];
    }
    [dict setObject:[Common getCurrentTime] forKey:@"time"];
    [dict setObject:notiType forKey:@"contentType"];
    [dict setObject:notiType forKey:@"msgType"];
    [dict setObject:notiContent forKey:@"replyContent"];
    [dict setObject:notiID forKey:@"contentID"];
    [dict setObject:title forKey:@"fromNickname"];
    [dict setObject:@"no" forKey:@"fromHeadImg"];
    [dict setObject:@"no" forKey:@"ifRead"];
    [self.chatDelegate newMessageReceived:dict];
    [self.commentDelegate newCommentReceived:dict];

}

//注册成功
- (void)xmppStreamDidRegister:(XMPPStream *)sender{
    self.regsuccess();
}

//注册失败
- (void)xmppStream:(XMPPStream *)sender didNotRegister:(NSXMLElement *)error{
    NSError *err=[[NSError alloc] initWithDomain:@"WeShare" code:-100 userInfo:@{@"detail": @"reg fail"}];
    self.regfail(err);
}

- (void)xmppRoster:(XMPPRoster *)sender didReceivePresenceSubscriptionRequest:(XMPPPresence *)presence
{
    //取得好友状态
    NSString *presenceType = [NSString stringWithFormat:@"%@", [presence type]]; //online/offline
    //请求的用户
//    NSString *presenceFromUser =[NSString stringWithFormat:@"%@", [[presence from] user]];
//    NSString *fromnickName = [presence fromName];
//    NSString *additionMsg = [presence additionMsg];
//    NSString *headID = [presence headID];
//    NSLog(@"presenceType:%@,fromNickName:%@,additionMsg:%@",presenceType,fromnickName,additionMsg);
//    NSDictionary * uDict = [NSDictionary dictionaryWithObjectsAndKeys:presenceFromUser,@"fromUser",fromnickName,@"fromNickname",additionMsg,@"addtionMsg",headID,@"headID", nil];
    NSLog(@"presence2:%@  sender2:%@",presence,sender);
    if ([presenceType isEqualToString:@"subscribe"]) {
//        [self.addReqDelegate newAddReq:uDict];
    }
    
   // [self.addReq newAddReq:@""];
//    XMPPJID *jid = [XMPPJID jidWithString:presenceFromUser];
//    [self.xmppRoster acceptPresenceSubscriptionRequestFrom:jid andAddToRoster:YES];
}

//接受到好友状态更新
- (void)xmppStream:(XMPPStream *)sender didReceivePresence:(XMPPPresence *)presence{
    
    //取得好友状态
    NSString *presenceType = [presence type]; //online/offline
    
    NSLog(@"presenceType:%@",presenceType);
 //   NSString *presenceFromUser =[NSString stringWithFormat:@"%@", [[presence from] user]];
//    [self.addReqDelegate newAddReq:presenceFromUser];
    
    
    // [self.addReq newAddReq:@""];
//    XMPPJID *jid = [XMPPJID jidWithString:presenceFromUser];
//    [self.xmppRoster acceptPresenceSubscriptionRequestFrom:jid andAddToRoster:YES];
    
    if ([presenceType isEqualToString:@"subscribed"]) {
        [self.processFriendDelegate processFriend:presence];
  //      [self.addReqDelegate newAddReq:presenceFromUser];
        // [self.addReq newAddReq:@""];
//        XMPPJID *jid = [XMPPJID jidWithString:presenceFromUser];
//        [self.xmppRoster acceptPresenceSubscriptionRequestFrom:jid andAddToRoster:YES];
    }
//    else if([presenceType isEqualToString:@"error"]){
//        NSLog(@"错误");
//    }
//    else{
//        //当前用户
//        NSString *userId = [[sender myJID] user];
//        //在线用户
//        NSString *presenceFromUser = [[presence from] user];
//        if (![presenceFromUser isEqualToString:userId]) {
//            //在线状态
//            if ([presenceType isEqualToString:@"available"]) {
//                //用户列表委托(后面讲)
//                [self.buddyListDelegate newBuddyOnline:[NSString stringWithFormat:@"%@", presenceFromUser]];
//                
//            }else if ([presenceType isEqualToString:@"unavailable"]) {
//                //用户列表委托(后面讲)
//                //[self.buddyListDelegate buddyWentOffline:[NSString stringWithFormat:@"%@", presenceFromUser]];
//                [self.buddyListDelegate newBuddyOnline:[[NSString stringWithFormat:@"%@", presenceFromUser]stringByAppendingString:@"[不在线]"]];
//            }
//        }
//    }
}

//fetchRoster后，将结果回调方式传来。
- (void)xmppRosterDidPopulate:(XMPPRosterMemoryStorage *)sender{
    if(self.xmppRosterscallback){
        self.xmppRosterscallback(sender);
    }
    NSLog(@"%@",sender);
}


@end
