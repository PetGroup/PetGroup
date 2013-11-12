//
//  FriendCircleDataSource.m
//  PetGroup
//
//  Created by 阿铛 on 13-10-14.
//  Copyright (c) 2013年 Tolecen. All rights reserved.
//

#import "FriendCircleDataSource.h"
#import "TempData.h"
@interface FriendCircleDataSource ()
@property (nonatomic,assign)int pageNo;
@end
@implementation FriendCircleDataSource
- (id)init
{
    self = [super init];
    if (self) {
        self.replyCountDic = [[NSMutableDictionary alloc]init];
//        self.rowHighArray = [[NSMutableArray alloc]init];
    }
    return self;
}

-(void)reloadDataSuccess:(void (^)(void))success failure:(void (^)(void))failure
{//body={"method":"getAllFriendStates","token":"XXX","channel":"","mac":"","imei":"","params":{"lastStateid":""}}
    self.pageNo = 0;
    NSTimeInterval cT = [[NSDate date] timeIntervalSince1970];
    long long a = (long long)(cT*1000);
    NSMutableDictionary* params = [NSMutableDictionary dictionary];
    [params setObject:[NSString stringWithFormat:@"%d",_pageNo] forKey:@"pageNo"];
    [params setObject:@"20" forKey:@"pageSize"];
    NSMutableDictionary* body = [NSMutableDictionary dictionary];
    [body setObject:@"service.uri.pet_states" forKey:@"service"];
    [body setObject:params forKey:@"params"];
    [body setObject:@"getAllFriendStates" forKey:@"method"];
    [body setObject:@"1" forKey:@"channel"];
    [body setObject:[SFHFKeychainUtils getPasswordForUsername:MACADDRESS andServiceName:LOCALACCOUNT error:nil] forKey:@"mac"];
    [body setObject:@"iphone" forKey:@"imei"];
    [body setObject:[NSString stringWithFormat:@"%lld",a] forKey:@"connectTime"];
    [body setObject:[SFHFKeychainUtils getPasswordForUsername:LOCALTOKEN andServiceName:LOCALACCOUNT error:nil] forKey:@"token"];
    [NetManager requestWithURLStr:BaseClientUrl Parameters:body TheController:self.myController success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@",responseObject);
        NSArray*array = responseObject;
        [self.dataSourceArray removeAllObjects];
        if (array.count>0) {
            self.pageNo++;
            for (NSDictionary*a in array) {
                Dynamic* b = [[Dynamic alloc]initWithNSDictionary:a];
                [self.dataSourceArray addObject:b];
                [self saveReplyNumberDic:b];
//                [self saverowHighArray:b];
            }
            
        }
        success();
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure();
    }];
}
-(void)loadMoreDataSuccess:(void (^)(void))success failure:(void (^)(void))failure
{
    NSTimeInterval cT = [[NSDate date] timeIntervalSince1970];
    long long a = (long long)(cT*1000);
    NSMutableDictionary* params = [NSMutableDictionary dictionary];
    [params setObject:[NSString stringWithFormat:@"%d",_pageNo] forKey:@"pageNo"];
    [params setObject:@"20" forKey:@"pageSize"];
    NSMutableDictionary* body = [NSMutableDictionary dictionary];
    [body setObject:@"service.uri.pet_states" forKey:@"service"];
    [body setObject:params forKey:@"params"];
    [body setObject:@"getAllFriendStates" forKey:@"method"];
    [body setObject:@"1" forKey:@"channel"];
    [body setObject:[SFHFKeychainUtils getPasswordForUsername:MACADDRESS andServiceName:LOCALACCOUNT error:nil] forKey:@"mac"];
    [body setObject:@"iphone" forKey:@"imei"];
    [body setObject:[NSString stringWithFormat:@"%lld",a] forKey:@"connectTime"];
    [body setObject:[SFHFKeychainUtils getPasswordForUsername:LOCALTOKEN andServiceName:LOCALACCOUNT error:nil] forKey:@"token"];
    [NetManager requestWithURLStr:BaseClientUrl Parameters:body TheController:self.myController success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@",responseObject);
        NSArray*array = responseObject;
        if (array.count>0) {
            self.pageNo++;
            for (NSDictionary*a in array) {
                Dynamic* b = [[Dynamic alloc]initWithNSDictionary:a];
                [self.dataSourceArray addObject:b];
                [self saveReplyNumberDic:b];
//                [self saverowHighArray:b];
            }
        }
        success();
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure();
    }];
}
-(NSString*)replyCountWithDynamicID:(NSString*)dynamicID
{
    if ([[self.replyCountDic allKeys] containsObject:dynamicID]) {
        if ([[self.replyCountDic objectForKey:dynamicID] intValue]!= 0) {
            return [self.replyCountDic objectForKey:dynamicID];
        }
    }
    return @"回复";
}
-(void)saveReplyNumberDic:(Dynamic*)dynamic
{
    //获取回复总数
    NSTimeInterval cT = [[NSDate date] timeIntervalSince1970];
    long long a = (long long)(cT*1000);
    NSMutableDictionary* params = [NSMutableDictionary dictionary];
    [params setObject:dynamic.dynamicID forKey:@"stateid"];
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
        [self.replyCountDic setObject:[NSString stringWithFormat:@"%d",[responseObject intValue]]forKey:dynamic.dynamicID];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}
//-(void)saverowHighArray:(Dynamic*)dynamic
//{
//    NSString* high = [NSString stringWithFormat:@"%f",[DynamicCell heightForRowWithDynamic:dynamic]];
//    [self.rowHighArray addObject:high];
//}
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
