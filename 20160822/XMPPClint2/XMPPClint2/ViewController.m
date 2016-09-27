//
//  ViewController.m
//  XMPPClint2
//
//  Created by qingyun on 16/8/20.
//  Copyright © 2016年 qingyun. All rights reserved.
//

#import "ViewController.h"
#import "BCNetConnect.h"
#import "UserStatus.h"
#import "Message.h"
@interface ViewController ()<XMPPStreamDelegate, UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong)NSMutableArray *friends;
@property (nonatomic, strong)NSMutableArray *messages;//收到的所有消息

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    //初始化容器
    self.friends = [NSMutableArray array];
    self.messages = [NSMutableArray array];
    //接收streamdelegate
    [[BCNetConnect shareNetConnect].stream addDelegate:self delegateQueue:dispatch_get_main_queue()];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
}


#pragma mark - xmpp stream delegate
//好友上线或者下线的delegate
-(void)xmppStream:(XMPPStream *)sender didReceivePresence:(XMPPPresence *)presence{
    NSLog(@"%@", presence);
    
    //当前用户的名字
    NSString *myName = sender.myJID.user;
    
    //发送人名字
    NSString *fromString = presence.from.user;
    
    //接收人
    NSString *toString = presence.to.user;
    
    //消息的类型
    NSString *pType = presence.type;
    
    //当收到别人发给我的消息的时候
    if (![myName isEqualToString:fromString]) {
        UserStatus *status = [[UserStatus alloc] init];
        status.name = fromString;
//        available是上线的时候,消息的类型
        status.isOnline = [pType isEqualToString:@"available"] ? YES : NO;
        
        for (int i = 0;i < self.friends.count; i ++) {
            UserStatus *s = self.friends[i];
            //如果已经存在该用户,更新用户状态
            if ([s.name isEqualToString:status.name]) {
                [self.friends removeObject:s];
                [self.friends insertObject:status atIndex:i];
            }
        }
        //当没有在之前的循环中被添加,那么是新用户,追加到后面
        if (![self.friends containsObject:status]) {
            [self.friends addObject:status];
        }
        
        [self.tableView reloadData];
    }
}

//接收消息的delegate方法
-(void)xmppStream:(XMPPStream *)sender didReceiveMessage:(XMPPMessage *)message{
    if (message.body == nil) {
        return;
    }
    //将收到的消息,转化为模型对象
    Message *messageModel = [[Message alloc] init];
    messageModel.from = message.from.user;
    messageModel.to = message.to.user;
    if ([messageModel.from isEqualToString:sender.myJID.user]) {
        messageModel.isMe = YES;
    }else{
        messageModel.isMe = NO;
    }
    messageModel.body = message.body;
    [self.messages addObject:messageModel];
    
    [self.tableView reloadData];
}

#pragma mark - table view delegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.friends.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"friendCell" forIndexPath:indexPath];
    UserStatus *friend = self.friends[indexPath.row];
    //显示用户名和状态
    cell.textLabel.text = [NSString stringWithFormat:@"%@  %@", friend.name , friend.isOnline ? @"在线" : @"离线"];
    
    //遍历消息数组,找到所有当前好友发送的未读消息,以及最后一条消息内容
    NSMutableArray *friendMessages = [NSMutableArray array];
    for (NSUInteger index = 0; index < self.messages.count; index ++) {
        Message *message = self.messages[index];
        //判断如果用户名一致
        if ([friend.name isEqualToString:message.from]) {
            [friendMessages addObject:message];
        }
    }
    NSString *text = [NSString stringWithFormat:@"%@  (%ld)", [[friendMessages lastObject] body], friendMessages.count];
    
    cell.detailTextLabel.text = text;
    
    return cell;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    //清理当前好友的未读消息
    //将好友传递给下一控制器
    //找到好友
    if ([segue.identifier isEqualToString:@"chart"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
        UserStatus *user = self.friends[indexPath.row];
        //清理未读消息
        NSMutableArray *messages = [self.messages mutableCopy];
        for (int i = 0; i < self.messages.count; i++) {
            Message *mess = self.messages[i];
            if ([mess.from isEqualToString:user.name]) {
                [messages removeObject:mess];
            }
        }
        self.messages = messages;
        [self.tableView reloadData];
        
        //将聊天对象,传递给下一个控制器
        UIViewController *vc = segue.destinationViewController;
        [vc setValue:user.name forKey:@"friendName"];
        
    }
}


@end
