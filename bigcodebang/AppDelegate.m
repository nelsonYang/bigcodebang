
#import "AppDelegate.h"

#import "CollectionDao.h"
#import "Macro.h"
#import "JSONKit.h"
#import "UserDao.h"
#import "CommonData.h"
#import "ALToastView.h"
#import "Macro.h"
#import "DesEncrypt.h"
#import "ShareSDK/ShareSDK.h"
#import <TencentOpenAPI/QQApiInterface.h>
#import <TencentOpenAPI/TencentOAuth.h>
#import "WeChatConnection/WeChatConnection.h"
#import "WXApi.h"
#import "GuidViewController.h"
#import "WeiboSDK.h"
#import "SettingDAO.h"


@implementation AppDelegate
@synthesize me;
@synthesize tabBarController;
@synthesize wx;
@synthesize sid;
@synthesize service;
@synthesize request;



- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"everLaunched"]) {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"everLaunched"];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"firstLaunch"];
    }
    
    [ShareSDK registerApp:@"26ab49dfd420"];
    [ShareSDK  connectSinaWeiboWithAppKey:@"3236027186"
                                appSecret:@"138a1664211f9f4ac1a852d0d8589f99"
                              redirectUri:@"http://www.bigcodebang.com"
                              weiboSDKCls:[WeiboSDK class]];
    [ShareSDK connectQZoneWithAppKey:@"100371282"
                           appSecret:@"aed9b0303e3ed1e27bae87c33761161d"
                   qqApiInterfaceCls:[QQApiInterface class]
                     tencentOAuthCls:[TencentOAuth class]];
    [ShareSDK connectWeChatWithAppId:@"wx4868b35061f87885"
                           wechatCls:[WXApi class]];
    
    [WeiboSDK enableDebugMode:YES];
    [WeiboSDK registerApp:sinakey];
    
    [self createTables];
    [self setCommonData];
  
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"firstLaunch"]) {
        GuidViewController *appStartController = [[GuidViewController alloc] init];
        self.window.rootViewController = appStartController;
        [appStartController release];
    }else {
        wx  =[[RecommandViewController alloc]init];
        service = [[ServiceViewController alloc]init];
        me =[[MEViewController alloc]init];
        
        tabBarController  =[[UITabBarController alloc]init];
        NSArray *viewControllers=[NSArray arrayWithObjects:wx,service,me, nil];
        
        [tabBarController setViewControllers:viewControllers];
        UINavigationController *navigrationCtrl = [[UINavigationController alloc]initWithRootViewController:tabBarController];
        [[self window]setRootViewController:navigrationCtrl];
        navigrationCtrl.navigationBarHidden = YES;
        self.window.backgroundColor = [UIColor whiteColor];
        
        
    }
    [self.window makeKeyAndVisible];
    return YES;
}

-(void) setCommonData
{
    NSMutableArray *resultData = [UserDao getUserInfo];
    for (int i=0; i< resultData.count; i++) {
        NSDictionary *data = [resultData objectAtIndex:i];
        if([[data objectForKey:@"type"] isEqualToString:@"1"]){
            if([data objectForKey:@"accessToken"] !=  nil)
            {
                [CommonData setAccessToken:[data objectForKey:@"accessToken"]];
            }
            if([data objectForKey:@"userId"] !=  nil)
            {
                [CommonData setUserId:[data objectForKey:@"userId"]];
            }
            if([data objectForKey:@"sid"] !=  nil)
            {
                [CommonData setSid:[data objectForKey:@"sid"]];
            }
            if ([data objectForKey:@"uid"] != nil) {
                [CommonData setUid:[data objectForKey:@"uid"]];
            }
            if ([data objectForKey:@"money"] != nil) {
                [CommonData setMoney:[data objectForKey:@"money"]];
            }
            
        }else{
            if([data objectForKey:@"accessToken"] !=  nil)
            {
                [CommonData setTencentAccessToken:[data objectForKey:@"accessToken"]];
            }
            if([data objectForKey:@"userId"] !=  nil)
            {
                [CommonData setTencentUserId:[data objectForKey:@"userId"]];
            }
            if([data objectForKey:@"sid"] !=  nil)
            {
                [CommonData setSid:[data objectForKey:@"sid"]];
            }
            if ([data objectForKey:@"uid"] != nil) {
                [CommonData setUid:[data objectForKey:@"uid"]];
            }
            if ([data objectForKey:@"money"] != nil) {
                [CommonData setMoney:[data objectForKey:@"money"]];
            }
            
        }
    }
    
}

-(void) createTables
{
    [UserDao createUser];
    [CollectionDao createCollection];
    [SettingDAO createSetting];
}





- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    
}
-(void) didReceiveWeiboRequest:(WBBaseRequest *)request
{
    //  MEViewController *controller = [[[MEViewController alloc] init] autorelease];
    //  [self.viewController presentModalViewController:controller animated:YES];
}

