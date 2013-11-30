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
        self.headPhote = [[EGOImageView alloc]initWithFrame:CGRectMake(10, 10, 45, 45)];
        _headPhote.placeholderImage = [UIImage imageNamed:@"headbg"];
        [self.contentView addSubview:_headPhote];
        
        self.nameL = [[UILabel alloc]initWithFrame:CGRectMake(10, 60, 50, 20)];
        _nameL.font = [UIFont systemFontOfSize:14];
        _nameL.textColor = [UIColor grayColor];
        [self.contentView addSubview:_nameL];
        
        self.titleL = [[UILabel alloc]initWithFrame:CGRectMake(65, 10, 228, 20)];
        _titleL.numberOfLines = 0;
        _titleL.font = [UIFont systemFontOfSize:16];
//        _titleL.textColor = [UIColor grayColor];
        [self.contentView addSubview:_titleL];
        
        self.timeL = [[UILabel alloc]initWithFrame:CGRectMake(65, 60, 100, 20)];
        _timeL.font = [UIFont systemFontOfSize:14];
        _timeL.textColor = [UIColor grayColor];
        [self.contentView addSubview:_timeL];
        
        UIImageView* readI = [[UIImageView alloc]initWithFrame:CGRectMake(170, 65, 16, 10)];
        readI.image = [UIImage imageNamed:@"guanzhu"];
        [self.contentView addSubview:readI];
        
        self.readL = [[UILabel alloc]initWithFrame:CGRectMake(189, 60, 70, 20)];
        _readL.font = [UIFont systemFontOfSize:14];
        _readL.textColor = [UIColor grayColor];
        [self.contentView addSubview:_readL];
        
        UIImageView* replyI = [[UIImageView alloc]initWithFrame:CGRectMake(256, 65, 16, 10)];
        replyI.image = [UIImage imageNamed:@"huifu"];
        [self.contentView addSubview:replyI];
        
        self.replyL = [[UILabel alloc]initWithFrame:CGRectMake(275, 60, 50, 20)];
        _replyL.font = [UIFont systemFontOfSize:14];
        _replyL.textColor = [UIColor grayColor];
        [self.contentView addSubview:_replyL];
        
        self.goodI = [[UIImageView alloc]initWithFrame:CGRectMake(298, 0, 22, 22)];
        _goodI.image = [UIImage imageNamed:@"jinghua"];
        _goodI.hidden = YES;
        [self.contentView addSubview:_goodI];
        
        self.topI = [[UIImageView alloc]initWithFrame:CGRectMake(298, 0, 22, 22)];
        _topI.image = [UIImage imageNamed:@"zhiding"];
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
    CGSize size = [self.article.name sizeWithFont:[UIFont systemFontOfSize:16] constrainedToSize:CGSizeMake(228, 50) lineBreakMode:NSLineBreakByWordWrapping];
    _titleL.frame = CGRectMake(65, 10, 228, size.height);
    _titleL.text = self.article.name;
    _timeL.text = self.article.ct;
    _readL.text = self.article.clientCount;
    _replyL.text = self.article.replyCount;
    if (_article.isTop) {
        _topI.hidden = NO;
    }else{
        _topI.hidden = YES;
    }
    if (_article.isEute) {
        _goodI.hidden = NO;
    }else{
        _goodI.hidden = YES;
    }
    
}
@end
