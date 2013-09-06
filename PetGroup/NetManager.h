//
//  NetManager.h
//  PetGroup
//
//  Created by Tolecen on 13-8-20.
//  Copyright (c) 2013年 Tolecen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NetManager : NSObject
+(void)requestWithURLStr:(NSString *)urlStr Parameters:(NSDictionary *)parameters success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
    failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;
+(void)requestWithURLStr:(NSString *)urlStr Parameters:(NSDictionary *)parameters success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success;
+(void)downloadImageWithBaseURLStr:(NSString *)url ImageId:(NSString *)imgId success:(void (^)(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image))success
    failure:(void (^)(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error))failure;
+(void)uploadImage:(UIImage *)uploadImage WithURLStr:(NSString *)urlStr ImageName:(NSString *)imageName Progress:(void (^)(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite))block Success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
           failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;
+(void)uploadImageWithCompres:(UIImage *)uploadImage WithURLStr:(NSString *)urlStr ImageName:(NSString *)imageName  Progress:(void (^)(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite))block Success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                      failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;
+(void)uploadImages:(NSArray *)imageArray WithURLStr:(NSString *)urlStr ImageName:(NSArray *)imageNameArray Progress:(void (^)(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite))block Success:(void (^)(AFHTTPRequestOperation *operation, NSDictionary * responseObject))success
            failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;
+(void)uploadImagesWithCompres:(NSArray *)imageArray WithURLStr:(NSString *)urlStr ImageName:(NSArray *)imageNameArray Progress:(void (^)(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite))block Success:(void (^)(AFHTTPRequestOperation *operation,  NSDictionary *responseObject))success
                       failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;
@end
