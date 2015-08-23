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
#import "ZYHomeDropdown.h"
#import "ZYConst.h"
#import "ZYMetaTool.h"
#import "UIView+Extension.h"
#import "ZYRegion.h"

@interface ZYDistrictViewController () <ZYHomeDropdownDataSource, ZYHomeDropdownDelegate>

- (IBAction)changeCity:(id)sender;
@end

@implementation ZYDistrictViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    ZYHomeDropdown *dropdown = [ZYHomeDropdown homeDropdown];
    dropdown.dataSource = self;
    dropdown.delegate = self;
    UIView *title = [self.view.subviews firstObject];
    dropdown.y = title.height;
    [self.view addSubview:dropdown];
    self.preferredContentSize = CGSizeMake(dropdown.width, CGRectGetMaxY(dropdown.frame));
}

- (IBAction)changeCity:(id)sender {
    
    /**
     *  注意，应当先让它自己注销掉，再从主窗口presentViewController，一个窗口，只能present一个ViewController
     */
    [self dismissViewControllerAnimated:YES completion:nil];
    ZYCityViewController *cityVc = [[ZYCityViewController alloc] initWithNibName:@"ZYCityViewController" bundle:nil];
    UINavigationController *nVc = [[UINavigationController alloc] initWithRootViewController:cityVc];
    nVc.modalPresentationStyle = UIModalPresentationFormSheet;
    
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:nVc animated:YES completion:nil];
    
}

#pragma mark ----ZYHomeDropdownDataSource
- (NSUInteger)numberOfRowsInMainTable:(ZYHomeDropdown *)homeDropdown
{
    return self.regions.count;
}

- (NSString *)homeDropdown:(ZYHomeDropdown *)homeDropdown titleForRowInMainTable:(NSUInteger)row
{
    return [self.regions[row] name];
}

- (NSArray *)homeDropdown:(ZYHomeDropdown *)homeDropdown subDataForRowInMainTable:(NSUInteger)row
{
    return [self.regions[row] subregions];
}

#pragma mark ----ZYHomeDropdownDelegate
- (void)homeDropdown:(ZYHomeDropdown *)homeDropdown didSelectedRowInMainTable:(int)row
{
    ZYRegion *region = self.regions[row];
    if (region.subregions == 0) {
        [[NSNotificationCenter defaultCenter] postNotificationName:ZYRegionDidChangeNotification object:nil userInfo:@{ZYSelectCategory : region}];
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)homeDropdown:(ZYHomeDropdown *)homeDropdown didSelectedRowInSubTable:(int)subRow mainRow:(int)mainRow
{
    ZYRegion *region = self.regions[mainRow];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:ZYRegionDidChangeNotification object:nil userInfo:@{ZYSelectRegion : region, ZYSelectSubregionName : region.subregions[subRow]}];
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
