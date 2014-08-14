//
//  ExchangeViewController.m
//  bigcodebang
//
//  Created by nelson on 14-8-6.
//  Copyright (c) 2014年 bigcodebang. All rights reserved.
//

#import "ExchangeViewController.h"
#import "CommonData.h"
#import "BindZhiFuBaoViewController.h"
#import "WithDrawViewController.h"
#import "UserDao.h"
#import "TelChargeViewController.h"

@interface ExchangeViewController ()

@end

@implementation ExchangeViewController

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
    recommandLabel.text = @"兑换";
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
    
    UILabel *moneyLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 65, 320, 30)];
   // moneyLabel.layer.borderWidth = 0.5f;
    //moneyLabel.layer.borderColor = [UIColor grayColor].CGColor;
    moneyLabel.text = [NSString stringWithFormat:@"当前积分:%@",[CommonData getMoneny]];
    moneyLabel.textColor = [UIColor redColor];
    moneyLabel.textAlignment = NSTextAlignmentCenter;
    moneyLabel.font = [UIFont systemFontOfSize:14.0f];
    [self.view addSubview:moneyLabel];
    [moneyLabel release];
    
    UILabel *descLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 95, 280, 80)];
   // descLabel.layer.borderWidth = 0.5f;
    //descLabel.layer.borderColor = [UIColor grayColor].CGColor;
    descLabel.text = @"     提现说明：如果选择支付宝提现将扣除10%的税收，如果选择电话将不扣除税收，税收由平台支付。";
    descLabel.numberOfLines = 3;
    descLabel.textColor = [UIColor redColor];
    descLabel.textAlignment = NSTextAlignmentLeft;
    descLabel.font = [UIFont systemFontOfSize:16];
    [self.view addSubview:descLabel];
    [descLabel release];
    
    UIButton *withDrawButton = [UIButton buttonWithType:UIButtonTypeCustom];
    withDrawButton.frame = CGRectMake(20, 190, 130, 100);
    //withDrawButton.backgroundColor = [UIColor colorWithRed:12/255.0 green:134/255.0 blue:243/255.0 alpha:1.0f];
    [withDrawButton setImage:[UIImage imageNamed:@"alipay.png"] forState:(UIControlStateNormal)];
   // [withDrawButton setTitle:@"支付宝提现" forState:UIControlStateNormal];
    [withDrawButton addTarget:self action:@selector(withDraw:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:withDrawButton];
    
    
    
    UIButton *telephoneChargeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    telephoneChargeButton.frame = CGRectMake(160, 190, 130, 100);
    //telephoneChargeButton.backgroundColor = [UIColor colorWithRed:12/255.0 green:134/255.0 blue:243/255.0 alpha:1.0f];
    //[telephoneChargeButton setTitle:@"手机充值" forState:UIControlStateNormal];
     [telephoneChargeButton setImage:[UIImage imageNamed:@"phone_recharge.png"] forState:(UIControlStateNormal)];
    [telephoneChargeButton addTarget:self action:@selector(telCharge:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:telephoneChargeButton];
    
    
    // Do any additional setup after loading the view from its nib.
}

-(void) back:(id) sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void) withDraw:(id) sender
{
    NSDictionary *userInfo = [UserDao getUserInfoBySid:[CommonData getSid]];
    NSString *flag = @"0";
    NSString *account =[userInfo objectForKey:@"account"];
    
    if(account != nil){
        flag = @"1";
    }
    if([flag isEqualToString:@"1"]){
        WithDrawViewController *wdv = [[[WithDrawViewController alloc] init]autorelease];
        [self.navigationController pushViewController:wdv animated:YES];
    }else{
        BindZhiFuBaoViewController *bzfbv = [[[BindZhiFuBaoViewController alloc] init]autorelease];
        [self.navigationController pushViewController:bzfbv animated:YES];
    }
}

-(void) telCharge:(id) sender
{
    TelChargeViewController *telVC = [[[TelChargeViewController alloc] init]autorelease];
    [self.navigationController pushViewController:telVC animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
