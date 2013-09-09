//
//  Photo.m
//  PhotoDemo
//
//  Created by Harry on 12-12-6.
//  Copyright (c) 2012年 Harry. All rights reserved.
//

#import "HGPhoto.h"
#import "HGPhotoWall.h"
#import <QuartzCore/QuartzCore.h>
#import "UIImageView+AFNetworking.h"

@interface HGPhoto() <UIGestureRecognizerDelegate>

@property (strong, nonatomic) UIView *viewMask;
@property (strong, nonatomic) EGOImageView *viewPhoto;

@property (strong, nonatomic) NSString *stringImageUrl;
@property (nonatomic) CGPoint pointOrigin;
@property (nonatomic) BOOL editModel;

@property (nonatomic) PhotoType type;

@end

#define kPhotoSize 62.5

@implementation HGPhoto

- (id)initWithOrigin:(CGPoint)origin
{
    self = [super initWithFrame:CGRectMake(origin.x, origin.y, kPhotoSize, kPhotoSize)];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        
        self.viewPhoto = [[EGOImageView alloc] initWithFrame:self.bounds];
//        self.viewPhoto.layer.cornerRadius = 12;
//        self.viewPhoto.layer.masksToBounds = YES;
        
        self.viewMask = [[UIView alloc] initWithFrame:self.bounds];
        self.viewMask.alpha = 0.6;
        self.viewMask.backgroundColor = [UIColor blackColor];
        self.viewMask.layer.masksToBounds = YES;
        
        
        
        UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapPress:)];
        
        [self addSubview:self.viewPhoto];
        [self addSubview:self.viewMask];
        
        delBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [delBtn setBackgroundColor:[UIColor redColor]];
        [delBtn setFrame:CGRectMake(-5, -5, 15, 15)];
        [self addSubview:delBtn];
        [delBtn addTarget:self action:@selector(delSelf) forControlEvents:UIControlEventTouchUpInside];
        delBtn.hidden = YES;
        
        [self addGestureRecognizer:tapRecognizer];
        
        self.editModel = NO;
        self.useCache = NO;
        self.viewMask.hidden = YES;
    }
    return self;
}

- (void)setPhotoType:(PhotoType)type
{
    self.type = type;
    if (type == PhotoTypeAdd) {
        self.viewPhoto.image = [UIImage imageNamed:@"addpicbtn.png"];
    }
}

- (PhotoType)getPhotoType
{
    return self.type;
}

- (void)setPhotoUrl:(NSString*)photoUrl
{
    [self.viewPhoto setImageWithURL:[NSURL URLWithString:photoUrl] placeholderImage:[UIImage imageNamed:@"cat.png"]];
}

-(void)SetPhotoUrlWithCache:(NSString *)url
{
    self.viewPhoto.placeholderImage = [UIImage imageNamed:@"cat.png"];
    NSRange range=[url rangeOfString:@"<local>"];
    if (range.location!=NSNotFound) {
//        self.viewPhoto.image =
        NSString *path = [RootDocPath stringByAppendingPathComponent:@"tempImage"];
        NSString  *openImgPath = [NSString stringWithFormat:@"%@/%@",path,[url substringFromIndex:7]];
        NSData * nsData= [NSData dataWithContentsOfFile:openImgPath];
        UIImage * openPic= [UIImage imageWithData:nsData];
        self.viewPhoto.image = openPic;
    }
    else
        self.viewPhoto.imageURL = [NSURL URLWithString:url];
}

- (void)moveToPosition:(CGPoint)point
{
    if (self.type == PhotoTypePhoto) {
        [UIView animateWithDuration:0.5 animations:^{
            self.frame = CGRectMake(point.x, point.y, self.frame.size.width, self.frame.size.height);
        } completion:nil];
    } else {
        self.frame = CGRectMake(point.x, point.y, self.frame.size.width, self.frame.size.height);
    }
}

- (void)setEditModel:(BOOL)edit
{
    if (self.type == PhotoTypePhoto) {
        if (edit) {
            UILongPressGestureRecognizer *longPressreRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress:)];
            longPressreRecognizer.delegate = self;
            [self addGestureRecognizer:longPressreRecognizer];
        } else {
            for (UIGestureRecognizer *recognizer in [self gestureRecognizers]) {
                if ([recognizer isKindOfClass:[UILongPressGestureRecognizer class]]) {
                    [self removeGestureRecognizer:recognizer];
                    break;
                }
            }
        }
    }
}

-(void)delSelf
{
    [self.delegate delPhoto:self];
    
}

#pragma mark - UIGestureRecognizer

- (void)tapPress:(id)sender
{
    if (self.wiggle) {
        delBtn.hidden = YES;
        self.moved = NO;
        [viewLayer removeAllAnimations];
        HGPhotoWall * yyy = (HGPhotoWall *)[self superview];
        yyy.labelDescription.text = @"点击“+”添加头像，最多可添加8张";
        return;
    }
    if ([self.delegate respondsToSelector:@selector(photoTaped:)]) {
        [self.delegate photoTaped:self];
    }
}

- (void)handleLongPress:(id)sender
{
    HGPhotoWall * yyy = (HGPhotoWall *)[self superview];
    yyy.labelDescription.text = @"按住并拖动可移动照片位置，松开可执行删除";
    for (UIView * it in self.superview.subviews) {
        [[it layer] removeAllAnimations];
    }
    self.wiggle = YES;
    [delBtn setHidden:NO];
    viewLayer=[self layer];
    CABasicAnimation*animation=[CABasicAnimation
                                
                                animationWithKeyPath:@"transform"];
    animation.duration=0.2;
    animation.repeatCount = MAXFLOAT;
    animation.autoreverses=YES;
    animation.fromValue=[NSValue valueWithCATransform3D:CATransform3DRotate
                         
                         (viewLayer.transform, -0.03, 0.0, 0.0, 0.03)];
    animation.toValue=[NSValue valueWithCATransform3D:CATransform3DRotate
                       
                       (viewLayer.transform, 0.03, 0.0, 0.0, 0.03)];
    [viewLayer addAnimation:animation forKey:@"wiggle"];
    
    UILongPressGestureRecognizer *recognizer = sender;
    CGPoint point = [recognizer locationInView:self];
    
    CGFloat diffx = 0.;
    CGFloat diffy = 0.;
    
    if (UIGestureRecognizerStateBegan == recognizer.state) {
        self.viewMask.hidden = NO;
        self.pointOrigin = point;
        [self.superview bringSubviewToFront:self];
    } else if (UIGestureRecognizerStateEnded == recognizer.state) {
        self.viewMask.hidden = YES;
        if ([self.delegate respondsToSelector:@selector(photoMoveFinished:)]) {
            
            [self.delegate photoMoveFinished:self];
        }
        if (self.moved) {
            [delBtn setHidden:YES];
            [viewLayer removeAllAnimations];
            self.moved = NO;
        }
        HGPhotoWall * yyy = (HGPhotoWall *)[self superview];
        yyy.labelDescription.text = @"点击“+”添加头像，最多可添加8张";
        
    } else {
        self.moved = YES;
        diffx = point.x - self.pointOrigin.x;
        diffy = point.y - self.pointOrigin.y;
    }
    
    CGFloat originx = self.frame.origin.x +diffx;
    CGFloat originy = self.frame.origin.y +diffy;
    
    self.frame = CGRectMake(originx, originy, self.frame.size.width, self.frame.size.height);

}

@end