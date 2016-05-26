//
//  ViewController.m
//  SlideMenu
//
//  Created by csh on 16/5/25.
//  Copyright © 2016年 csh. All rights reserved.
//

#import "ViewController.h"
#import "SlideNavigationController.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}
- (IBAction)openMenu:(id)sender {
    [[SlideNavigationController sharedInstance] openMenu:MenuLeft withCompletion:nil];
    
}
#pragma mark - SlideNavigationController Methods -

- (BOOL)slideNavigationControllerShouldDisplayLeftMenu
{
    return YES;
}

- (BOOL)slideNavigationControllerShouldDisplayRightMenu
{
    return YES;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
