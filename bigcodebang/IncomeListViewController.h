//
//  IncomeListViewController.h
//  BigBand
//
//  Created by nelson on 14-7-20.
//  Copyright (c) 2014年 ioschen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IncomeListViewController : UIViewController
- (IBAction)back:(id)sender;
@property (retain, nonatomic) IBOutlet UITableView *incomeDataView;

@end
