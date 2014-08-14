//
//  WXViewController.m
//  weChatDemo
//

//  Copyright (c) 2013 ioschen. All rights reserved.
//
#import "RecommandViewController.h"
#import "ASIFormDataRequest.h"
#import "JSONKit.h"
#import "Dialog.h"
#import "EGORefreshTableHeaderView.h"
#import "LoadMoreFooterView.h"
#import "Macro.h"
#import <CommonCrypto/CommonCryptor.h>
#import "DesEncrypt.h"
#import "DetailImageViewController.h"
#import "CommonData.h"
#import "WeiboSDK.h"
#import "ShareSDK/ShareSDK.h"
#import "UIImageView+WebCache.h"
#import "CollectionDao.h"
#import "SettingDAO.h"
#import "MJPhoto.h"
#import "MJPhotoBrowser.h"
#import "GifImageViewController.h"



@interface RecommandViewController ()<UITableViewDataSource,UITableViewDelegate,EGORefreshTableHeaderDelegate,LoadMoreFooterViewDelegate,UIScrollViewDelegate,UIActionSheetDelegate,UIGestureRecognizerDelegate>
{
    UITableView *recommandTableView;
    EGORefreshTableHeaderView *_refreshHeaderView;
    LoadMoreFooterView *_loadMoreFooterView;
    NSInteger _currentPage;
    BOOL _reloading;
    Dialog *_dialog;
    NSString *requestType;
    NSMutableArray * dataList;
    UIActionSheet *actionSheet;
    NSInteger current;
    NSInteger selectRow;
    MJPhoto *photo;
    MJPhotoBrowser *browser;
    NSMutableArray *photos;
    
}

@property(retain,nonatomic) ASIFormDataRequest *request;
@property (retain,nonatomic) ASIFormDataRequest *voteUpRequest;
@property (retain,nonatomic) ASIFormDataRequest *voteDownRequest;
@property (retain,nonatomic) ASIHTTPRequest *collectRequest;
@property (strong,nonatomic) ASIFormDataRequest *configRequest;
@property(assign,nonatomic) long differentTime;
@property (assign,nonatomic) long long serverTime;



@end


@implementation RecommandViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    NSLog(@"init here");
    self = [super initWithNibName:@"RecommandViewController" bundle:nibBundleOrNil];
    if (self) {
        UITabBarItem *tbi=[self tabBarItem];
        [tbi setTitle:@"推荐"];
        UIImage *image=[UIImage imageNamed:@"home.png"];
        [tbi setImage:image];
    }
    
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (void) scrollViewDidScroll:(UIScrollView *)scrollView
{
    
    [_refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
    [_loadMoreFooterView loadMoreScrollViewDidScroll:scrollView];
    [_loadMoreFooterView setHidden:NO];
}

-(void) scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [_refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
    [_loadMoreFooterView loadMoreshScrollViewDidEndDragging:scrollView];
    
}

- (void) egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView *)view
{
    _reloading = YES;
    _currentPage++;
    [self requestPicList:_currentPage];
}

-(BOOL) egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView *)view
{
    return _reloading;
}

-(NSDate*) egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView *)view
{
    return [NSDate date];
}


-(void) loadMoreTableFooterDidTriggerRefresh:(LoadMoreFooterView *)view
{
    _reloading = YES;
    _currentPage++;
    [self requestPicList:_currentPage];
    
}

