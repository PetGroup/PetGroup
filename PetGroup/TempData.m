//
//  TempData.m
//  NewXMPPTest
//
//  Created by Tolecen on 13-7-23.
//  Copyright (c) 2013年 Tolecen. All rights reserved.
//

#import "TempData.h"

@implementation TempData
static TempData *sharedInstance=nil;

+(TempData *) sharedInstance
{
    @synchronized(self)
    {
        if(!sharedInstance)
        {
            sharedInstance=[[self alloc] init];
            [sharedInstance initThis];
        }
        return sharedInstance;
    }
}
-(void)initThis
{
    panned = YES;
    needConnectChatServer = NO;
    serverAddress = Host;
    latitude = 0;
    longitude = 0;
    self.newFriendsReq = NO;
    loggedIn = NO;
}
-(void)makeLogged:(BOOL)logged
{
    loggedIn = logged;
}
-(BOOL)LoggedIn
{
    return loggedIn;
}
-(void)Panned:(BOOL)pan
{
    panned = pan;
}
-(void)needConnectChatServer:(BOOL)flag
{
    needConnectChatServer = flag;
}
-(BOOL)ifPanned
{
    return panned;
}
-(BOOL)ifNeedConnectChatServer
{
    return needConnectChatServer;
}
-(void)SetServer:(NSString *)server
{
    serverAddress = server;
}
-(NSString *)GetServer
{
    return serverAddress;
}
-(void)setLat:(double)lat Lon:(double)lon
{
    latitude = lat;
    longitude = lon;
}
-(double)returnLat
{
    return latitude;
}
-(double)returnLon
{
    return longitude;
}
@end
