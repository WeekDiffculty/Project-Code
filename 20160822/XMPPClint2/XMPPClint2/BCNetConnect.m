//
//  BCNetConnnect.m
//  XMPPClint
//
//  Created by qingyun on 16/8/20.
//  Copyright © 2016年 qingyun. All rights reserved.
//

#import "BCNetConnect.h"
#import "AppDelegate.h"

@interface BCNetConnect ()<XMPPStreamDelegate, XMPPRosterDelegate>

@end

@implementation BCNetConnect

+(instancetype)shareNetConnect{
    static BCNetConnect *connect;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        connect = [[BCNetConnect alloc] init];
    });
    return connect;
}

//连接服务器
-(BOOL)connect{
    //如果已经存在连接,断开重连
    if (self.stream.isConnected) {
        [self.stream disconnect];
    }
    
    //使用用户名,密码,服务器地址连接服务器
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    NSString *userName = [userDef objectForKey:@"user"];
    NSString *pwd = [userDef objectForKey:@"pwd"];
    NSString *service = [userDef objectForKey:@"service"];
    
    //设置服务器地址和用户名,在三个参数都有的时候,才能链接
    if (!userName || !pwd || !service) {
        return NO;
    }
    self.stream.hostName = service;//主机地址
    XMPPJID *user = [XMPPJID jidWithString:userName];
    self.stream.myJID = user;//服务器域名
    
    NSError *error;
    return [self.stream connectWithTimeout:XMPPStreamTimeoutNone error:&error];
    
}



//注册账号

//设置状态
-(void)goOnline{
    //构建一个状态对象,默认值为上线
    XMPPPresence *presence = [XMPPPresence presence];
    [_stream sendElement:presence];
}

//接收消息

#pragma mark - xmpp stream delegate
-(void)xmppStreamDidConnect:(XMPPStream *)sender{
    NSLog(@"connect success");
    
    if (!_isRegist) {
        //登录验证
        NSString *pwd = [[NSUserDefaults standardUserDefaults] objectForKey:@"pwd"];
        NSError *error;
        [self.stream authenticateWithPassword:pwd error:&error];
    }else{
        //注册
        NSString *pwd = [[NSUserDefaults standardUserDefaults] objectForKey:@"pwd"];
        NSError *error;
        [self.stream registerWithPassword:pwd error:&error];
    }

}

//登录成功的delegate
-(void)xmppStreamDidAuthenticate:(XMPPStream *)sender{
    NSLog(@"login success");
    //设置上线状态
    [self goOnline];
    //登录成功后切换到首页
    AppDelegate *app = [[UIApplication sharedApplication] delegate];
    [app changeToHome];
    
    //初始化花名册的存储器和花名册
    self.storage = [[XMPPRosterCoreDataStorage alloc] init];
    self.roster = [[XMPPRoster alloc] initWithRosterStorage:_storage];
    
    //绑定stream
    [self.roster activate:self.stream];
    
    //设置delegate,已经被stream接收,不会调用delegate方法
    [self.roster addDelegate:self delegateQueue:dispatch_get_main_queue()];
    
    
}
-(void)xmppStream:(XMPPStream *)sender didNotAuthenticate:(DDXMLElement *)error{
    NSLog(@"%@", error);
}

-(void)xmppStreamDidRegister:(XMPPStream *)sender{
    NSLog(@"注册成功");
    NSString *pwd = [[NSUserDefaults standardUserDefaults] objectForKey:@"pwd"];
    NSError *error;
    [self.stream authenticateWithPassword:pwd error:&error];
}

-(void)xmppStream:(XMPPStream *)sender didNotRegister:(DDXMLElement *)error{
    NSLog(@"%@", error);
}

//收到状态改变
-(void)xmppStream:(XMPPStream *)sender didReceivePresence:(XMPPPresence *)presence{
    NSLog(@"%@", presence);
    
    //当状态类型是订阅的时候
    if ([presence.type isEqualToString:@"subscribe"]) {
        XMPPJID *from = presence.from;
        //同意对方的添加,并且添加对方
        [self.roster acceptPresenceSubscriptionRequestFrom:from andAddToRoster:YES];
    }
}

//收到订阅请求
//- (void)xmppRoster:(XMPPRoster *)sender didReceivePresenceSubscriptionRequest:(XMPPPresence *)presence{
//    
//}


#pragma mark - get

//xmpp数据流的通道,所有的xml数据流通过该对象收发
-(XMPPStream *)stream{
    if (!_stream) {
        _stream = [[XMPPStream alloc] init];
        //添加delegate
        [_stream addDelegate:self delegateQueue:dispatch_get_main_queue()];
    }
    return _stream;
}

@end
