//
//  DynamicDataSource.m
//  PetGroup
//
//  Created by 阿铛 on 13-10-25.
//  Copyright (c) 2013年 Tolecen. All rights reserved.
//

#import "DynamicDataSource.h"

@implementation DynamicDataSource
- (id)init
{
    self = [super init];
    if (self) {
        self.replyCountDic = [[NSMutableDictionary alloc]init];
    }
    return self;
}
-(void)reloadDataSuccess:(void (^)(void))success failure:(void (^)(void))failure
{
    
}
-(void)loadMoreDataSuccess:(void (^)(void))success failure:(void (^)(void))failure
{
    
}
-(NSString*)replyCountWithDynamicID:(NSString*)dynamicID
{
    if ([[self.replyCountDic allKeys] containsObject:dynamicID]) {
        return [self.replyCountDic objectForKey:dynamicID];
    }
    //获取回复总数
    NSTimeInterval cT = [[NSDate date] timeIntervalSince1970];
    long long a = (long long)(cT*1000);
    NSMutableDictionary* params = [NSMutableDictionary dictionary];
    [params setObject:dynamicID forKey:@"stateid"];
    NSMutableDictionary* body = [NSMutableDictionary dictionary];
    [body setObject:@"service.uri.pet_states" forKey:@"service"];
    [body setObject:params forKey:@"params"];
    [body setObject:@"getTotalReply" forKey:@"method"];
    [body setObject:@"1" forKey:@"channel"];
    [body setObject:[SFHFKeychainUtils getPasswordForUsername:MACADDRESS andServiceName:LOCALACCOUNT error:nil] forKey:@"mac"];
    [body setObject:@"iphone" forKey:@"imei"];
    [body setObject:[NSString stringWithFormat:@"%lld",a] forKey:@"connectTime"];
    [body setObject:[SFHFKeychainUtils getPasswordForUsername:LOCALTOKEN andServiceName:LOCALACCOUNT error:nil] forKey:@"token"];
    [NetManager requestWithURLStr:BaseClientUrl Parameters:body TheController:self.myController success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@",responseObject);
        [self.replyCountDic setObject:[NSString stringWithFormat:@"%d",[responseObject intValue]]forKey:dynamicID];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
    return @"回复";
}
#pragma mark - table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSourceArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"cell";
    DynamicCell*cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier ];
    if (cell == nil) {
        cell = [[DynamicCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
        cell.delegate = self.myController;
    }
    cell.indexPath = indexPath;
    cell.dynamic = self.dataSourceArray[indexPath.row];
    [cell.replyB setTitle:[self replyCountWithDynamicID:((Dynamic*)self.dataSourceArray[indexPath.row]).dynamicID] forState:UIControlStateNormal];
    return cell;
}
@end
