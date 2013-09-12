//
//  NearbyDynamicDelegateAndDataSource.m
//  PetGroup
//
//  Created by 阿铛 on 13-8-22.
//  Copyright (c) 2013年 Tolecen. All rights reserved.
//

#import "NearbyDynamicDelegateAndDataSource.h"
#import "TempData.h"
#import "DynamicCell.h"
#import "Dynamic.h"

@implementation NearbyDynamicDelegateAndDataSource
-(void)reloadDataSuccess:(void (^)(void))success failure:(void (^)(void))failure
{
    self.pageIndex = 0;
    self.lastStateid = -1;
   [NetManager requestWithURLStr:BaseClientUrl Parameters:[self parameter] success:^(AFHTTPRequestOperation *operation, id responseObject) {
       NSLog(@"%@",[[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding]);
       NSArray*array = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
       [self.dataSourceArray removeAllObjects];
       for (NSDictionary*a in array) {
           Dynamic* b = [[Dynamic alloc]initWithNSDictionary:a];
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
        if (array.count>0) {
            for (NSDictionary*a in array) {
                Dynamic* b = [[Dynamic alloc]initWithNSDictionary:a];
                [self.dataSourceArray addObject:b];
            }
            self.pageIndex = [[[array lastObject] objectForKey:@"pageIndex"] intValue] + 1;
            self.lastStateid = [[[array lastObject] objectForKey:@"id"] intValue];
            success();
        }else{
            UIAlertView *aler = [[UIAlertView alloc]initWithTitle:nil message:@"没有更多动态啦" delegate:self cancelButtonTitle:@"知道啦" otherButtonTitles: nil];
            [aler show];
            success();
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
    [params setObject:@"" forKey:@"type"];
    [params setObject:@"" forKey:@"gender"];
    [params setObject:[NSString stringWithFormat:@"%f",[[TempData sharedInstance] returnLon]] forKey:@"longitude"];
    [params setObject:[NSString stringWithFormat:@"%f",[[TempData sharedInstance] returnLat]] forKey:@"latitude"];
    [params setObject:[NSString stringWithFormat:@"%d",self.pageIndex] forKey:@"pageIndex"];
    NSMutableDictionary* body = [NSMutableDictionary dictionary];
    [body setObject:params forKey:@"params"];
    [body setObject:@"getUserStateView" forKey:@"method"];
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
    cell.dynamic = self.dataSourceArray[indexPath.row];
    return cell;
}

@end
