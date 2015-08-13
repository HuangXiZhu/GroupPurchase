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
@interface ZYCategoryViewController ()

@end

@implementation ZYCategoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    ZYHomeDropdown *dropdown = [ZYHomeDropdown homeDropdown];
    NSString *path = [[NSBundle mainBundle] pathForResource:@"categories.plist" ofType:nil];
    dropdown.categories = [ZYCategory objectArrayWithFile:path];
    [self.view addSubview:dropdown];
    
    // 设置控制器view在popover中的尺寸
    self.preferredContentSize = dropdown.size;
}

@end
