//
//  XMLMatcher.m
//  NewXMPPTest
//
//  Created by 阿铛 on 13-8-4.
//  Copyright (c) 2013年 Tolecen. All rights reserved.
//

#import "XMLMatcher.h"
#import "GDataXMLNode.h"

@interface XMLMatcher ()

@property (nonatomic,strong)NSMutableArray* dogArray;
@property (nonatomic,strong)NSMutableArray* catArray;
@property (nonatomic,strong)NSMutableArray* otherArray;
@property (nonatomic,strong)NSMutableArray* dogTypeArray;
@property (nonatomic,strong)NSMutableArray* catTypeArray;
@property (nonatomic,strong)NSMutableArray* otherTypeArray;
@property (nonatomic,strong)NSMutableArray* typeArray;

@end

@implementation XMLMatcher
static XMLMatcher*mather;


-(id)init
{
    if (self = [super init]) {
        NSMutableArray* dogArray = [[NSMutableArray alloc]init];
        NSMutableArray* catArray = [[NSMutableArray alloc]init];
        NSMutableArray* otherArray = [[NSMutableArray alloc]init];
        NSMutableArray* dogTypeArray = [[NSMutableArray alloc]init];
        NSMutableArray* catTypeArray = [[NSMutableArray alloc]init];
        NSMutableArray* otherTypeArray = [[NSMutableArray alloc]init];
        NSMutableArray* typeArray = [[NSMutableArray alloc]initWithObjects:@"狗狗",@"猫咪",@"其他" ,nil];
        self.typeArray = typeArray;
        self.dogArray = dogArray;
        self.catArray = catArray;
        self.otherArray = otherArray;
        self.dogTypeArray = dogTypeArray;
        self.catTypeArray = catTypeArray;
        self.otherTypeArray = otherTypeArray;
        NSString *path =[[NSString alloc]initWithString:[[NSBundle mainBundle]pathForResource:@"petCategory"ofType:@"xml"]];
        NSData* data = [[NSData alloc]initWithContentsOfFile:path];
        GDataXMLDocument *doc = [[GDataXMLDocument alloc] initWithData:data  options:0 error:nil];
        GDataXMLElement* rootrootElement = [doc rootElement];
        
        GDataXMLElement* otherElement = [rootrootElement elementsForName:@"Other"][0];
        for (GDataXMLElement* a in [otherElement elementsForName:@"name"]) {
            [self.otherArray addObject:[a stringValue]];
            [self.otherTypeArray addObject:[NSNumber numberWithInt:[[[a attributeForName:@"id"]stringValue] intValue]]];
        }
        
        GDataXMLElement* dogElement = [rootrootElement elementsForName:@"Dog"][0];
        for (GDataXMLElement* a in [dogElement elementsForName:@"name"]) {
            [self.dogArray addObject:[a stringValue]];
            [self.dogTypeArray addObject:[NSNumber numberWithInt:[[[a attributeForName:@"id"]stringValue] intValue]]];
        }
        GDataXMLElement* catElement = [rootrootElement elementsForName:@"Cat"][0];
        for (GDataXMLElement* a in [catElement elementsForName:@"name"]) {
            [self.catArray addObject:[a stringValue]];
            [self.catTypeArray addObject:[NSNumber numberWithInt:[[[a attributeForName:@"id"]stringValue] intValue]]];
        }
    }
    return self;
}
+(NSArray*)allArray
{
    if ( mather == nil) {
        mather= [[XMLMatcher alloc]init];
    }
    return [[NSArray alloc]initWithObjects:mather.dogArray,mather.catArray,mather.otherArray, nil];
}
+(NSArray*)allType
{
    if ( mather == nil) {
        mather= [[XMLMatcher alloc]init];
    }
    return mather.typeArray;
}
+(NSArray*)allDogs
{
    if ( mather == nil) {
        mather= [[XMLMatcher alloc]init];
    }
    return mather.dogArray;
}
+(NSArray*)allCats
{
    if ( mather == nil) {
        mather= [[XMLMatcher alloc]init];
    }
    return mather.catArray;
}
+(NSArray*)allother
{
    if ( mather == nil) {
        mather= [[XMLMatcher alloc]init];
    }
    return mather.otherArray;
}
+(NSNumber*)typeWithString1:(NSString *)str1 andString2:(NSString*)str2
{
    if ( mather == nil) {
        mather= [[XMLMatcher alloc]init];
    }
    if ([str1 isEqualToString:@"Dog"])
    {
        for (int i = 0; i<mather.dogArray.count; i++) {
            if ([mather.dogArray[i] isEqualToString:str2]) {
                return mather.dogTypeArray[i];
            }
        }
    }
    if ([str1 isEqualToString:@"Cat"]) {
        for (int i = 0; i<mather.catArray.count; i++) {
            if ([mather.catArray[i] isEqualToString:str2]) {
                return mather.catTypeArray[i];
            }
        }
    }
    if ([str1 isEqualToString:@"Other"]) {
        for (int i = 0; i<mather.otherArray.count; i++) {
            if ([mather.otherArray[i] isEqualToString:str2]) {
                return mather.otherTypeArray[i];
            }
        }
    }


    
   
    return 0;
}
+(NSString*)typeStringWithNumber:(NSString*)number
{
    if ( mather == nil) {
        mather= [[XMLMatcher alloc]init];
    }
    switch ([number intValue]/1000) {
        case 1:{
            for (int i = 0; i<mather.dogTypeArray.count; i++) {
                if ([mather.dogTypeArray[i] intValue] ==[number intValue]) {
                    return mather.dogArray[i];
                }
            }
        }break;
        case 2:{
            for (int i = 0; i<mather.catTypeArray.count; i++) {
                if ([mather.catTypeArray[i] intValue] ==[number intValue]) {
                    return mather.catArray[i];
                }
            }
        }break;
        case 3:{
            for (int i = 0; i<mather.otherTypeArray.count; i++) {
                if ([mather.otherTypeArray[i] intValue] ==[number intValue]) {
                    return mather.otherArray[i];
                }
            }
        }break;
        default:
            break;
    }
    return @"未知";
}
@end
