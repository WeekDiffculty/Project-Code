    //
//  RegistVC.m
//  Yueba
//
//  Created by qingyun on 16/8/23.
//  Copyright © 2016年 qingyun. All rights reserved.
//

#import "RegistVC.h"
#import "QYHTTPManager.h"

@interface RegistVC ()
@property (weak, nonatomic) IBOutlet UITextField *smsFild;
@property (weak, nonatomic) IBOutlet UITextField *pwdFild;

@end

@implementation RegistVC
- (IBAction)registAccount:(id)sender {
    //本地验证短信验证码和密码
    
    //调用封装好的创建账户的方法
    [[QYHTTPManager httpManager] creatAccount:_phoneNumber PWD:_pwdFild.text SMS:_smsFild.text Completion:^(NSURLSessionTask *task, id responseObject, NSError *error) {
        //请求的回调结果
        if (error) {
            NSLog(@"%@", error);
            return;
        }
        
        NSLog(@"%@", responseObject);
        
        //切换到提交用户信息界面
        UIViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"uplodInfo"];
        [self.navigationController pushViewController:vc animated:YES];
        
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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

@end
