//
//  HGPhotoWall.h
//  PhotoDemo
//
//  Created by Harry on 12-12-6.
//  Copyright (c) 2012年 Harry. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
@protocol HGPhotoWallDelegate <NSObject>

- (void)photoWallPhotoTaped:(NSUInteger)index WithPhotoWall:(UIView *)photoWall;
- (void)photoWallMovePhotoFromIndex:(NSInteger)index toIndex:(NSInteger)newIndex;
- (void)photoWallAddAction;
- (void)photoWallAddFinish;
- (void)photoWallDeleteFinish;

@end
typedef  enum
{
    DescriptionTypePet,
    DescriptionTypeImage
}DescriptionType;
@interface HGPhotoWall : UIView
@property (strong, nonatomic) UILabel *labelDescription;
@property (assign) id<HGPhotoWallDelegate> delegate;
@property (strong,nonatomic)UIView *bg;
@property (assign,nonatomic)DescriptionType descriptionType;
- (void)setPhotos:(NSArray*)photos;
- (void)setEditModel:(BOOL)canEdit;
- (void)addPhoto:(NSString*)string;
- (void)deletePhotoByIndex:(NSUInteger)index;
-(void)setAnimationNO;

@end