-(BOOL)loadMoreTableFooterDataSourceIsLoading:(LoadMoreFooterView *)view
{
    return _reloading;
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
    recommandLabel.text = @"推荐";
    recommandLabel.textColor = [UIColor whiteColor];
    recommandLabel.textAlignment = NSTextAlignmentCenter;
    recommandLabel.font = [UIFont systemFontOfSize:25];
    [self.view addSubview:recommandLabel];
    [recommandLabel release];
    _appDel = (AppDelegate *)[UIApplication sharedApplication].delegate;
    dataList = [[NSMutableArray alloc]init];
    _differentTime = [self getDifferentTime];
    NSLog(@"differntTime : %ld",_differentTime);
    [CommonData setDifferentTime:[NSString stringWithFormat:@"%ld",_differentTime]];
    
    
    if(_refreshHeaderView == nil){
        recommandTableView = [[UITableView alloc]initWithFrame:CGRectMake(0,60,320, 480)];
        recommandTableView.dataSource = self;
        recommandTableView.delegate = self;
        EGORefreshTableHeaderView *view = [[EGORefreshTableHeaderView alloc]initWithFrame:CGRectMake(0.0f, 0.0f - recommandTableView.bounds.size.height, recommandTableView.bounds.size.width,recommandTableView.bounds.size.height)];
        view.delegate = self;
        _refreshHeaderView = view;
        [recommandTableView addSubview:view];
        recommandTableView.backgroundView = nil;
        //recommandTableView.backgroundColor = [UIColor whiteColor];
        recommandTableView.backgroundColor = [UIColor colorWithRed:128/255.0 green:138/255.0 blue:135/255.0 alpha:0.5];
        recommandTableView.separatorStyle = UITableViewCellSelectionStyleNone;
        [self.view addSubview:recommandTableView];
    }
    [_refreshHeaderView refreshLastUpdatedDate];
    if(_loadMoreFooterView == nil)
    {
        _loadMoreFooterView = [[LoadMoreFooterView alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
        _loadMoreFooterView.delegate=self;
        recommandTableView.tableFooterView = _loadMoreFooterView;
        [recommandTableView.tableFooterView setHidden:true];
    }
    _currentPage = 1;
    [self requestPicList:_currentPage];
    [self requestIosConfig];
    
}

- (void) requestServiceTime
{
    requestType = @"wolf";
    NSString *url = [serverUrl stringByAppendingString:@"wolf=TIME"];
    NSURL *nsURL = [NSURL URLWithString:url];
    _request = [ASIFormDataRequest requestWithURL:nsURL];
    _request.delegate = self;
    [_request startSynchronous];
    
}
- (void) requestIosConfig
{
   
    long long clientTime = [[NSDate date] timeIntervalSince1970]*1000 + _differentTime;
    NSString *plainText = [[NSNumber numberWithLongLong:clientTime]stringValue];
    //
    NSLog(@"plainText=%@",plainText);
    NSString *seed = [DesEncrypt encryptUseDES:plainText key:deskey];
    NSLog(@"seed = %@",seed);
    NSString *url = [serverUrl stringByAppendingFormat:@"act=INQUIRE_IOS_CONFIG&seed=%@",seed];
    NSURL *nsURL = [NSURL URLWithString:url];
    _configRequest = [ASIFormDataRequest requestWithURL:nsURL];
    _configRequest.delegate = self;
    [_configRequest startAsynchronous];

}

-(long) getDifferentTime
{
    NSFileManager *fileManage = [NSFileManager defaultManager];
    NSArray *directories = NSSearchPathForDirectoriesInDomains(NSDocumentationDirectory, NSUserDomainMask, YES);
    NSString *documentDir =[directories objectAtIndex:0];
    NSString *filePath = [documentDir stringByAppendingPathComponent:@"key.txt"];
    NSData *data = nil;
    if([fileManage fileExistsAtPath:filePath]){
        NSLog(@"file exist%@",filePath);
        data = [NSData dataWithContentsOfFile:filePath];
        NSString *result = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        return [result longLongValue];
    }else
    {
        NSLog(@"file not exist%@",filePath);
        long long clientTime = [[NSDate date] timeIntervalSince1970]*1000;
        [self requestServiceTime];
        _differentTime = _serverTime - clientTime;
        NSNumber *longNumber = [NSNumber numberWithLong:_differentTime];
        NSString *longStr = [longNumber stringValue];
        data = [longStr dataUsingEncoding:NSUTF8StringEncoding];
        BOOL isSuccess = [fileManage createFileAtPath:filePath contents:nil attributes:nil];
        if(isSuccess){
            [data writeToFile:filePath atomically:YES];
            
        }else{
            NSLog(@"create file fail");
        }
        return _differentTime;
        
    }
}

- (void) actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *imagePath = [[NSBundle mainBundle] pathForResource:@"ShareSDK"  ofType:@"jpg"];
    
    //构造分享内容
    id<ISSContent> publishContent = [ShareSDK content:@"分享内容"
                                       defaultContent:@"默认分享内容，没内容时显示"
                                                image:[ShareSDK imageWithPath:imagePath]
                                                title:@"ShareSDK"
                                                  url:@"http://www.sharesdk.cn"
                                          description:@"这是一条测试信息"
                                            mediaType:SSPublishContentMediaTypeNews];
    
    [ShareSDK showShareActionSheet:nil
                         shareList:nil
                           content:publishContent
                     statusBarTips:YES
                       authOptions:nil
                      shareOptions: nil
                            result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                                if (state == SSResponseStateSuccess)
                                {
                                    NSLog(@"分享成功");
                                }
                                else if (state == SSResponseStateFail)
                                {
                                    NSLog(@"分享失败,错误码:%d,错误描述:%@", [error errorCode], [error errorDescription]);
                                }
                            }];
}


