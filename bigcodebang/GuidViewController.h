//
//  GuidViewController.h
//  BigBand
//
//  Created by nelson on 14-7-26.
//  Copyright (c) 2014年 ioschen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIImage+SplitImageIntoTwoParts.h"

@interface GuidViewController : UIViewController<UIScrollViewDelegate>
@property (nonatomic,strong) IBOutlet UIImageView *imageView;
@property (nonatomic,strong) UIImageView *left;
@property (nonatomic,strong) UIImageView *right;

@property (retain, nonatomic) IBOutlet UIScrollView *pageScroll;
@property (retain, nonatomic) IBOutlet UIPageControl *pageControl;

- (IBAction)gotoMainView:(id)sender;
@property (retain, nonatomic) IBOutlet UIButton *gotoMainViewBtn;
@end
