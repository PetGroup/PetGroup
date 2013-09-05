//
//  EditDynamicViewController.h
//  PetGroup
//
//  Created by 阿铛 on 13-8-23.
//  Copyright (c) 2013年 Tolecen. All rights reserved.
//

#import <UIKit/UIKit.h>
@class DynamicViewController;
@interface EditDynamicViewController : UIViewController<UITextViewDelegate,UIActionSheetDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate>
@property(nonatomic,weak)DynamicViewController* viewC;
@end
