//
//  DynamicCell.m
//  PetGroup
//
//  Created by 阿铛 on 13-8-22.
//  Copyright (c) 2013年 Tolecen. All rights reserved.
//

#import "DynamicCell.h"
#import "EGOImageButton.h"
#import "OHAttributedLabel.h"
#import "ImageCell.h"

@interface DynamicCell ()<UICollectionViewDelegate,UICollectionViewDataSource,OHAttributedLabelDelegate>

{
    UIButton* nameB;
    EGOImageButton* headB;
    UIButton* zanB;
    UIButton* zhuanfaB;
}
@property (nonatomic,retain)UIView* backView;
//@property (nonatomic,retain)UIImageView * zanImageV;
@property (nonatomic,retain)UILabel* timeL;
@property (nonatomic,retain)OHAttributedLabel* transmitMsgL;
@property (nonatomic,retain)OHAttributedLabel* msgL;
//@property (nonatomic,retain)NSArray* imageButtons;
@property (nonatomic,retain)UIImageView* bottomIV;
@property (nonatomic,retain)UICollectionView*imageCollectionV;
@end
@implementation DynamicCell
+(CGFloat)heightForRowWithDynamic:(Dynamic*)dynamic
{
    CGFloat height = 60;
    if (!dynamic.ifTransmitMsg) {
        CGSize msgSize = [dynamic.msg sizeConstrainedToSize:CGSizeMake(250, 100)];
        height += (msgSize.height+10);
        if (dynamic.smallImage.count>=1&&dynamic.smallImage.count<=3) {
            height+=85;
        }else if(dynamic.smallImage.count>3&&dynamic.smallImage.count<=6){
            height+=165;
        }else if(dynamic.smallImage.count>6){
            height+=245;
        }
    }else{
        CGSize size =[dynamic.transmitMsg sizeConstrainedToSize:CGSizeMake(250, 100)];
        height+=(size.height+5);
        CGSize msgSize = [dynamic.msg sizeConstrainedToSize:CGSizeMake(250, 100)];
        height+=(msgSize.height+10);
        if (dynamic.smallImage.count>=1&&dynamic.smallImage.count<=3) {
            height+=80;
        }else if(dynamic.smallImage.count>3&&dynamic.smallImage.count<=6){
            height+=160;
        }else if(dynamic.smallImage.count>6){
            height+=240;
        }
    }
    

    return height+=33.5;
    return 300;
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.contentView.backgroundColor = [UIColor whiteColor];
        self.backView = [[UIView alloc]init];
        _backView.backgroundColor = [UIColor colorWithRed:0.95 green:0.95 blue:0.95 alpha:1];
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
        layout.itemSize = CGSizeMake(75,75);
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
        
        self.timeL = [[UILabel alloc]init];
        _timeL.textColor = [UIColor grayColor];
        _timeL.font = [UIFont systemFontOfSize:12];
        [self.contentView addSubview:_timeL];
        
        self.transmitMsgL = [[OHAttributedLabel alloc]initWithFrame:CGRectZero];
        _transmitMsgL.backgroundColor = [UIColor clearColor];
        _transmitMsgL.numberOfLines = 0;
        _transmitMsgL.delegate = self;
        [self.contentView addSubview:_transmitMsgL];
        
        self.msgL = [[OHAttributedLabel alloc]initWithFrame:CGRectZero];
        _msgL.backgroundColor = [UIColor clearColor];
        _msgL.numberOfLines = 0;
        _msgL.delegate = self;
        [self.contentView addSubview:_msgL];
        
        self.bottomIV = [[UIImageView alloc]init];
        _bottomIV.userInteractionEnabled = YES;
        [self.contentView addSubview:_bottomIV];
        zanB = [UIButton buttonWithType:UIButtonTypeCustom];
        zanB.frame = CGRectMake(1, 0, 106, 35);
        zanB.titleLabel.font = [UIFont systemFontOfSize:12];
        [zanB setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [zanB addTarget:self action:@selector(zanAction) forControlEvents:UIControlEventTouchUpInside];
        [zanB setBackgroundImage:[UIImage imageNamed:@"zanB"] forState:UIControlStateNormal];
        [_bottomIV addSubview:zanB];
        self.replyB = [UIButton buttonWithType:UIButtonTypeCustom];
        _replyB.frame = CGRectMake(108, 0, 106, 35);
        _replyB.titleLabel.font = [UIFont systemFontOfSize:12];
        [_replyB setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_replyB addTarget:self action:@selector(replyAction) forControlEvents:UIControlEventTouchUpInside];
        [_replyB setBackgroundImage:[UIImage imageNamed:@"replyB"] forState:UIControlStateNormal];
        [_bottomIV addSubview:_replyB];
        zhuanfaB = [UIButton buttonWithType:UIButtonTypeCustom];
        zhuanfaB.frame = CGRectMake(215, 0, 106, 35);
        zhuanfaB.titleLabel.font = [UIFont systemFontOfSize:12];
        [zhuanfaB setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [zhuanfaB setTitle:@"       转发" forState:UIControlStateNormal];
        [zhuanfaB addTarget:self action:@selector(zhuanfaAction) forControlEvents:UIControlEventTouchUpInside];
        [zhuanfaB setBackgroundImage:[UIImage imageNamed:@"zhuanfaB"] forState:UIControlStateNormal];
        [_bottomIV addSubview:zhuanfaB];
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
    _timeL.frame = CGRectMake(60, 40, timeSize.width, timeSize.height);
    _timeL.text = self.dynamic.submitTime;
    CGFloat origin = 60;
    
    if (!self.dynamic.ifTransmitMsg) {
        CGSize size = [self.dynamic.msg sizeConstrainedToSize:CGSizeMake(250, 100)];
        _msgL.frame = CGRectMake(60, origin, 250, size.height);
        _msgL.attributedText = self.dynamic.msg;
        origin = origin + size.height + 10;
        if (self.dynamic.smallImage.count>=1&&self.dynamic.smallImage.count<=3) {
            switch (self.dynamic.smallImage.count) {
                case 1:{
                    _imageCollectionV.frame = CGRectMake(60, origin, 80, 80);
                }break;
                case 2:{
                    _imageCollectionV.frame = CGRectMake(60, origin, 160, 80);
                }break;
                case 3:{
                    _imageCollectionV.frame = CGRectMake(60, origin, 240, 80);
                }break;

                default:
                    break;
            }
            origin+=85;
        }else if(self.dynamic.smallImage.count == 4){
            _imageCollectionV.frame = CGRectMake(60, origin, 160, 160);
            origin+=165;
        }else if(self.dynamic.smallImage.count>4&&self.dynamic.smallImage.count<=6){
            _imageCollectionV.frame = CGRectMake(60, origin, 240, 160);
            origin+=165;
        }else if(self.dynamic.smallImage.count>6){
            _imageCollectionV.frame = CGRectMake(60, origin, 240, 240);
            origin+=245;
        }
    }else{
        CGSize transmitMsgSize = [self.dynamic.transmitMsg sizeConstrainedToSize:CGSizeMake(250, 100)];
        self.transmitMsgL.frame =CGRectMake (60, origin, 250, transmitMsgSize.height);
         _transmitMsgL.attributedText = self.dynamic.transmitMsg;
        origin = origin + transmitMsgSize.height +5;
        CGSize size = [self.dynamic.msg sizeConstrainedToSize:CGSizeMake(250, 100)];
        _msgL.frame = CGRectMake(60, origin, 250, size.height);
        _msgL.attributedText = self.dynamic.msg;
        origin = origin + size.height + 10;
        if (self.dynamic.smallImage.count>=1&&self.dynamic.smallImage.count<=3) {
            switch (self.dynamic.smallImage.count) {
                case 1:{
                    _imageCollectionV.frame = CGRectMake(60, origin, 80, 80);
                }break;
                case 2:{
                    _imageCollectionV.frame = CGRectMake(60, origin, 160, 80);
                }break;
                case 3:{
                    _imageCollectionV.frame = CGRectMake(60, origin, 240, 80);
                }break;
                    
                default:
                    break;
            }
            origin+=85;
        }else if(self.dynamic.smallImage.count == 4){
            _imageCollectionV.frame = CGRectMake(60, origin, 160, 160);
            origin+=165;
        }else if(self.dynamic.smallImage.count>4&&self.dynamic.smallImage.count<=6){
            _imageCollectionV.frame = CGRectMake(60, origin, 240, 160);
            origin+=165;
        }else if(self.dynamic.smallImage.count>6){
            _imageCollectionV.frame = CGRectMake(60, origin, 240, 240);
            origin+=245;
        }
        self.backView.frame = CGRectMake(_msgL.frame.origin.x-10, _msgL.frame.origin.y-5, 255, origin-_msgL.frame.origin.y);
    }
    [_imageCollectionV reloadData];
    if (self.dynamic.countZan>0) {
        [zanB setTitle:[NSString stringWithFormat:@"       %d",self.dynamic.countZan] forState:UIControlStateNormal];
    }else{
        [zanB setTitle:@"       赞" forState:UIControlStateNormal];
    }
    
    _bottomIV.frame = CGRectMake(0, origin, 320, 35);
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
#pragma mark - button action
-(void)PersonDetail
{
    if (self.delegate&&[self.delegate respondsToSelector:@selector(dynamicCellPressNameButtonOrHeadButtonAtIndexPath:)]) {
        [self.delegate dynamicCellPressNameButtonOrHeadButtonAtIndexPath:self.indexPath];
    }
}
-(void)zanAction
{
    if (self.delegate&&[self.delegate respondsToSelector:@selector(dynamicCellPressZanButtonAtIndexPath:)]) {
        [self.delegate dynamicCellPressZanButtonAtIndexPath:self.indexPath];
    }
}
-(void)replyAction
{
    if (self.delegate&&[self.delegate respondsToSelector:@selector(dynamicCellPressReplyButtonAtIndexPath:)]) {
        [self.delegate dynamicCellPressReplyButtonAtIndexPath:self.indexPath];
    }
}
-(void)zhuanfaAction
{
    if (self.delegate&&[self.delegate respondsToSelector:@selector(dynamicCellPressZhuangFaButtonAtIndexPath:)]) {
        [self.delegate dynamicCellPressZhuangFaButtonAtIndexPath:self.indexPath];
    }
}
#pragma mark - OHAttributedLabelDelegate
-(BOOL)attributedLabel:(OHAttributedLabel*)attributedLabel shouldFollowLink:(NSTextCheckingResult*)linkInfo
{
    if (self.delegate&&[_delegate respondsToSelector:@selector(dynamicCellPressURL:)]) {
        [_delegate dynamicCellPressURL:linkInfo.extendedURL];
    }
    return NO;
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
