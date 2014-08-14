//
//  MEViewController.m
//  weChatDemo
//
//  Created by  on 8/16/13.
//  Copyright (c) 2013 ioschen. All rights reserved.
//

#import "MEViewController.h"
#import "Macro.h"
#import "RecommandViewController.h"
#import "MyInfoViewController.h"
#import "LogoutViewController.h"
#import "MyTaskViewController.h"
#import "UserDao.h"
#import "ASIFormDataRequest.h"
#import "ASIHTTPRequest.h"
#import "JSONKit.h"
#import "WeiboSDK.h"
#import "TaoBaoViewController.h"
#import "AliMamaViewController.h"
#import "CommonData.h"
#import "MyCollectionViewController.h"
#import "DesEncrypt.h"
#import  "ALToastView.h"
#import "QQViewController.h"

@interface MEViewController ()<UIAlertViewDelegate,ASIHTTPRequestDelegate>

@property(strong,nonatomic)  ASIHTTPRequest *request;
@property(strong,nonatomic)  ASIHTTPRequest *versionRequest;
@property(strong,nonatomic) NSString* downloadUrl;

@end


@implementation MEViewController

@synthesize request;



- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:@"MEViewController" bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization//
        UITabBarItem *tbi=[self tabBarItem];
        [tbi setTitle:@"我"];
        UIImage *i=[UIImage imageNamed:@"me.png"];
        [tbi setImage:i];
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
    recommandLabel.text = @"我";
    recommandLabel.textColor = [UIColor whiteColor];
    recommandLabel.textAlignment = NSTextAlignmentCenter;
    recommandLabel.font = [UIFont systemFontOfSize:25];
    [self.view addSubview:recommandLabel];
    [recommandLabel release];
    CGRect frame=CGRectMake(0, 60, self.view.frame.size.width, self.view.frame.size.height-70);
     medataTable = [[UITableView alloc]initWithFrame:frame style:UITableViewStyleGrouped];
    [medataTable setDataSource:self];
    [medataTable setDelegate:self];//指定委托
    [self.view addSubview:medataTable];//加载tableview
    
    dataArray1 = [[NSMutableArray alloc] initWithObjects:@"我的资料",@"我的收藏", nil];
    dataArray2 = [[NSMutableArray alloc] initWithObjects:@"新浪登录", nil];
    dataArray3 = [[NSMutableArray alloc] initWithObjects:@"客服QQ",@"版本更新",@"设置", nil];
    dataIcon1 = [[NSMutableArray alloc] initWithObjects:@"info.png",@"mycollect.png", nil];
    dataIcon2 = [[NSMutableArray alloc] initWithObjects:@"sina_weibo.png", nil];
    dataIcon3 = [[NSMutableArray alloc] initWithObjects:@"qq.png",@"update.png", @"setting.png",nil];
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


//指定有多少个分区(Section)，默认为1
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    //return [titleArray count];//返回标题数组中元素的个数来确定分区的个数
    return 3;
}

//指定每个分区中有多少行，默认为1
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    switch (section) {
        case 0:
            return [dataArray1 count];//每个分区通常对应不同的数组，返回其元素个数来确定分区的行数
            break;
        case 1:
            return [dataArray2 count];
            break;
        case 2:
            return [dataArray3 count];//每个分区通常对应不同的数组，返回其元素个数来确定分区的行数
            break;
        default:
            return 0;
            break;
    }
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

    
    switch (indexPath.section) {
        case 0://对应各自的分区
            [icon setImage:[UIImage imageNamed:[dataIcon1 objectAtIndex:indexPath.row]]];
            [titleLabel setText:[dataArray1 objectAtIndex:indexPath.row]];
            break;
        case 1://对应各自的分区
            [icon setImage:[UIImage imageNamed:[dataIcon2 objectAtIndex:indexPath.row]]];
            [titleLabel setText:[dataArray2 objectAtIndex:indexPath.row]];
            break;
        case 2://对应各自的分区
            [icon setImage:[UIImage imageNamed:[dataIcon3 objectAtIndex:indexPath.row]]];
            [titleLabel setText:[dataArray3 objectAtIndex:indexPath.row]];
            break;
        default:
            [[cell textLabel]setText:@"Unknown"];
            break;
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


- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch(indexPath.section){
        case 0:
            if(indexPath.row == 0){
                if([CommonData getUid] != nil){
                    MyInfoViewController *myinfo =[[[MyInfoViewController alloc]init]   autorelease];
                    [self.navigationController pushViewController: myinfo animated:YES];
                }else{
                    [self sinaweiboLogIn];
                }
            }else if(indexPath.row == 1){
                MyCollectionViewController *cbv = [[[MyCollectionViewController alloc]init]autorelease];
                
                [self.navigationController pushViewController:cbv animated:YES];
            }
            break;
        case 1:
            [self sinaweiboLogIn];
            break;
        case 2:
            //[sinaWeibo logIn];
            if(indexPath.row == 0){
                QQViewController *qqvc = [[QQViewController alloc] init];
                [self.navigationController pushViewController:qqvc animated:YES];
                [qqvc release];
            }else if(indexPath.row == 1){
                      //版本更新
                    [self versionCheck];
             
            }else if(indexPath.row == 2){
                LogoutViewController *lvc = [[[LogoutViewController alloc]init] autorelease];
                [self.navigationController pushViewController:lvc animated:YES];
            }
            break;
    }
    return  indexPath;

}


