//
//  ChartVC.m
//  XMPPClint2
//
//  Created by qingyun on 16/8/22.
//  Copyright © 2016年 qingyun. All rights reserved.
//

#import "ChartVC.h"
#import "BCNetConnect.h"
#import "Message.h"
#import "Message.h"
#import "MessageCell.h"

@interface ChartVC ()<XMPPStreamDelegate, UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UITextField *textFild;

@property (nonatomic, strong)NSMutableArray *messageArray;//所有的当前聊天的消息

@end

@implementation ChartVC

-(void)dealloc{
    //离开控制器,删除delegate
    [[BCNetConnect shareNetConnect].stream removeDelegate:self];
}

- (IBAction)sendMessage:(id)sender {
//    构建一个消息对象
    NSString *body = self.textFild.text;
    XMPPJID *toJID = [XMPPJID jidWithString:[self.friendName stringByAppendingString:@"@biancheng.me"]];
    XMPPMessage *message = [XMPPMessage messageWithType:@"chat" to:toJID];
    [message addBody:body];
//    发送消息
    [[BCNetConnect shareNetConnect].stream sendElement:message];
    self.textFild.text = nil;
    
    //将消息放到数据源中
    Message *mess = [[Message alloc] init];
    mess.from = [BCNetConnect shareNetConnect].stream.myJID.user;
    mess.to = self.friendName;
    mess.body = body;
    mess.isMe = YES;
    
    [self.messageArray addObject:mess];
    
    [self.tableView reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [[BCNetConnect shareNetConnect].stream addDelegate:self delegateQueue:dispatch_get_main_queue()];
    
    self.messageArray = [NSMutableArray array];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
}

#pragma mark - xmpp stream delegate

-(void)xmppStream:(XMPPStream *)sender didReceiveMessage:(XMPPMessage *)message{
    //只关注当前聊天的消息
    NSString *fromString = message.from.user;
    if (![fromString isEqualToString:self.friendName] ) {
        return;
    }
    //没有内容
    if (message.body  == nil) {
        return;
    }
    //转化为model,保存到数据源
    Message *mess = [[Message alloc] init];
    mess.from = fromString;
    mess.to = sender.myJID.user;
    mess.body = message.body;
    mess.isMe = NO;
    
    [self.messageArray addObject:mess];
    
    [self.tableView reloadData];
}

#pragma mark - table View delegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.messageArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    Message *message = self.messageArray[indexPath.row];
    MessageCell *cell;
    if (message.isMe){
        cell = [tableView dequeueReusableCellWithIdentifier:@"right" forIndexPath:indexPath];
    }else{
        cell = [tableView dequeueReusableCellWithIdentifier:@"left" forIndexPath:indexPath];
    }
    cell.nameLabel.text = message.from;
    cell.bodylabel.text = message.body;
    return cell;
    
}

@end
