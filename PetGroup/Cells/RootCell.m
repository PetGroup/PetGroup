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
    _tableView.frame = CGRectMake(11, 18, self.contentView.frame.size.width-22, self.contentView.frame.size.height-36);
    [_tableView reloadData];
    _bgImageV.frame = CGRectMake(10, 10, self.contentView.frame.size.width-20, self.contentView.frame.size.height-20);

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
        return (arrayCount - 1) * 60 + 166 + 36;
    }
    return arrayCount*300+36;
}
@end
