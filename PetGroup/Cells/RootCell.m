//
//  RootCell.m
//  Test
//
//  Created by wangxr on 14-1-2.
//  Copyright (c) 2014年 wangxr. All rights reserved.
//

#import "RootCell.h"
#import "WithContenSubjectCell.h"
#import "WithBigImageSubjectCell.h"
#import "NormanSubjectCell.h"
#import "ArticleViewController.h"
#import "Subject.h"

@interface RootCell ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,retain)UITableView * tableView;
@property (nonatomic,retain)UIImageView * bgImageV;
@property (nonatomic,retain)UILabel * timeL;
@property (nonatomic,retain)UIImageView* blackIV;
@end
@implementation RootCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.contentView.backgroundColor =[UIColor colorWithRed:0.90 green:0.90 blue:0.90 alpha:1];

        self.bgImageV = [[UIImageView alloc]init];
        _bgImageV.image = [[UIImage imageNamed:@"root_bg"] resizableImageWithCapInsets:UIEdgeInsetsMake(8, 8, 8, 8)];
        [self.contentView addSubview:_bgImageV];
        
        self.tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.bounces = NO;
        _tableView.separatorStyle = UITableViewCellSelectionStyleNone;
        [self.contentView addSubview:_tableView];
        
        self.blackIV = [[UIImageView alloc]init];
        _blackIV.image = [[UIImage imageNamed:@"timelabelbg"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 5, 0, 5)];
        _blackIV.alpha = 0.5;
        [self.contentView addSubview:_blackIV];
        
        self.timeL = [[UILabel alloc]init];
        _timeL.textColor = [UIColor whiteColor];
        _timeL.backgroundColor = [UIColor clearColor];
        _timeL.font = [UIFont systemFontOfSize:14];
        _timeL.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:_timeL];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    int a = 0;
    if (_array.count>1) {
        a = (_array.count - 1) * 60 + 166 + 16;
    }else{
        a = _array.count*300+16;
    }
    _tableView.frame = CGRectMake(11, 48, self.contentView.frame.size.width-22, a-16);
    [_tableView reloadData];
    _bgImageV.frame = CGRectMake(10, 40, self.contentView.frame.size.width-20, a);
    
    NSString * time = ((Subject*)_array[0]).time;
    NSDateFormatter * dateF= [[NSDateFormatter alloc]init];
    dateF.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSDate *date = [dateF dateFromString:time];
    NSTimeInterval theMessageT = [date timeIntervalSince1970];
    time = [Common CurrentTime:[Common getCurrentTime] AndMessageTime:[NSString stringWithFormat:@"%f",theMessageT]];
    CGSize size = [time sizeWithFont:[UIFont systemFontOfSize:16] constrainedToSize:CGSizeMake(320, 20) lineBreakMode:NSLineBreakByWordWrapping];
    _timeL.frame = CGRectMake((320 - size.width)/2, 10, size.width, size.height);
    _blackIV.frame = CGRectMake((320 - size.width-10)/2, 10, size.width+10, size.height);
    _timeL.text = time;
}
#pragma mark - Table view data source
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.array.count > 1) {
        switch (indexPath.row) {
            case 0:{
                return 166;
            }break;
                
            default:{
                return 60;
            }break;
        }
    }
    return 300;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.array.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.array.count > 1) {
        switch (indexPath.row) {
            case 0:{
                static NSString *CellIdentifier = @"WithBigImageSubjectCell";
                WithBigImageSubjectCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                if (!cell) {
                    cell = [[WithBigImageSubjectCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                }
                cell.subject = _array[indexPath.row];
                return cell;
            }break;
                
            default:{
                static NSString *CellIdentifier = @"NormanSubjectCell";
                NormanSubjectCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                if (!cell) {
                    cell = [[NormanSubjectCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                }
                cell.subject = _array[indexPath.row];
                return cell;
            }break;
        }
    }
    static NSString *CellIdentifier = @"WithContenSubjectCell";
    WithContenSubjectCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[WithContenSubjectCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    cell.subject = _array[indexPath.row];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    ArticleViewController* artVC = [[ArticleViewController alloc]init];
    artVC.articleID = ((Subject*)self.array[indexPath.row]).articleID;
    [self.viewC.navigationController pushViewController:artVC animated:YES];
}
+(CGFloat)heightForRowWithArrayCount:(NSUInteger)arrayCount
{
    if (arrayCount>1) {
        return (arrayCount - 1) * 60 + 166 + 56;
    }
    return arrayCount*300+56;
}
@end
