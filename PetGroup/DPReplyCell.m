//
//  DPReplyCell.m
//  PetGroup
//
//  Created by wangxr on 13-11-30.
//  Copyright (c) 2013年 Tolecen. All rights reserved.
//

#import "DPReplyCell.h"
@interface DPReplyCell ()
@property (nonatomic,retain)UILabel* nameL;
@property (nonatomic,retain)UIImageView* starV;
@property (nonatomic,retain)UILabel* excerptL;
@end
@implementation DPReplyCell
+(CGFloat)heightForRowWithDynamic:(DPReply*)reply
{
    CGSize size = [reply.excerpt sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(300, 200) lineBreakMode:NSLineBreakByWordWrapping];
    return 55+size.height;
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.nameL = [[UILabel alloc]initWithFrame:CGRectMake(10, 5, 300, 20)];
        [self.contentView addSubview:_nameL];
        self.starV = [[UIImageView alloc]initWithFrame:CGRectMake(10, 30,  84,16)];
        [self.contentView addSubview:_starV];
        self.excerptL = [[UILabel alloc]init];
        _excerptL.font = [UIFont systemFontOfSize:14];
        _excerptL.numberOfLines = 0;
        [self.contentView addSubview:_excerptL];
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
    _nameL.text = self.reply.nickname;
    if (self.reply.rating==0) {
        _starV.image = [UIImage imageNamed:@"star_16_0.png"];
    }else if (self.reply.rating==1) {
        _starV.image = [UIImage imageNamed:@"star_16_1.png"];
        
    }else if (self.reply.rating==2) {
        _starV.image = [UIImage imageNamed:@"star_16_2.png"];
        
    }else if (self.reply.rating==3) {
        _starV.image = [UIImage imageNamed:@"star_16_3.png"];
        
    }else if (self.reply.rating==3.5) {
        _starV.image = [UIImage imageNamed:@"star_16_35.png"];
        
    }else if (self.reply.rating==4) {
        _starV.image = [UIImage imageNamed:@"star_16_4.png"];
        
    }else if (self.reply.rating==4.5) {
        _starV.image = [UIImage imageNamed:@"star_16_45.png"];
        
    }else {
        _starV.image = [UIImage imageNamed:@"star_16_5.png"];
    }
    CGSize size = [self.reply.excerpt sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(300, 200) lineBreakMode:NSLineBreakByWordWrapping];
    _excerptL.frame = CGRectMake(10, 50, 300, size.height);
    _excerptL.text = self.reply.excerpt;
}
@end
