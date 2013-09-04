//
//  PhotoWall.m
//  PhotoDemo
//
//  Created by Harry on 12-12-6.
//  Copyright (c) 2012年 Harry. All rights reserved.
//

#import "HGPhotoWall.h"

#import "HGPhoto.h"

@interface HGPhotoWall() <HGPhotoDelegate>
{
    
}
@property (strong, nonatomic) UILabel *labelDescription;

@property (strong, nonatomic) NSArray *arrayPositions;
@property (strong, nonatomic) NSMutableArray *arrayPhotos;
@property (nonatomic) BOOL isEditModel;

@end

#define kFrameHeight 82.5
#define kFrameHeight2x 155.

#define kImagePositionx @"positionx"
#define kImagePositiony @"positiony"

@implementation HGPhotoWall

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:CGRectMake(0., 0., 300., 0.)];
    if (self) {
      //  self.backgroundColor = [UIColor clearColor];
        self.bg = [[UIView alloc] initWithFrame:CGRectMake(10., 0., 300., 0.)];
        self.bg.backgroundColor = [UIColor whiteColor];
        self.bg.layer.cornerRadius = 8;
        self.bg.layer.masksToBounds = YES;
        self.bg.layer.borderColor = [[UIColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:1] CGColor];
        self.bg.layer.borderWidth = 1;
//        [self addSubview:self.bg];
        
        self.arrayPositions = [NSArray arrayWithObjects:
                               [NSDictionary dictionaryWithObjectsAndKeys:@"10", kImagePositionx, @"10", kImagePositiony, nil],
                               [NSDictionary dictionaryWithObjectsAndKeys:@"82.5", kImagePositionx, @"10", kImagePositiony, nil],
                               [NSDictionary dictionaryWithObjectsAndKeys:@"155", kImagePositionx, @"10", kImagePositiony, nil],
                               [NSDictionary dictionaryWithObjectsAndKeys:@"227.5", kImagePositionx, @"10", kImagePositiony, nil],
                               [NSDictionary dictionaryWithObjectsAndKeys:@"10", kImagePositionx, @"82.5", kImagePositiony, nil],
                               [NSDictionary dictionaryWithObjectsAndKeys:@"82.5", kImagePositionx, @"82.5", kImagePositiony, nil],
                               [NSDictionary dictionaryWithObjectsAndKeys:@"155", kImagePositionx, @"82.5", kImagePositiony, nil],
                               [NSDictionary dictionaryWithObjectsAndKeys:@"227.5", kImagePositionx, @"82.5", kImagePositiony, nil],
                               [NSDictionary dictionaryWithObjectsAndKeys:@"330", kImagePositionx, @"82.5", kImagePositiony, nil], nil];
        self.arrayPhotos = [NSMutableArray arrayWithCapacity:1];
        
        self.labelDescription = [[UILabel alloc] initWithFrame:CGRectMake(10., 0., 300., 18.)];
        self.labelDescription.backgroundColor = [UIColor clearColor];
        self.labelDescription.textColor = [UIColor grayColor];
        self.labelDescription.font = [UIFont systemFontOfSize:12.];
        self.labelDescription.textAlignment = NSTextAlignmentLeft;
        
        [self addSubview:self.labelDescription];
        
        self.labelDescription.hidden = YES;
   
    }
    return self;
}

- (void)setPhotos:(NSArray*)photos
{
    if (self.descriptionType==DescriptionTypePet) {
        self.labelDescription.text = @"点击图片查看宠物，点击“+”添加宠物";
    }
    else
        self.labelDescription.text = @"点击“+”添加头像，最多可添加8张";
    [self.arrayPhotos removeAllObjects];
    NSUInteger count = [photos count];
    for (int i=0; i<count; i++) {
        NSDictionary *dictionaryTemp = [self.arrayPositions objectAtIndex:i];
        CGFloat originx = [[dictionaryTemp objectForKey:kImagePositionx] floatValue];
        CGFloat originy = [[dictionaryTemp objectForKey:kImagePositiony] floatValue];
        HGPhoto *photoTemp = [[HGPhoto alloc] initWithOrigin:CGPointMake(originx, originy)];
        photoTemp.delegate = self;
        [photoTemp setPhotoUrl:[photos objectAtIndex:i]];
        [self addSubview:photoTemp];
        [self.arrayPhotos addObject:photoTemp];
    }
    
    NSDictionary *dictionaryTemp = [self.arrayPositions objectAtIndex:count];
    CGFloat originx = [[dictionaryTemp objectForKey:kImagePositionx] floatValue];
    CGFloat originy = [[dictionaryTemp objectForKey:kImagePositiony] floatValue];
    HGPhoto *photoTemp = [[HGPhoto alloc] initWithOrigin:CGPointMake(originx, originy)];
    photoTemp.delegate = self;
    photoTemp.hidden = YES;
    [photoTemp setPhotoType:PhotoTypeAdd];
    [self.arrayPhotos addObject:photoTemp];
    [self addSubview:photoTemp];
    
    CGFloat frameHeight = -1;
    if (count > 4) {
        frameHeight = kFrameHeight2x;
    } else {
        frameHeight = kFrameHeight;
    }
    self.frame = CGRectMake(0., 0., 300., frameHeight);
    self.bg.frame = CGRectMake(10., 0., 300., frameHeight);
}

