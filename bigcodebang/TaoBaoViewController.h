//
//  TaoBaoViewController.h
//  BigBand
//
//  Created by nelson on 14-7-19.
//  Copyright (c) 2014年 ioschen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TaoBaoViewController : UIViewController<UIWebViewDelegate>
- (IBAction)back:(id)sender;
@property (retain, nonatomic) IBOutlet UIWebView *taobaoWebView;

@end
