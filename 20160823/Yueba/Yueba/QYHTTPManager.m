//
//  QYHTTPManager.m
//  Yueba
//
//  Created by qingyun on 16/8/23.
//  Copyright © 2016年 qingyun. All rights reserved.
//

#import "QYHTTPManager.h"
#import "Common.h"

@implementation QYHTTPManager

+(instancetype)httpManager{
    //预先设置baseurl
    return [[QYHTTPManager alloc] initWithBaseURL:[NSURL URLWithString:kBaseURL]];
}

-(NSURLSessionDataTask *)GET:(NSString *)URLString parameters:(id)parameters Completion:(QYHTTPManagerCompletionHandle)completionHandle{
    return [self GET:URLString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        completionHandle(task, responseObject, nil);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        completionHandle(task, nil, error);
    }];
}

-(NSURLSessionDataTask *)POST:(NSString *)URLString parameters:(id)parameters Completion:(QYHTTPManagerCompletionHandle)completionHandle{
    return [self POST:URLString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        completionHandle(task, responseObject, nil);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        completionHandle(task, nil, error);
    }];
}

-(NSURLSessionDataTask *)sendSMSCode:(NSString *)phoneNumer Completion:(QYHTTPManagerCompletionHandle)completionHandle{
    
    NSDictionary *params = @{@"telephone":phoneNumer};
    return [self POST:kSendSMS parameters:params Completion:completionHandle];
}

-(NSURLSessionDataTask *)creatAccount:(NSString *)phoneNumber PWD:(NSString *)pwd SMS:(NSString *)smsCode Completion:(QYHTTPManagerCompletionHandle)completionHandle{
    
    NSDictionary *params = @{@"telephone":phoneNumber, @"password":pwd, @"smsCode": smsCode};
    
    return [self POST:kCreatAccount parameters:params Completion:completionHandle];
}

-(NSURLSessionDataTask *)loginService:(NSString *)phone PWD:(NSString *)pwd Completion:(QYHTTPManagerCompletionHandle)completionHandle{
    NSDictionary *params = @{@"telephone":phone, @"password":pwd};
    return [self POST:kLoginService parameters:params Completion:completionHandle];
}

@end
