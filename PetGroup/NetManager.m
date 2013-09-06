//
//  NetManager.m
//  PetGroup
//
//  Created by Tolecen on 13-8-20.
//  Copyright (c) 2013年 Tolecen. All rights reserved.
//

#import "NetManager.h"
#define CompressionQuality 1  //图片上传时压缩质量
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
        NSLog(@"%@",error);
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

//上传单张图片,压缩
+(void)uploadImageWithCompres:(UIImage *)uploadImage WithURLStr:(NSString *)urlStr ImageName:(NSString *)imageName  Progress:(void (^)(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite))block Success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
           failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    NSURL *url = [NSURL URLWithString:urlStr];
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:url];
    UIImage* a = [NetManager compressImageDownToPhoneScreenSize:uploadImage targetSizeX:100 targetSizeY:100];
    UIImage* upImage = [NetManager image:a centerInSize:CGSizeMake(100, 100)];
    NSData *imageData = UIImageJPEGRepresentation(upImage, CompressionQuality);
    NSMutableURLRequest *request = [httpClient multipartFormRequestWithMethod:@"POST" path:@"" parameters:nil constructingBodyWithBlock: ^(id <AFMultipartFormData>formData) {
        [formData appendPartWithFileData:imageData name:@"file" fileName:imageName mimeType:@"image/jpeg"];
    }];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [operation setUploadProgressBlock:block];
    [operation setCompletionBlockWithSuccess:success failure:failure];
    [httpClient enqueueHTTPRequestOperation:operation];
}
//上传单张图片,不压缩
+(void)uploadImage:(UIImage *)uploadImage WithURLStr:(NSString *)urlStr ImageName:(NSString *)imageName  Progress:(void (^)(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite))block Success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                      failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    NSURL *url = [NSURL URLWithString:urlStr];
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:url];
    NSData *imageData = UIImageJPEGRepresentation(uploadImage, 1);
    NSMutableURLRequest *request = [httpClient multipartFormRequestWithMethod:@"POST" path:@"" parameters:nil constructingBodyWithBlock: ^(id <AFMultipartFormData>formData) {
        [formData appendPartWithFileData:imageData name:@"file" fileName:imageName mimeType:@"image/jpeg"];
    }];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [operation setUploadProgressBlock:block];
    [operation setCompletionBlockWithSuccess:success failure:failure];
    [httpClient enqueueHTTPRequestOperation:operation];
}
//上传多张图片，压缩
+(void)uploadImagesWithCompres:(NSArray *)imageArray WithURLStr:(NSString *)urlStr ImageName:(NSArray *)imageNameArray Progress:(void (^)(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite))block Success:(void (^)(AFHTTPRequestOperation *operation,  NSDictionary *responseObject))success
           failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    NSMutableDictionary * reponseStrArray = [NSMutableDictionary dictionary];
    for (int i = 0; i<imageArray.count; i++) {
        [NetManager uploadImageWithCompres:[imageArray objectAtIndex:i] WithURLStr:BaseUploadImageUrl ImageName:[imageNameArray objectAtIndex:i] Progress:block Success:^(AFHTTPRequestOperation *operation, id responseObject) {
                NSString *response = [operation responseString];
                [reponseStrArray setObject:response forKey:[imageNameArray objectAtIndex:i]];
                if (reponseStrArray.count==imageArray.count) {
                    success(operation,reponseStrArray);
            }
        } failure:failure];
    }
}
//上传多张图片，不压缩
+(void)uploadImages:(NSArray *)imageArray WithURLStr:(NSString *)urlStr ImageName:(NSArray *)imageNameArray Progress:(void (^)(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite))block Success:(void (^)(AFHTTPRequestOperation *operation,  NSDictionary *responseObject))success
            failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    NSMutableDictionary * reponseStrArray = [NSMutableDictionary dictionary];
    for (int i = 0; i<imageArray.count; i++) {
        [NetManager uploadImage:[imageArray objectAtIndex:i] WithURLStr:BaseUploadImageUrl ImageName:[imageNameArray objectAtIndex:i] Progress:block Success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSString *response = [operation responseString];
            [reponseStrArray setObject:response forKey:[imageNameArray objectAtIndex:i]];
            if (reponseStrArray.count==imageArray.count) {
                success(operation,reponseStrArray);
            }
        } failure:failure];
    }
}
//图片压缩 两个方法组合
+(UIImage*)compressImageDownToPhoneScreenSize:(UIImage*)theImage targetSizeX:(CGFloat) sizeX targetSizeY:(CGFloat) sizeY
{
	
	UIImage * bigImage = theImage;
	
	float actualHeight = bigImage.size.height;
	float actualWidth = bigImage.size.width;
	
	float imgRatio = actualWidth / actualHeight;
	if(actualWidth > sizeX || actualHeight > sizeY)
	{
		float maxRatio = sizeX / sizeY;
		
		if(imgRatio < maxRatio){
            imgRatio = sizeX / actualWidth;
			actualHeight = imgRatio * actualHeight;
			actualWidth = sizeX;
		} else {
            imgRatio = sizeY / actualHeight;
			actualWidth = imgRatio * actualWidth;
			actualHeight = sizeY;

		}
        
	}
	CGRect rect = CGRectMake(0.0, 0.0, actualWidth, actualHeight);
	UIGraphicsBeginImageContext(rect.size);
	[bigImage drawInRect:rect];  // scales image to rect
	theImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	return theImage;
}
+ (UIImage *) image: (UIImage *) image centerInSize: (CGSize) viewsize
{
	CGSize size = image.size;
	
	UIGraphicsBeginImageContext(viewsize);
	float dwidth = (viewsize.width - size.width) / 2.0f;
	float dheight = (viewsize.height - size.height) / 2.0f;
	
	CGRect rect = CGRectMake(dwidth, dheight, size.width, size.height);
	[image drawInRect:rect];
	
    UIImage *newimg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
	
    return newimg;
}
@end