- (WBMessageObject *)messageToShare:(NSDictionary *)data
{
    WBMessageObject *message = [WBMessageObject message];
    
    WBWebpageObject *webpage = [WBWebpageObject object];
    webpage.objectID = [data objectForKey:@"id"];
    webpage.title = [data objectForKey:@"title"];
    webpage.description = [data objectForKey:@"title"];
    webpage.thumbnailData = [NSData dataWithContentsOfURL:[NSURL URLWithString:[data objectForKey:@"picurl"]]];
    webpage.webpageUrl = @"http://sina.cn?a=1";
    message.mediaObject = webpage;
    return message;
}

-(void) sinaweiboLogIn
{
    WBAuthorizeRequest *sinarequest = [WBAuthorizeRequest request];
    sinarequest.redirectURI = sinaRedirectURI;
    sinarequest.scope = @"all";
    [WeiboSDK sendRequest:sinarequest];
}

-(void) tencentLogin
{
   // [_appDel.tencentEngine logInWithDelegate:_appDel.self onSuccess:@selector(successLogin:) onFailure:@selector(failureLogin:)];
}


- (void) requestPicList:(NSInteger) page
{
    requestType = @"INQUIRE_IMAGE_PAGE";
    NSString *urlStr = @"%@act=INQUIRE_IMAGE_PAGE&pageSize=10&pageIndex=%d&seed=%@" ;
    _dialog = [[Dialog alloc] init];
    [_dialog showProgress:self];
    long long clientTime = [[NSDate date] timeIntervalSince1970]*1000 + _differentTime;
    NSString *plainText = [[NSNumber numberWithLongLong:clientTime]stringValue];
    //
    NSLog(@"plainText=%@",plainText);
    NSString *seed = [DesEncrypt encryptUseDES:plainText key:deskey];
    NSLog(@"seed = %@",seed);
    urlStr = [NSString stringWithFormat:urlStr,serverUrl,page,seed];
    NSLog(@"url = %@",urlStr);
    NSURL *url = [NSURL URLWithString:urlStr];
    _request = [ASIFormDataRequest requestWithURL:url];
    
    _request.delegate = self;
    [_request startAsynchronous];
    
}

