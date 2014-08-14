//
//  TaoBaoViewController.m
//  BigBand
//
//  Created by nelson on 14-7-19.
//  Copyright (c) 2014年 ioschen. All rights reserved.
//

#import "TaoBaoViewController.h"
#import "Dialog.h"
#import "Macro.h"
#import "SettingDAO.h"
@interface TaoBaoViewController (){
    Dialog *dialog;
}

@end

@implementation TaoBaoViewController
@synthesize taobaoWebView;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:@"TaoBaoViewController" bundle:nibBundleOrNil];
    if (self) {
        
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
    recommandLabel.text = @"淘宝精选推荐";
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
    dialog =[[Dialog alloc]init];
    self.taobaoWebView =[[UIWebView alloc] initWithFrame:CGRectMake(0, 60, 320,screenHeight - 60.0f)];
    self.taobaoWebView.delegate = self;
    self.taobaoWebView.scalesPageToFit = YES;
    [self.view addSubview:self.taobaoWebView];
    [dialog showProgress:self withLabel:@"淘宝精选加载中...."];
    NSString *url = @"http://ai.m.taobao.com/?pid=mm_57496364_7198170_24026043";
    [self.taobaoWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]]];
    self.taobaoWebView.delegate = self;
    // Do any additional setup after loading the view from its nib.
}

#pragma mark UIWebViewDelegate

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    return YES;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [dialog hideProgress];
    NSDictionary *data = [SettingDAO getSetting];
    if(data != nil){
        
    }else{
      //  NSDictionary *data =[NSDictionary alloc] initWithObjectsAndKeys:<#(id), ...#>, nil];
       // [SettingDAO insertSetting:data];
    }
    
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

- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)dealloc {
    [dialog release];
    [taobaoWebView release];
    [super dealloc];
}
@end
