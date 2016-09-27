//
//  UserStatus.h
//  XMPPClint2
//
//  Created by qingyun on 16/8/22.
//  Copyright © 2016年 qingyun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserStatus : NSObject

@property (nonatomic, strong)NSString *name;//用户名
@property (nonatomic)BOOL isOnline;//是否在线

@end