- (void) requestFinished:(ASIHTTPRequest *) request
{
    
    [_dialog hideProgress];
    JSONDecoder *jsonDecoder = [[JSONDecoder alloc] init];
    NSData *data = [request responseData];
    NSDictionary *dic =  [jsonDecoder objectWithData:data];
    
    NSString *resultCode = [dic objectForKey: @"state"];
    NSString *act = [dic objectForKey:@"act"];
    if(_reloading){
        _reloading = NO;
        [_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:recommandTableView];
        [_loadMoreFooterView loadMoreshScrollViewDataSourceDidFinishedLoading:recommandTableView];
        
        [_loadMoreFooterView setHidden:YES];
    }
    if([act isEqualToString:@"INQUIRE_IMAGE_PAGE"]){
        if([resultCode isEqualToString: @"SUCCESS"]){
            [dataList removeAllObjects];
            NSMutableDictionary *resultData = [dic objectForKey:@"data"];
            NSArray *dataArray = [resultData objectForKey:@"list"];
            for(int i=0;i<[dataArray count];i++){
                [dataList addObject:[dataArray objectAtIndex:i]];
            }
            [recommandTableView reloadData];
            [_refreshHeaderView refreshLastUpdatedDate];
        }
    
    }else if([act isEqualToString:@"ADD_FAVORITE_IMAGE"]){
        if([resultCode isEqualToString:@"SUCCESS"]){
            NSDictionary *data = [dataList objectAtIndex:selectRow];
             NSString *url = [picurl stringByAppendingString:[data objectForKey:@"fileName"]];
            NSDictionary *dic = [[NSDictionary alloc]initWithObjectsAndKeys:[CommonData getUid],@"userId",[data objectForKey:@"title"],@"title",url,@"url",url,@"sPicUrl",url,@"mPicUrl",[data objectForKey:@"voteDown"],@"voteDown",[data objectForKey:@"voteUp"],@"voteUp",[data objectForKey:@"id"],@"picId", nil];
            BOOL result = [CollectionDao insertCollection:dic];
            UIAlertView *alert = nil;
            if(result){
                //
                alert =[[UIAlertView alloc]initWithTitle:@"" message:@"收藏成功" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
                [alert show];
            }else{
                alert=[[UIAlertView alloc]initWithTitle:@"" message:@"收藏失败" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
                [alert show];
                
            }
            [alert release];
            [dic release];
        }else if([resultCode isEqualToString:@"UNLOGIN"]){
            [self sinaweiboLogIn];
        }else{
            NSLog(@"collection error");

        }
    
    }else if([act isEqualToString:@"VOTE_DOWN_IMAGE"]){
        if([resultCode isEqualToString:@"SUCCESS"]){
            NSMutableDictionary *data = [dataList objectAtIndex:selectRow];
            NSDictionary *dataDic = [dic objectForKey:@"data"];
            NSString *voteDownNum = [NSString stringWithFormat:@"%@",[dataDic objectForKey:@"voteDown"]];
            NSString *url = [picurl stringByAppendingString:[data objectForKey:@"fileName"]];
            NSDictionary *updateData = [[[NSDictionary alloc] initWithObjectsAndKeys:[data objectForKey:@"id"],@"id",[data objectForKey:@"title"],@"title",url,@"picurl",[data objectForKey:@"voteUp"],@"voteUp",voteDownNum,@"voteDown",[data objectForKey:@"fileName"],@"fileName", nil] autorelease];
            [dataList setObject:updateData atIndexedSubscript:selectRow];
            [recommandTableView reloadData];
           
        }else{
            NSLog(@"votedown error");
        }
    
    
    }else if([act isEqualToString:@"VOTE_UP_IMAGE"]){
        if([resultCode isEqualToString:@"SUCCESS"]){
            NSDictionary *data = [dataList objectAtIndex:selectRow];
            NSDictionary *dataDic = [dic objectForKey:@"data"];
            NSString *voteUpNum = [NSString stringWithFormat:@"%@",[dataDic objectForKey:@"voteUp"]];
            NSString *url = [picurl stringByAppendingString:[data objectForKey:@"fileName"]];
            NSDictionary *updateData = [[[NSDictionary alloc] initWithObjectsAndKeys:[data objectForKey:@"id"],@"id",[data objectForKey:@"title"],@"title",url,@"picurl",[data objectForKey:@"voteDown"],@"voteDown",voteUpNum,@"voteUp",[data objectForKey:@"fileName"],@"fileName", nil] autorelease];
            [dataList setObject:updateData atIndexedSubscript:selectRow];
            [recommandTableView reloadData];
        }else{
            NSLog(@"voteup error");
        }
    
    }else if([act isEqualToString:@"INQUIRE_IOS_CONFIG"]){
        if([resultCode isEqualToString:@"SUCCESS"]){
            NSDictionary *data = [SettingDAO getSetting];
            NSDictionary *dataInfo = [dic objectForKey:@"data"];
            NSString *iosPointSwitch =[dataInfo objectForKey:@"iosPointSwitch"];
            NSString *flag = @"0";
            if([iosPointSwitch isEqualToString:@"on"]){
                flag = @"1";
            }
            NSDictionary *params;
            if(data == nil){
                params = [[[NSDictionary alloc]initWithObjectsAndKeys:@"0",@"lastUploadTime",flag,@"isShowFlag",@"0",@"isUpgrade",@"0",@"isBind",@"0",@"todayClickSpecialTime",@"0",@"todayClickTAOBAOTime",[CommonData getUid],@"uid", nil] autorelease];
                bool result = [SettingDAO insertSetting:params];
                NSLog(@"insert result=%d",result);
            }else{
                NSString *settingId = [data objectForKey:@"settingId"];
                params = [[[NSDictionary alloc]initWithObjectsAndKeys:flag,@"isShowFlag", nil] autorelease];
                bool result = [SettingDAO updateSetting:params bySettingId:settingId];
                NSLog(@"update result=%d",result);
        
            }
        }
    
    }else{
        NSString *wolf = [dic objectForKey:@"wolf"];
        if(wolf){
            NSString *time = [dic objectForKey:@"time"];
            _serverTime = [time longLongValue];
        }
    }
    [jsonDecoder release];
    
    
}
- (void) requestFailed:(ASIHTTPRequest *) request
{
    NSError *error = [request error];
    NSLog(@"error=%@",error);
    
}



- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    [tableView setSeparatorColor:[UIColor grayColor]];
    return [dataList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSUInteger row = [indexPath row];
    NSDictionary *rowData = [dataList objectAtIndex:row];
    static NSString *CustomCellIdentifier = @"CustomCellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CustomCellIdentifier];
    //if(cell == nil){
    cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CustomCellIdentifier] autorelease];
    //}
   
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(10, 5, 298, 390)];
    bgView.layer.borderColor = [UIColor grayColor].CGColor;
    bgView.layer.borderWidth = 0.3f;
   // bgView.backgroundColor = [UIColor colorWithRed:128/255.0 green:138/255.0 blue:135/255.0 alpha:0.2];

    [self.view addSubview:bgView];
    [bgView release];
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 298, 30)];
   
    titleLabel.font = [UIFont systemFontOfSize:14.0f];
    titleLabel.text = [rowData objectForKey:@"title"];
    titleLabel.textColor = [UIColor grayColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [bgView addSubview:titleLabel];
    [titleLabel release];
    
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 40, 298, 280)
    ];
    
    NSString *url = [picurl stringByAppendingString:[rowData objectForKey:@"fileName"]];
    [imageView setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"10.png"]];
     imageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showPicDetail:)];
    imageView.tag = [indexPath row];
    tapGesture.delegate = self;
    [imageView addGestureRecognizer:tapGesture];
    
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    [bgView addSubview:imageView];
    [imageView release];
    [tapGesture release];
    
    UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(0, 335, 298, 0.3f)];
    line.backgroundColor = [UIColor grayColor];
    [bgView addSubview:line];
    [line release];
    
   
    UIButton *goodButton = [UIButton buttonWithType:UIButtonTypeCustom];
    goodButton.frame = CGRectMake(9, 345, 30, 30);
    [goodButton addTarget:self action:@selector(voteup:) forControlEvents:UIControlEventTouchUpInside];
    [goodButton setImage:[UIImage imageNamed:@"good.png"] forState:UIControlStateNormal];
     [goodButton setImage:[UIImage imageNamed:@"good_on.png"] forState:UIControlStateHighlighted];
     goodButton.tag = row;
    [bgView addSubview:goodButton];
    
    UILabel *goodNumLabel = [[UILabel alloc] initWithFrame:CGRectMake(44, 345, 25, 30)];
    goodNumLabel.text = [NSString stringWithFormat:@"%@",[rowData objectForKey:@"voteUp"]];
    
    goodNumLabel.font = [UIFont systemFontOfSize:13.0f];
    goodNumLabel.textAlignment = NSTextAlignmentLeft;
    goodNumLabel.textColor = [UIColor grayColor];
    [bgView addSubview:goodNumLabel];
    [goodNumLabel release];
    
    UILabel *verticalLine = [[UILabel alloc] initWithFrame:CGRectMake(74, 350, 0.3f, 20)];
    verticalLine.backgroundColor = [UIColor grayColor];
    [bgView addSubview:verticalLine];
    [verticalLine release];
    
    
    
    
    UIButton *badButton = [UIButton buttonWithType:UIButtonTypeCustom];
    badButton.frame = CGRectMake(85, 345, 30, 30);
    [badButton setImage:[UIImage imageNamed:@"bad.png"] forState:UIControlStateNormal];
    //[badButton setImage:[UIImage imageNamed:@"bad_active.png"] forState:UIControlStateHighlighted];
    [badButton setImage:[UIImage imageNamed:@"bad_on.png"] forState:UIControlStateHighlighted];
    [badButton addTarget:self action:@selector(votedown:) forControlEvents:UIControlEventTouchUpInside];
    badButton.tag = row;
    [bgView addSubview:badButton];
    
    UILabel *badNumLabel = [[UILabel alloc] initWithFrame:CGRectMake(115, 345, 25, 30)];
    badNumLabel.text =[NSString stringWithFormat:@"%@",[rowData objectForKey:@"voteDown"]];
    
    badNumLabel.font = [UIFont systemFontOfSize:13.0f];
    badNumLabel.textAlignment = NSTextAlignmentLeft;
    badNumLabel.textColor = [UIColor grayColor];
    [bgView addSubview:badNumLabel];
    [badNumLabel release];
    
    verticalLine = [[UILabel alloc] initWithFrame:CGRectMake(145, 350, 0.3f, 20)];
    verticalLine.backgroundColor = [UIColor grayColor];
    [bgView addSubview:verticalLine];
    [verticalLine release];
    
    
    UIButton *collectionButton = [UIButton buttonWithType:UIButtonTypeCustom];
    collectionButton.frame = CGRectMake(156, 345, 30, 30);
    [collectionButton addTarget:self action:@selector(collect:) forControlEvents:UIControlEventTouchUpInside];
    collectionButton.tag = row;
    [collectionButton setImage:[UIImage imageNamed:@"collect.png"] forState:UIControlStateNormal];
    [collectionButton setImage:[UIImage imageNamed:@"collect_on.png"] forState:UIControlStateHighlighted];
    [bgView addSubview:collectionButton];
    
    UILabel *collectionLabel = [[UILabel alloc] initWithFrame:CGRectMake(190, 345, 30, 30)];
    collectionLabel.text = @"收藏";
    
    collectionLabel.font = [UIFont systemFontOfSize:14.0f];
    collectionLabel.textAlignment = NSTextAlignmentLeft;
    collectionLabel.textColor = [UIColor grayColor];
    [bgView addSubview:collectionLabel];
    [collectionLabel release];

    verticalLine = [[UILabel alloc] initWithFrame:CGRectMake(226, 350, 0.3f, 20)];
    verticalLine.backgroundColor = [UIColor grayColor];
    [bgView addSubview:verticalLine];
    [verticalLine release];
    
    UIButton *shareButton = [UIButton buttonWithType:UIButtonTypeCustom];
    shareButton.frame = CGRectMake(231, 345, 30, 30);
    
    [shareButton setImage:[UIImage imageNamed:@"share.png"] forState:UIControlStateNormal];
    [shareButton setImage:[UIImage imageNamed:@"share_on.png"] forState:UIControlStateHighlighted];
    shareButton.tag = row;
   [shareButton addTarget:self action:@selector(shareClick:) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:shareButton];
    
    UILabel *shareLabel = [[UILabel alloc] initWithFrame:CGRectMake(266, 345, 30, 30)];
    shareLabel.text = @"分享";
    
    shareLabel.font = [UIFont systemFontOfSize:14.0f];
    shareLabel.textAlignment = NSTextAlignmentLeft;
    shareLabel.textColor = [UIColor grayColor];
   
    [bgView addSubview:shareLabel];
    [shareLabel release];
    
    [cell.contentView addSubview:bgView];
    return cell;
}

