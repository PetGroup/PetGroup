//
//  NetManager.m
//  PetGroup
//
//  Created by Tolecen on 13-8-20.
//  Copyright (c) 2013年 Tolecen. All rights reserved.
//

#import "NetManager.h"
#define CompressionQuality 0.5  //图片上传时压缩质量
@implementation NetManager

//post请求，需自己设置失败提示
+(void)requestWithURLStr:(NSString *)urlStr Parameters:(NSDictionary *)parameters success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
    failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:urlStr]];
    [httpClient setParameterEncoding:AFFormURLParameterEncoding];
    [httpClient postPath:@"" parameters:parameters success:success failure:failure];
}

//post请求，通用失败提示
+(void)requestWithURLStr:(NSString *)urlStr Parameters:(NSDictionary *)parameters success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
{
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:urlStr]];
    [httpClient setParameterEncoding:AFFormURLParameterEncoding];
    [httpClient postPath:@"" parameters:parameters success:success failure:^(AFHTTPRequestOperation *operation, NSError *error){
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"网络请求异常，请确认网络连接正常" delegate:self cancelButtonTitle:@"知道了" otherButtonTitles: nil];
        [alert show];
    }];
}

//下载图片
+(void)downloadImageWithBaseURLStr:(NSString *)url ImageId:(NSString *)imgId success:(void (^)(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image))success
                           failure:(void (^)(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error))failure
{
    NSString * downLoadUrl = [NSString stringWithFormat:@"%@%@",url,imgId];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:downLoadUrl]];
    AFImageRequestOperation *operation;
    [AFImageRequestOperation addAcceptableContentTypes:[NSSet setWithObject:@"multipart/form-data"]];
    operation = [AFImageRequestOperation imageRequestOperationWithRequest:request imageProcessingBlock:nil success:success  failure:failure];
    
    [operation start];

}

//上传单张图片
+(void)uploadImage:(UIImage *)uploadImage WithURLStr:(NSString *)urlStr ImageName:(NSString *)imageName Progress:(void (^)(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite))block Success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
           failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    NSURL *url = [NSURL URLWithString:urlStr];
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:url];
    NSData *imageData = UIImageJPEGRepresentation(uploadImage, CompressionQuality);
    NSMutableURLRequest *request = [httpClient multipartFormRequestWithMethod:@"POST" path:@"" parameters:nil constructingBodyWithBlock: ^(id <AFMultipartFormData>formData) {
        [formData appendPartWithFileData:imageData name:@"file" fileName:imageName mimeType:@"image/jpeg"];
    }];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [operation setUploadProgressBlock:block];
    [operation setCompletionBlockWithSuccess:success failure:failure];
    [httpClient enqueueHTTPRequestOperation:operation];
}

//上传多张图片
+(void)uploadImages:(NSArray *)imageArray WithURLStr:(NSString *)urlStr ImageName:(NSArray *)imageNameArray Progress:(void (^)(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite))block Success:(void (^)(AFHTTPRequestOperation *operation,  NSArray *responseObject))success
           failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    NSMutableArray * reponseStrArray = [NSMutableArray array];
    for (int i = 0; i<imageArray.count; i++) {
        [NetManager uploadImage:[imageArray objectAtIndex:i] WithURLStr:BaseUploadImageUrl ImageName:[imageNameArray objectAtIndex:i] Progress:block Success:^(AFHTTPRequestOperation *operation, id responseObject) {
                NSString *response = [operation responseString];
                [reponseStrArray addObject:[response stringByAppendingFormat:@"+%@",[imageNameArray objectAtIndex:i]]];
                if (reponseStrArray.count==imageArray.count) {
                    success(operation,reponseStrArray);
            }
        } failure:failure];
    }
}
@end
