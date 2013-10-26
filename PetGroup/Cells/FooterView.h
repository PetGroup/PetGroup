//
//  FooterView.h
//  PetGroup
//
//  Created by 阿铛 on 13-10-11.
//  Copyright (c) 2013年 Tolecen. All rights reserved.
//

#import <UIKit/UIKit.h>
@class FooterView;
@protocol FooterViewDelegate<NSObject>
-(void)footerView:(FooterView*)footerV didSelectUnfoldBAtIndexPath:(NSIndexPath *)indexPath;
@end
@interface FooterView : UICollectionReusableView
@property(nonatomic,assign) UIButton* unfoldB;
@property(nonatomic,assign) id<FooterViewDelegate>delegate;
@property(nonatomic,retain) NSIndexPath* indexPath;
@end
