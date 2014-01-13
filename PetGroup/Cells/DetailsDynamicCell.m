//
//  DetailsDynamicCell.m
//  PetGroup
//
//  Created by 阿铛 on 13-10-26.
//  Copyright (c) 2013年 Tolecen. All rights reserved.
//

#import "DetailsDynamicCell.h"
#import "EGOImageButton.h"
#import "OHAttributedLabel.h"
#import "ImageCell.h"
@interface DetailsDynamicCell ()<UICollectionViewDelegate,UICollectionViewDataSource>

{
    UIButton* nameB;
    EGOImageButton* headB;
}
@property (nonatomic,retain)UIView* backView;
@property (nonatomic,retain)UIImageView * zanImageV;
@property (nonatomic,retain)UILabel* timeL;
@property (nonatomic,retain)OHAttributedLabel* transmitMsgL;
@property (nonatomic,retain)OHAttributedLabel* msgL;
//@property (nonatomic,retain)NSArray* imageButtons;
@property (nonatomic,retain)UILabel*separatorL;
@property (nonatomic,retain)UICollectionView*imageCollectionV;
@end
@implementation DetailsDynamicCell
+(CGFloat)heightForRowWithDynamic:(Dynamic*)dynamic;
{
    CGFloat height = 60;
    if (!dynamic.ifTransmitMsg) {
        CGSize msgSize = [dynamic.msg sizeConstrainedToSize:CGSizeMake(300, 200)];
        height += msgSize.height;
        if (dynamic.smallImage.count>=1&&dynamic.smallImage.count<=3) {
            height+=103.3;
        }else if(dynamic.smallImage.count>3&&dynamic.smallImage.count<=6){
            height+=206.6;
        }else if(dynamic.smallImage.count>6){
            height+=309.9;
        }
    }else{
        CGSize size =[dynamic.transmitMsg sizeConstrainedToSize:CGSizeMake(300, 200)];
        height+=(size.height+5);
        CGSize msgSize = [dynamic.msg sizeConstrainedToSize:CGSizeMake(280, 200)];
        height+=(msgSize.height+5);
        if (dynamic.smallImage.count>=1&&dynamic.smallImage.count<=3) {
            height+=96.6;
        }else if(dynamic.smallImage.count>3&&dynamic.smallImage.count<=6){
            height+=193.2;
        }else if(dynamic.smallImage.count>6){
            height+=289.8;
        }
    }
    
    return height;
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        self.backView = [[UIView alloc]init];
        _backView.backgroundColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1];
        [self.contentView addSubview:_backView];
        
        nameB = [UIButton buttonWithType:UIButtonTypeCustom];
        [nameB setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [nameB addTarget:self action:@selector(PersonDetail) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:nameB];
        nameB.titleLabel.font = [UIFont systemFontOfSize:16];
        
        headB = [[EGOImageButton alloc]initWithPlaceholderImage:[UIImage imageNamed:@"moren_people.png"]];
        [headB addTarget:self action:@selector(PersonDetail) forControlEvents:UIControlEventTouchUpInside];
        headB.tintColor = [UIColor grayColor];
        [self.contentView addSubview:headB];
        
        UICollectionViewFlowLayout* layout = [[UICollectionViewFlowLayout alloc]init];
//        layout.itemSize = CGSizeMake(75,75);
        layout.minimumLineSpacing = 5.0;
        layout.minimumInteritemSpacing = 5.0;
        layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        self.imageCollectionV = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:layout];
        [self.contentView addSubview:_imageCollectionV];
        _imageCollectionV.backgroundColor = [UIColor clearColor];
        _imageCollectionV.delegate = self;
        _imageCollectionV.dataSource = self;
        [_imageCollectionV registerClass:[ImageCell class] forCellWithReuseIdentifier:@"cell"];
        
