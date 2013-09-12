//
//  PersonDynamicDelegateAndDataSouce.m
//  PetGroup
//
//  Created by 阿铛 on 13-9-11.
//  Copyright (c) 2013年 Tolecen. All rights reserved.
//

#import "PersonDynamicDelegateAndDataSouce.h"
#import "PersonalDynamic.h"
#import "PersonalDynamicCell.h"
@implementation PersonDynamicDelegateAndDataSouce
-(void)reloadDataSuccess:(void (^)(void))success failure:(void (^)(void))failure
{
    self.pageIndex = 0;
    self.lastStateid = -1;
    [NetManager requestWithURLStr:BaseClientUrl Parameters:[self parameter] success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@",[[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding]);
        NSArray*array = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        [self.dataSourceArray removeAllObjects];
        for (NSDictionary*a in array) {
            PersonalDynamic* b = [[PersonalDynamic alloc]initWithNSDictionary:a];
            [self.dataSourceArray addObject:b];
        }
        self.pageIndex = [[[array lastObject] objectForKey:@"pageIndex"] intValue] + 1;
        self.lastStateid = [[[array lastObject] objectForKey:@"id"] intValue];
        success();
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure();
    }];
}
-(void)loadMoreDataSuccess:(void (^)(void))success failure:(void (^)(void))failure
{
    [NetManager requestWithURLStr:BaseClientUrl Parameters:[self parameter] success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@",[[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding]);
        NSArray*array = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        for (NSDictionary*a in array) {
            PersonalDynamic* b = [[PersonalDynamic alloc]initWithNSDictionary:a];
            [self.dataSourceArray addObject:b];
        }
        self.pageIndex = [[[array lastObject] objectForKey:@"pageIndex"] intValue] + 1;
        self.lastStateid = [[[array lastObject] objectForKey:@"id"] intValue];
        success();
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure();
    }];
}
-(NSDictionary*)parameter
{
    NSTimeInterval cT = [[NSDate date] timeIntervalSince1970];
    long long a = (long long)(cT*1000);
    NSMutableDictionary* params = [NSMutableDictionary dictionary];
    [params setObject:self.userID forKey:@"userid"];
    [params setObject:[NSString stringWithFormat:@"%d",self.pageIndex] forKey:@"pageIndex"];
    [params setObject:[NSString stringWithFormat:@"%lld",self.lastStateid] forKey:@"lastStateid"];
    NSMutableDictionary* body = [NSMutableDictionary dictionary];
    [body setObject:params forKey:@"params"];
    [body setObject:@"findFriendStates" forKey:@"method"];
    [body setObject:@"1" forKey:@"channel"];
    [body setObject:[SFHFKeychainUtils getPasswordForUsername:MACADDRESS andServiceName:LOCALACCOUNT error:nil] forKey:@"mac"];
    [body setObject:@"iphone" forKey:@"imei"];
    [body setObject:[NSString stringWithFormat:@"%lld",a] forKey:@"connectTime"];
    [body setObject:[SFHFKeychainUtils getPasswordForUsername:LOCALTOKEN andServiceName:LOCALACCOUNT error:nil] forKey:@"token"];
    return body;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"FrendbyCell";
    PersonalDynamicCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier ];
    if (cell == nil) {
        cell = [[PersonalDynamicCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    }
    cell.viewC = self.viewC;
    cell.dynamic = self.dataSourceArray[indexPath.row];
    return cell;
}


@end
