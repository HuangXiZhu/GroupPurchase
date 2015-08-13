//
//  ZYDistrictViewController.m
//  团购HD
//
//  Created by 王志盼 on 15/8/12.
//  Copyright (c) 2015年 王志盼. All rights reserved.
//

#import "ZYDistrictViewController.h"
#import "ZYCityViewController.h"
#import "UIBarButtonItem+ZYExtension.h"

@interface ZYDistrictViewController () <ZYCityViewControllerDelegate>

- (IBAction)changeCity:(id)sender;
@end

@implementation ZYDistrictViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (IBAction)changeCity:(id)sender {
    
    ZYCityViewController *cityVc = [[ZYCityViewController alloc] initWithNibName:@"ZYCityViewController" bundle:nil];
    UINavigationController *nVc = [[UINavigationController alloc] initWithRootViewController:cityVc];
    cityVc.delegate = self;
    nVc.modalPresentationStyle = UIModalPresentationFormSheet;
    [self presentViewController:nVc animated:YES completion:nil];
}

#pragma mark ----ZYCityViewControllerDelegate

- (void)ZYCityViewController:(ZYCityViewController *)cityVc didClickLeftBarButton:(UIBarButtonItem *)leftBarButton
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
