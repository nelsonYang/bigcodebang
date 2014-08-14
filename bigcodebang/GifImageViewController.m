//
//  GifImageViewController.m
//  bigcodebang
//
//  Created by nelson on 14-8-13.
//  Copyright (c) 2014年 bigcodebang. All rights reserved.
//

#import "GifImageViewController.h"
#import "Macro.h"
#import "Dialog.h"

@interface GifImageViewController ()
@property(strong,nonatomic) UIWebView *gifWebView;
@property (strong,nonatomic) Dialog *dialog;
@end

@implementation GifImageViewController

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
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor = [UIColor blackColor];
 
    self.gifWebView =[[UIWebView alloc] initWithFrame:CGRectMake(0, 150, screenWidth,screenHeight-280)];
    self.gifWebView.delegate = self;
  
    self.gifWebView.scalesPageToFit = YES;
    [self.view addSubview:self.gifWebView];
    [self.gifWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:_picUrl]]];
    self.dialog =[[Dialog alloc]init];
    [self.dialog showProgress:self withLabel:@"图片加载中..."];
    self.gifWebView.delegate = self;
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
     button.frame = CGRectMake(0, 150, screenWidth, screenHeight-280);
     [button addTarget:self action:@selector(back:) forControlEvents:UIControlEventAllTouchEvents];
   // button.backgroundColor = [UIColor blackColor];
    [self.view addSubview:button];
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

#pragma mark UIWebViewDelegate

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
     [self.dialog hideProgress];
    return YES;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
     [self.dialog hideProgress];
  
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
     [self.dialog hideProgress];
}


@end