-(void) sinaweiboLogIn
{
    WBAuthorizeRequest *sinarequest = [WBAuthorizeRequest request];
    sinarequest.redirectURI = sinaRedirectURI;
    sinarequest.scope = @"all";
   
    [WeiboSDK sendRequest:sinarequest];
}


-(void) versionCheck
{
    //http请求
    NSString *differentTimeStr = [CommonData getDifferentTime];
    NSLog(@"differentTime=%@",differentTimeStr);
    long long differentTime =[differentTimeStr longLongValue];
    long long clientTime = [[NSDate date] timeIntervalSince1970]*1000 + differentTime;
    NSString *plainText = [[NSNumber numberWithLongLong:clientTime]stringValue];
    //
    NSLog(@"plainText=%@",plainText);
    NSString *seed = [DesEncrypt encryptUseDES:plainText key:deskey];
    NSLog(@"seed = %@",seed);
    NSString *url = [serverUrl stringByAppendingFormat:@"act=INQUIRE_IOS_CONFIG&seed=%@",seed];
    NSURL *nsURL = [NSURL URLWithString:url];
    _versionRequest = [ASIFormDataRequest requestWithURL:nsURL];
    _versionRequest.delegate = self;
    [_versionRequest startAsynchronous];
    
    

}

-(void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSLog(@"buttonIdn=%d",buttonIndex);
    if(buttonIndex == 1){
       [[UIApplication sharedApplication] openURL:[NSURL URLWithString:_downloadUrl]];
    }
}


-(void) requestFinished:(ASIHTTPRequest *)_request
{
    JSONDecoder *jsonDecoder = [[JSONDecoder alloc] init];
    NSData *data = [_request responseData];
    NSDictionary *dic =  [jsonDecoder objectWithData:data];
    NSString *resultCode = [dic objectForKey: @"state"];
   
    if(resultCode){
        if([resultCode isEqualToString: @"SUCCESS"]){
            
             NSDictionary *dataInfo = [dic objectForKey:@"data"];
            NSString *iosversionCode =[dataInfo objectForKey:@"iosVersion"];
            _downloadUrl =[[dataInfo objectForKey:@"iosUrl"] copy];
            if([iosversionCode isEqualToString:versionCode]){
                   [ALToastView toastInView:self.view withText:@"已经是最新版本"];
            }else{
                UIAlertView *alert;
                alert = [[UIAlertView alloc] initWithTitle:@"版本升级"
                                                   message:@"有新版本，是否升级！"
                                                  delegate: self
                                         cancelButtonTitle:@"取消"
                                         otherButtonTitles: @"升级", nil];
                [alert show];
                [alert release];
            }
            
        }else{
          [ALToastView toastInView:self.view withText:@"已经是最新版本"];
        }
        
    }else{
        [ALToastView toastInView:self.view withText:@"已经是最新版本"];
    }
    [jsonDecoder release];


}
-(void) requestFailed:(ASIHTTPRequest *) request
{
  [ALToastView toastInView:self.view withText:@"已经是最新版本"];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) dealloc
{
    [super dealloc];
    [medataTable release];
    [dataArray1 release];
    [dataArray2 release];
    [dataArray3 release];
    [dataIcon1 release];
    [dataIcon2 release];
    [dataIcon3 release];
    [_downloadUrl release];
}
@end