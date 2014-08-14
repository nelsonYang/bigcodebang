//
//  QQViewController.m
//  bigcodebang
//
//  Created by nelson on 14-8-10.
//  Copyright (c) 2014年 bigcodebang. All rights reserved.
//

#import "QQViewController.h"

@interface QQViewController ()

@end

@implementation QQViewController

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
    recommandLabel.text = @"客服QQ";
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
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(20, 100, 280, 80)];
    bgView.layer.borderWidth = 0.5f;
    bgView.layer.borderColor = [UIColor grayColor].CGColor;
    UILabel *messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 5, 270, 30)];
     messageLabel.text =@"有任何问题请联系客服";
    messageLabel.font = [UIFont systemFontOfSize:14.0f];
    messageLabel.textAlignment = NSTextAlignmentCenter;
    messageLabel.textColor = [UIColor grayColor];
    [bgView addSubview:messageLabel];
    [messageLabel release];
    UILabel *messageLabel2 = [[UILabel alloc] initWithFrame:CGRectMake(5, 40, 270, 30)];
    messageLabel2.text =@"3029267837";
    messageLabel2.textAlignment = NSTextAlignmentCenter;
    messageLabel2.font = [UIFont systemFontOfSize:16.0f];
    messageLabel2.textColor = [UIColor redColor];
    [bgView addSubview:messageLabel2];
    [messageLabel2 release];
    [self.view addSubview:bgView];
    [bgView release];
    // Do any additional setup after loading the view from its nib.
}

-(void) back:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
