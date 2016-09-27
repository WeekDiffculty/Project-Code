//
//  BCNetConnnect.h
//  XMPPClint
//
//  Created by qingyun on 16/8/20.
//  Copyright © 2016年 qingyun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XMPP.h"
#import "XMPPRosterCoreDataStorage.h"

//@import XMPP;

@interface BCNetConnect : NSObject

@property (nonatomic, strong)XMPPStream *stream;//客户端
@property (nonatomic)BOOL isRegist;//当前连接后的操作

@property (nonatomic, strong)XMPPRosterCoreDataStorage *storage;//花名册的存储器
@property (nonatomic, strong)XMPPRoster *roster;//花名册,管理好友

//获取单例对象
+(instancetype)shareNetConnect;

//连接服务器
-(BOOL)connect;

@end
