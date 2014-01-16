//
//  AddPetMessageViewController.h
//  PetGroup
//
//  Created by wangxr on 14-1-16.
//  Copyright (c) 2014年 Tolecen. All rights reserved.
//

#import <UIKit/UIKit.h>
@class PetInfo;
@protocol AddRQCodeMessageDelegate <NSObject>

@optional
- (void)finishAddRQCodeMessageWithPet:(PetInfo*)pet;
@end
@interface AddPetMessageViewController : UIViewController
@property (nonatomic,assign)id<AddRQCodeMessageDelegate>delegate;
@property (nonatomic,retain)NSString* RQCodeNo;
@property (nonatomic,retain)id RQCodeMessage;
@end
