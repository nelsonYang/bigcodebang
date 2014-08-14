//
//  WXViewController.h
//  weChatDemo
//
//  Created by ioschen on 8/16/13.
//  Copyright (c) 2013 ioschen. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AppDelegate;


@interface RecommandViewController: UIViewController
{
    AppDelegate *_appDel;
}

- (IBAction)search:(id)sender;
@end
