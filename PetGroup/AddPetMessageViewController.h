//
//  AddPetMessageViewController.h
//  PetGroup
//
//  Created by wangxr on 14-1-16.
//  Copyright (c) 2014年 Tolecen. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AddRQCodeMessageDelegate <NSObject>

@optional
- (void)finishAddRQCodeMessageWithPet:(NSDictionary*)pet;
@end
@interface AddPetMessageViewController : UIViewController
@property (nonatomic,assign)BOOL edit;
@property (nonatomic,assign)id<AddRQCodeMessageDelegate>delegate;
@property (nonatomic,retain)NSMutableDictionary* RQCodeMessage;
@end
