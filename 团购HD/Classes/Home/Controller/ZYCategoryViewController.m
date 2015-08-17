//
//  ZYCategoryViewController.m
//  团购HD
//
//  Created by 王志盼 on 15/8/11.
//  Copyright (c) 2015年 王志盼. All rights reserved.
//

#import "ZYCategoryViewController.h"
#import "ZYHomeDropdown.h"
#import "UIView+Extension.h"
#import "ZYCategory.h"
#import "MJExtension.h"
#import "ZYMetaTool.h"
@interface ZYCategoryViewController () <ZYHomeDropdownDataSource>

@end

@implementation ZYCategoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    ZYHomeDropdown *dropdown = [ZYHomeDropdown homeDropdown];
    dropdown.dataSource = self;
    [self.view addSubview:dropdown];
    
    // 设置控制器view在popover中的尺寸
    self.preferredContentSize = dropdown.size;
}

#pragma mark ----ZYHomeDropdownDataSource
- (NSUInteger)numberOfRowsInMainTable:(ZYHomeDropdown *)homeDropdown
{
    return [ZYMetaTool categories].count;
}

- (NSString *)homeDropdown:(ZYHomeDropdown *)homeDropdown titleForRowInMainTable:(NSUInteger)row
{
    return [[ZYMetaTool categories][row] name];
}

- (NSArray *)homeDropdown:(ZYHomeDropdown *)homeDropdown subDataForRowInMainTable:(NSUInteger)row
{
    return [[ZYMetaTool categories][row] subcategories];
}

- (NSString *)homeDropdown:(ZYHomeDropdown *)homeDropdown normalIconForRowInMainTable:(NSUInteger)row
{
    return [[ZYMetaTool categories][row] small_icon];
}

- (NSString *)homeDropdown:(ZYHomeDropdown *)homeDropdown selectedIconForRowInMainTable:(NSUInteger)row
{
    return [[ZYMetaTool categories][row] small_highlighted_icon];
}
@end