-(void) showPicDetail:(UITapGestureRecognizer *)sender
{
    int row =  sender.view.tag;
    NSLog(@"row=%d",row);
    /*NSDictionary *data = [dataList objectAtIndex:row];
    DetailImageViewController *divc = [[[DetailImageViewController alloc] init]autorelease];
    divc.picUrl  = [picurl stringByAppendingString:[data objectForKey:@"fileName"]];
    [self presentViewController:divc animated:YES completion: nil];*/
    photos = [NSMutableArray arrayWithCapacity:1];
    NSDictionary *data = [dataList objectAtIndex:row];
    NSString *picUrl  = [picurl stringByAppendingString:[data objectForKey:@"fileName"]];
    NSLog(@"url=%@",picUrl);
    if ([picUrl hasSuffix:@".gif"]) {
        GifImageViewController *gvc = [[[GifImageViewController alloc] init] autorelease];
        gvc.picUrl = picUrl;
        [self.navigationController pushViewController:gvc animated:YES];
    }else{
        photo = [[MJPhoto alloc] init];
        photo.url = [NSURL URLWithString:picUrl]; // 图片路径
        photo.srcImageView = (UIImageView*)sender.view;
        [photos addObject:photo];
        browser = [[MJPhotoBrowser alloc] init];
        browser.currentPhotoIndex = 0; // 弹出相册时显示的第一张图片是？
        browser.photos = photos; // 设置所有的图片
        [browser show];
    }
   

}

