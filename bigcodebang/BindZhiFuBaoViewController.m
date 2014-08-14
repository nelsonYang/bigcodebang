//
//  BindZhiFuBaoViewController.m
//  BigBand
//
//  Created by nelson on 14-7-19.
//  Copyright (c) 2014年 ioschen. All rights reserved.
//

#import "BindZhiFuBaoViewController.h"
#import "WithDrawViewController.h"
#import "WeiboSDK.h"
#import "CommonData.h"
#import "Macro.h"
#import "UserDao.h"
#import "ALToastView.h"
@interface BindZhiFuBaoViewController ()

@end

@implementation BindZhiFuBaoViewController
@synthesize account;
@synthesize accountName;
@synthesize telephone;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [account setDelegate:self];
    [accountName setDelegate:self];
    [telephone setDelegate:self];
    UILabel *topLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 15)];
    topLabel.backgroundColor = [UIColor colorWithRed:12/255.0 green:134/255.0 blue:243/255.0 alpha:1.0f];
    [self.view addSubview:topLabel];
    [topLabel release];
    UILabel *recommandLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 15, 320, 45)];
    recommandLabel.backgroundColor =  [UIColor colorWithRed:12/255.0 green:134/255.0 blue:243/255.0 alpha:1.0f];
    recommandLabel.text = @"绑定支付宝";
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
    
    UIButton *saveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    saveBtn.frame = CGRectMake(250, 20, 50, 30);
    [saveBtn setTitle:@"保存" forState:UIControlStateNormal];
    [saveBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [saveBtn addTarget:self action:@selector(save:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:saveBtn];
    
     UILabel *accountLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 80, 100, 45)];
    accountLabel.text = @"*支付宝账号:";
    accountLabel.font = [UIFont systemFontOfSize:16.0f];
    [self.view addSubview:accountLabel];
    [accountLabel release];
    
    account = [[UITextField alloc] initWithFrame:CGRectMake(120, 80, 150, 45)];
    account.font = [UIFont systemFontOfSize:16.0f];
    account.borderStyle = UITextBorderStyleRoundedRect;
    [account setReturnKeyType:UIReturnKeyDone];
    account.delegate = self;
    [self.view addSubview:account];
    [account release];
    
    UILabel *accountNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 135, 100, 45)];
    accountNameLabel.text = @"*支付宝姓名:";
    accountNameLabel.font = [UIFont systemFontOfSize:16.0f];
    [self.view addSubview:accountNameLabel];
    [accountNameLabel release];
    
    
    accountName = [[UITextField alloc] initWithFrame:CGRectMake(120, 135, 150, 45)];
    accountName.font = [UIFont systemFontOfSize:16.0f];
    [accountName setReturnKeyType:UIReturnKeyDone];
    accountName.borderStyle = UITextBorderStyleRoundedRect;
    accountName.delegate = self;
    [self.view addSubview:accountName];
    [accountName release];
    
    UIButton *saveBottomBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    saveBottomBtn.frame = CGRectMake(80, 190, 150, 45);
    saveBottomBtn.backgroundColor =[UIColor colorWithRed:12/255.0 green:134/255.0 blue:243/255.0 alpha:1.0f];
    [saveBottomBtn setTitle:@"保存" forState:UIControlStateNormal];
    [saveBottomBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [saveBottomBtn addTarget:self action:@selector(save:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:saveBottomBtn];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(BOOL) textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (IBAction)save:(id)sender {
    if([CommonData getUid] != nil){
        if(account.text != nil && ![account.text isEqualToString:@""] && accountName != nil && ![accountName.text isEqualToString:@""]){
        NSDictionary *data = [[NSDictionary alloc]initWithObjectsAndKeys:accountName.text, @"accountName",account.text,@"account",nil];
       BOOL result = [UserDao updateUserInfo:data bySid:[CommonData getSid]];
        [data release];
        if(result){
            [CommonData setBindAccountFlag:@"1"];
            WithDrawViewController *wdv = [[[WithDrawViewController alloc] init]autorelease];
            [self.navigationController pushViewController:wdv animated:YES];
        }else{
            
            [ALToastView toastInView:self.view withText:@"绑定支付宝失败"];
        }
        }else{
            [ALToastView toastInView:self.view withText:@"请输入账号和姓名"];
        }
    }else{
        [self sinaweiboLogIn];
    }
}

-(void) sinaweiboLogIn
{
    WBAuthorizeRequest *sinarequest = [WBAuthorizeRequest request];
    sinarequest.redirectURI = sinaRedirectURI;
    sinarequest.scope = @"all";
    [WeiboSDK sendRequest:sinarequest];
}

- (IBAction)back:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)dealloc {
    [account release];
    [accountName release];
    [super dealloc];
}
@end
