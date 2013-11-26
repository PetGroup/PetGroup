//
//  Business.m
//  PetGroup
//
//  Created by wangxr on 13-11-25.
//  Copyright (c) 2013年 Tolecen. All rights reserved.
//
static char* grades[5]={"一般","尚可","好","很好","非常好"};
#import "Business.h"

@implementation Business
-(id)initWithDictionary:(NSDictionary*)dic
{
    if (self = [super init]) {
        [self setBusinessWithDictionary:dic];
    }
    return self;
}
-(void)setBusinessWithDictionary:(NSDictionary*)dic
{

    self.name = [dic objectForKey:@"name"];
    self.branchName = [dic objectForKey:@"branch_name"];
    self.ratingSImgURL = [NSURL URLWithString:[dic objectForKey:@"rating_s_img_url"]];
    self.categories = [dic objectForKey:@"categories"];
    self.regions = [dic objectForKey:@"regions"] ;
    self.hasDeal = [[dic objectForKey:@"has_deal"] intValue];
    self.hasCoupon = [[dic objectForKey:@"has_coupon"] intValue];
    self.distance = [[dic objectForKey:@"distance"] intValue];
    self.reviewCount = [[dic objectForKey:@"review_count"] intValue];
    int index = [[dic objectForKey:@"decoration_grade"] intValue];
    
    self.decorationGrade = [NSString stringWithCString:grades[index] encoding:NSUTF8StringEncoding];
    index = [[dic objectForKey:@"product_grade"] intValue];
    self.productGrade = [NSString stringWithCString:grades[index] encoding:NSUTF8StringEncoding];
    self.adress = [dic objectForKey:@"address"];
    self.telephone = [dic objectForKey:@"telephone"];
    self.couponID = [dic objectForKey:@"coupon_id"];
    self.couponDescription = [dic objectForKey:@"coupon_description"];
    self.deals = [dic objectForKey:@"deals"];
    self.sPhotoURL = [NSURL URLWithString:[dic objectForKey:@"s_photo_url"] ] ;
    self.photoURL = [NSURL URLWithString:[dic objectForKey:@"photo_url"]];
    self.avgRating = [[dic objectForKey:@"avg_rating"]floatValue];
    self.businessUrl=[dic objectForKey:@"business_url"];
    self.couponUrl=[dic objectForKey:@"coupon_url"];
    self.latitude = [[dic objectForKey:@"latitude"]doubleValue];
    self.longitude = [[dic objectForKey:@"longitude"]doubleValue];
    self.businessID = [[dic objectForKey:@"business_id"] intValue];
    
}
@end
