//
//  AddFriendVC.m
//  LeanCloudClint
//
//  Created by qingyun on 16/8/16.
//  Copyright © 2016年 qingyun. All rights reserved.
//

#import "AddFriendVC.h"
#import <AVOSCloud/AVOSCloud.h>

@interface AddFriendVC ()
@property (weak, nonatomic) IBOutlet UITextField *friendName;

@end

@implementation AddFriendVC


- (IBAction)addFriend:(id)sender {
    //检查用户输入
    if (self.friendName.text == nil) {
        NSLog(@"friendName nil");
        return;
    }
    NSString *username = [[NSUserDefaults standardUserDefaults] objectForKey:@"username"];
    //向服务器添加一条记录
    AVObject *friend = [AVObject objectWithClassName:@"Friend"];
    [friend setObject:username forKey:@"myname"];
    [friend setObject:self.friendName.text forKey:@"friendname"];
    //异步执行保存
    [friend saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            NSLog(@"保存成功");
        }else{
            NSLog(@"%@", error);
        }
    }];
    [self.navigationController popViewControllerAnimated:YES];
    
    
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
