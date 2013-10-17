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
        self.headPhote = [[EGOImageView alloc]initWithFrame:CGRectMake(10, 10, 50, 50)];
        _headPhote.placeholderImage = [UIImage imageNamed:@"headbg"];
        [self.contentView addSubview:_headPhote];
        
        self.nameL = [[UILabel alloc]initWithFrame:CGRectMake(10, 70, 50, 12)];
        _nameL.font = [UIFont systemFontOfSize:14];
        [self.contentView addSubview:_nameL];
        
        self.titleL = [[UILabel alloc]initWithFrame:CGRectMake(70, 10, 140, 20)];
        _titleL.numberOfLines = 0;
        _titleL.font = [UIFont systemFontOfSize:14];
        _titleL.textColor = [UIColor grayColor];
        [self.contentView addSubview:_titleL];
        
        self.timeL = [[UILabel alloc]initWithFrame:CGRectMake(70, 70, 100, 12)];
        _timeL.font = [UIFont systemFontOfSize:14];
        _timeL.textColor = [UIColor grayColor];
        [self.contentView addSubview:_timeL];
        
        UIImageView* readI = [[UIImageView alloc]initWithFrame:CGRectMake(170, 70, 16, 10)];
        readI.image = [UIImage imageNamed:@"guanzhu"];
        [self.contentView addSubview:readI];
        
        self.readL = [[UILabel alloc]initWithFrame:CGRectMake(186, 70, 70, 12)];
        _readL.font = [UIFont systemFontOfSize:14];
        _readL.textColor = [UIColor grayColor];
        [self.contentView addSubview:_readL];
        
        UIImageView* replyI = [[UIImageView alloc]initWithFrame:CGRectMake(256, 70, 16, 10)];
        replyI.image = [UIImage imageNamed:@"huifu"];
        [self.contentView addSubview:replyI];
        
        self.replyL = [[UILabel alloc]initWithFrame:CGRectMake(272, 70, 50, 12)];
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
    _nameL.text = @"阿铛";
    _titleL.text = @"超人会飞";
    _timeL.text = @"1分钟前发表";
    _readL.text = @"1351341";
    _replyL.text = @"124";
}
@end