- (IBAction)collect:(id)sender {
    if([CommonData getUid] != nil){
        UIButton *btn = (UIButton *) sender;
        NSInteger row = btn.tag;
        selectRow = row;
        NSDictionary *rowData = [dataList objectAtIndex:row];
        long long clientTime = [[NSDate date] timeIntervalSince1970]*1000 + _differentTime;
        NSString *plainText = [[NSNumber numberWithLongLong:clientTime]stringValue];
        //
        NSLog(@"plainText=%@",plainText);
        NSString *seed = [DesEncrypt encryptUseDES:plainText key:deskey];
        NSLog(@"seed = %@",seed);
        NSString *urlS = [NSString stringWithFormat:@"%@act=ADD_FAVORITE_IMAGE&imageId=%@&seed=%@&sid=%@",serverUrl,[rowData objectForKey:@"id"],seed,[CommonData getSid]];
        NSLog(@"url=%@",urlS);
        NSURL *url = [NSURL URLWithString:urlS];
        _collectRequest =  [ASIFormDataRequest requestWithURL:url];
        _collectRequest.delegate = self;
        
        [_collectRequest startAsynchronous];
    }else{
        [self sinaweiboLogIn];
    }
}



- (IBAction)voteup:(id)sender {

    UIButton *btn = (UIButton *) sender;
    NSInteger row = btn.tag;
    selectRow = row;
    NSDictionary *rowData = [dataList objectAtIndex:row];
    long long clientTime = [[NSDate date] timeIntervalSince1970]*1000 + _differentTime;
    NSString *plainText = [[NSNumber numberWithLongLong:clientTime]stringValue];
    //
    NSLog(@"plainText=%@",plainText);
    NSString *seed = [DesEncrypt encryptUseDES:plainText key:deskey];
    NSLog(@"seed = %@",seed);
    NSString *urlS = [NSString stringWithFormat:@"%@act=VOTE_UP_IMAGE&id=%@&seed=%@",serverUrl,[rowData objectForKey:@"id"],seed];
    NSLog(@"url=%@",urlS);
    NSURL *url = [NSURL URLWithString:urlS];
    _voteUpRequest = [ASIFormDataRequest requestWithURL:url];
    _voteUpRequest.delegate = self;
    
    [_voteUpRequest startAsynchronous];
}



