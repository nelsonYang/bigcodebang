//
//  MyCollectionViewController.m
//  BigBand
//
//  Created by nelson on 14-7-26.
//  Copyright (c) 2014年 ioschen. All rights reserved.
//

#import "MyCollectionViewController.h"
#import "YFJLeftSwipeDeleteTableView.h"
#import "CollectionDao.h"
#import  "CommonData.h"
#import "DetailImageViewController.h"
#import "ASIFormDataRequest.h"
#import "DesEncrypt.h"
#import "JSONKit.h"
#import "Macro.h"
#import "Dialog.h"
#import "WeiboSDK.h"
#import "UIImageView+WebCache.h"
#import "MJPhotoBrowser.h"
#import "MJPhoto.h"
#import "GifImageViewController.h"

@interface MyCollectionViewController ()<ASIHTTPRequestDelegate>{
    UIButton * _deleteButton;
    NSIndexPath * _editingIndexPath;
    
    UISwipeGestureRecognizer * _leftGestureRecognizer;
    UISwipeGestureRecognizer * _rightGestureRecognizer;
    UITapGestureRecognizer * _tapGestureRecognizer;
    MJPhoto *photo;
    MJPhotoBrowser *browser;
    UIImageView *detailImageView;
    NSMutableArray *photos;
    
}
@property (nonatomic, strong) YFJLeftSwipeDeleteTableView * tableView;
@property (strong,nonatomic) NSMutableArray *list;
@property (strong,nonatomic) ASIFormDataRequest *request;
@property (strong,nonatomic) Dialog *dialog;
@end

@implementation MyCollectionViewController

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
    _list = [[NSMutableArray alloc] init];
  
    UILabel *topLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 15)];
    topLabel.backgroundColor = [UIColor colorWithRed:12/255.0 green:134/255.0 blue:243/255.0 alpha:1.0f];
    [self.view addSubview:topLabel];
    [topLabel release];
    UILabel *recommandLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 15, 320, 45)];
    recommandLabel.backgroundColor =  [UIColor colorWithRed:12/255.0 green:134/255.0 blue:243/255.0 alpha:1.0f];
    recommandLabel.text = @"我的收藏";
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
    UIButton *syncBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    syncBtn.frame = CGRectMake(250, 20, 50, 30);
    [syncBtn setTitle:@"同步" forState:UIControlStateNormal];
    [syncBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [syncBtn addTarget:self action:@selector(sync:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:syncBtn];
      [self requestData:1];
    CGRect frame = CGRectMake(0,70,self.view.bounds.size.width,self.view.bounds.size.height);
    self.tableView = [[YFJLeftSwipeDeleteTableView alloc] initWithFrame:frame];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView setSeparatorColor:[UIColor grayColor]];
    [self.view addSubview:self.tableView];
   
}

-(void) requestData:(NSInteger) page
{
    NSMutableArray *result =  [CollectionDao getCollectionByPage:page withPageCount:50 byUserId:[CommonData getUid]];
    for(int i=0;i<[result count];i++){
        [_list addObject:[result objectAtIndex:i]];
    }
    
}



#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [_list count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"collectionTableViewCell";
    
    UITableViewCell *cell = (UITableViewCell*)[tableView  dequeueReusableCellWithIdentifier:CellIdentifier];
    //if(cell == nil){
    cell = [[[UITableViewCell alloc]
                initWithStyle:UITableViewCellStyleDefault
                reuseIdentifier:CellIdentifier]autorelease];
        
    //}
    NSInteger row = [indexPath row];
    NSDictionary *data = [_list objectAtIndex:row];
    NSString *imageUrl = [data objectForKey:@"sPicUrl"];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 5, 55, 55)];
    
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    [imageView setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:[UIImage imageNamed:@"10.png"]];
    [cell.contentView addSubview:imageView];
    [imageView release];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, 5, 200, 50)];
    titleLabel.font = [UIFont systemFontOfSize:14.0f];
    titleLabel.textColor = [UIColor grayColor];
    titleLabel.text = [data objectForKey:@"title"];
    [cell.contentView addSubview:titleLabel];
    [titleLabel release];
    
    
    return cell;
}

// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        NSDictionary *data = [_list objectAtIndex:indexPath.row];
        [CollectionDao deleteCollection:[data objectForKey:@"picId"]];
        [_list removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 65;
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"row=%ld",(long)[indexPath row]);
    /*NSInteger row = [indexPath row];
    NSDictionary *data = [_list objectAtIndex:row];
    DetailImageViewController *divc = [[[DetailImageViewController alloc] init]autorelease];
    divc.picUrl =[data objectForKey:@"mPicUrl"];
    [self presentViewController:divc animated:YES completion:^{
        
    }];*/
    int row =  [indexPath row];
    NSLog(@"row=%d",row);
    /*NSDictionary *data = [dataList objectAtIndex:row];
     DetailImageViewController *divc = [[[DetailImageViewController alloc] init]autorelease];
     divc.picUrl  = [picurl stringByAppendingString:[data objectForKey:@"fileName"]];
     [self presentViewController:divc animated:YES completion: nil];*/
    photos = [NSMutableArray arrayWithCapacity:1];
    NSDictionary *dataDic = [_list objectAtIndex:row];
    NSString *picUrl  =[dataDic objectForKey:@"url"];
    NSLog(@"url=%@",picUrl);
    if([picUrl hasSuffix:@".gif"]){
        GifImageViewController *gvc = [[[GifImageViewController alloc] init] autorelease];
        gvc.picUrl = picUrl;
        [self.navigationController pushViewController:gvc animated:YES];
       // [self.navigationController:gvc animated:YES completion:^{
            
       // }];
    }else{
        photo = [[MJPhoto alloc] init];
        photo.url = [NSURL URLWithString:picUrl]; // 图片路径
        detailImageView = [[UIImageView alloc] init];
        photo.srcImageView = detailImageView;
        [photos addObject:photo];
        browser = [[MJPhotoBrowser alloc] init];
        browser.currentPhotoIndex = 0; // 弹出相册时显示的第一张图片是？
        browser.photos = photos; // 设置所有的图片
        [browser show];
    }
    return indexPath;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    [_list release];
    [_tableView release];
    [detailImageView release];
    [photos release];
    [photo release];
    [browser release];
    
    [super dealloc];
}

- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)sync:(id)sender {
    if([CommonData getUid] != nil){
        _dialog = [[Dialog alloc] init];
        [_dialog showProgress:self];
        NSString *differentTimeStr = [CommonData getDifferentTime];
        NSLog(@"differentTime=%@",differentTimeStr);
        long long differentTime =[differentTimeStr longLongValue];
        long long clientTime = [[NSDate date] timeIntervalSince1970]*1000 + differentTime;
        NSString *plainText = [[NSNumber numberWithLongLong:clientTime]stringValue];
        //
        NSLog(@"plainText=%@",plainText);
        NSString *seed = [DesEncrypt encryptUseDES:plainText key:deskey];
        NSLog(@"seed = %@",seed);
        NSString *url = [serverUrl stringByAppendingFormat:@"act=INQUIRE_FAVORITE_IMAGE&pageIndex=1&pageSize=100&sid=%@&seed=%@",[CommonData getSid],seed];
        NSURL *nsURL = [NSURL URLWithString:url];
        _request = [ASIFormDataRequest requestWithURL:nsURL];
        _request.delegate = self;
        [_request startSynchronous];
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

- (void) requestFinished:(ASIHTTPRequest *) request
{
    
    [_dialog hideProgress];
    JSONDecoder *jsonDecoder = [[JSONDecoder alloc] init];
    NSData *data = [request responseData];
    NSDictionary *dic =  [jsonDecoder objectWithData:data];
    
    NSString *resultCode = [dic objectForKey: @"state"];
    if(resultCode){
        if([resultCode isEqualToString: @"SUCCESS"]){
            NSMutableDictionary *resultData = [dic objectForKey:@"data"];
            NSArray *dataArray = [resultData objectForKey:@"list"];
            [CollectionDao deleteAllCollection];
            for (int index= 0; index <[dataArray count]; index++) {
                NSDictionary *dataDic = [dataArray objectAtIndex:index];
                NSString *url = [picurl stringByAppendingString:[dataDic objectForKey:@"fileName"]];
                NSDictionary *dic = [[NSDictionary alloc]initWithObjectsAndKeys:[CommonData getUid],@"userId",[dataDic objectForKey:@"title"],@"title",url,@"url",url,@"sPicUrl",url,@"mPicUrl",[dataDic objectForKey:@"voteDown"],@"voteDown",[dataDic objectForKey:@"voteUp"],@"voteUp",[dataDic objectForKey:@"id"],@"picId", nil];
                 [CollectionDao insertCollection:dic];
                
                [dic release];
            }
            [_list removeAllObjects];
            [self requestData:1];
            [_tableView reloadData];
        }
        
    }
    [jsonDecoder release];
    
    
}
- (void) requestFailed:(ASIHTTPRequest *) request
{
    NSError *error = [request error];
    NSLog(@"error=%@",error);
    
}

@end
