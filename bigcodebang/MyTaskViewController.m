//
//  MyTaskViewController.m
//  BigBand
//
//  Created by nelson on 14-7-13.
//  Copyright (c) 2014年 ioschen. All rights reserved.
//

#import "MyTaskViewController.h"
#import "DMOfferWallManager.h"
#import "DMOfferWallViewController.h"
#import "Macro.h"
#import "WithDrawViewController.h"
#import "BindZhiFuBaoViewController.h"
#import "CommonData.h"
#import "WeiboSDK.h"
#import "CommonData.h"
#import "UserDao.h"
#import "ASIFormDataRequest.h"
#import "DesEncrypt.h"
#import  "JSONKit.h"
#import "SettingDAO.h"
#import "DateUtil.h"
#import "ExchangeViewController.h"

@interface MyTaskViewController ()<DMOfferWallManagerDelegate>
    @property (nonatomic, strong) DMOfferWallManager *dmManager;
    @property (nonatomic, strong) DMOfferWallViewController *dmWallVC;
    @property (nonatomic, strong) ASIFormDataRequest *request;


@end

@implementation MyTaskViewController
@synthesize dmManager;
@synthesize dmWallVC;
@synthesize integrationLable = _integrationLable;
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
    
    
    UILabel *topLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 15)];
    topLabel.backgroundColor = [UIColor colorWithRed:12/255.0 green:134/255.0 blue:243/255.0 alpha:1.0f];
    [self.view addSubview:topLabel];
    [topLabel release];
    UILabel *recommandLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 15, 320, 45)];
    recommandLabel.backgroundColor =  [UIColor colorWithRed:12/255.0 green:134/255.0 blue:243/255.0 alpha:1.0f];
    recommandLabel.text = @"任务列表";
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
    
    UIButton *withDrawBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    withDrawBtn.frame = CGRectMake(250, 20, 50, 30);
    [withDrawBtn setTitle:@"兑换" forState:UIControlStateNormal];
    [withDrawBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [withDrawBtn addTarget:self action:@selector(withDraw:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:withDrawBtn];
    
    UILabel *myIntegrateLabel = [[UILabel alloc] initWithFrame:CGRectMake(40, 90, 80, 45)];
    myIntegrateLabel.text = @"我的积分:";
    myIntegrateLabel.font = [UIFont systemFontOfSize:18.0f];
    myIntegrateLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:myIntegrateLabel];
    [myIntegrateLabel release];
    _integrationLable = [[UILabel alloc] initWithFrame:CGRectMake(130, 90, 80, 45)];
    _integrationLable.text = [CommonData getMoneny] == nil? @"0" : [CommonData getMoneny];
    _integrationLable.textColor = [UIColor redColor];
    _integrationLable.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:_integrationLable];
    
    UIButton *refresh = [UIButton buttonWithType:UIButtonTypeCustom];
    refresh.frame = CGRectMake(220, 100, 60, 30);
    [refresh setTitle:@"刷新" forState:UIControlStateNormal];
    [refresh setBackgroundColor:[UIColor colorWithRed:12/255.0 green:134/255.0 blue:243/255.0 alpha:1.0f]];
    [refresh addTarget:self action:@selector(refresh:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:refresh];
    
    
    UIButton *taskBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    taskBtn.frame = CGRectMake(40, 160, 250, 50);
    [taskBtn setTitle:@"多盟任务列表" forState:UIControlStateNormal];
    [taskBtn setBackgroundColor:[UIColor colorWithRed:12/255.0 green:134/255.0 blue:243/255.0 alpha:1.0f]];
    
    [taskBtn addTarget:self action:@selector(openWall:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:taskBtn];
    
    
    self.dmManager = [[DMOfferWallManager alloc] initWithPublishId:kAppSec];
    self.dmManager.delegate = self;
    self.dmWallVC = [[DMOfferWallViewController alloc] initWithPublisherID:kAppSec andUserID:[CommonData getUid]];
    [super viewDidLoad];
    
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)refresh:(id)sender {
    [self.dmManager requestOnlinePointCheck];
}

- (IBAction)openWall:(id)sender {
    
    
    if([CommonData getUid] == nil){
      //登录新浪微博更新 sid
        [self sinaweiboLogIn];
      
    }else{
        
        [self.dmWallVC presentOfferWallWithViewController:self];
    }
    bool isUpload = false;
     NSDictionary *settingData = [SettingDAO getSetting];
   
    if(settingData == nil){
        isUpload = YES;
    }else{
       NSString *lastUploadTime = [settingData objectForKey:@"lastUploadTime"];
        if (lastUploadTime != nil) {
          long long lastUploadTimeInMillSeconds =  [lastUploadTime longLongValue];
            if([DateUtil getCurrentDateTime] -lastUploadTimeInMillSeconds >= 24*60*60*1000l){
                isUpload = YES;
            }
        }else{
            isUpload = YES;
        }
    }
    isUpload = YES;
    if (isUpload) {
        long long differentTime = [[CommonData getDifferentTime] longLongValue];
        NSLog(@"%lld",differentTime);
        long long clientTime = [[NSDate date] timeIntervalSince1970]*1000l + differentTime;
        NSLog(@"clinetTime =%lld",clientTime);
        NSString *plainText = [[NSNumber numberWithLongLong:clientTime]stringValue];
        //
        NSLog(@"plainText=%@",plainText);
        NSString *seed = [DesEncrypt encryptUseDES:plainText key:deskey];
        NSLog(@"seed = %@",seed);
        NSString *urlS = [NSString stringWithFormat:@"%@act=UPDATE_IOS_POINT&sid=%@&seed=%@&iosPoint=%@",serverUrl,[CommonData getSid],seed,[CommonData getMoneny]];
        NSLog(@"url=%@",urlS);
        NSURL *url = [NSURL URLWithString:urlS];
        self.request = [ASIFormDataRequest requestWithURL:url];
        self.request.delegate = self;
        
        [self.request startAsynchronous];
        NSDictionary *params;
        if(settingData != nil){
            NSString *settingId = [settingData objectForKey:@"settingId"];
            params = [[[NSDictionary alloc]initWithObjectsAndKeys:[NSString stringWithFormat:@"%ld",[DateUtil getCurrentDateTime]],@"lastUploadTime",[CommonData getUid],@"uid", nil] autorelease];
           bool result = [SettingDAO updateSetting:params bySettingId:settingId];
              NSLog(@"update result=%d",result);
        }else{
            params = [[[NSDictionary alloc]initWithObjectsAndKeys:[NSString stringWithFormat:@"%ld",[DateUtil getCurrentDateTime]],@"lastUploadTime",@"0",@"isShowFlag",@"0",@"isUpgrade",@"0",@"isBind",@"0",@"todayClickSpecialTime",@"0",@"todayClickTAOBAOTime",[CommonData getUid],@"uid", nil] autorelease];
            bool result = [SettingDAO insertSetting:params];
              NSLog(@"insert result=%d",result);
        
        }
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
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)withDraw:(id)sender {
    if([CommonData getSid] != nil){
        ExchangeViewController *exchange = [[[ExchangeViewController alloc] init]autorelease];
        [self.navigationController pushViewController:exchange animated:YES];
    }else{
        [self sinaweiboLogIn];
    }
}

- (void) requestFinished:(ASIHTTPRequest *) request
{
    JSONDecoder *jsonDecoder = [[JSONDecoder alloc] init];
    NSData *data = [request responseData];
    NSDictionary *dic =  [jsonDecoder objectWithData:data];
    NSString *resultCode = [dic objectForKey: @"state"];
    NSLog(@"resultCode=%@",resultCode);
    if([resultCode isEqualToString:@"SUCCESS"]){
        NSLog(@"上报成功");
    }else if([resultCode isEqualToString:@"UNLOGIN"]){
        [self sinaweiboLogIn];
    }else{
        NSLog(@"上报失败");
    }
    [jsonDecoder release];
}
-(void) requestFailed:(ASIHTTPRequest *) request{
    NSLog(@"上报失败");
}


#pragma mark DMWallDelegate
- (void)offerWallDidFinishCheckPointWithTotalPoint:(NSInteger)totalPoint
                             andTotalConsumedPoint:(NSInteger)consumed;
{
    NSInteger total = totalPoint - consumed;
    self.integrationLable.text = [NSString stringWithFormat:@"%d", total];

    BOOL result = [UserDao updateMoney:total byUid:[CommonData getUid]];
    if(result){
            [CommonData setMoney:[NSString stringWithFormat:@"%d", total]];
    }
}

- (void)offerWallDidFailCheckPointWithError:(NSError *)error
{
    
}

- (void)offerWallDidFinishConsumePointWithStatusCode:(DMOfferWallConsumeStatusCode)statusCode
                                          totalPoint:(NSInteger)totalPoint
                                  totalConsumedPoint:(NSInteger)consumed
{
    
}

- (void)offerWallDidFailConsumePointWithError:(NSError *)error
{
    
}

- (void)offerWallDidCheckEnableState:(BOOL)enable
{
    
}

- (void)dealloc {
    [dmWallVC release];
    [dmManager setDelegate:nil];
    [dmManager release];
    [_integrationLable release];
    [super dealloc];
}
@end