- (IBAction)votedown:(id)sender {
    
    // dialog = [[Dialog alloc] init];
    //[dialog showProgress:self];
    UIButton *btn = (UIButton *) sender;
    NSInteger row = btn.tag;
    selectRow = row;
    NSDictionary *rowData = [dataList objectAtIndex:row];
    long long clientTime = [[NSDate date] timeIntervalSince1970]*1000 + _differentTime;
    NSString *plainText = [[NSNumber numberWithLongLong:clientTime]stringValue];
    //
    NSLog(@"plainText=%@",plainText);
    NSString *seed = [DesEncrypt encryptUseDES:plainText key:deskey];
    NSLog(@"seed = %@",seed);
    NSString *urlS = [NSString stringWithFormat:@"%@act=VOTE_DOWN_IMAGE&id=%@&seed=%@",serverUrl,[rowData objectForKey:@"id"],seed];
    NSLog(@"url=%@",urlS);
    NSURL *url = [NSURL URLWithString:urlS];
    _voteDownRequest = [ASIFormDataRequest requestWithURL:url];
    _voteDownRequest.delegate = self;
    
    [_voteDownRequest startAsynchronous];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    
    return YES;
}


#pragma mark Table Delegate Methods
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 400;
}

/*- (NSIndexPath *)tableView:(UITableView *)tableView
  willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *data = [dataList objectAtIndex:[indexPath row]];
    DetailImageViewController *divc = [[[DetailImageViewController alloc] init]autorelease];
    divc.picUrl  = [picurl stringByAppendingString:[data objectForKey:@"fileName"]];
    [self presentViewController:divc animated:YES completion: nil];
    return indexPath;
    return indexPath;
    
}*/

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


