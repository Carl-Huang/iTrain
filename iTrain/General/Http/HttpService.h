//
//  HttpService.h
//  HWSDK
//
//  Created by Carl on 13-11-28.
//  Copyright (c) 2013年 helloworld. All rights reserved.
//

#import "AFHttp.h"
#define URL_PREFIX @"http://192.168.1.103/news/list.action"

@interface HttpService : AFHttp

+ (HttpService *)sharedInstance;


- (void)feeback:(NSDictionary *)params completionBlock:(void (^)(id object))success failureBlock:(void (^)(NSError * error,NSString * reponseString))failure;

- (void)news:(NSDictionary *)params completionBlock:(void (^)(id object))success failureBlock:(void (^)(NSError * error,NSString * reponseString))failure;
@end
