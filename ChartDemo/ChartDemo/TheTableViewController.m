//
//  TheTableViewController.m
//  ChartDemo
//
//  Created by Dzy on 19/01/2017.
//  Copyright © 2017 Dzy. All rights reserved.
//

#import "TheTableViewController.h"

@interface TheTableViewController ()
{
    UITableView *zmitTableView;
    UITableView *secondTableView;

}
#define kScreenWidth 320
#define kScreenHeight 480

@end

@implementation TheTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    zmitTableView = [[UITableView alloc] initWithFrame:CGRectMake(0 , 0, kScreenWidth, kScreenHeight)];
    
    secondTableView = [[UITableView alloc] initWithFrame:CGRectMake(0,100, kScreenWidth, kScreenHeight)];

    secondTableView.scrollEnabled = NO;
    secondTableView.userInteractionEnabled = YES;
    [zmitTableView addSubview:secondTableView];
    [self.view addSubview:  zmitTableView];

    UIPanGestureRecognizer   *panGestureRecognize = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
    
    [secondTableView addGestureRecognizer:panGestureRecognize];

    // Do any additional setup after loading the view.
}

-(void)handlePan:(UIPanGestureRecognizer *)sender
{
    CGPoint translatin = [sender translationInView:secondTableView];
    sender.view.center = CGPointMake(sender.view.center.x + translatin.x, sender.view.center.y);
//    [sender setTranslation:CGPointZero inView:self.YidaScrollView.scrollViewTableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
