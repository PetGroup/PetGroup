//
//  AttentionDataSource.m
//  PetGroup
//
//  Created by 阿铛 on 13-10-14.
//  Copyright (c) 2013年 Tolecen. All rights reserved.
//

#import "AttentionDataSource.h"
#import "Dynamic.h"
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
-(void)reloadDataSuccess:(void (^)(void))success failure:(void (^)(void))failure
{
    NSTimeInterval cT = [[NSDate date] timeIntervalSince1970];
    long long a = (long long)(cT*1000);
    NSMutableDictionary* params = [NSMutableDictionary dictionary];
    [params setObject:@"0" forKey:@"pageIndex"];
    [params setObject:@"-1" forKey:@"lastStateid"];
    NSMutableDictionary* body = [NSMutableDictionary dictionary];
    [body setObject:params forKey:@"params"];
    [body setObject:@"getAllFriendStates" forKey:@"method"];
    [body setObject:@"1" forKey:@"channel"];
    [body setObject:[SFHFKeychainUtils getPasswordForUsername:MACADDRESS andServiceName:LOCALACCOUNT error:nil] forKey:@"mac"];
    [body setObject:@"iphone" forKey:@"imei"];
    [body setObject:[NSString stringWithFormat:@"%lld",a] forKey:@"connectTime"];
    [body setObject:[SFHFKeychainUtils getPasswordForUsername:LOCALTOKEN andServiceName:LOCALACCOUNT error:nil] forKey:@"token"];
    [NetManager requestWithURLStr:BaseClientUrl Parameters:body TheController:self.myController success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@",[[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding]);
        NSArray*array = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
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
            header.titleL.text = @"我关注的";
            return header;
        }
        
    }
    if ([kind isEqualToString:UICollectionElementKindSectionFooter]&&indexPath.section!=0) {
        static NSString *footIdentifier = @"footer";
        FooterView* footer = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:footIdentifier forIndexPath:indexPath];
        footer.delegate = self.myController;
        footer.indexPath = indexPath;
        return footer;
    }
    return nil;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (section == 0) {
        if (self.dynamicArray.count>0) {
            return 1;
        }else{
            return 0;
        }
    }else
        return 2;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section!=0) {
        static NSString *cellIdentifier = @"cell";
        CircleCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
        cell.highlighted = YES;
        [cell layoutSubviews];
        return cell;
    }else{
        static NSString *identifier = @"friend";
        FriendCircleCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
        if (self.dynamicArray.count>0) {
            cell.dynamic = self.dynamicArray[0];
        }
        [cell layoutSubviews];
        return cell;
    }
    
}
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 5;
}

@end
