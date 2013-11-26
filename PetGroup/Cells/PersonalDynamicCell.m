//
//  PersonalDynamicCell.m
//  PetGroup
//
//  Created by 阿铛 on 13-9-11.
//  Copyright (c) 2013年 Tolecen. All rights reserved.
//

#import "PersonalDynamicCell.h"
#import "EGOImageButton.h"
#import "OHAttributedLabel.h"
#import "ImageCell.h"
@interface PersonalDynamicCell ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic,retain)UIView* backView;
@property (nonatomic,retain)UILabel* timeL;
@property (nonatomic,retain)OHAttributedLabel* transmitMsgL;
@property (nonatomic,retain)OHAttributedLabel* msgL;
//@property (nonatomic,retain)NSArray* imageButtons;
@property (nonatomic,retain)UICollectionView*imageCollectionV;
@end

@implementation PersonalDynamicCell
+(CGFloat)heightForRowWithDynamic:(Dynamic*)dynamic;
{
    CGFloat height = 10;
    if (!dynamic.ifTransmitMsg) {
        CGSize msgSize = [dynamic.msg sizeConstrainedToSize:CGSizeMake(210, 100)];
        height += (msgSize.height+10);
    }else{
        CGSize size =[dynamic.transmitMsg sizeConstrainedToSize:CGSizeMake(210, 100)];
        height+=(size.height+5);
        CGSize msgSize = [dynamic.msg sizeConstrainedToSize:CGSizeMake(210, 100)];
        height+=(msgSize.height+10);
    }
    if (dynamic.smallImage.count>=1&&dynamic.smallImage.count<=3) {
        height+=75;
    }else if(dynamic.smallImage.count>3&&dynamic.smallImage.count<=6){
        height+=145;
    }else if(dynamic.smallImage.count>6){
        height+=215;
    }
    return height>60?height:60;
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.contentView.backgroundColor = [UIColor whiteColor];
        self.backView = [[UIView alloc]init];
        _backView.backgroundColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1];
        [self.contentView addSubview:_backView];
        
        UICollectionViewFlowLayout* layout = [[UICollectionViewFlowLayout alloc]init];
        layout.itemSize = CGSizeMake(65,65);
        layout.minimumLineSpacing = 5.0;
        layout.minimumInteritemSpacing = 0.0;
        layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        self.imageCollectionV = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:layout];
        [self.contentView addSubview:_imageCollectionV];
        _imageCollectionV.backgroundColor = [UIColor clearColor];
        _imageCollectionV.delegate = self;
        _imageCollectionV.dataSource = self;
        [_imageCollectionV registerClass:[ImageCell class] forCellWithReuseIdentifier:@"cell"];
        
        self.timeL = [[UILabel alloc]init];
        _timeL.backgroundColor = [UIColor clearColor];
        _timeL.textColor = [UIColor blackColor];
        _timeL.textAlignment = NSTextAlignmentCenter;
        _timeL.adjustsFontSizeToFitWidth = YES;
        _timeL.minimumScaleFactor = 0.0;
        [self.contentView addSubview:_timeL];
        
        self.transmitMsgL = [[OHAttributedLabel alloc]initWithFrame:CGRectZero];
        _transmitMsgL.backgroundColor = [UIColor clearColor];
        _transmitMsgL.numberOfLines = 0;
        [self.contentView addSubview:_transmitMsgL];
        
        self.msgL = [[OHAttributedLabel alloc]initWithFrame:CGRectZero];
        _msgL.backgroundColor = [UIColor clearColor];
        _msgL.numberOfLines = 0;
        [self.contentView addSubview:_msgL];
       
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}
-(void)layoutSubviews
{
    [super layoutSubviews];
    for (UIView*a in self.contentView.subviews) {
        a.frame = CGRectZero;
    }
    
    _timeL.frame = CGRectMake((self.contentView.frame.size.width-300)/2, 10, 80, 40);
    _timeL.text = self.dynamic.listTime;
    CGFloat origin = 10;
    
    if (!self.dynamic.ifTransmitMsg) {
        CGSize size = [self.dynamic.msg sizeConstrainedToSize:CGSizeMake(210, 100)];
        _msgL.frame = CGRectMake(self.contentView.frame.size.width-220, origin, 210, size.height);
        _msgL.attributedText = self.dynamic.msg;
        origin = origin + size.height + 10;
        if (self.dynamic.smallImage.count>=1&&self.dynamic.smallImage.count<=3) {
            _imageCollectionV.frame = CGRectMake(100, origin, 200, 70);
            origin+=75;
        }else if(self.dynamic.smallImage.count>3&&self.dynamic.smallImage.count<=6){
            _imageCollectionV.frame = CGRectMake(100, origin, 200, 140);
            origin+=145;
        }else if(self.dynamic.smallImage.count>6){
            _imageCollectionV.frame = CGRectMake(100, origin, 200, 210);
            origin+=215;
        }
    }else{
        CGSize transmitMsgSize = [self.dynamic.transmitMsg sizeConstrainedToSize:CGSizeMake(210, 100)];
        self.transmitMsgL.frame =CGRectMake (self.contentView.frame.size.width-220, origin, 210, transmitMsgSize.height);
        _transmitMsgL.attributedText = self.dynamic.transmitMsg;
        origin = origin + transmitMsgSize.height +5;
        CGSize size = [self.dynamic.msg sizeConstrainedToSize:CGSizeMake(210, 100)];
        _msgL.frame = CGRectMake(self.contentView.frame.size.width-220, origin, 210, size.height);
        _msgL.attributedText = self.dynamic.msg;
        origin = origin + size.height + 10;
        if (self.dynamic.smallImage.count>=1&&self.dynamic.smallImage.count<=3) {
            _imageCollectionV.frame = CGRectMake(self.contentView.frame.size.width-220, origin, 200, 70);
            origin+=75;
        }else if(self.dynamic.smallImage.count>3&&self.dynamic.smallImage.count<=6){
            _imageCollectionV.frame = CGRectMake(self.contentView.frame.size.width-220, origin, 200, 140);
            origin+=145;
        }else if(self.dynamic.smallImage.count>6){
            _imageCollectionV.frame = CGRectMake(self.contentView.frame.size.width-220, origin, 200, 210);
            origin+=215;
        }
        self.backView.frame = CGRectMake(_msgL.frame.origin.x-10, _msgL.frame.origin.y-5, 220, origin-_msgL.frame.origin.y);
    }
    [_imageCollectionV reloadData];
}
#pragma mark - collection view delegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSMutableArray* array = [[NSMutableArray alloc]init];
    for (int i = 0;i<self.dynamic.smallImage.count;i++) {
        NSIndexPath* indexPath = [NSIndexPath indexPathForRow:i inSection:0];
        ImageCell* cell =(ImageCell*)[collectionView cellForItemAtIndexPath:indexPath];
        [array addObject:cell.imageV.image];
    }
    if (self.delegate&&[self.delegate respondsToSelector:@selector(dynamicCellPressImageButtonWithSmallImageArray:andImageIDArray:indext:)]) {
        [self.delegate dynamicCellPressImageButtonWithSmallImageArray:array andImageIDArray:self.dynamic.imgIDArray indext:indexPath.row];
    }
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dynamic.smallImage.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"cell";
    ImageCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    cell.imageV.imageURL = [NSURL URLWithString:[NSString stringWithFormat:BaseImageUrl"%@",self.dynamic.smallImage[indexPath.row]]];
    return cell;
    
}
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

@end
