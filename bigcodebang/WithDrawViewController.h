//
//  WithDrawViewController.h
//  BigBand
//
//  Created by nelson on 14-7-19.
//  Copyright (c) 2014年 ioschen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WithDrawViewController : UIViewController
@property (retain, nonatomic) IBOutlet UIPickerView *moneyPick;
- (IBAction)withdraw:(id)sender;
- (IBAction)back:(id)sender;

@end