//还可以添加下拉刷新和滑动删除等等
- (void)dealloc {
    [_dialog release];
    [actionSheet release];
    [photos release];
    [photo release];
    [browser release];
    
    [super dealloc];
}

- (IBAction)search:(id)sender {
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"search" message:@"search" delegate:self cancelButtonTitle:@"test" otherButtonTitles:@"search", nil];
    [alert show];
}
- (IBAction) shareClick: (id)sender
{
    UIButton *btn = (UIButton *) sender;
    NSInteger row = btn.tag;
    NSDictionary *rowData = [dataList objectAtIndex:row];
    NSString *url = [picurl stringByAppendingString:[rowData objectForKey:@"fileName"]];
   id<ISSCAttachment> image = [ShareSDK imageWithUrl:url];
    //构造分享内容
    id<ISSContent> publishContent = [ShareSDK content:[rowData objectForKey:@"title"]
                                       defaultContent:@"来自代码大爆炸http://www.bigcodebang.com"
                                                image:image
                                                title:[rowData objectForKey:@"title"]
                                                  url:url
                                          description:@"来自代码大爆炸http://www.bigcodebang.com"
                                            mediaType:SSPublishContentMediaTypeNews];
    
    [ShareSDK showShareActionSheet:nil
                         shareList:nil
                           content:publishContent
                     statusBarTips:YES
                       authOptions:nil
                      shareOptions: nil
                            result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                                if (state == SSResponseStateSuccess)
                                {
                                    NSLog(@"分享成功");
                                }
                                else if (state == SSResponseStateFail)
                                {
                                    NSLog(@"分享失败,错误码:%d,错误描述:%@", [error errorCode], [error errorDescription]);
                                }
                            }];
}
@end

