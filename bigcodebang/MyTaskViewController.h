//
//  MyTaskViewController.h
//  BigBand
//
//  Created by nelson on 14-7-13.
//  Copyright (c) 2014年 . All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyTaskViewController : UIViewController

@property (retain, nonatomic) IBOutlet UILabel *integrationLable;
- (IBAction)refresh:(id)sender;
- (IBAction)openWall:(id)sender;
- (IBAction)back:(id)sender;
- (IBAction)withDraw:(id)sender;

@end
