//
//  ServiceViewController.m
//  BigBand
//
//  Created by nelson on 14-7-27.
//  Copyright (c) 2014年 ioschen. All rights reserved.
//

#import "ServiceViewController.h"
#import "ASIHTTPRequest.h"
#import "WeiboSDK.h"
#import "AliMamaViewController.h"
#import "TaoBaoViewController.h"
#import "MyTaskViewController.h"
#import "CommonData.h"
#import "Macro.h"
#import "SettingDAO.h"
#import "DateUtil.h"

@interface ServiceViewController (){
    bool isShow;
    bool isSpecialShow;
    bool isTaoBaoShow;
    UIImageView *taoBaoRedDotView;
    UIImageView *specialRedDotView;
}
@property(strong,nonatomic)  ASIHTTPRequest *request;

@end

@implementation ServiceViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        UITabBarItem *tbi=[self tabBarItem];
        [tbi setTitle:@"服务"];
        UIImage *image=[UIImage imageNamed:@"service.png"];
        [tbi setImage:image];
    }
    return self;
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    isShow = true;
    isSpecialShow = true;
    isTaoBaoShow = true;
    long currentTime = [DateUtil getCurrentDateTime];
    NSDictionary *settingData = [SettingDAO getSetting];
    if(settingData != nil){
        NSString *isShowFlag = [settingData objectForKey:@"isShowFlag"];
        NSString *todayClickTAOBAOTime = [settingData objectForKey:@"todayClickTAOBAOTime"];
        NSString *todayClickSpecialTime = [settingData objectForKey:@"todayClickSpecialTime"]
        ;
        
        if(isShowFlag == nil || [isShowFlag isEqualToString:@"0"]){
            isShow = false;
        }
        
        if(todayClickTAOBAOTime != nil ){
            if(currentTime - [todayClickTAOBAOTime longLongValue] < 24*60*60*1000l){
                isTaoBaoShow = false;
            }
            
        }
        if(todayClickSpecialTime != nil ){
            if(currentTime - [todayClickSpecialTime longLongValue] < 24*60*60*1000l){
                isSpecialShow = false;
            }
            
        }
    }
    long hour = [DateUtil getCurrentHour];
    if(hour > 2 && hour < 6){
        isShow = false;
    }
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    NSLog(@"view did load");
    
   /* isShow = true;
    isSpecialShow = true;
    isTaoBaoShow = true;
    long currentTime = [DateUtil getCurrentDateTime];
    NSDictionary *settingData = [SettingDAO getSetting];
    if(settingData != nil){
        NSString *isShowFlag = [settingData objectForKey:@"isShowFlag"];
        NSString *todayClickTAOBAOTime = [settingData objectForKey:@"todayClickTAOBAOTime"];
        NSString *todayClickSpecialTime = [settingData objectForKey:@"todayClickSpecialTime"]
        ;

        if(isShowFlag == nil || [isShowFlag isEqualToString:@"0"]){
            isShow = false;
        }
        
        if(todayClickTAOBAOTime != nil ){
            if(currentTime - [todayClickSpecialTime longLongValue] < 24*60*60*1000l){
                isTaoBaoShow = false;
            }
            
        }
        if(todayClickSpecialTime != nil ){
            if(currentTime - [todayClickSpecialTime longLongValue] < 24*60*60*1000l){
                isSpecialShow = false;
            }
            
        }
    }
    long hour = [DateUtil getCurrentHour];
    if(hour > 2 && hour < 6){
        isShow = false;
    }*/
    //isShow = true;
    //isSpecialShow = true;
   // isTaoBaoShow = true;
    dataArray1 =[[NSMutableArray alloc] initWithObjects:@"天天特价", nil];
    
    dataIcon1 =[[NSMutableArray alloc] initWithObjects:@"special-_price.png", nil];
    dataArray2 =[[NSMutableArray alloc] initWithObjects:@"淘宝精品推荐", nil];
    
    dataIcon2 =[[NSMutableArray alloc] initWithObjects:@"taobao.png", nil];
    dataArray3 =[[NSMutableArray alloc] initWithObjects:@"点点赚钱", nil];
    dataIcon3 =[[NSMutableArray alloc] initWithObjects:@"money.png", nil];
    UILabel *topLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 15)];
    topLabel.backgroundColor = [UIColor colorWithRed:12/255.0 green:134/255.0 blue:243/255.0 alpha:1.0f];
    [self.view addSubview:topLabel];
    [topLabel release];
    UILabel *recommandLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 15, 320, 45)];
    recommandLabel.backgroundColor =  [UIColor colorWithRed:12/255.0 green:134/255.0 blue:243/255.0 alpha:1.0f];
    recommandLabel.text = @"服务";
    recommandLabel.textColor = [UIColor whiteColor];
    recommandLabel.textAlignment = NSTextAlignmentCenter;
    recommandLabel.font = [UIFont systemFontOfSize:25];
    [self.view addSubview:recommandLabel];
    [recommandLabel release];
    serviceTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 60, 320, 420) style:UITableViewStyleGrouped];
    [serviceTable setDataSource:self];
    [serviceTable setDelegate:self];
    [self.view addSubview:serviceTable];
    
}

//指定有多少个分区(Section)，默认为1
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (isShow) {
        return 3;
    }else{
        return 2;
    }

}


-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
    
}


