//
//  AddFriendVC.m
//  XMPPClint2
//
//  Created by qingyun on 16/8/22.
//  Copyright © 2016年 qingyun. All rights reserved.
//

#import "AddFriendVC.h"
#import "BCNetConnect.h"

@interface AddFriendVC ()
@property (weak, nonatomic) IBOutlet UITextField *friendName;

@end

@implementation AddFriendVC
- (IBAction)addFriend:(id)sender {
    //添加的好友的id
    NSString *NameId = [NSString stringWithFormat:@"%@@biancheng.me", _friendName.text];
    //JID
    XMPPJID *jID = [XMPPJID jidWithString:NameId];
    
    //使用花名册添加好友
    [[BCNetConnect shareNetConnect].roster subscribePresenceToUser:jID];
    
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
