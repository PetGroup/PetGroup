//
//  DynamicViewController.h
//  NewXMPPTest
//
//  Created by Tolecen on 13-7-3.
//  Copyright (c) 2013年 Tolecen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DynamicViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>
{
    UILabel *titleLabel;

}
@property (strong,nonatomic) UIView * headBigImageV;
@property (strong,nonatomic) UIImageView * headBigImage;
@property (strong,nonatomic) UILabel * hostNameLabel;
@property (strong,nonatomic) UIImageView * genderImageV;
@property (strong,nonatomic) UILabel * distLabel;
@property (strong,nonatomic) UIButton * loveBtn;
@property (strong,nonatomic) UILabel * loveLabel;
@property (strong,nonatomic) UILabel *headSignatureL;
@property (strong,nonatomic) UITableView * infoTableV;
@end
