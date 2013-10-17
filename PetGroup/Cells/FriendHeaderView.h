//
//  FriendHeaderView.h
//  PetGroup
//
//  Created by 阿铛 on 13-10-14.
//  Copyright (c) 2013年 Tolecen. All rights reserved.
//

#import <UIKit/UIKit.h>
@class FriendHeaderView;
@protocol FriendHeaderViewDelegate<NSObject>
-(void)didSelectSearchBAtFriendHeaderView:(FriendHeaderView*)friendHeaderV;
@end
@interface FriendHeaderView : UICollectionReusableView
@property(nonatomic,assign) id<FriendHeaderViewDelegate>delegate;
@end
