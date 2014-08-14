//
//  BindZhiFuBaoViewController.h
//  BigBand
//
//  Created by nelson on 14-7-19.
//  Copyright (c) 2014年 ioschen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BindZhiFuBaoViewController : UIViewController<UITextFieldDelegate>

- (IBAction)save:(id)sender;
- (IBAction)back:(id)sender;
@property (retain, nonatomic) IBOutlet UITextField *account;
@property (retain, nonatomic) IBOutlet UITextField *accountName;
@property (retain,nonatomic) IBOutlet UITextField *telephone;

@end
