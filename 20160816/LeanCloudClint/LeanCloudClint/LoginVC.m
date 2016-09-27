//
//  LoginVC.m
//  LeanCloudClint
//
//  Created by qingyun on 16/8/16.
//  Copyright © 2016年 qingyun. All rights reserved.
//

#import "LoginVC.h"
#import <AVOSCloud/AVOSCloud.h>
#import "AppDelegate.h"

@interface LoginVC ()
@property (weak, nonatomic) IBOutlet UITextField *userName;
@property (weak, nonatomic) IBOutlet UITextField *pwd;

@end

@implementation LoginVC
- (IBAction)login:(id)sender {
    if (self.userName.text == nil || self.pwd.text == nil) {
        NSLog(@"userName or pwd nil");
    }
    
    [AVUser logInWithUsernameInBackground:self.userName.text password:self.pwd.text block:^(AVUser *user, NSError *error) {
        if (!error) {
            NSLog(@"登录成功");
            
            NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
            [def setObject:user.username forKey:@"username"];
            [def synchronize];
            
            AppDelegate *app = [[UIApplication sharedApplication] delegate];
            [app change2HomeVC];
        }else{
            NSLog(@"%@", error);
        }
    }];
    
}

@end
