//
//  ViewController.m
//  ShareDemo
//
//  Created by Xionghaizi on 16/8/15.
//  Copyright © 2016年 Xionghaizi. All rights reserved.
//

#import "ViewController.h"
#import <UMSocial.h>

@interface ViewController ()<UMSocialUIDelegate>

@end

@implementation ViewController


//umeng的回调方法
-(void)didFinishGetUMSocialDataInViewController:(UMSocialResponseEntity *)response
{
    //根据`responseCode`得到发送结果,如果分享成功
    if(response.responseCode == UMSResponseCodeSuccess)
    {
        //得到分享到的平台名
        NSLog(@"share to sns name is %@",[[response.data allKeys] objectAtIndex:0]);
    }
}
//分享图片到微博
- (IBAction)sharing:(id)sender {
    //http://h.hiphotos.baidu.com/image/h%3D200/sign=561c618ab451f819ee25044aeab54a76/7acb0a46f21fbe09046d24b56f600c338744ad64.jpg
    
    [[UMSocialData defaultData].urlResource setResourceType:UMSocialUrlResourceTypeImage url:@"http://h.hiphotos.baidu.com/image/h%3D200/sign=561c618ab451f819ee25044aeab54a76/7acb0a46f21fbe09046d24b56f600c338744ad64.jpg"];
    [UMSocialData defaultData].extConfig.title = @"分享一下!";
    [UMSocialSnsService presentSnsIconSheetView:self appKey:@"57b128fee0f55afbf50026ab" shareText:@"分享图片" shareImage:[UIImage imageNamed:@"share"] shareToSnsNames:@[UMShareToSina] delegate:self];
    
    
}
- (IBAction)loginsina:(id)sender {
    UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToSina];
    
    snsPlatform.loginClickHandler(self,[UMSocialControllerService defaultControllerService],YES,^(UMSocialResponseEntity *response){
        
        //          获取微博用户名、uid、token等
        
        if (response.responseCode == UMSResponseCodeSuccess) {
            
            NSDictionary *dict = [UMSocialAccountManager socialAccountDictionary];
            UMSocialAccountEntity *snsAccount = [[UMSocialAccountManager socialAccountDictionary] valueForKey:snsPlatform.platformName];
            NSLog(@"\nusername = %@,\n usid = %@,\n token = %@ iconUrl = %@,\n unionId = %@,\n thirdPlatformUserProfile = %@,\n thirdPlatformResponse = %@ \n, message = %@",snsAccount.userName,snsAccount.usid,snsAccount.accessToken,snsAccount.iconURL, snsAccount.unionId, response.thirdPlatformUserProfile, response.thirdPlatformResponse, response.message);
            
        }});
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
