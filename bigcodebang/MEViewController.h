//
//  MEViewController.h
//  weChatDemo
//
//  Created by ioschen on 8/16/13.
//  Copyright (c) 2013 ioschen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WeiboSDK.h"
//#import "CLYAppDelegate.h"

@interface MEViewController : UIViewController<UITableViewDataSource,UITabBarDelegate,WBHttpRequestDelegate,UITableViewDelegate>
{
    UITableView *medataTable;
    NSMutableArray *dataArray1; //定义数据数组1
    NSMutableArray *dataArray2;//定义数据数组2
    NSMutableArray *dataArray3; //定义数据数组3
    NSMutableArray *dataIcon1; //定义数据数组1
    NSMutableArray *dataIcon2;//定义数据数组2
    NSMutableArray *dataIcon3; //定义数据数组3

}


@property(strong,nonatomic) NSString* userId;

@end
