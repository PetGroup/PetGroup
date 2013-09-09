//
//  UpLoadPhotoViewController.h
//  NewXMPPTest
//
//  Created by 阿铛 on 13-8-20.
//  Copyright (c) 2013年 Tolecen. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef  enum
{
    PetTypeStyleDog = 1,
    PetTypeStyleCat,
    PetTypeStyleOther,
    PetTypeStyleNone
}PetTypeStyle;
@interface UpLoadPhotoViewController : UIViewController<UINavigationControllerDelegate,UIImagePickerControllerDelegate>

@property (nonatomic ,assign) PetTypeStyle petType;
@property (nonatomic ,strong) NSDictionary *hostDic;
@property (nonatomic ,strong) NSDictionary *petDic;

@end
