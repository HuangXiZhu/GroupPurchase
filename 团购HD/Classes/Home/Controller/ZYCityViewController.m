//
//  ZYCityViewController.m
//  团购HD
//
//  Created by 王志盼 on 15/8/12.
//  Copyright (c) 2015年 王志盼. All rights reserved.
//

#import "ZYCityViewController.h"
#import "UIBarButtonItem+ZYExtension.h"
@interface ZYCityViewController ()

@end

@implementation ZYCityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self setupNar];
}

- (void)setupNar
{
    self.navigationItem.title = @"切换城市";
    
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem barButtonItemWithTarget:self action:@selector(clickLeftBarButton) normalImage:@"btn_navigation_close" highImage:@"btn_navigation_close_hl"];
}

- (void)clickLeftBarButton
{
    if ([self.delegate respondsToSelector:@selector(ZYCityViewController:didClickLeftBarButton:)]) {
        [self.delegate ZYCityViewController:self didClickLeftBarButton:nil];
    }
}

@end
