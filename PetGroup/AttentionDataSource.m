//
//  AttentionDataSource.m
//  PetGroup
//
//  Created by 阿铛 on 13-10-14.
//  Copyright (c) 2013年 Tolecen. All rights reserved.
//

#import "AttentionDataSource.h"
#import "Dynamic.h"
#import "CircleClassify.h"
#import "TempData.h"
#import "CircleClassify.h"
#import "CircleEntity.h"
@interface AttentionDataSource()

@end

@implementation AttentionDataSource
- (id)init
{
    self = [super init];
    if (self) {
//        self.dynamicArray = [[NSMutableArray alloc]init];
    }
    return self;
}
-(void)loadHistorySuccess:(void (^)(void))success failure:(void (^)(void))failure
{
    
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
//    NSArray* dynamicArray = [defaults objectForKey:MyFriendDynamic];
    NSArray* array = [defaults objectForKey:MyCircle];
//    for (NSDictionary*a in dynamicArray) {
//        Dynamic* b = [[Dynamic alloc]initWithNSDictionary:a];
//        [self.dynamicArray addObject:b];
//    }
    if (array.count<=0) {
        array = @[@{@"id": @"0",@"atte" :@"1",@"name" :@"我关注的圈子",@"child":@[]},@{@"id": @"0",@"atte" :@"1",@"name" :@"热点推荐",@"child":@[]},@{@"id": @"0",@"atte" :@"1",@"name" :@"综合交流区",@"child":@[]},@{@"id": @"0",@"atte" :@"1",@"name" :@"汪星人",@"child":@[]},@{@"id": @"0",@"atte" :@"1",@"name" :@"喵星人",@"child":@[]},@{@"id": @"0",@"atte" :@"1",@"name" :@"鸟兽虫鱼",@"child":@[]},@{@"id": @"0",@"atte" :@"1",@"name" :@"各地俱乐部",@"child":@[]}];
    }
    for (NSDictionary* dic in array) {
        CircleClassify* a = [[CircleClassify alloc]initWithDictionnary:dic];
        [self.dataSourceArray addObject:a];
    }
    success();
}
-(void)reloadDataSuccess:(void (^)(void))success failure:(void (^)(void))failure
{
//    NSTimeInterval cT = [[NSDate date] timeIntervalSince1970];
//    long long a = (long long)(cT*1000);
//    NSMutableDictionary* params = [NSMutableDictionary dictionary];
//    [params setObject:@"0" forKey:@"pageNo"];
//    [params setObject:@"1" forKey:@"pageSize"];
//    NSMutableDictionary* body = [NSMutableDictionary dictionary];
//    [body setObject:@"service.uri.pet_states" forKey:@"service"];
//    [body setObject:params forKey:@"params"];
//    [body setObject:@"getAllFriendStates" forKey:@"method"];
//    [body setObject:@"1" forKey:@"channel"];
//    [body setObject:[SFHFKeychainUtils getPasswordForUsername:MACADDRESS andServiceName:LOCALACCOUNT error:nil] forKey:@"mac"];
//    [body setObject:@"iphone" forKey:@"imei"];
//    [body setObject:[NSString stringWithFormat:@"%lld",a] forKey:@"connectTime"];
//    [body setObject:[SFHFKeychainUtils getPasswordForUsername:LOCALTOKEN andServiceName:LOCALACCOUNT error:nil] forKey:@"token"];
//    [NetManager requestWithURLStr:BaseClientUrl Parameters:body TheController:self.myController success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        NSLog(@"%@",responseObject);
//        NSArray*array = responseObject;
//        NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
//        [defaults setObject:array forKey:MyFriendDynamic];
//        [defaults synchronize];
//        [self.dynamicArray removeAllObjects];
//        if (array.count>0) {
//            for (NSDictionary*a in array) {
//                Dynamic* b = [[Dynamic alloc]initWithNSDictionary:a];
//                [self.dynamicArray addObject:b];
//            }
//        }
//        success();       
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        failure();
//    }];
    NSTimeInterval cT = [[NSDate date] timeIntervalSince1970];
    long long a = (long long)(cT*1000);
    NSMutableDictionary* params = [NSMutableDictionary dictionary];
    [params setObject:[[TempData sharedInstance] getMyUserID] forKey:@"userId"];
    NSMutableDictionary* body = [NSMutableDictionary dictionary];
    [body setObject:params forKey:@"params"];
    [body setObject:@"1" forKey:@"channel"];
    [body setObject:[SFHFKeychainUtils getPasswordForUsername:MACADDRESS andServiceName:LOCALACCOUNT error:nil] forKey:@"mac"];
    [body setObject:@"iphone" forKey:@"imei"];
    [body setObject:[NSString stringWithFormat:@"%lld",a] forKey:@"connectTime"];
    [body setObject:[SFHFKeychainUtils getPasswordForUsername:LOCALTOKEN andServiceName:LOCALACCOUNT error:nil] forKey:@"token"];
    [body setObject:@"getAllForumAsTree" forKey:@"method"];
    [body setObject:@"service.uri.pet_bbs" forKey:@"service"];
    [NetManager requestWithURLStr:BaseClientUrl Parameters:body TheController:self.myController success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@",responseObject);
        NSArray* array = responseObject;
        NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:array forKey:MyCircle];
        [defaults synchronize];
        [self.dataSourceArray removeAllObjects];
        if (array.count > 0) {
            for (NSDictionary* dic in array) {
                CircleClassify* a = [[CircleClassify alloc]initWithDictionnary:dic];
                [self.dataSourceArray addObject:a];
            }
        }
        success();
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure();
    }];
}
#pragma mark - table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section == 0){
        CircleClassify* classify =self.dataSourceArray[0];
        return classify.circleArray.count+1;
    }else{
        CircleClassify* classify = self.dataSourceArray[section];
        if (classify.zhankai) {
            return classify.circleArray.count;
        }else{
            if (classify.circleArray.count>2) {
                return 2;
            }else{
                return classify.circleArray.count;
            }
        }
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"Cell";
    UITableViewCell*cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier ];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    }
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            cell.textLabel.text = @"朋友圈";
        }else{
            cell.textLabel.text = ((CircleEntity*)((CircleClassify*)self.dataSourceArray[0]).circleArray[indexPath.row-1]).name;
        }
    }else{
        cell.textLabel.text = ((CircleEntity*)((CircleClassify*)self.dataSourceArray[indexPath.section]).circleArray[indexPath.row]).name;
    }
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dataSourceArray.count;
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return ((CircleClassify*)self.dataSourceArray[section]).name;
}
@end
