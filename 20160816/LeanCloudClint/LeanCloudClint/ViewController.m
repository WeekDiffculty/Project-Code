//
//  ViewController.m
//  LeanCloudClint
//
//  Created by qingyun on 16/8/16.
//  Copyright © 2016年 qingyun. All rights reserved.
//

#import "ViewController.h"
#import <AVOSCloud/AVOSCloud.h>
#import "AppDelegate.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UITextField *userName;
@property (weak, nonatomic) IBOutlet UITextField *pwd;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)creatAccount:(id)sender {
    //注册账号
    if (self.userName.text == nil || self.pwd.text == nil) {
        NSLog(@"name or pwd nil");
        return;
    }
    
    //创建用户
    AVUser *user = [[AVUser alloc] init];
    user.username = self.userName.text;
    user.password = self.pwd.text;
    //保存用异步模式
    [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            NSLog(@"注册成功");
            NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
            [def setObject:user.username forKey:@"username"];
            [def synchronize];
            AppDelegate *app = [[UIApplication sharedApplication] delegate];
            [app change2HomeVC];
        }else{
            NSLog(@"%@",error);
        }
    }];
    
}

@end
