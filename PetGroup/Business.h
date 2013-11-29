//
//  Business.h
//  PetGroup
//
//  Created by wangxr on 13-11-25.
//  Copyright (c) 2013年 Tolecen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Business : NSObject
//列表界面使用的数据
@property(nonatomic , retain) NSString* name;//商户名称
@property(nonatomic , retain) NSString* branchName;//分店名
@property(nonatomic , retain) NSURL* sPhotoURL;//商家照片小图
@property(nonatomic , retain) NSURL* ratingSImgURL;//星级评分小图url
@property(nonatomic , retain) NSArray* regions;//商家所在区域，数组从前到后顺序依次向下分级
@property(nonatomic , retain) NSArray* categories;//商家所属分类，数组从前到后顺序分级
@property(nonatomic ,assign) int hasDeal;//是否有团购0:没有 1:有
@property(nonatomic ,assign) int hasCoupon;//是否有优惠券0:没有 1:有
@property(nonatomic ,assign) int distance;//商家距传入坐标的距离
@property(nonatomic)float avgRating;
@property(nonatomic,retain)NSString*businessUrl;//商家html5页面链接
@property(nonatomic,retain)NSString*couponUrl;//优惠券链接


////////////////////////////////////////////////////////////////////////////
//详情界面需要使用的数据
@property(nonatomic , assign) int reviewCount;//评价数量
@property(nonatomic , retain) NSString* decorationGrade;//环境评价
@property(nonatomic ,retain) NSString* productGrade;//产品／食品口味评价
@property(nonatomic ,retain) NSString* adress;//地址
@property(nonatomic ,retain) NSString* telephone;//带区号的电话
@property(nonatomic , retain) NSString* couponID;//优惠券ID
@property(nonatomic ,retain) NSString* couponDescription;//优惠券描述
@property(nonatomic , retain) NSArray* deals;//团购列表
@property(nonatomic ,retain) NSURL* photoURL;//商家大图
@property(nonatomic ,assign)double latitude;//纬度坐标
@property(nonatomic ,assign)double longitude;//经度
////////////////////////////////////////////////////////////////////////////
//用于获取其他信息的数据
//@property(nonatomic ,readonly) NSDictionary* dictionary;
@property(nonatomic , retain) NSString* businessID;//商户ID

-(id)initWithDictionary:(NSDictionary*)dic;//用dictionary来初始化该类的对象
-(void)setBusinessWithDictionary:(NSDictionary*)dic;//用于通过dictionary给属性进行负值
@end
