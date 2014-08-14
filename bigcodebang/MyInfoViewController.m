//
//  MyInfoViewController.m
//  BigBand
//
//  Created by nelson on 14-7-5.
//  Copyright (c) 2014年 ioschen. All rights reserved.
//
#import "UserDao.h"
#import "MyInfoViewController.h"
#import "UIImageView+WebCache.h"
#import "WeiboSDK.h"
#import "Macro.h"
#import "UserDao.h"
#import "JSONKit.h"


@interface MyInfoViewController ()<UITableViewDataSource,UITableViewDelegate,WBHttpRequestDelegate>

@property(strong,nonatomic) NSArray *dataArray1;
@property(strong,nonatomic) NSArray *dataArray2;
@property(copy,nonatomic) NSDictionary *dataInfo;
@property(strong,nonatomic) NSString * userID;
@property(strong,nonatomic) NSString *accessToken;


@end

@implementation MyInfoViewController
@synthesize myInfoTableView;
@synthesize dataArray1;
@synthesize dataArray2;
@synthesize dataInfo;
@synthesize accessToken;
@synthesize userID;
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
    dataArray1 =[[NSArray alloc]initWithObjects:@"头像", nil];
    dataArray2 = [[NSArray alloc]initWithObjects:@"昵称",@"性别",@"地址",@"支付宝姓名",@"支付宝账号",nil];
    
    UILabel *topLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 15)];
    topLabel.backgroundColor = [UIColor colorWithRed:12/255.0 green:134/255.0 blue:243/255.0 alpha:1.0f];
    [self.view addSubview:topLabel];
    [topLabel release];
    UILabel *recommandLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 15, 320, 45)];
    recommandLabel.backgroundColor =  [UIColor colorWithRed:12/255.0 green:134/255.0 blue:243/255.0 alpha:1.0f];
    recommandLabel.text = @"我的资料";
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
    CGRect frame=CGRectMake(0, 60, self.view.frame.size.width, self.view.frame.size.height);
    myInfoTableView = [[[UITableView alloc]initWithFrame:frame style:UITableViewStyleGrouped] autorelease];
    myInfoTableView.dataSource = self;
    myInfoTableView.delegate = self;
    dataInfo = [[UserDao getUserInfoByType:@"1"] copy];
    userID =  [dataInfo objectForKey:@"userId"];
    accessToken = [dataInfo objectForKey:@"accessToken"];
    NSString *url = [[[NSString alloc] initWithString:sinaInfoUrl] stringByAppendingFormat:@"uid=%@&access_token=%@",userID,accessToken];
   [WBHttpRequest requestWithURL:url httpMethod:@"GET" params:nil delegate:self withTag:[NSString stringWithFormat:@"userID=%@;accessToken=%@",userID,accessToken]];
    [self.view addSubview:myInfoTableView];
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}



//指定有多少个分区(Section)，默认为1
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    //return [titleArray count];//返回标题数组中元素的个数来确定分区的个数
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 70.0;
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
        default:
            return 0;
            break;
    }
}
//绘制Cell
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"myInfoCell";
    //初始化cell并指定其类型，也可自定义cell
    UITableViewCell *cell = (UITableViewCell*)[tableView  dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    }
    if(indexPath.section == 0){
        UILabel *headLable  = [[[UILabel alloc]initWithFrame:CGRectMake(30, 0, 120, 70)]autorelease];
        [headLable setText:[dataArray1 objectAtIndex:indexPath.row]];
        UIImageView *headImage = [[[UIImageView alloc]initWithFrame:CGRectMake(200, 0, 70, 70)] autorelease];
        headImage.contentMode = UIViewContentModeScaleAspectFit;
        
        [headImage setImageWithURL:[NSURL URLWithString:  [dataInfo objectForKey:@"headimgurl"]] placeholderImage:[UIImage imageNamed:@"me.png"]];
        [cell.contentView addSubview:headLable];
        [cell.contentView addSubview:headImage];
    }else{
        UILabel *titleLable  = [[[UILabel alloc]initWithFrame:CGRectMake(30, 0, 100, 70)]autorelease];
        [titleLable setText:[dataArray2 objectAtIndex:indexPath.row]];
        UILabel *valueLable = nil;
        if(indexPath.row == 0){
            valueLable = [[[UILabel alloc]initWithFrame:CGRectMake(150, 0, 180, 70)]autorelease];
            valueLable.textAlignment = NSTextAlignmentCenter;
            [valueLable setText:[dataInfo objectForKey:@"nickName"]];
        }else if(indexPath.row == 1){
            valueLable = [[[UILabel alloc]initWithFrame:CGRectMake(150, 0, 180, 70)]autorelease];
            valueLable.textAlignment = NSTextAlignmentCenter;
            NSString *gender = [dataInfo objectForKey:@"gender"];
            if([gender isEqualToString:@"m"]){
                gender = @"男";
            }else if([gender isEqualToString:@"f"]){
                gender = @"女";
            }
            [valueLable setText:gender];
        
        }else if(indexPath.row == 2){
            valueLable = [[[UILabel alloc]initWithFrame:CGRectMake(150, 0, 180, 70)]autorelease];
            valueLable.textAlignment = NSTextAlignmentCenter;
            [valueLable setText:[dataInfo objectForKey:@"location"]];
        
        }else if(indexPath.row == 3){
            valueLable = [[[UILabel alloc]initWithFrame:CGRectMake(150, 0, 180, 70)]autorelease];
            valueLable.textAlignment = NSTextAlignmentCenter;
            [valueLable setText:[dataInfo objectForKey:@"accountName"]];
        
        }else if(indexPath.row == 4){
            valueLable = [[[UILabel alloc]initWithFrame:CGRectMake(150, 0, 180, 70)]autorelease];
            valueLable.textAlignment = NSTextAlignmentCenter;
            [valueLable setText:[dataInfo objectForKey:@"account"]];
        
        }
       
        [cell.contentView addSubview:titleLable];
        [cell.contentView addSubview:valueLable];
    
    }
    cell.accessoryType= UITableViewCellAccessoryNone;
    return cell;
}


- (void)request:(WBHttpRequest *)request didFinishLoadingWithResult:(NSString *)result
{
    NSDictionary *resultDic = [result objectFromJSONString];
    NSLog(@"RESULT= %@",result);
    NSDictionary *data = [[NSDictionary alloc]initWithObjectsAndKeys:userID,@"userId",accessToken,@"accessToken",[resultDic objectForKey:@"profile_image_url"],@"headimgurl",[resultDic objectForKey:@"location"],@"location",[resultDic objectForKey:@"name"],@"nickname",[resultDic objectForKey:@"gender"],@"gender", nil];
    [UserDao updateUserInfo:data byuserId:userID];
    dataInfo = [[UserDao getUserInfoById:userID] copy];
    [myInfoTableView reloadData];
  
}

- (void)request:(WBHttpRequest *)request didFailWithError:(NSError *)error{
    NSLog(@"ERROR=%@",error);

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
  //  [myInfoTableView release];
    [dataArray1 release];
    [dataArray2 release];
    [super dealloc];
}
@end
