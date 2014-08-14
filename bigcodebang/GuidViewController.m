//
//  GuidViewController.m
//  BigBand
//
//  Created by nelson on 14-7-26.
//  Copyright (c) 2014年 ioschen. All rights reserved.
//

#import "GuidViewController.h"
#import "RecommandViewController.h"
#import "MEViewController.h"
#import "ServiceViewController.h"

@interface GuidViewController ()

@end

@implementation GuidViewController
@synthesize gotoMainViewBtn = _gotoMainViewBtn;

@synthesize imageView;
@synthesize left = _left;
@synthesize right = _right;
@synthesize pageScroll;
@synthesize pageControl;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    pageControl.numberOfPages = 4;
    pageControl.currentPage = 0;
    pageScroll.delegate = self;
    
    pageScroll.contentSize = CGSizeMake(self.view.frame.size.width * 4, self.view.frame.size.height);
    
    
}

- (void)viewDidUnload
{
    
    [self setGotoMainViewBtn:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

-(void)dealloc
{
    [_gotoMainViewBtn release];
    [super dealloc];
    [self.imageView release];
    [self.left release];
    [self.right release];
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

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}




-(void)animationDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context
{
    if ([animationID isEqualToString:@"split"] && finished) {
        
        [self.left removeFromSuperview];
        [self.right removeFromSuperview];
        
       RecommandViewController *wx  =[[RecommandViewController alloc]init];
       MEViewController *me =[[MEViewController alloc]init];
        ServiceViewController *service = [[ServiceViewController alloc]init];
       UITabBarController *tabBarController  =[[UITabBarController alloc]init];
        NSArray *viewControllers=[NSArray arrayWithObjects:wx,service,me, nil];
        [tabBarController setViewControllers:viewControllers];
        UINavigationController *navigrationCtrl = [[UINavigationController alloc]initWithRootViewController:tabBarController];
        navigrationCtrl.navigationBarHidden = YES;
        [self presentViewController:navigrationCtrl animated:YES
                         completion:^{
        }];
   
        
        
    }
}

- (IBAction)gotoMainView:(id)sender {
    
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"firstLaunch"];
    [self.gotoMainViewBtn setHidden:YES];
    NSArray *array = [UIImage splitImageIntoTwoParts:self.imageView.image];
    self.left = [[UIImageView alloc] initWithImage:[array objectAtIndex:0]];
    self.right = [[UIImageView alloc] initWithImage:[array objectAtIndex:1]];
    [self.view addSubview:self.left];
    [self.view addSubview:self.right];
    [self.pageScroll setHidden:YES];
    [self.pageControl setHidden:YES];
    self.left.transform = CGAffineTransformIdentity;
    self.right.transform = CGAffineTransformIdentity;
    
    [UIView beginAnimations:@"split" context:nil];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDuration:1];
    [UIView setAnimationDidStopSelector:@selector(animationDidStop:finished:context:)];
    
    self.left.transform = CGAffineTransformMakeTranslation(-160 ,0);
    self.right.transform = CGAffineTransformMakeTranslation(160 ,0);
    [UIView commitAnimations];
    
}


-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat pageWidth = self.view.frame.size.width;
    int page = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    
    pageControl.currentPage = page;
}
@end
