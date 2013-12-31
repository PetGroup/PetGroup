//
//  NewReplyArticleDataSource.m
//  PetGroup
//
//  Created by 阿铛 on 13-10-14.
//  Copyright (c) 2013年 Tolecen. All rights reserved.
//

#import "NewReplyArticleDataSource.h"
#import "Article.h"
@implementation NewReplyArticleDataSource
- (id)init
{
    self = [super init];
    if (self) {
        self.needSave = NO;
    }
    return self;
}
-(void)loadHistorySuccess:(void (^)(void))success failure:(void (^)(void))failure
{
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    NSArray* array = [defaults objectForKey:MyNewReplyArticle];
    if (array) {
        for (NSDictionary* dic in array) {
            Article* a = [[Article alloc]initWithDictionnary:dic];
            [self.dataSourceArray addObject:a];
        }
        success();
    }else
    {
        failure();
    }
}
-(void)reloadDataSuccess:(void (^)(void))success failure:(void (^)(void))failure
{//body={"method":"getNewReplysByReplyct","token":"","params":{"pageNo":"1","pageSize":"3"}}
    self.pageNo = 0;
    NSTimeInterval cT = [[NSDate date] timeIntervalSince1970];
    long long a = (long long)(cT*1000);
    NSMutableDictionary* params = [NSMutableDictionary dictionary];
    [params setObject:@"NEW_ET" forKey:@"action"];
    [params setObject:@"false" forKey:@"withTop"];
    if (![self.forumPid isEqualToString:@"0"]) {
        [params setObject:self.forumPid forKey:@"forumId"];
    }
    [params setObject:[NSString stringWithFormat:@"%d",self.pageNo] forKey:@"pageNo"];
    [params setObject:@"20" forKey:@"pageSize"];
    NSMutableDictionary* body = [NSMutableDictionary dictionary];
    [body setObject:params forKey:@"params"];
    [body setObject:@"getNoteList" forKey:@"method"];
    [body setObject:@"service.uri.pet_bbs" forKey:@"service"];
    [body setObject:@"1" forKey:@"channel"];
    [body setObject:[SFHFKeychainUtils getPasswordForUsername:MACADDRESS andServiceName:LOCALACCOUNT error:nil] forKey:@"mac"];
    [body setObject:@"iphone" forKey:@"imei"];
    [body setObject:[NSString stringWithFormat:@"%lld",a] forKey:@"connectTime"];
    [body setObject:[SFHFKeychainUtils getPasswordForUsername:LOCALTOKEN andServiceName:LOCALACCOUNT error:nil] forKey:@"token"];
    [NetManager requestWithURLStr:BaseClientUrl Parameters:body TheController:self.myController success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@",responseObject);
        NSArray* array = responseObject;
        if (self.needSave) {
            NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
            [defaults setObject:array forKey:MyNewReplyArticle];
            [defaults synchronize];
        }
        [self.dataSourceArray removeAllObjects];
        if (array.count > 0) {
            for (NSDictionary* dic in array) {
                Article* a = [[Article alloc]initWithDictionnary:dic];
                [self.dataSourceArray addObject:a];
            }
        }
        success();
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure();
    }];
}
-(void)loadMoreDataSuccess:(void (^)(void))success failure:(void (^)(void))failure
{
    self.pageNo ++;
    NSTimeInterval cT = [[NSDate date] timeIntervalSince1970];
    long long a = (long long)(cT*1000);
    NSMutableDictionary* params = [NSMutableDictionary dictionary];
    [params setObject:@"NEW_ET" forKey:@"action"];
    [params setObject:@"false" forKey:@"withTop"];
    if (![self.forumPid isEqualToString:@"0"]) {
        [params setObject:self.forumPid forKey:@"forumId"];
    }
    
    [params setObject:[NSString stringWithFormat:@"%d",self.pageNo] forKey:@"pageNo"];
    [params setObject:@"20" forKey:@"pageSize"];
    NSMutableDictionary* body = [NSMutableDictionary dictionary];
    [body setObject:params forKey:@"params"];
    [body setObject:@"getNoteList" forKey:@"method"];
    [body setObject:@"service.uri.pet_bbs" forKey:@"service"];
    [body setObject:@"1" forKey:@"channel"];
    [body setObject:[SFHFKeychainUtils getPasswordForUsername:MACADDRESS andServiceName:LOCALACCOUNT error:nil] forKey:@"mac"];
    [body setObject:@"iphone" forKey:@"imei"];
    [body setObject:[NSString stringWithFormat:@"%lld",a] forKey:@"connectTime"];
    [body setObject:[SFHFKeychainUtils getPasswordForUsername:LOCALTOKEN andServiceName:LOCALACCOUNT error:nil] forKey:@"token"];
    [NetManager requestWithURLStr:BaseClientUrl Parameters:body TheController:self.myController success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@",responseObject);
        NSArray* array = responseObject;
        if (array.count > 0) {
            for (NSDictionary* dic in array) {
                Article* a = [[Article alloc]initWithDictionnary:dic];
                [self.dataSourceArray addObject:a];
            }
        }
        success();
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure();
    }];
}
@end
