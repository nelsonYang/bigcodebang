//
//  AppDelegate.h
//  bigcodebang
//
//  Created by nelson on 14-7-27.
//  Copyright (c) 2014年 bigcodebang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <UIKit/UIKit.h>
#import "WeiboSDK.h"
#import "RecommandViewController.h"
#import "MEViewController.h"
#import "ASIFormDataRequest.h"
#import "ServiceViewController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate,WeiboSDKDelegate,WBHttpRequestDelegate>


@property (strong, nonatomic) UIWindow *window;
@property (strong,nonatomic) RecommandViewController *wx;
@property (strong,nonatomic) MEViewController *me;
@property (strong,nonatomic) ServiceViewController *service;
@property (strong,nonatomic) UITabBarController *tabBarController;
@property (strong,nonatomic) NSString *sid;
@property (strong,nonatomic) ASIFormDataRequest *request;


@end
