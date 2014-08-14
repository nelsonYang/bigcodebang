//
//  ServiceViewController.h
//  BigBand
//
//  Created by nelson on 14-7-27.
//  Copyright (c) 2014年 ioschen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WeiboSDK.h"

@interface ServiceViewController : UIViewController<UITableViewDataSource,UITabBarDelegate,WBHttpRequestDelegate,UITableViewDelegate>
{
    NSMutableArray *dataArray1;
    NSMutableArray *dataIcon1;
    NSMutableArray *dataArray2;
    NSMutableArray *dataIcon2;
    NSMutableArray *dataArray3;
    NSMutableArray *dataIcon3;
    UITableView *serviceTable;
 
}

@end
