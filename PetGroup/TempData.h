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
    
    double latitude;
    double longitude;
    
    BOOL loggedIn;
}
@property (assign,nonatomic)BOOL newFriendsReq;

+ (id)sharedInstance;
-(void)Panned:(BOOL)pan;
-(BOOL)ifPanned;
-(void)needConnectChatServer:(BOOL)flag;
-(BOOL)ifNeedConnectChatServer;
-(NSString *)GetServer;
-(void)SetServer:(NSString *)server;
-(void)setLat:(double)lat Lon:(double)lon;
-(double)returnLat;
-(double)returnLon;
-(void)makeLogged:(BOOL)logged;
-(BOOL)LoggedIn;
@end
