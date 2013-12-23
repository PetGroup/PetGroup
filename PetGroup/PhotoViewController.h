//
//  PhotoViewController.h
//  PetGroup
//
//  Created by 阿铛 on 13-9-4.
//  Copyright (c) 2013年 Tolecen. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol PhotoViewControllerDelegate <NSObject>

-(void)zanButtonActionWithPage:(int)page;
-(NSString*)titleLableTextWithPage:(int)page;

@end

@interface PhotoViewController : UIViewController
@property (nonatomic,strong)NSArray* imgIDArray;
@property (nonatomic,assign)int indext;
@property (nonatomic,assign)id<PhotoViewControllerDelegate>delegate;
- (id)initWithPath:(NSString*)path;
- (id)initWithSmallImages:(NSArray*)sImages images:(NSArray*)images indext:(int)indext;
@end
