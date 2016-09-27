//
//  QYAccount.m
//  Yueba
//
//  Created by qingyun on 16/8/23.
//  Copyright © 2016年 qingyun. All rights reserved.
//

#import "QYAccount.h"

#define kAccountFile @"accountFile"

@interface QYAccount ()<NSCoding>

@end

@implementation QYAccount

//实现单例方法
+(instancetype)shareAccount{
    static QYAccount *account;
    //单例的block
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        //归档的文件路劲
        NSString *documentsPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
        NSString *filePath = [documentsPath stringByAppendingPathComponent:kAccountFile];
        account = [NSKeyedUnarchiver unarchiveObjectWithFile:filePath];
        if (!account) {
            //如果解档失败
            account = [[QYAccount alloc] init];
        }
        
    });
    return account;
}

-(void)saveLogin:(NSDictionary *)info{
    self.telephone = [info[@"telephone"] stringValue];
    self.userId = [info[@"userId"] stringValue];
    self.name = info[@"name"];
    self.gender = info[@"gender"];
    
    NSString *documentsPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    NSString *filePath = [documentsPath stringByAppendingPathComponent:kAccountFile];
    [NSKeyedArchiver archiveRootObject:self toFile:filePath];
    
}

-(BOOL)isLogin{
    if (self.userId) {
        return YES;
    }else{
        return NO;
    }
}

//解档的delegate
-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super init]) {
        self.telephone = [aDecoder decodeObjectForKey:@"telephone"];
        self.userId = [aDecoder decodeObjectForKey:@"userId"];
        self.name =[aDecoder decodeObjectForKey:@"name"];
        self.gender = [aDecoder decodeObjectForKey:@"gender"];
    }
    
    return self;
    
    
}

//归档的方法
-(void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:self.telephone forKey:@"telephone"];
    [aCoder encodeObject:self.userId forKey:@"userId"];
    [aCoder encodeObject:self.name forKey:@"name"];
    [aCoder encodeObject:self.gender forKey:@"gender"];
}


@end
