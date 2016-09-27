//
//  Common.h
//  Yueba
//
//  Created by qingyun on 16/8/23.
//  Copyright © 2016年 qingyun. All rights reserved.
//

#ifndef Common_h
#define Common_h

//url
#define kBaseURL @"http://yueba.applinzi.com"

#define kSendSMS @"users/smsCaptcha.json"//发送短信验证码
#define kCreatAccount @""//注册账号
#define kLoginService @"users/login.json"//登录服务器


//code

#ifndef DEBUG

#define NSLog(...) {}

#endif



#endif /* Common_h */