- (void)setEditModel:(BOOL)canEdit
{
    self.isEditModel = canEdit;
    if (self.isEditModel) {
        HGPhoto *photoTemp = [self.arrayPhotos lastObject];
        photoTemp.hidden = NO;
        self.labelDescription.hidden = NO;
    } else {
        HGPhoto *photoTemp = [self.arrayPhotos lastObject];
        photoTemp.hidden = YES;
        self.labelDescription.hidden = YES;
    }
    
    NSUInteger count = [self.arrayPhotos count]-1;
    for (int i=0; i<count; i++) {
        HGPhoto *photoTemp = [self.arrayPhotos objectAtIndex:i];
        [photoTemp setEditModel:self.isEditModel];
    }
    [self reloadPhotos:NO];
}

- (void)addPhoto:(NSString*)string
{
    NSUInteger index = [self.arrayPhotos count] - 1;
    NSDictionary *dictionaryTemp = [self.arrayPositions objectAtIndex:index];
    CGFloat originx = [[dictionaryTemp objectForKey:kImagePositionx] floatValue];
    CGFloat originy = [[dictionaryTemp objectForKey:kImagePositiony] floatValue];
    
    HGPhoto *photoTemp = [[HGPhoto alloc] initWithOrigin:CGPointMake(originx, originy)];
    photoTemp.delegate = self;
    [photoTemp setPhotoUrl:string];
    [photoTemp setEditModel:self.isEditModel];
    
    [self.arrayPhotos insertObject:photoTemp atIndex:index];
    [self addSubview:photoTemp];
    [self reloadPhotos:YES];
}

- (void)deletePhotoByIndex:(NSUInteger)index
{
    HGPhoto *photoTemp = [self.arrayPhotos objectAtIndex:index];
    [self.arrayPhotos removeObject:photoTemp];
    [photoTemp removeFromSuperview];
    [self reloadPhotos:YES];
}

#pragma mark - Photo

- (void)photoTaped:(HGPhoto*)photo
{
    NSUInteger type = [photo getPhotoType];
    if (type == PhotoTypeAdd) {
        if ([self.delegate respondsToSelector:@selector(photoWallAddAction)]) {
            [self.delegate photoWallAddAction];
        }
    } else if (type == PhotoTypePhoto) {
        NSUInteger index = [self.arrayPhotos indexOfObject:photo];
        if ([self.delegate respondsToSelector:@selector(photoWallPhotoTaped:WithPhotoWall:)]) {
            [self.delegate photoWallPhotoTaped:index WithPhotoWall:self];
        }
    }
}

- (void)photoMoveFinished:(HGPhoto*)photo
{
    CGPoint pointPhoto = CGPointMake(photo.frame.origin.x, photo.frame.origin.y);
    CGFloat space = -1;
    NSUInteger oldIndex = [self.arrayPhotos indexOfObject:photo];
    NSUInteger newIndex = -1;
    
    NSUInteger count = [self.arrayPhotos count] - 1;
    for (int i=0; i<count; i++) {
        NSDictionary *dictionaryTemp = [self.arrayPositions objectAtIndex:i];
        CGFloat originx = [[dictionaryTemp objectForKey:kImagePositionx] floatValue];
        CGFloat originy = [[dictionaryTemp objectForKey:kImagePositiony] floatValue];
        CGPoint pointTemp = CGPointMake(originx, originy);
        CGFloat spaceTemp = [self spaceToPoint:pointPhoto FromPoint:pointTemp];
        if (space < 0) {
            space = spaceTemp;
            newIndex = i;
        } else {
            if (spaceTemp < space) {
                space = spaceTemp;
                newIndex = i;
            }
        }
    }
    
    [self.arrayPhotos removeObject:photo];
    [self.arrayPhotos insertObject:photo atIndex:newIndex];
    
    [self reloadPhotos:NO];
    
    if ([self.delegate respondsToSelector:@selector(photoWallMovePhotoFromIndex:toIndex:)]) {
        [self.delegate photoWallMovePhotoFromIndex:oldIndex toIndex:newIndex];
    }
}

- (void)reloadPhotos:(BOOL)add
{
    NSUInteger count = -1;
    if (add) {
        count = [self.arrayPhotos count];
    } else {
        count = [self.arrayPhotos count] - 1;
    }
    for (int i=0; i<count; i++) {
        NSDictionary *dictionaryTemp = [self.arrayPositions objectAtIndex:i];
        CGFloat originx = [[dictionaryTemp objectForKey:kImagePositionx] floatValue];
        CGFloat originy = [[dictionaryTemp objectForKey:kImagePositiony] floatValue];
        
        HGPhoto *photoTemp = [self.arrayPhotos objectAtIndex:i];
        [photoTemp moveToPosition:CGPointMake(originx, originy)];
    }
    
    CGFloat frameHeight = -1;
    NSUInteger countPhoto = [self.arrayPhotos count];
    if (self.isEditModel) {
        if (countPhoto > 4) {
            frameHeight = kFrameHeight2x + 20.;
        } else {
            frameHeight = kFrameHeight + 20.;
        }
        self.labelDescription.frame = CGRectMake(self.labelDescription.frame.origin.x, frameHeight - 25., self.labelDescription.frame.size.width, self.labelDescription.frame.size.height);
    } else {
        if (countPhoto > 5) {
            frameHeight = kFrameHeight2x;
        } else {
            frameHeight = kFrameHeight;
        }
    }
    self.frame = CGRectMake(0., 0., 300., frameHeight);
    self.bg.frame = CGRectMake(10., 0., 300., frameHeight);
}

- (CGFloat)spaceToPoint:(CGPoint)point FromPoint:(CGPoint)otherPoint
{
    float x = point.x - otherPoint.x;
    float y = point.y - otherPoint.y;
    return sqrt(x * x + y * y);
}

@end