//        NSMutableArray* arr = [[NSMutableArray alloc]init];
//        for (int i = 0; i < 9; i++) {
//            EGOImageButton * a = [[EGOImageButton alloc]initWithPlaceholderImage:[UIImage imageNamed:@"placeholder.png"]];
//            [self.contentView addSubview:a];
//            a.tag = 1000+i;
//            [a addTarget:self action:@selector(loadBagImage:)  forControlEvents:UIControlEventTouchUpInside];
//            [arr addObject:a];
//        }
//        self.imageButtons = arr;
        
        self.timeL = [[UILabel alloc]init];
        _timeL.textColor = [UIColor grayColor];
        _timeL.font = [UIFont systemFontOfSize:12];
        [self.contentView addSubview:_timeL];
        
        self.transmitMsgL = [[OHAttributedLabel alloc]initWithFrame:CGRectZero];
        _transmitMsgL.backgroundColor = [UIColor clearColor];
        _transmitMsgL.numberOfLines = 0;
        [self.contentView addSubview:_transmitMsgL];
        
        self.msgL = [[OHAttributedLabel alloc]initWithFrame:CGRectZero];
        _msgL.backgroundColor = [UIColor clearColor];
        _msgL.numberOfLines = 0;
        [self.contentView addSubview:_msgL];
        self.separatorL = [[UILabel alloc]init];
        _separatorL.backgroundColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1];
        [self.contentView addSubview:_separatorL];
    }
    return self;
}
-(void)layoutSubviews
{
    [super layoutSubviews];
    for (UIView*a in self.contentView.subviews) {
        a.frame = CGRectZero;
    }
    headB.frame = CGRectMake(10, 10, 40, 40);
    headB.imageURL = [NSURL URLWithString:[NSString stringWithFormat:BaseImageUrl"%@",self.dynamic.userHeadImage]];
    CGSize nameSize = [self.dynamic.nickName sizeWithFont:[UIFont systemFontOfSize:16] constrainedToSize:CGSizeMake(250, 20) lineBreakMode:NSLineBreakByWordWrapping];
    nameB.frame = CGRectMake(60, 10, nameSize.width, 20);
    [nameB setTitle:self.dynamic.nickName forState:UIControlStateNormal];
    
    CGSize timeSize = [self.dynamic.submitTime sizeWithFont:[UIFont systemFontOfSize:12] constrainedToSize:CGSizeMake(250, 12) lineBreakMode:NSLineBreakByWordWrapping];
    _timeL.frame = CGRectMake(60, 30, timeSize.width, timeSize.height);
    _timeL.text = self.dynamic.submitTime;
    
    CGFloat origin = 55;
    
    if (!self.dynamic.ifTransmitMsg) {
        CGSize size = [self.dynamic.msg sizeConstrainedToSize:CGSizeMake(300, 200)];
        _msgL.frame = CGRectMake(10, origin, 300, size.height);
        _msgL.attributedText = self.dynamic.msg;
        origin = origin + size.height + 5;
        if (self.dynamic.smallImage.count>=1&&self.dynamic.smallImage.count<=3) {
            switch (self.dynamic.smallImage.count) {
                case 1:{
                    _imageCollectionV.frame = CGRectMake(10, origin, 100, 98.3);
                }break;
                case 2:{
                    _imageCollectionV.frame = CGRectMake(10, origin, 200, 98.3);
                }break;
                case 3:{
                    _imageCollectionV.frame = CGRectMake(10, origin, 300, 98.3);
                }break;
                    
                default:
                    break;
            }
            origin+=103.3;
        }else if (self.dynamic.smallImage.count == 4){
            _imageCollectionV.frame = CGRectMake(10, origin, 200, 201.6);
            origin+=206.6;
        }else if(self.dynamic.smallImage.count>4&&self.dynamic.smallImage.count<=6){
            _imageCollectionV.frame = CGRectMake(10, origin, 300, 201.6);
            origin+=206.6;
        }else if(self.dynamic.smallImage.count>6){
            _imageCollectionV.frame = CGRectMake(10, origin, 300, 304.9);
            origin+=309.9;
        }
    }else{
        CGSize transmitMsgSize = [self.dynamic.transmitMsg sizeConstrainedToSize:CGSizeMake(300, 200)];
        self.transmitMsgL.frame =CGRectMake (10, 55, 300, transmitMsgSize.height);
        _transmitMsgL.attributedText = self.dynamic.transmitMsg;
        origin = origin + transmitMsgSize.height + 5;
        CGSize size = [self.dynamic.msg sizeConstrainedToSize:CGSizeMake(280, 200)];
        _msgL.frame = CGRectMake(20, origin, 280, size.height);
        _msgL.attributedText = self.dynamic.msg;
        origin = origin + size.height + 5;
        if (self.dynamic.smallImage.count>=1&&self.dynamic.smallImage.count<=3) {
            switch (self.dynamic.smallImage.count) {
                case 1:{
                    _imageCollectionV.frame = CGRectMake(20, origin, 93.3, 91.6);
                }break;
                case 2:{
                    _imageCollectionV.frame = CGRectMake(20, origin, 188.2, 91.6);
                }break;
                case 3:{
                    _imageCollectionV.frame = CGRectMake(20, origin, 280, 91.6);
                }break;
                    
                default:
                    break;
            }
            origin+=96.6;
        }else if (self.dynamic.smallImage.count == 4){
            _imageCollectionV.frame = CGRectMake(20, origin, 188.2, 188.2);
            origin+=193.2;
        }else if(self.dynamic.smallImage.count>4&&self.dynamic.smallImage.count<=6){
            _imageCollectionV.frame = CGRectMake(20, origin, 280, 188.2);
            origin+=193.2;
        }else if(self.dynamic.smallImage.count>6){
            _imageCollectionV.frame = CGRectMake(20, origin, 280, 284.9);
            origin+=289.8;
        }
        self.backView.frame = CGRectMake(_msgL.frame.origin.x-10, _msgL.frame.origin.y-3, 300, origin-_msgL.frame.origin.y);
    }
    [_imageCollectionV reloadData];
    _separatorL.frame = CGRectMake(0, self.contentView.frame.size.height-1, 320, 1);
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)PersonDetail
{
    if (self.delegate&&[self.delegate respondsToSelector:@selector(dynamicCellPressNameButtonOrHeadButton)]) {
        [self.delegate dynamicCellPressNameButtonOrHeadButton];
    }
}
#pragma mark - collection view delegate flow layout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (!self.dynamic.ifTransmitMsg) {
        return CGSizeMake(93.3, 93.3);
    }else{
        return CGSizeMake(86.6, 86.6);
    }
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
