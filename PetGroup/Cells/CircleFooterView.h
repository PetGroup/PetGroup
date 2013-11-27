//
//  CircleFooterView.h
//  PetGroup
//
//  Created by wangxr on 13-11-27.
//  Copyright (c) 2013年 Tolecen. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol CircleFooterViewDelegate<NSObject>
-(void)circleFooterViewPressButtonWithIndexPath:(NSInteger)section;
@end
@interface CircleFooterView : UITableViewHeaderFooterView
@property (nonatomic,assign)id<CircleFooterViewDelegate>delegate;
@property (nonatomic,retain)UIButton*button;
@property (nonatomic,assign)NSInteger  section;
@end
