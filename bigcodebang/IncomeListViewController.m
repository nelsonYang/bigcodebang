//
//  IncomeListViewController.m
//  BigBand
//
//  Created by nelson on 14-7-20.
//  Copyright (c) 2014年 ioschen. All rights reserved.
//

#import "IncomeListViewController.h"
#import "ASIFormDataRequest.h"


@interface IncomeListViewController ()<UITableViewDataSource,UITableViewDelegate>

@property(strong,nonatomic) NSMutableArray *dataList;
@property(retain,nonatomic) ASIFormDataRequest *request;

@end

@implementation IncomeListViewController
@synthesize dataList;
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
    [self requestIncomeList:1];
    // Do any additional setup after loading the view from its nib.
    UILabel *topLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 15)];
    topLabel.backgroundColor = [UIColor colorWithRed:12/255.0 green:134/255.0 blue:243/255.0 alpha:1.0f];
    [self.view addSubview:topLabel];
    [topLabel release];
    UILabel *recommandLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 15, 320, 45)];
    recommandLabel.backgroundColor =  [UIColor colorWithRed:12/255.0 green:134/255.0 blue:243/255.0 alpha:1.0f];
    recommandLabel.text = @"提现列表";
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
}

-(void) requestIncomeList:(NSInteger) page
{


}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    [tableView setSeparatorColor:[UIColor grayColor]];
    return [dataList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CustomCellIdentifier = @"CustomCellIdentifier";
  
    
  
    return nil;
}

#pragma mark Table Delegate Methods
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80.0f;
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
    [_incomeDataView release];
    [super dealloc];
}
@end
