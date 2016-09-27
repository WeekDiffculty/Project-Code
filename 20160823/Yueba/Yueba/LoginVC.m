//
//  LoginVC.m
//  Yueba
//
//  Created by qingyun on 16/8/23.
//  Copyright © 2016年 qingyun. All rights reserved.
//

#import "LoginVC.h"
#import "QYHTTPManager.h"
#import "QYAccount.h"

@interface LoginVC ()
@property (weak, nonatomic) IBOutlet UITextField *phoneFild;
@property (weak, nonatomic) IBOutlet UITextField *pwdFild;

@end

@implementation LoginVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.navigationBarHidden = NO;
    //边延伸
    self.edgesForExtendedLayout = UIRectEdgeNone;
    //没有半透明效果
    self.navigationController.navigationBar.translucent = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)loginService:(id)sender {
    //先本地验证电话号码和密码
    
    //登录请求
    [[QYHTTPManager httpManager] loginService:_phoneFild.text PWD:_pwdFild.text Completion:^(NSURLSessionTask *task, id responseObject, NSError *error) {
        if (error) {
            NSLog(@"%@", error);
            return;
        }
        NSLog(@"%@", responseObject);
        BOOL result = [responseObject[@"success"] boolValue];
        if (result) {
            [[QYAccount shareAccount] saveLogin:responseObject[@"data"]];
            
            if (responseObject[@"data"][@"name"]) {
                //跳转到首页
            }else{
//                跳转到更新用户信息页面
                //切换到提交用户信息界面
                UIViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"uplodInfo"];
                [self.navigationController pushViewController:vc animated:YES];
            }
            
        }else{
            //当登录失败,给用户提示
        }
        
        
        
    }];
}
@end
