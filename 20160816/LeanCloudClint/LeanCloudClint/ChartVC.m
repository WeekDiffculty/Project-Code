//
//  ChartVC.m
//  LeanCloudClint
//
//  Created by qingyun on 16/8/16.
//  Copyright © 2016年 qingyun. All rights reserved.
//

#import "ChartVC.h"
#import <AVOSCloudIM/AVOSCloudIM.h>
#import "AppDelegate.h"
#import "ChartCell.h"

@interface ChartVC ()<AVIMClientDelegate, UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong)AVIMConversation *conversation;
@property (nonatomic, strong)NSString *username;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UITextField *textFild;
@property (strong, nonatomic)NSMutableArray *messages;

@end

@implementation ChartVC
//发送消息

- (IBAction)sendMessage:(id)sender {
    if (self.textFild.text == nil) {
        return;
    }
    AVIMTextMessage *message = [AVIMTextMessage messageWithText:self.textFild.text attributes:nil];
    [self.conversation sendMessage:message callback:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            NSLog(@"发送成功");
        }else{
            NSLog(@"发送失败");
        }
    }];
    self.textFild.text = nil;
    [self.messages addObject:message];
    [self.tableView reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.username = [[NSUserDefaults standardUserDefaults] objectForKey:@"username"];
    [self creatConversation];
    //初始化数组
    self.messages = [NSMutableArray array];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
}

-(void)creatConversation{
    AppDelegate *app = [[UIApplication sharedApplication] delegate];
    NSString *conName = [NSString stringWithFormat:@"%@ and %@", self.username, self.friendName];
    //创建会话
    app.client.delegate = self;
    [app.client createConversationWithName:conName
                                 clientIds:@[self.friendName]//会话名字
                                attributes:nil//自定义属性
                                   options:AVIMConversationOptionUnique//可选参数
                                  callback:^(AVIMConversation *conversation, NSError *error) {
                                      if (!error) {
                                          self.conversation = conversation;
                                      }else{
                                          NSLog(@"%@", error);
                                      }
    }];
}


#pragma mark - clint delegate

- (void)conversation:(AVIMConversation *)conversation didReceiveTypedMessage:(AVIMTypedMessage *)message{
    NSLog(@"message:%@", message.text);
    
    //添加到数据源中
    [self.messages addObject:message];
    [self.tableView reloadData];
}

#pragma mark - tableview delegate datasource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.messages.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    AVIMTextMessage *message = self.messages[indexPath.row];
    //判断是收的消息还是发送的消息
    ChartCell *cell;
    if ([message.clientId isEqualToString:self.username]) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"right" forIndexPath:indexPath];
    }else{
        cell = [tableView dequeueReusableCellWithIdentifier:@"left" forIndexPath:indexPath];
    }
    //绑定内容
    cell.nameLabel.text = message.clientId;
    cell.messageLabel.text = message.text;
    return cell;
}

@end
