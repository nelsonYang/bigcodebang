//
//  MyInfoViewController.h
//  BigBand
//
//  Created by nelson on 14-7-5.
//  Copyright (c) 2014年 ioschen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyInfoViewController : UIViewController
{
    UITableView *myInfoTableView;
}
@property (retain, nonatomic) IBOutlet UITableView *myInfoTableView;

- (IBAction)back:(id)sender;


@end
