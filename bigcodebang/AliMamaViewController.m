//
//  AliMamaViewController.m
//  BigBand
//
//  Created by nelson on 14-7-19.
//  Copyright (c) 2014年 ioschen. All rights reserved.
//

#import "AliMamaViewController.h"
#import "Dialog.h"
#import "Macro.h"

@interface AliMamaViewController (){
     Dialog *dialog;
}
@end

@implementation AliMamaViewController
@synthesize alimamaWebView;
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
    recommandLabel.text = @"天天特价";
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
    dialog = [[Dialog alloc] init];
    NSString *url = @"http://m.taobao.com/channel/chn/mobile/tejia_taoke.php?pid=mm_57496364_7198170_24010924";
    self.alimamaWebView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 60, 320,screenHeight - 60.0f)];
    self.alimamaWebView.delegate = self;
    self.alimamaWebView.scalesPageToFit = YES;
    [self.view addSubview:self.alimamaWebView];
    [dialog showProgress:self withLabel:@"天天特价加载中..."];
    [self.alimamaWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]]];
    [self.alimamaWebView setDelegate:self];
}

#pragma mark UIWebViewDelegate

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    return YES;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [dialog hideProgress];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [dialog hideProgress];
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [alimamaWebView release];
    [dialog release];
 
    [super dealloc];
}
- (IBAction)back:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}
@end
