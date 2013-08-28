//
//  NearbyDynamicDelegateAndDataSource.m
//  PetGroup
//
//  Created by 阿铛 on 13-8-22.
//  Copyright (c) 2013年 Tolecen. All rights reserved.
//

#import "NearbyDynamicDelegateAndDataSource.h"
#import "DynamicCell.h"

@implementation NearbyDynamicDelegateAndDataSource

-(void)reloadDataSuccess:(void (^)(void))success failure:(void (^)(void))failure
{
    self.pageIndex = 0;
   [NetManager requestWithURLStr:BaseClientUrl Parameters:[self parameter] success:^(AFHTTPRequestOperation *operation, id responseObject) {
       self.dataSourceArray = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
       NSLog(@"%@",self.dataSourceArray);
   } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
       NSLog(@"%@",error);
   }];
}
-(void)loadMoreDataSuccess:(void (^)(void))success failure:(void (^)(void))failure
{
    
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
