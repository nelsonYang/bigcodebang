//
//  DetailImageViewController.h
//  BigBand
//
//  Created by nelson on 14-7-15.
//  Copyright (c) 2014年 ioschen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailImageViewController : UIViewController
{
    
    CGFloat roation;
    CGFloat scale;
}
@property(strong,nonatomic) NSString *picUrl;
- (IBAction)back:(id)sender;
- (IBAction)savePic:(id)sender;
@property (retain, nonatomic) IBOutlet UIImageView *picImageView;
- (IBAction)leftRotate:(id)sender;
- (IBAction)rightRote:(id)sender;
- (IBAction)zoomOut:(id)sender;
- (IBAction)zoomIn:(id)sender;

@end
