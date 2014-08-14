//
//  AliMamaViewController.h
//  BigBand
//
//  Created by nelson on 14-7-19.
//  Copyright (c) 2014年 ioschen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AliMamaViewController : UIViewController<UIWebViewDelegate>
@property (retain, nonatomic) IBOutlet UIWebView *alimamaWebView;

- (IBAction)back:(id)sender;

@end
