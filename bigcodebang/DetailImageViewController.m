//
//  DetailImageViewController.m
//  BigBand
//
//  Created by nelson on 14-7-15.
//  Copyright (c) 2014年 ioschen. All rights reserved.
//

#import "DetailImageViewController.h"
#import "UIImageView+WebCache.h"

@interface DetailImageViewController ()

@end

@implementation DetailImageViewController
@synthesize picUrl;
@synthesize picImageView;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UILabel *topLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 15)];
    topLabel.backgroundColor = [UIColor colorWithRed:12/255.0 green:134/255.0 blue:243/255.0 alpha:1.0f];
    [self.view addSubview:topLabel];
    [topLabel release];
    UILabel *recommandLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 15, 320, 45)];
    recommandLabel.backgroundColor =  [UIColor colorWithRed:12/255.0 green:134/255.0 blue:243/255.0 alpha:1.0f];
    recommandLabel.text = @"图片详情";
    recommandLabel.textColor = [UIColor whiteColor];
    recommandLabel.textAlignment = NSTextAlignmentCenter;
    recommandLabel.font = [UIFont systemFontOfSize:25];
    [self.view addSubview:recommandLabel];
    [recommandLabel release];
    UIButton *back = [UIButton buttonWithType:UIButtonTypeCustom];
    back.frame = CGRectMake(10, 20, 30, 30);
    [back setImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
    [back addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:back];
    UIButton *save = [UIButton buttonWithType:UIButtonTypeCustom];
    save.frame = CGRectMake(250, 20, 50, 30);
    [save setTitle:@"保存" forState:UIControlStateNormal];
    [save setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [save addTarget:self action:@selector(savePic:) forControlEvents:UIControlEventTouchUpInside];
     [self.view addSubview:save];
    roation = 0;
    scale = 1;
    [picImageView setImageWithURL:[NSURL URLWithString:picUrl] placeholderImage:[UIImage imageNamed:@"13.png"]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)back:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (IBAction)savePic:(id)sender {
    UIImageWriteToSavedPhotosAlbum(picImageView.image, self, @selector(imageSavedToPhotosAlbum: didFinishSavingWithError: contextInfo:), nil);
}

- (void)imageSavedToPhotosAlbum:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *) contextInfo
{
    NSString *message;
    NSString *title;
    if (!error) {
        title = @"成功提示";
        message = @"成功保存到相册";
    } else {
        title = @"失败提示";
        message = [error description];
    }
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                    message:message
                                                   delegate:nil
                                          cancelButtonTitle:@"知道了"
                                          otherButtonTitles:nil];
    [alert show];
    [alert release];
}
- (void)dealloc {
    [picImageView release];
    [super dealloc];
}
- (IBAction)leftRotate:(id)sender {
    [UIView animateWithDuration:0.5f animations:^{
        roation -= M_PI_2;
        picImageView.transform = CGAffineTransformMakeRotation(roation);
    }];
}

- (IBAction)rightRote:(id)sender {
    [UIView animateWithDuration:0.5f animations:^{
        roation += M_PI_2;
        picImageView.transform = CGAffineTransformMakeRotation(roation);
    }];
}

- (IBAction)zoomOut:(id)sender {
    [UIView animateWithDuration:0.5f animations:^{
        scale*=1.5;
        [picImageView.layer setAnchorPoint:CGPointMake(0.5, 0.5)];
        picImageView.transform = CGAffineTransformMakeScale(scale,scale);
    }];
}

- (IBAction)zoomIn:(id)sender {
    [UIView animateWithDuration:0.5f animations:^{
        scale/=1.5;
        picImageView.transform = CGAffineTransformMakeScale(scale,scale);
    }];
}
@end
