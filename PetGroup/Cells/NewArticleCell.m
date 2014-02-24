//
//  NewArticleCell.m
//  PetGroup
//
//  Created by wangxr on 14-2-24.
//  Copyright (c) 2014年 Tolecen. All rights reserved.
//

#import "NewArticleCell.h"
#import "EGOImageView.h"
#import "ImageCell.h"

@interface NewArticleCell ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property(nonatomic,retain)EGOImageView* headPhote;
@property(nonatomic,retain)UIImageView* replyIV;
@property(nonatomic,retain)UILabel* nameL;
@property(nonatomic,retain)UILabel* titleL;
@property(nonatomic,retain)UILabel* timeL;
@property(nonatomic,retain)UILabel* replyL;
@property(nonatomic,retain)UIImageView* goodI;
@property (nonatomic,retain)UICollectionView*imageCollectionV;

@end
@implementation NewArticleCell
+ (CGFloat)heightForRowWithArticle:(Article*)article
{
    if (article.imageArray.count<1) {
        return 80;
    }
    CGSize sz = [article.name sizeWithFont:[UIFont systemFontOfSize:16] constrainedToSize:CGSizeMake(MAXFLOAT, 20) lineBreakMode:NSLineBreakByCharWrapping];
    
    CGSize linesSz = [article.name sizeWithFont:[UIFont systemFontOfSize:16] constrainedToSize:CGSizeMake(228, MAXFLOAT) lineBreakMode:NSLineBreakByCharWrapping];
    if(sz.width > linesSz.width && linesSz.height > 20)//判断是否折行
    {
        return  170;
    }
    else
    {
        return  150;
    }
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleGray;
        // Initialization code
        self.headPhote = [[EGOImageView alloc]initWithFrame:CGRectMake(10, 10, 38, 38)];
        _headPhote.placeholderImage = [UIImage imageNamed:@"placeholderman"];
        [self.contentView addSubview:_headPhote];
        UIImageView * bgbgV = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 38, 38)];
        [bgbgV setImage:[UIImage imageNamed:@"headMask.png"]];
        [self.contentView addSubview:bgbgV];
        
        self.nameL = [[UILabel alloc]initWithFrame:CGRectMake(10, 52, 50, 20)];
        _nameL.font = [UIFont systemFontOfSize:14];
        _nameL.textColor = [UIColor grayColor];
        [self.contentView addSubview:_nameL];
        
        self.titleL = [[UILabel alloc]initWithFrame:CGRectMake(60, 10, 228, 20)];
        _titleL.numberOfLines = 0;
        _titleL.font = [UIFont systemFontOfSize:16];
        _titleL.lineBreakMode = NSLineBreakByCharWrapping;
        [self.contentView addSubview:_titleL];
        
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
        
        self.timeL = [[UILabel alloc]initWithFrame:CGRectMake(65, 52, 70, 20)];
        _timeL.font = [UIFont systemFontOfSize:14];
        _timeL.textColor = [UIColor colorWithRed:0.65 green:0.65 blue:0.65 alpha:1];
        [self.contentView addSubview:_timeL];
        
        self.replyIV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"huifu_icon"]];
        [self.contentView addSubview:_replyIV];
        self.replyL = [[UILabel alloc]initWithFrame:CGRectMake(265, 52, 40, 20)];
        _replyL.font = [UIFont systemFontOfSize:14];
        _replyL.textColor = [UIColor colorWithRed:0.65 green:0.65 blue:0.65 alpha:1];
        [self.contentView addSubview:_replyL];
        
        self.goodI = [[UIImageView alloc]init];
        _goodI.hidden = YES;
        [self.contentView addSubview:_goodI];
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)layoutSubviews
{
    [super layoutSubviews];
    _headPhote.imageURL = [NSURL URLWithString: [NSString stringWithFormat:BaseImageUrl"%@",self.article.headImage]];
    _nameL.text = self.article.userName;
    CGSize size = [self.article.name sizeWithFont:[UIFont systemFontOfSize:16] constrainedToSize:CGSizeMake(240, 50) lineBreakMode:NSLineBreakByCharWrapping];
    _titleL.frame = CGRectMake(60, 10, 240, size.height);
    _titleL.text = self.article.name;
    _timeL.text = self.article.ct;
    _replyL.text =[NSString stringWithFormat:@"%@",self.article.replyCount];
    CGPoint lastPoint;
    CGSize sz = [_titleL.text sizeWithFont:_titleL.font constrainedToSize:CGSizeMake(MAXFLOAT, 20) lineBreakMode:NSLineBreakByCharWrapping];
    
    CGSize linesSz = [_titleL.text sizeWithFont:_titleL.font constrainedToSize:CGSizeMake(_titleL.frame.size.width, MAXFLOAT) lineBreakMode:NSLineBreakByCharWrapping];
    if(sz.width > linesSz.width && linesSz.height > 20)//判断是否折行
    {
        lastPoint = CGPointMake(_titleL.frame.origin.x + (int)sz.width % (int)linesSz.width,linesSz.height - 10);
    }
    else
    {
        lastPoint = CGPointMake(_titleL.frame.origin.x + sz.width, _titleL.frame.origin.y);
    }
    if (lastPoint.y>40) {
        lastPoint = CGPointMake(280 , 30);
        if (_article.isTop || _article.isEute) {
            lastPoint = CGPointMake(250 , 30);
        }
    }
    if (_article.isEute) {
        _goodI.hidden = NO;
        _goodI.image = [UIImage imageNamed:@"jing"];
        _goodI.frame = CGRectMake(lastPoint.x, lastPoint.y, 18, 18);
    }else{
        _goodI.hidden = YES;
    }
    lastPoint = CGPointMake(lastPoint.x , lastPoint.y+30);
    if (self.article.imageArray.count > 0) {
        switch (self.article.imageArray.count) {
            case 1:{
                _imageCollectionV.frame = CGRectMake(60, lastPoint.y, 80, 80);
            }break;
            case 2:{
                _imageCollectionV.frame = CGRectMake(60, lastPoint.y, 160, 80);
            }break;
            case 3:{
                _imageCollectionV.frame = CGRectMake(60, lastPoint.y, 240, 80);
            }break;
                
            default:
                break;
        }
        lastPoint = CGPointMake(lastPoint.x , lastPoint.y+80);
    }else{
        _imageCollectionV.frame = CGRectMake(60, lastPoint.y, 0, 0);
    }
    if (lastPoint.y < 52) {
        lastPoint = CGPointMake(lastPoint.x , 52);
    }
    [_imageCollectionV reloadData];
    _timeL.frame = CGRectMake(65, lastPoint.y, 70, 20);
    _replyIV.frame = CGRectMake(250, lastPoint.y+4, 15, 13);
    _replyL.frame = CGRectMake(270, lastPoint.y, 50, 20);
}
#pragma mark - collection view delegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSMutableArray* array = [[NSMutableArray alloc]init];
    for (int i = 0;i<self.article.imageArray.count;i++) {
        NSIndexPath* indexPath = [NSIndexPath indexPathForRow:i inSection:0];
        ImageCell* cell =(ImageCell*)[collectionView cellForItemAtIndexPath:indexPath];
        [array addObject:cell.imageV.image];
    }
    if (self.delegate&&[self.delegate respondsToSelector:@selector(dynamicCellPressImageButtonWithSmallImageArray:andImageIDArray:indext:)]) {
        [self.delegate dynamicCellPressImageButtonWithSmallImageArray:array andImageIDArray:self.article.imageArray indext:indexPath.row];
    }
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.article.imageArray.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"cell";
    ImageCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    cell.imageV.imageURL = [NSURL URLWithString:[NSString stringWithFormat:BaseImageUrl"%@/75",self.article.imageArray[indexPath.row]]];
    return cell;
    
}
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
@end
