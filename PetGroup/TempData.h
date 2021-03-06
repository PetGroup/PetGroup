//
//  TempData.h
//  NewXMPPTest
//
//  Created by Tolecen on 13-7-23.
//  Copyright (c) 2013年 Tolecen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TempData : NSObject
{
    BOOL panned;
    BOOL needConnectChatServer;
    NSString * serverAddress;
    NSString * serverDomain;
    
    double latitude;
    double longitude;
    
    BOOL loggedIn;
    BOOL ifNeedChat;
    
    BOOL opened;
//    BOOL needToQRCodePage;
    NSString * needChatUserName;
    
}
@property (retain,nonatomic)NSString* myUserID;
@property (assign,nonatomic)BOOL newFriendsReq;
@property (nonatomic,assign)BOOL needDisplayPushNotification;
@property (nonatomic,assign)BOOL changeUser;
@property (nonatomic,assign)BOOL haveGotFriends;
@property (nonatomic,assign)BOOL appActive;
@property (nonatomic,assign)BOOL friendsInfoChanged;
@property (nonatomic,assign)BOOL needToQRCodePage;
@property (strong,nonatomic)NSString* hostPort;
@property (strong,nonatomic)NSMutableArray* friendsKeyArray;

+ (TempData*)sharedInstance;
-(void)friendsArrayAddNameKey:(NSString *)nameKey;
-(void)setOpened:(BOOL)haveOpened;
-(BOOL)ifOpened;
-(void)Panned:(BOOL)pan;
-(BOOL)ifPanned;
-(void)needConnectChatServer:(BOOL)flag;
-(BOOL)ifNeedConnectChatServer;
-(NSString *)getServer;
-(NSString *)getDomain;
-(NSString *)getRealDomain;
-(void)SetServer:(NSString *)server TheDomain:(NSString *)domain;
-(void)setLat:(double)lat Lon:(double)lon;
-(double)returnLat;
-(double)returnLon;
-(void)makeLogged:(BOOL)logged;
-(BOOL)LoggedIn;
-(void)setNeedChatToUser:(NSString *)user;
-(void)setNeedChatNO;
-(BOOL)needChat;
-(NSString *)getNeedChatUser;
-(NSString*)getMyUserID;
@end
