//
//  QYAccount.h
//  Yueba
//
//  Created by qingyun on 16/8/23.
//  Copyright © 2016年 qingyun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QYAccount : NSObject

@property (nonatomic, strong)NSString *userId;//用户id
@property (nonatomic, strong)NSString *telephone;//用户电话
@property (nonatomic, strong)NSString *name;//用户名字
@property (nonatomic, strong)NSString *gender;//用户性别

//单例类分享方法
+(instancetype)shareAccount;

//保存登录信息的方法
-(void)saveLogin:(NSDictionary *)info;

//判断是否登录
-(BOOL)isLogin;

//退出登录
-(void)logOut;

@end
