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
#import "NotConnectDelegate.h"
#import "Common.h"
#import "XMPPRoster.h"
#import "XMPPRosterMemoryStorage.h"
#import "XMPPvCardTemp.h"
#import "XMPPvCardTempModule.h"
#import "XMPPvCardCoreDataStorage.h"
#import "XMPPRosterMemoryStorage.h"
#import "XMPPJID.h"

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
    self.xmppStream.enableBackgroundingOnSocket = YES;
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
    self.account=[theaccount stringByAppendingString:Domain];
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
    [self.xmppvCardTempModule fetchvCardTempForJID:[XMPPJID jidWithString:[Account stringByAppendingString:Domain]]];
    return [self.xmppvCardTempModule vCardTempForJID:[XMPPJID jidWithString:[Account stringByAppendingString:Domain]] shouldFetch:YES];
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
    NSError *err=[[NSError alloc] initWithDomain:Domain code:-1000 userInfo:nil];
    self.fail(err);
}

//添加好友
-(void)addFriend:(NSString *)user{
    NSString * nickName = [SFHFKeychainUtils getPasswordForUsername:USERNICKNAME andServiceName:LOCALACCOUNT error:nil];
    [self.xmppRoster addUser:[XMPPJID jidWithString:[user stringByAppendingString:Domain]] withNickname:nickName];
}
-(void)addFriend:(NSString *)user WithMsg:(NSString *)msg HeadID:(NSString *)headID{
    NSString * nickName = [SFHFKeychainUtils getPasswordForUsername:USERNICKNAME andServiceName:LOCALACCOUNT error:nil];
    [self.xmppRoster addUser:[XMPPJID jidWithString:[user stringByAppendingString:Domain]] withNickname:nickName Msg:msg HeadID:headID];
}
//删除好友
-(void)delFriend:(NSString *)user{
    [self.xmppRoster removeUser:[XMPPJID jidWithString:[user stringByAppendingString:Domain]]];
}

//处理加好友
-(void)addOrDenyFriend:(Boolean)issubscribe user:(NSString *)user{
    XMPPJID *jid=[XMPPJID jidWithString:[NSString stringWithFormat:@"%@%@",user,Domain]];
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

- (void)xmppRosterDidChange:(XMPPRosterMemoryStorage *)sender
{
//	DDLogVerbose(@"%@: %@", THIS_FILE, THIS_METHOD);
//	
//	roster = [sender sortedUsersByAvailabilityName];
}
- (BOOL)xmppStream:(XMPPStream *)sender didReceiveIQ:(XMPPIQ *)iq {
    if (!self.rosters) {
        self.rosters = [NSMutableArray array];
    }
    [self.rosters removeAllObjects];
    if ([@"result" isEqualToString:iq.type]) {
        NSXMLElement *query = iq.childElement;
        if ([@"query" isEqualToString:query.name]) {
            NSArray *items = [query children];
            for (NSXMLElement *item in items) {
                NSString *jid = [item attributeStringValueForName:@"jid"];
                NSRange range = [jid rangeOfString:@"@"];
                NSString * sender = [jid substringToIndex:range.location];
               // XMPPJID *xmppJID = [XMPPJID jidWithString:jid];
                if ([[item attributeStringValueForName:@"subscription"] isEqualToString:@"both"]) {
                    [self.rosters addObject:sender];
                }
            }
        }
        
    }
    return YES;
}
// 3.关于通信的
//收到消息后调用
- (void)xmppStream:(XMPPStream *)sender didReceiveMessage:(XMPPMessage *)message{
    
    NSString *msg = [[message elementForName:@"body"] stringValue];
    NSString *from = [[message attributeForName:@"from"] stringValue];
   // NSString * fromNickName = [[message attributeForName:@"nickname"] stringValue];
    if(msg!=nil){
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        [dict setObject:msg forKey:@"msg"];
        [dict setObject:from forKey:@"sender"];
        //[dict setObject:fromNickName forKey:@"nickname"];
        //消息接收到的时间
        [dict setObject:[Common getCurrentTime] forKey:@"time"];
        
        //消息委托(这个后面讲)
        NSLog(@"theDict%@",dict);
        [self.chatDelegate newMessageReceived:dict];
    }
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
    NSString *presenceFromUser =[NSString stringWithFormat:@"%@", [[presence from] user]];
    NSString *fromnickName = [presence fromName];
    NSString *additionMsg = [presence additionMsg];
    NSString *headID = [presence headID];
    NSLog(@"presenceType:%@,fromNickName:%@,additionMsg:%@",presenceType,fromnickName,additionMsg);
    NSDictionary * uDict = [NSDictionary dictionaryWithObjectsAndKeys:presenceFromUser,@"fromUser",fromnickName,@"fromNickname",additionMsg,@"addtionMsg",headID,@"headID", nil];
    NSLog(@"presence2:%@  sender2:%@",presence,sender);
    if ([presenceType isEqualToString:@"subscribe"]) {
        [self.addReqDelegate newAddReq:uDict];
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
