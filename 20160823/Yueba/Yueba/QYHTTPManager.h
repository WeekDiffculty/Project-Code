//
//  QYHTTPManager.h
//  Yueba
//
//  Created by qingyun on 16/8/23.
//  Copyright © 2016年 qingyun. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>

typedef void(^QYHTTPManagerCompletionHandle) (NSURLSessionTask *task, id responseObject, NSError *error);

@interface QYHTTPManager : AFHTTPSessionManager

//添加了baseURL
+(instancetype)httpManager;


//封装af的get方法
-(NSURLSessionDataTask *)GET:(NSString *)URLString
                  parameters:(id)parameters
                  Completion:(QYHTTPManagerCompletionHandle)completionHandle;

-(NSURLSessionDataTask *)POST:(NSString *)URLString
                  parameters:(id)parameters
                  Completion:(QYHTTPManagerCompletionHandle)completionHandle;

//请求短信验证码的请求
-(NSURLSessionDataTask *)sendSMSCode:(NSString *)phoneNumer Completion:(QYHTTPManagerCompletionHandle )completionHandle;

//注册账号的方法
-(NSURLSessionDataTask *)creatAccount:(NSString *)phoneNumber PWD:(NSString *)pwd SMS:(NSString *)smsCode Completion:(QYHTTPManagerCompletionHandle )completionHandle;

//登录服务器
-(NSURLSessionDataTask *)loginService:(NSString *)phone PWD:(NSString *)pwd Completion:(QYHTTPManagerCompletionHandle )completionHandle;


@end
