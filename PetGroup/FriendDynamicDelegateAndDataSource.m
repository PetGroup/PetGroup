//
//  FriendDynamicDelegateAndDataSource.m
//  PetGroup
//
//  Created by 阿铛 on 13-8-22.
//  Copyright (c) 2013年 Tolecen. All rights reserved.
//

#import "FriendDynamicDelegateAndDataSource.h"
#import "DynamicCell.h"

@implementation FriendDynamicDelegateAndDataSource
-(void)reloadDataSuccess:(void (^)(void))success failure:(void (^)(void))failure
{
    self.pageIndex = 0;
    [NetManager requestWithURLStr:BaseClientUrl Parameters:[self parameter] success:^(AFHTTPRequestOperation *operation, id responseObject) {
        self.dataSourceArray = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"%@",self.dataSourceArray);
        self.pageIndex = [[[self.dataSourceArray lastObject] objectForKey:@"pageIndex"] intValue] + 1;
        success();
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure();
    }];
}
-(void)loadMoreDataSuccess:(void (^)(void))success failure:(void (^)(void))failure
{
    [NetManager requestWithURLStr:BaseClientUrl Parameters:[self parameter] success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSArray*array = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"%@",self.dataSourceArray);
        if (array.count>0) {
            [self.dataSourceArray addObjectsFromArray:array];
            self.pageIndex = [[[self.dataSourceArray lastObject] objectForKey:@"pageIndex"] intValue] + 1;
            success();
        }else{
            UIAlertView *aler = [[UIAlertView alloc]initWithTitle:nil message:@"没有更多动态啦" delegate:self cancelButtonTitle:@"知道啦" otherButtonTitles: nil];
            [aler show];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure();
    }];
}
-(NSDictionary*)parameter
{
    NSTimeInterval cT = [[NSDate date] timeIntervalSince1970];
    long long a = (long long)(cT*1000);
    NSMutableDictionary* params = [NSMutableDictionary dictionary];
    [params setObject:[NSString stringWithFormat:@"%d",self.pageIndex] forKey:@"pageIndex"];
    NSMutableDictionary* body = [NSMutableDictionary dictionary];
    [body setObject:params forKey:@"params"];
    [body setObject:@"findMyStates" forKey:@"method"];
    [body setObject:@"1" forKey:@"channel"];
    [body setObject:[SFHFKeychainUtils getPasswordForUsername:MACADDRESS andServiceName:LOCALACCOUNT error:nil] forKey:@"mac"];
    [body setObject:@"iphone" forKey:@"imei"];
    [body setObject:[NSString stringWithFormat:@"%lld",a] forKey:@"connectTime"];
    [body setObject:[SFHFKeychainUtils getPasswordForUsername:LOCALTOKEN andServiceName:LOCALACCOUNT error:nil] forKey:@"token"];
    return body;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"NearbyCell";
    DynamicCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier ];
    if (cell == nil) {
        cell = [[DynamicCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    }
    cell.viewC = self.viewC;
    cell.textLabel.text = @"哈哈";
    return cell;
}


@end