- (void)didReceiveWeiboResponse:(WBBaseResponse *)response
{
    int resultCode = response.statusCode;
    if ([response isKindOfClass:WBAuthorizeResponse.class]) {
        if(resultCode == 0){
            NSString *userID = [(WBAuthorizeResponse *) response userID];
            NSString *accessToken =  [(WBAuthorizeResponse *) response accessToken];
            [CommonData setUserId:userID];
            [CommonData setAccessToken:accessToken];
            NSDictionary *userDic;
            NSDictionary *data = [UserDao getUserInfoById:userID];
            BOOL insertResult;
            if(data != nil){
                [self requestServerUserId:userID];
                userDic = [[NSDictionary alloc] initWithObjectsAndKeys:userID,@"userId",accessToken,@"accessToken",@"1",@"type", nil];
                insertResult =  [UserDao updateUserInfo:userDic byuserId:userID];
                [CommonData setSid:[data objectForKey:@"sid"]];
                [CommonData setUid:[data objectForKey:@"uid"]];
            }else{
                userDic = [[NSDictionary alloc] initWithObjectsAndKeys:userID,@"userId",accessToken,@"accessToken",@"1",@"type",@"0",@"money", nil];
                insertResult =  [UserDao insertUserWithUserId:userDic];
                if(insertResult){
                    [self requestServerUserId:userID];
                }else{
                    NSLog(@"log in failure");
                }
            }
            [userDic release];
            
        }else{
            NSLog(@"log in failure");
        }
        
    }else if([response isKindOfClass:WBSendMessageToWeiboResponse.class]){
        UIAlertView *alert = nil;
        if(resultCode == 0){
            alert =[[UIAlertView alloc]initWithTitle:@"" message:@"分享成功" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            [alert show];
        }else{
            alert   =[[UIAlertView alloc]initWithTitle:@"" message:@"分享失败" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            [alert show];
        }
        [alert release];
        
    }
    
}

-(void) getSid:(NSString *) userId withAccessToken:(NSString *) accessToken withType:(NSString *) type
{
    
    
}

-(void) requestServerUserId:(NSString *) userId{
    NSString *differentTimeStr = [CommonData getDifferentTime];
    NSLog(@"differentTime=%@",differentTimeStr);
    long long differentTime =[differentTimeStr longLongValue];
    long long clientTime = [[NSDate date] timeIntervalSince1970]*1000 + differentTime;
    NSString *plainText = [[NSNumber numberWithLongLong:clientTime]stringValue];
    //
    NSLog(@"plainText=%@",plainText);
    NSString *seed = [DesEncrypt encryptUseDES:plainText key:deskey];
    NSLog(@"seed = %@",seed);
    NSString *url = [serverUrl stringByAppendingFormat:@"act=SINA_USER_LOGIN&sinaId=%@&seed=%@",userId,seed];
    NSURL *nsURL = [NSURL URLWithString:url];
    request = [ASIFormDataRequest requestWithURL:nsURL];
    request.delegate = self;
    [request startSynchronous];
    
    
}
-(void) requestFinished:(ASIHTTPRequest *)_request
{
    JSONDecoder *jsonDecoder = [[JSONDecoder alloc] init];
    NSData *data = [_request responseData];
    NSDictionary *dic =  [jsonDecoder objectWithData:data];
    
    NSString *resultCode = [dic objectForKey: @"state"];
    if([resultCode isEqualToString:@"SUCCESS"]){
        NSString *_sid = [dic objectForKey:@"sid"];
        NSString *uid = nil;
        NSDictionary *data =[dic objectForKey:@"data"];
        [CommonData setSid:_sid];
        if ( data != nil) {
            uid = [data objectForKey:@"id"];
            [CommonData setUid:uid];
        }
        NSDictionary *paramdata = [[NSDictionary alloc] initWithObjectsAndKeys:_sid,@"sid",uid,@"uid", nil];
        BOOL updateResult = [UserDao updateUserInfo:paramdata byuserId:[CommonData getUserId]];
        UIAlertView *alert = nil;
        if(updateResult){
            alert =[[UIAlertView alloc]initWithTitle:@"" message:@"登录成功" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            [alert show];
        }else{
            alert=[[UIAlertView alloc]initWithTitle:@"" message:@"登录失败" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            [alert show];
        }
        sid = [CommonData getSid];
        [alert release];
        [paramdata release];
    }else{
        NSLog(@"登录失败");
    }
    [jsonDecoder release];
    
    
}
-(void) requestFailed:(ASIHTTPRequest *)request
{
    NSLog(@"请求失败");
}


#pragma mark TencentEvent
/*- (void)successLogin:(id)sender
 {
 
 NSString *accessToken = tencentEngine.accessToken;
 [CommonData setTencentUserId:@"123456"];
 [CommonData setTencentAccessToken:accessToken];
 UIAlertView *alert = nil;
 NSDictionary *userDic = [[NSDictionary alloc] initWithObjectsAndKeys:@"123456",@"userId",accessToken,@"accessToken",@"2",@"type", nil];
 BOOL createResult =  [UserDao createUser];
 if(createResult){
 BOOL insertResult =  [UserDao insertUserWithUserId:userDic];
 if(insertResult){
 alert =[[UIAlertView alloc]initWithTitle:@"" message:@"登录成功" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
 [alert show];
 
 }else{
 alert=[[UIAlertView alloc]initWithTitle:@"" message:@"登录失败" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
 [alert show];
 }
 }else{
 UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:@"登录失败" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
 [alert show];
 }
 [alert release];
 [userDic release];
 
 }
 
 - (void)failureLogin:(id)sender
 {
 NSLog(@"tencent login fail");
 }*/



/*- (BOOL) application:(UIApplication *)application handleOpenURL:(NSURL *)url
 {
 return [WeiboSDK handleOpenURL:url delegate:self];
 }*/

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    
    NSLog(@"%@",[url scheme]);
    if([[url scheme] isEqualToString:@"wb3236027186"]){
        return [WeiboSDK handleOpenURL:url delegate:self];
    }else{
        return [ShareSDK handleOpenURL:url
                     sourceApplication:sourceApplication
                            annotation:annotation
                            wxDelegate:self];
    }
}


- (BOOL)application:(UIApplication *)application  handleOpenURL:(NSURL *)url
{
    NSLog(@"%@",[url scheme]);
    return [ShareSDK handleOpenURL:url
                        wxDelegate:self];
}



-(void)dealloc
{
    [me release];
    [tabBarController release];
    [wx release];
    [super dealloc];
    
}


@end
