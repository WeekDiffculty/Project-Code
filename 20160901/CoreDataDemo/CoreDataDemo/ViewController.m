//
//  ViewController.m
//  CoreDataDemo
//
//  Created by qingyun on 16/9/1.
//  Copyright © 2016年 qingyun. All rights reserved.
//

#import "ViewController.h"
#import "AppDelegate.h"
#import "Person.h"
#import "Card.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UITextField *name;
@property (weak, nonatomic) IBOutlet UITextField *age;
@property (weak, nonatomic) IBOutlet UITextField *card;

@end

@implementation ViewController
- (IBAction)save:(id)sender {
    AppDelegate *app = [[UIApplication sharedApplication] delegate];
    
//    //根据实体往数据缓冲池中添加一个对象
//    NSManagedObject *person = [NSEntityDescription insertNewObjectForEntityForName:@"Person" inManagedObjectContext:app.context];
//    //设置属性
//    [person setValue:_name.text forKey:@"name"];
//    [person setValue:[NSNumber numberWithInt:_age.text.intValue] forKey:@"age"];
//    
//    //添加另外的一个实体
//    NSManagedObject *card = [NSEntityDescription insertNewObjectForEntityForName:@"Card" inManagedObjectContext:app.context];
//    [card setValue:_card.text forKey:@"no"];
//    
//    
//    //建立起一个关系
//    [person setValue:card forKey:@"card"];
//    [card setValue:person forKey:@"person"];
    
    //构建实体
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Person" inManagedObjectContext:app.context];
    //初始化模型对象
    Person *person = [[Person alloc] initWithEntity:entity insertIntoManagedObjectContext:app.context];
    person.name = _name.text;
    person.age = [NSNumber numberWithInt:_age.text.intValue];
    
    //初始化对象
    Card *card = [NSEntityDescription insertNewObjectForEntityForName:@"Card" inManagedObjectContext:app.context];
    card.no = _card.text;
    
    //指定关系
    person.card = card;
    card.person = person;
    
    
    
    //将context中的所有修改,更新到数据库
    NSError *error;
    [app.context save:&error];
    if (error) {
        NSLog(@"%@",error);
    }
    else{
        NSLog(@"保存成功");
    }
    _name.text = nil;
    _age.text = nil;
    _card.text = nil;
    
}
- (IBAction)select:(id)sender {
    //查询模型对象
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Person"];
    
    //设置排序规则
    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"age" ascending:YES];
    fetchRequest.sortDescriptors = @[sort];
    
    //设置谓词
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name like %@", @"zhang*"];
    fetchRequest.predicate = predicate;
    
    
    //执行查询
    NSError *error;
    AppDelegate *app = [[UIApplication sharedApplication] delegate];
    NSArray *result = [app.context executeFetchRequest:fetchRequest error:&error];
    for (NSUInteger index = 0; index < result.count; index ++) {
//        NSManagedObject *person = result[index];
//        NSLog(@"%@, %@, %@", [person valueForKey:@"name"], [[person valueForKey:@"age"] stringValue], [[person valueForKey:@"card"] valueForKey:@"no"]);
        
        Person *person = [result objectAtIndex:index];
        NSLog(@"%@, %@, %@", person.name, person.age.stringValue, person.card.no);
        
        
//        //修改内容
//        //年龄 + 10
//        int age = [[person valueForKey:@"age"] intValue];
//        [person setValue:[NSNumber numberWithInt:age + 10] forKey:@"age"];
//        
//        //删除内容
//        NSString *name = [person valueForKey:@"name"];
//        if ([name isEqualToString:@"zhanglisi"]) {
//            NSManagedObject *card = [person valueForKey:@"card"];
//            if (card) {
//                [app.context deleteObject:card];
//            }else{
//                NSLog(@"card nil");
//            }
//            
//        }
    }
    
    [app.context save:&error];
    
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
