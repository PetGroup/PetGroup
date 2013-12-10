//
//  UserGuidCell.h
//  PetGroup
//
//  Created by wangxr on 13-12-10.
//  Copyright (c) 2013年 Tolecen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGOImageView.h"
@interface UserGuidCell : UICollectionViewCell
@property (nonatomic,retain)UIImageView * bgView;
@property (nonatomic,retain)EGOImageView * logeV;
@property (nonatomic,retain)UILabel * titleL;
@property (nonatomic,assign)BOOL canCancel;
@end
