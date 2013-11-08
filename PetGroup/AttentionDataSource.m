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
@interface AttentionDataSource()

@end

@implementation AttentionDataSource
- (id)init
{
    self = [super init];
    if (self) {
        self.dynamicArray = [[NSMutableArray alloc]init];
    }
    return self;
}
-(void)loadHistorySuccess:(void (^)(void))success failure:(void (^)(void))failure
{
    
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    NSArray* dynamicArray = [defaults objectForKey:MyDynamic];
    NSArray* array = [defaults objectForKey:MyCircle];
    for (NSDictionary*a in dynamicArray) {
        Dynamic* b = [[Dynamic alloc]initWithNSDictionary:a];
        [self.dynamicArray addObject:b];
    }
    for (NSDictionary* dic in array) {
        CircleClassify* a = [[CircleClassify alloc]initWithDictionnary:dic];
        [self.dataSourceArray addObject:a];
    }
    success();
}
-(void)reloadDataSuccess:(void (^)(void))success failure:(void (^)(void))failure
{
    NSTimeInterval cT = [[NSDate date] timeIntervalSince1970];
    long long a = (long long)(cT*1000);
    NSMutableDictionary* params = [NSMutableDictionary dictionary];
    [params setObject:@"0" forKey:@"pageNo"];
    [params setObject:@"1" forKey:@"pageSize"];
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
        NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:array forKey:MyDynamic];
        [defaults synchronize];
        [self.dynamicArray removeAllObjects];
        if (array.count>0) {
            for (NSDictionary*a in array) {
                Dynamic* b = [[Dynamic alloc]initWithNSDictionary:a];
                [self.dynamicArray addObject:b];
            }
        }
        success();       
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure();
    }];
    [body setObject:@"getAllForumAsTree" forKey:@"method"];
    NSMutableDictionary* param = [NSMutableDictionary dictionary];
    [param setObject:[[TempData sharedInstance] getMyUserID] forKey:@"userId"];
    [body setObject:param forKey:@"params"];
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
#pragma mark - collection view data source
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        if (indexPath.section == 0) {
            static NSString *headIdentifier = @"friendHeader";
            FriendHeaderView* friendHeader= [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headIdentifier forIndexPath:indexPath];
            friendHeader.delegate = self.myController;
            return friendHeader;
        }else{
            static NSString *headIdentifier = @"header";
             HeaderView* header= [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headIdentifier forIndexPath:indexPath];
            header.titleL.text =((CircleClassify*)self.dataSourceArray[indexPath.section-1]).name;
            return header;
        }
        
    }
    if ([kind isEqualToString:UICollectionElementKindSectionFooter]&&indexPath.section!=0) {
        static NSString *footIdentifier = @"footer";
        FooterView* footer = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:footIdentifier forIndexPath:indexPath];
        if (indexPath.section==1) {
            if (((CircleClassify*)self.dataSourceArray[0]).circleArray.count<=4) {
                footer.unfoldB.hidden = YES;
            }else{
                footer.unfoldB.hidden = NO;
            }
        }else{
            if (((CircleClassify*)self.dataSourceArray[indexPath.section-1]).circleArray.count<=2) {
                footer.unfoldB.hidden = YES;
            }else{
                footer.unfoldB.hidden = NO;
            }
        }
        if (((CircleClassify*)self.dataSourceArray[indexPath.section-1]).zhankai) {
            [footer.unfoldB setBackgroundImage:[UIImage imageNamed:@"shouqi"] forState:UIControlStateNormal];
        }else{
            [footer.unfoldB setBackgroundImage:[UIImage imageNamed:@"zhankai"] forState:UIControlStateNormal];
        }
        footer.delegate = self.myController;
        footer.indexPath = indexPath;
        return footer;
    }
    return nil;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    }else if(section == 1){
        CircleClassify* classify =self.dataSourceArray[0];
        if (classify.zhankai) {
            return classify.circleArray.count;
        }else{
            if (classify.circleArray.count>4) {
                return 4;
            }else{
                if (classify.circleArray.count==0) {
                    return 1;
                }
                return classify.circleArray.count;
            }
        }
    }else{
        CircleClassify* classify = self.dataSourceArray[section-1];
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
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section!=0) {
        if (indexPath.section==1) {
            CircleClassify* classify = self.dataSourceArray[0];
            if (classify.circleArray.count==0) {
                static NSString *identifier = @"place";
                PlaceHolderCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
                cell.placeHolderString = @"您还没有关注圈子，快去关注自己感兴趣的圈子吧";
                [cell layoutSubviews];
                return cell;
            }
        }
        static NSString *cellIdentifier = @"cell";
        CircleCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
        CircleClassify* classify = self.dataSourceArray[indexPath.section-1];
        cell.entity = classify.circleArray[indexPath.row];
        [cell layoutSubviews];
        return cell;
    }else{
        if (self.dynamicArray.count>0) {
            static NSString *identifier = @"friend";
            FriendCircleCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
            cell.dynamic = self.dynamicArray[0];
            [cell layoutSubviews];
            return cell;
        }else{
            static NSString *identifier = @"place";
            PlaceHolderCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
            cell.placeHolderString = @"您的朋友圈里还没又人发布动态,快来发布自己的动态或去添加好友";
            [cell layoutSubviews];
            return cell;
        }
    }
    
}
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return self.dataSourceArray.count+1;
}

@end
