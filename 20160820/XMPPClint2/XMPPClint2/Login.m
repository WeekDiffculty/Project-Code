//
//  Login.m
//  XMPPClint2
//
//  Created by qingyun on 16/8/20.
//  Copyright © 2016年 qingyun. All rights reserved.
//

#import "Login.h"
#import "BCNetConnect.h"

@interface Login ()
@property (weak, nonatomic) IBOutlet UITextField *userName;
@property (weak, nonatomic) IBOutlet UITextField *pwd;

@end

@implementation Login

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)login:(id)sender {
    //将用户输入的用户名和密码保存,连接服务器,并且登录
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    NSString *userName = [NSString stringWithFormat:@"%@@biancheng.me", self.userName.text];//用户名+域名
    [userDef setObject:userName forKey:@"user"];//jid
    [userDef setObject:self.pwd.text forKey:@"pwd"];//密码
    [userDef setObject:@"localhost" forKey:@"service"];//服务器地址
    [userDef synchronize];
    //服务器进行连接
    [[BCNetConnect shareNetConnect] connect];
    
}
- (IBAction)siginUp:(id)sender {
    //将用户输入的用户名和密码保存,连接服务器,并且登录
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    NSString *userName = [NSString stringWithFormat:@"%@@biancheng.me", self.userName.text];//用户名+域名
    [userDef setObject:userName forKey:@"user"];//jid
    [userDef setObject:self.pwd.text forKey:@"pwd"];//密码
    [userDef setObject:@"localhost" forKey:@"service"];//服务器地址
    [userDef synchronize];
    //服务器进行连接,之后进行注册
    [BCNetConnect shareNetConnect].isRegist = YES;
    [[BCNetConnect shareNetConnect] connect];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
