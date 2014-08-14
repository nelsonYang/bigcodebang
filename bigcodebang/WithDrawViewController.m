//
//  WithDrawViewController.m
//  BigBand
//
//  Created by nelson on 14-7-19.
//  Copyright (c) 2014年 ioschen. All rights reserved.
//

#import "WithDrawViewController.h"
#import "WeiboSDK.h"
#import "CommonData.h"
#import "Macro.h"
#import  "ALToastView.h"
#import "UserDao.h"
#import  "IncomeListViewController.h"
#import "ASIFormDataRequest.h"
#import "DesEncrypt.h"
#import "DMOfferWallManager.h"
#import "DMOfferWallViewController.h"
#import "JSONKit.h"

@interface WithDrawViewController ()<UIPickerViewDataSource,DMOfferWallManagerDelegate,UIPickerViewDelegate>
@property(assign,nonatomic) NSInteger mount;
@property (strong,nonatomic) NSArray *data;
@property(strong,nonatomic) ASIHTTPRequest *request;
@property (nonatomic, strong) DMOfferWallManager *dmManager;
@property (nonatomic,strong) DMOfferWallViewController * dmWallVC;
@property (nonatomic,strong) NSString *accountNO;
@end

@implementation WithDrawViewController
@synthesize mount;
@synthesize moneyPick;
@synthesize data;
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
    
    
    self.dmManager = [[DMOfferWallManager alloc] initWithPublishId:kAppSec];
    self.dmManager.delegate = self;
    self.dmWallVC = [[DMOfferWallViewController alloc] initWithPublisherID:kAppSec andUserID:[CommonData getUid]];
    UILabel *topLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 15)];
    topLabel.backgroundColor = [UIColor colorWithRed:12/255.0 green:134/255.0 blue:243/255.0 alpha:1.0f];
    [self.view addSubview:topLabel];
    [topLabel release];
    UILabel *recommandLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 15, 320, 45)];
    recommandLabel.backgroundColor =  [UIColor colorWithRed:12/255.0 green:134/255.0 blue:243/255.0 alpha:1.0f];
    recommandLabel.text = @"提现";
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
    
    
    moneyPick = [[UIPickerView alloc] initWithFrame:CGRectMake(40, 100, 240, 80)];
    moneyPick.showsSelectionIndicator = YES;
    //moneyPick.layer.borderWidth = 0.3f;
    //moneyPick.layer.borderColor = [UIColor grayColor].CGColor;
    moneyPick.backgroundColor = [UIColor colorWithRed:12/255.0 green:134/255.0 blue:243/255.0 alpha:0.1f];
    moneyPick.delegate = self;
    moneyPick.dataSource = self;
    //  moneyPick.backgroundColor =[UIColor colorWithRed:12/255.0 green:134/255.0 blue:243/255.0 alpha:1.0f];
    [self.view addSubview:moneyPick];
    
    
    UIButton *withdrawBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    withdrawBtn.frame = CGRectMake(40, 280, 240, 45);
    withdrawBtn.backgroundColor =[UIColor colorWithRed:12/255.0 green:134/255.0 blue:243/255.0 alpha:1.0f];
    [withdrawBtn setTitle:@"提现" forState:UIControlStateNormal];
    [withdrawBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [withdrawBtn addTarget:self action:@selector(withdraw:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:withdrawBtn];
    
    data = [[NSArray alloc] initWithObjects:@"20(元)-2000(积分)",@"30(元)-3000(积分)",@"50(元)-5000(积分)",@"100(元)-10000(积分)", nil];
    //,@"20话费-2000(积分)",@"30话费-3000(积分)",@"50话费-5000(积分)",@"100话费-10000(积分)"
    [super viewDidLoad];
}

-(NSInteger) numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}
-(NSInteger) pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return [data count];
}
-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    return [data objectAtIndex:row];
    
}
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{
    return  45.0f;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [moneyPick release];
    [data release];
    [self.dmManager release];
    [self.dmWallVC release];
    [super dealloc];
}
- (IBAction)withdraw:(id)sender {
    NSInteger row = [moneyPick selectedRowInComponent:0];
    if(row == 0){
        mount = 2000;
    }else if(row ==1){
        mount = 3000;
    }else if(row == 2){
        mount = 5000;
    }else if(row ==3){
        mount = 10000;
    }
    if([[CommonData getMoneny] intValue] >= mount){
        if([CommonData getUid] == nil){
            [self sinaweiboLogIn];
        }else{
            NSDictionary *userData = [UserDao getUserInfoById:[CommonData getUid]];
            NSString *account = [userData objectForKey:@"account"];
            NSString *accountName =[userData objectForKey:@"accountName"];
            [self requestWithDraw:account withName:accountName withMount:mount withUid:[CommonData getUid]];
        }
    }else{
        [ALToastView toastInView:self.view withText:@"积分不足，继续努力"];
    }
}

