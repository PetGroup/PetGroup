//
//  DataStoreManager.h
//  PetGroup
//
//  Created by Tolecen on 13-8-15.
//  Copyright (c) 2013年 Tolecen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DSMyDynamic.h"
#import "DSSayHellos.h"
#import "DSArticles.h"
#import "DSDynamicFriends.h"
#import "DSThumbMsgs.h"
#import "DSThumbPublicMsgs.h"
#import "DSComments.h"
#import "DSDynamicNearby.h"
#import "DSPublicMsgs.h"
#import "DSCommonMsgs.h"
#import "DSReceivedHellos.h"
#import "DSThumbSubscribedMsgs.h"
#import "DSSubscribedMsgs.h"
#import "DSPets.h"
#import "DSFriends.h"
#import "DSUnreadCount.h"
@interface DataStoreManager : NSObject
+(void)setDefaultDataBase:(NSString *)dataBaseName AndDefaultModel:(NSString *)modelName;
+(void)storeNewMsgs:(NSDictionary *)msg senderType:(NSString *)sendertype;
+(void)blankMsgUnreadCountForUser:(NSString *)username;
+(NSArray *)queryUnreadCountForCommonMsg;
+(void)deleteMsgsWithSender:(NSString *)sender;
+(NSArray *)qureyAllThumbMessages;
+(NSDictionary *)queryLastPublicMsg;
+(NSDictionary *)qureyLastReceivedHello;

+(BOOL)ifHaveThisFriend:(NSString *)userName;
+(void)addFriendToLocal:(NSDictionary *)userInfoDict;
+(void)updateFriendInfo:(NSDictionary *)userInfoDict ForUser:(NSString *)username;

+(void)saveMyInfo:(NSDictionary *)myInfo;

+(NSString *)qureyUnreadForReceivedHellos;
+(void)addPersonToSayHellos:(NSDictionary *)userInfoDict;
+(void)deleteReceivedHelloWithUserName:(NSString *)userName;
+(void)addPersonToReceivedHellos:(NSDictionary *)userInfoDict;
+(BOOL)ifSayHellosHaveThisPerson:(NSString *)username;
+(BOOL)checkSayHelloPersonIfHaveNickNameForUsername:(NSString *)username;
+(void)updateReceivedHellosStatus:(NSString *)theStatus ForPerson:(NSString *)userName;
+(void)qureyAllFriends;
@end
