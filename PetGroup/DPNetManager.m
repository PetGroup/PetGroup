//
//  DPNetManager.m
//  PetGroup
//
//  Created by wangxr on 13-11-25.
//  Copyright (c) 2013年 Tolecen. All rights reserved.
//
#import <CommonCrypto/CommonDigest.h>
#import "DPNetManager.h"
@interface DPNetManager ()<NSURLConnectionDataDelegate>
@property(nonatomic,retain)NSMutableData*data;
@property(nonatomic ,retain)NSURLConnection* connection;
@end
@implementation DPNetManager
-(id)initWithURL:(NSString*)URL delegate:(id<DPNetManagerDelegate>)delegate;
{
    if (self = [super init]) {
        _delegate = delegate;
        self.URlString = URL;
        [self startUpdateData];
    }
    return self;
    
}

-(void) startUpdateData
{
    NSURL*url = [[NSURL alloc]initWithString:self.URlString];
    NSURLRequest *req = [[NSMutableURLRequest alloc]initWithURL:url cachePolicy:0 timeoutInterval:10.0];
    NSURLConnection* urlC = [[NSURLConnection alloc]initWithRequest:req delegate:self];
    self.connection = urlC;
}
-(void)cancel
{
    [self.connection cancel];
}


- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    self.data = [[NSMutableData alloc]init];
}
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [self.data appendData:data];
}
- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSDictionary* dic =[NSJSONSerialization JSONObjectWithData:self.data options:0 error:nil];
    if ([[dic objectForKey:@"status"] isEqualToString:@"OK"]) {
        if ([dic objectForKey:@"businesses"]) {
            if (_delegate && [_delegate respondsToSelector:@selector(DPNetManagerDidFinishLoading:)]) {
                [_delegate DPNetManagerDidFinishLoading:[dic objectForKey:@"businesses"]];
            }
        }
        if ([dic objectForKey:@"reviews"]) {
            if (_delegate && [_delegate respondsToSelector:@selector(DPNetManagerDidFinishLoading:)]) {
                [_delegate DPNetManagerDidFinishLoading:[dic objectForKey:@"reviews"]];
            }
        }
        
    }else{
        if (_delegate &&[self.delegate respondsToSelector:@selector(DPNetManagerdidFailWithError:)]) {
            [self.delegate DPNetManagerdidFailWithError:nil];
        }
    }
    
}
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
    if (_delegate &&[self.delegate respondsToSelector:@selector(DPNetManagerdidFailWithError:)]) {
        [self.delegate DPNetManagerdidFailWithError:error];
    }
}
#pragma mark -serialize URL
+ (NSDictionary *)parseQueryString:(NSString *)query {
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithCapacity:6];
    NSArray *pairs = [query componentsSeparatedByString:@"&"];
    
    for (NSString *pair in pairs) {
        NSArray *elements = [pair componentsSeparatedByString:@"="];
		
		if ([elements count] <= 1) {
			return nil;
		}
		
        NSString *key = [[elements objectAtIndex:0] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSString *val = [[elements objectAtIndex:1] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        [dict setObject:val forKey:key];
    }
    return dict;
}


+ (NSString *)serializeURL:(NSString *)baseURL params:(NSDictionary *)params
{
	NSURL* parsedURL = [NSURL URLWithString:[baseURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
	NSMutableDictionary *paramsDic = [NSMutableDictionary dictionaryWithDictionary:[self parseQueryString:[parsedURL query]]];
	if (params) {
		[paramsDic setValuesForKeysWithDictionary:params];
	}
    
	NSMutableString *signString = [NSMutableString stringWithString:APP_KEY];
	NSMutableString *paramsString = [NSMutableString stringWithFormat:@"appkey=%@", APP_KEY];
	NSArray *sortedKeys = [[paramsDic allKeys] sortedArrayUsingSelector: @selector(compare:)];
	for (NSString *key in sortedKeys) {
		[signString appendFormat:@"%@%@", key, [paramsDic objectForKey:key]];
		[paramsString appendFormat:@"&%@=%@", key, [paramsDic objectForKey:key]];
	}
	[signString appendString:APP_SECRET];
	unsigned char digest[CC_SHA1_DIGEST_LENGTH];
	NSData *stringBytes = [signString dataUsingEncoding: NSUTF8StringEncoding];
	if (CC_SHA1([stringBytes bytes], [stringBytes length], digest)) {
		/* SHA-1 hash has been calculated and stored in 'digest'. */
		NSMutableString *digestString = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH];
		for (int i=0; i<CC_SHA1_DIGEST_LENGTH; i++) {
			unsigned char aChar = digest[i];
			[digestString appendFormat:@"%02X", aChar];
		}
		[paramsString appendFormat:@"&sign=%@", [digestString uppercaseString]];
		return [NSString stringWithFormat:@"%@://%@%@?%@", [parsedURL scheme], [parsedURL host], [parsedURL path], [paramsString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
	} else {
		return nil;
	}
}
@end