-(void) requestWithDraw:(NSString*) account withName:(NSString *)accountName withMount:(NSInteger) amount withUid:(NSString*) uid
{
    
    [self.dmManager requestOnlineConsumeWithPoint:amount];
    _accountNO = account;
    
}

-(void) requestFinished:(ASIHTTPRequest *) request
{
    JSONDecoder *jsonDecoder = [[JSONDecoder alloc] init];
    NSData *responseData = [request responseData];
    NSDictionary *dic =  [jsonDecoder objectWithData:responseData];
    
    NSString *resultCode = [dic objectForKey: @"state"];
   if([resultCode isEqualToString: @"SUCCESS"]){
    BOOL result =[UserDao consumeMoney:mount byUid:[CommonData getUid]];
    if(result){
        float money = [[CommonData getMoneny]  floatValue] - mount;
        [CommonData setMoney:[NSString stringWithFormat:@"%f",money]];
        UIAlertView *alert =[[UIAlertView alloc]initWithTitle:@"" message:@"查看订单信息请登入http://www.bigcodebang.com网站查看." delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alert show];
        [alert release];
        //IncomeListViewController *incomeList = [[[IncomeListViewController alloc]init   ] autorelease];
        //[self.navigationController pushViewController:incomeList animated:YES];
    }else{
        [ALToastView toastInView:self.view withText:@"提现失败"];
    }
   }else{
         [ALToastView toastInView:self.view withText:@"提现失败"];
   }
    [jsonDecoder release];
    
}

#pragma mark DMWallDelegate
- (void)offerWallDidFinishCheckPointWithTotalPoint:(NSInteger)totalPoint
                             andTotalConsumedPoint:(NSInteger)consumed;
{
    
}

- (void)offerWallDidFailCheckPointWithError:(NSError *)error
{
    
}

- (void)offerWallDidFinishConsumePointWithStatusCode:(DMOfferWallConsumeStatusCode)statusCode
                                          totalPoint:(NSInteger)totalPoint
                                  totalConsumedPoint:(NSInteger)consumed
{
    if (statusCode == DMOfferWallConsumeStatusCodeSuccess) {
        NSString *differentTimeStr = [CommonData getDifferentTime];
        NSLog(@"differentTime=%@",differentTimeStr);
        long long differentTime =[differentTimeStr longLongValue];
        long long clientTime = [[NSDate date] timeIntervalSince1970]*1000 + differentTime;
        NSString *plainText = [[NSNumber numberWithLongLong:clientTime]stringValue];
        //
        NSLog(@"plainText=%@",plainText);
        NSString *seed = [DesEncrypt encryptUseDES:plainText key:deskey];
        NSLog(@"seed = %@",seed);
        NSString *url = [serverUrl stringByAppendingFormat:@"act=ORDER_FOR_MONEY_FROM_IOS&sid=%@&seed=%@&zfb=%@&iosPoint=%d",[CommonData getSid],seed,_accountNO,mount];
        NSURL *nsURL = [NSURL URLWithString:url];
        _request = [ASIFormDataRequest requestWithURL:nsURL];
        _request.delegate = self;
        [_request startSynchronous];
        
    }else{
        [ALToastView toastInView:self.view withText:@"提现失败"];
    }
}

- (void)offerWallDidFailConsumePointWithError:(NSError *)error
{
    
}

- (void)offerWallDidCheckEnableState:(BOOL)enable
{
    
}


-(void) requestFailed:(ASIHTTPRequest *) request
{
    NSLog(@"请求失败");
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


@end
