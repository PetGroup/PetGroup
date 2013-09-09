//
//  AddPetViewController.h
//  NewXMPPTest
//
//  Created by 阿铛 on 13-8-20.
//  Copyright (c) 2013年 Tolecen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UpLoadPhotoViewController.h"

@interface AddPetViewController : UIViewController<UIPickerViewDataSource,UIPickerViewDelegate>

@property (nonatomic ,assign) PetTypeStyle petType;
@property (nonatomic ,strong) NSDictionary *hostDic;

@end