//绘制Cell
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    //初始化cell并指定其类型，也可自定义cell
    UITableViewCell *cell = (UITableViewCell*)[tableView  dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    UIImageView *icon = [[UIImageView alloc] initWithFrame:CGRectMake(15, 10, 40, 40)];
    icon.contentMode = UIViewContentModeScaleToFill;
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(90, 15, 110, 30)];
    
    
    UIImageView *arrowView = [[UIImageView alloc] initWithFrame:CGRectMake(280,20, 20, 20)];
    arrowView.contentMode = UIViewContentModeScaleAspectFit;
    [arrowView setImage:[UIImage imageNamed:@"arrow.png"]];
    
    
    if(indexPath.section == 0){
        
        if(isSpecialShow){
       specialRedDotView = [[UIImageView alloc] initWithFrame:CGRectMake(260,22, 15, 15)];
        specialRedDotView.contentMode = UIViewContentModeScaleAspectFit;
        [specialRedDotView setImage:[UIImage imageNamed:@"red_dot.png"]];
        [cell.contentView addSubview:specialRedDotView];
        [specialRedDotView release];
        }
        [icon setImage:[UIImage imageNamed:[dataIcon1 objectAtIndex:indexPath.row]]];
        [titleLabel setText:[dataArray1 objectAtIndex:indexPath.row]];
    }else if(indexPath.section == 1){
        if (isTaoBaoShow) {
            taoBaoRedDotView = [[UIImageView alloc] initWithFrame:CGRectMake(260,22, 15, 15)];
            taoBaoRedDotView.contentMode = UIViewContentModeScaleAspectFit;
            [taoBaoRedDotView setImage:[UIImage imageNamed:@"red_dot.png"]];
            [cell.contentView addSubview:taoBaoRedDotView];
            [taoBaoRedDotView release];
        }
        [icon setImage:[UIImage imageNamed:[dataIcon2 objectAtIndex:indexPath.row]]];
        [titleLabel setText:[dataArray2 objectAtIndex:indexPath.row]];
    }
    if (isShow) {
        if(indexPath.section == 2){
            [icon setImage:[UIImage imageNamed:[dataIcon3 objectAtIndex:indexPath.row]]];
            [titleLabel setText:[dataArray3 objectAtIndex:indexPath.row]];
        }
    }
    [cell.contentView addSubview:icon];
    [icon release];
    
    [titleLabel setFont:[UIFont systemFontOfSize:18.0f]];
    [cell.contentView addSubview:titleLabel];
    [titleLabel release];
    
    [cell.contentView addSubview:arrowView];
    [arrowView release];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 5.0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return  5.0;
}



- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0){
        if(indexPath.row == 0){
            if(isSpecialShow){
                [specialRedDotView setHidden:YES];
            }
            [self saveOrUpdateTime:1];
            AliMamaViewController *mama = [[[AliMamaViewController alloc]init] autorelease];
            [self.navigationController pushViewController:mama animated:YES];
           
        }
    }else if(indexPath.section == 1){
        if(indexPath.row == 0){
            if (isTaoBaoShow) {
                [taoBaoRedDotView setHidden:YES];
            }
            [self saveOrUpdateTime:2];
            TaoBaoViewController *taobao = [[[TaoBaoViewController alloc]init] autorelease];
            [self.navigationController pushViewController:taobao
                                                 animated:YES];
            
        }
        
    }
    if (isShow) {
        if(indexPath.section == 2){
            if(indexPath.row == 0){
                if ([CommonData getUid] != nil) {
                    MyTaskViewController *myTask =[[[MyTaskViewController alloc]init] autorelease];
                    [self.navigationController pushViewController: myTask animated:YES];
                }else{
                    [self sinaweiboLogIn];
                }
            }
        }
    }
   
    
    
    return  indexPath;
    
}

-(void) saveOrUpdateTime:(NSInteger) type
{
    
     NSDictionary *result = [SettingDAO getSetting];
       NSDictionary *params;
    if(result == nil){
     
        if(type == 1){
            params = [[[NSDictionary alloc]initWithObjectsAndKeys:@"0",@"lastUploadTime",@"0",@"isShowFlag",@"0",@"isUpgrade",@"0",@"isBind",[NSString stringWithFormat:@"%ld",[DateUtil getCurrentDateTime]],@"todayClickSpecialTime",@"0",@"todayClickTAOBAOTime",[CommonData getUid],@"uid", nil] autorelease];
           bool result = [SettingDAO insertSetting:params];
             NSLog(@"insert result=%d",result);
        }else{
            params = [[[NSDictionary alloc]initWithObjectsAndKeys:@"0",@"lastUploadTime",@"0",@"isShowFlag",@"0",@"isUpgrade",@"0",@"isBind",[NSString stringWithFormat:@"%ld",[DateUtil getCurrentDateTime]],@"todayClickTAOBAOTime",@"0",@"todayClickSpecialTime",[CommonData getUid],@"uid", nil] autorelease];
           bool result = [SettingDAO insertSetting:params];
              NSLog(@"insert result=%d",result);
        }
    
    }else{
        if(type == 1){
            NSString *settingId = [result objectForKey:@"settingId"];
            params = [[[NSDictionary alloc]initWithObjectsAndKeys:[NSString stringWithFormat:@"%ld",[DateUtil getCurrentDateTime]],@"todayClickSpecialTime", nil] autorelease];
           bool result = [SettingDAO updateSetting:params bySettingId:settingId];
              NSLog(@"update result=%d",result);
        }else{
            NSString *settingId = [result objectForKey:@"settingId"];
            params = [[[NSDictionary alloc]initWithObjectsAndKeys:[NSString stringWithFormat:@"%ld",[DateUtil getCurrentDateTime]],@"todayClickTAOBAOTime", nil] autorelease];
           bool result = [SettingDAO updateSetting:params bySettingId:settingId];
            NSLog(@"update result=%d",result);
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




- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [dataArray1 release];
    [dataIcon1 release];
    [dataArray2 release];
    [dataIcon2 release];
    [dataArray3 release];
    [dataIcon3 release];
    [serviceTable release];
    [super dealloc];
}
@end
