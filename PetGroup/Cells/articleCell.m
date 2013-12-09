//
//  articleCell.m
//  PetGroup
//
//  Created by 阿铛 on 13-10-12.
//  Copyright (c) 2013年 Tolecen. All rights reserved.
//

#import "articleCell.h"
#import "EGOImageView.h"
@interface articleCell ()

@property(nonatomic,retain)EGOImageView* headPhote;
@property(nonatomic,retain)UILabel* nameL;
@property(nonatomic,retain)UILabel* titleL;
@property(nonatomic,retain)UILabel* timeL;
@property(nonatomic,retain)UILabel* readL;
@property(nonatomic,retain)UILabel* replyL;
@property(nonatomic,retain)UIImageView* goodI;
@property(nonatomic,retain)UIImageView* topI;

@end
@implementation articleCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleGray;
        // Initialization code
        self.headPhote = [[EGOImageView alloc]initWithFrame:CGRectMake(10, 10, 38, 38)];
        _headPhote.placeholderImage = [UIImage imageNamed:@"headbg"];
        [self.contentView addSubview:_headPhote];
        self.headPhote.layer.cornerRadius = 5;
        self.headPhote.layer.masksToBounds=YES;
        
        self.nameL = [[UILabel alloc]initWithFrame:CGRectMake(10, 52, 50, 20)];
        _nameL.font = [UIFont systemFontOfSize:14];
        _nameL.textColor = [UIColor grayColor];
        [self.contentView addSubview:_nameL];
        
        self.titleL = [[UILabel alloc]initWithFrame:CGRectMake(60, 10, 228, 20)];
        _titleL.numberOfLines = 0;
        _titleL.font = [UIFont systemFontOfSize:16];
        _titleL.lineBreakMode = NSLineBreakByCharWrapping;
//        _titleL.backgroundColor = [UIColor grayColor];
        [self.contentView addSubview:_titleL];
        
        self.timeL = [[UILabel alloc]initWithFrame:CGRectMake(65, 52, 70, 20)];
        _timeL.font = [UIFont systemFontOfSize:14];
        _timeL.textColor = [UIColor colorWithRed:0.65 green:0.65 blue:0.65 alpha:1];
        [self.contentView addSubview:_timeL];
        
//        UIImageView* readI = [[UIImageView alloc]initWithFrame:CGRectMake(170, 57, 16, 10)];
//        readI.image = [UIImage imageNamed:@"guanzhu"];
//        [self.contentView addSubview:readI];
        
        self.readL = [[UILabel alloc]initWithFrame:CGRectMake(135, 52, 80, 20)];
        _readL.font = [UIFont systemFontOfSize:14];
        _readL.textColor = [UIColor colorWithRed:0.65 green:0.65 blue:0.65 alpha:1];
//        [_readL setBackgroundColor:[UIColor blueColor]];
        [self.contentView addSubview:_readL];
        
//        UIImageView* replyI = [[UIImageView alloc]initWithFrame:CGRectMake(256, 57, 16, 10)];
//        replyI.image = [UIImage imageNamed:@"huifu"];
//        [self.contentView addSubview:replyI];
        
        self.replyL = [[UILabel alloc]initWithFrame:CGRectMake(225, 52, 80, 20)];
        _replyL.font = [UIFont systemFontOfSize:14];
//        _replyL.backgroundColor = [UIColor redColor];
        [_replyL setTextAlignment:NSTextAlignmentRight];
        _replyL.textColor = [UIColor colorWithRed:0.65 green:0.65 blue:0.65 alpha:1];
        [self.contentView addSubview:_replyL];
        
        self.goodI = [[UIImageView alloc]init];
        _goodI.hidden = YES;
        [self.contentView addSubview:_goodI];
        
        self.topI = [[UIImageView alloc]init];
        _topI.hidden = YES;
        [self.contentView addSubview:_topI];
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
    _headPhote.imageURL = [NSURL URLWithString: [NSString stringWithFormat:BaseImageUrl"%@",self.article.headImage]];
    _nameL.text = self.article.userName;
    CGSize size = [self.article.name sizeWithFont:[UIFont systemFontOfSize:16] constrainedToSize:CGSizeMake(240, 50) lineBreakMode:NSLineBreakByCharWrapping];
    _titleL.frame = CGRectMake(60, 10, 240, size.height);
    _titleL.text = self.article.name;
//    _titleL.lineBreakMode = NSLineBreakByCharWrapping;
    _timeL.text = self.article.ct;
    _readL.text = self.article.circleName;
    _replyL.text =[NSString stringWithFormat:@"%@/%@",self.article.replyCount,self.article.clientCount];
    CGPoint lastPoint;
    CGSize sz = [_titleL.text sizeWithFont:_titleL.font constrainedToSize:CGSizeMake(MAXFLOAT, 20) lineBreakMode:NSLineBreakByCharWrapping];
    
    CGSize linesSz = [_titleL.text sizeWithFont:_titleL.font constrainedToSize:CGSizeMake(_titleL.frame.size.width, MAXFLOAT) lineBreakMode:NSLineBreakByCharWrapping];
    if(sz.width <= linesSz.width) //判断是否折行
    {
        lastPoint = CGPointMake(_titleL.frame.origin.x + sz.width, _titleL.frame.origin.y);
    }
    else
    {
        lastPoint = CGPointMake(_titleL.frame.origin.x + (int)sz.width % (int)linesSz.width,linesSz.height - 10);
    }
    if (_article.haveImage) {
        _topI.hidden = NO;
        _topI.image = [UIImage imageNamed:@"havepic"];
        if (lastPoint.x > 280) {
            lastPoint = CGPointMake(60, lastPoint.y + 20);
        }
        _topI.frame = CGRectMake(lastPoint.x, lastPoint.y-2, 22, 22);
        lastPoint = CGPointMake(lastPoint.x + 22, lastPoint.y);
        if (lastPoint.x > 300) {
            lastPoint = CGPointMake(60, lastPoint.y + 22);
        }
    }else{
        _topI.hidden = YES;
    }
    if (_article.isTop) {
        _goodI.hidden = NO;
        _goodI.image = [UIImage imageNamed:@"ding"];
        _goodI.frame = CGRectMake(lastPoint.x, lastPoint.y, 18, 18);
    }else if (_article.isEute) {
        _goodI.hidden = NO;
        _goodI.image = [UIImage imageNamed:@"jing"];
        _goodI.frame = CGRectMake(lastPoint.x, lastPoint.y, 18, 18);
    }else{
        _goodI.hidden = YES;
    }
    
}
@end
