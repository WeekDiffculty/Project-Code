//
//  HomeVC.m
//  LeanCloudClint
//
//  Created by qingyun on 16/8/16.
//  Copyright © 2016年 qingyun. All rights reserved.
//

#import "HomeVC.h"
#import <AVOSCloud/AVOSCloud.h>

@interface HomeVC ()

@property (nonatomic, strong)NSString *username;//自己登录的名字
@property (nonatomic, strong)NSArray *friends;//好友数据源

@end

@implementation HomeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    登录之后保存的
    self.username= [[NSUserDefaults standardUserDefaults] objectForKey:@"username"];
}

-(void)viewWillAppear:(BOOL)animated{
    //查询好友列表
    AVQuery *query = [AVQuery queryWithClassName:@"Friend"];
    //设置查询条件
    [query whereKey:@"myname" equalTo:self.username];
    //执行查询
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (error) {
            NSLog(@"%@", error);
            return ;
        }
        self.friends = objects;
        [self.tableView reloadData];
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - table view delegate datasource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.friends.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    AVObject *friend = self.friends[indexPath.row];
    cell.textLabel.text = friend[@"friendname"];
    return cell;    
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    //区分不同的跳转
    if ([segue.identifier isEqualToString:@"chart"]) {
        //找到选择的行
        UITableViewCell *cell = sender;
        //传递一个cell,找到位置
        NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
        AVObject *friend = self.friends[indexPath.row];
        //目标控制器,将要跳转的控制器
        UIViewController *vc = [segue destinationViewController];
        [vc setValue:friend[@"friendname"] forKey:@"friendName"];
    }
   
}


@end
