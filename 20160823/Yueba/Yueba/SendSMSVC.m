//
//  SendSMSVC.m
//  Yueba
//
//  Created by qingyun on 16/8/23.
//  Copyright © 2016年 qingyun. All rights reserved.
//

#import "SendSMSVC.h"
#import "Common.h"
#import <AFNetworking.h>
#import "QYHTTPManager.h"
#import "NSString+Log.h"

@interface SendSMSVC ()
@property (weak, nonatomic) IBOutlet UITextField *textFild;

@end

@implementation SendSMSVC

- (IBAction)sendSMS:(id)sender {
    //验证手机号
    
    //调用接口,请求短信验证码
//    NSString *url = [kBaseURL stringByAppendingPathComponent:kSendSMS];
//    NSDictionary *params = @{@"telephone":_textFild.text};
//    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
//    
//    [manager POST:url parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        NSLog(@"%@", responseObject);
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        NSLog(@"%@", error);
//    }];
    //通过封装,屏蔽了网络请求的细节
    [[QYHTTPManager httpManager] sendSMSCode:_textFild.text Completion:^(NSURLSessionTask *task, id responseObject, NSError *error) {
        if (error) {
            NSLog(@"%@", error);
            return;
        }
        NSLog(@"%@", responseObject);
        
    }];
    
    //当前控制器是从sb中初始化的
    UIViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"registvc"];
    //将电话号码传递到下一个控制器
    [vc setValue:_textFild.text forKey:@"phoneNumber"];
    
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.navigationBarHidden = NO;
    self.navigationItem.hidesBackButton = YES;
    
    //调整控制器的布局,边界不做扩展
    self.edgesForExtendedLayout = UIRectEdgeNone;
//    navbar半透明效果
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

@end
