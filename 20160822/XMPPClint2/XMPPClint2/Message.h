//
//  Message.h
//  XMPPClint2
//
//  Created by qingyun on 16/8/22.
//  Copyright © 2016年 qingyun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Message : NSObject

@property (nonatomic, strong)NSString *body;//消息的内容
@property (nonatomic, strong)NSString *from;
@property (nonatomic, strong)NSString *to;
@property (nonatomic)BOOL isMe;//是我发出的

@end
