//
//  ZYHomeDropdown.m
//  团购HD
//
//  Created by 王志盼 on 15/8/11.
//  Copyright (c) 2015年 王志盼. All rights reserved.
//

#import "ZYHomeDropdown.h"
#import "ZYCategory.h"
#import "ZYHomeMainCell.h"
#import "ZYHomeSubCell.h"
#import "ZYCategory.h"
#import "ZYHomeSubCell.h"
@interface ZYHomeDropdown () <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *mainTableView;
@property (weak, nonatomic) IBOutlet UITableView *subTableview;
//主表中被选的cell的model，用来刷新从表中的数据
@property (nonatomic, strong) ZYCategory *selectedCategory;
@end

@implementation ZYHomeDropdown

+ (instancetype)homeDropdown
{
    return [[self alloc] init];
}

- (instancetype)init
{
    if (self = [super init]) {
        self = [[[NSBundle mainBundle] loadNibNamed:@"ZYHomeDropdown" owner:nil options:nil] lastObject];
        [self commitInit];
    }
    return self;
}

- (void)commitInit
{
    self.mainTableView.delegate = self;
    self.mainTableView.dataSource = self;
    
    self.subTableview.delegate = self;
    self.subTableview.dataSource = self;
}

- (void)awakeFromNib
{
    self.autoresizingMask = UIViewAutoresizingNone;
}

#pragma mark ----UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.mainTableView == tableView) {
        return self.categories.count;
    }
    else{
        return self.selectedCategory.subcategories.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.mainTableView) {
        ZYHomeMainCell *cell = [ZYHomeMainCell mainCellWithTableView:tableView];
        cell.category = self.categories[indexPath.row];
        return cell;
    }
    else{
        ZYHomeSubCell *cell = [ZYHomeSubCell subCellWithTableView:tableView];
        cell.subcategory = self.selectedCategory.subcategories[indexPath.row];
        return cell;
    }
}


#pragma mark ----UITabelViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.mainTableView) {
        ZYHomeMainCell *cell = (ZYHomeMainCell *)[tableView cellForRowAtIndexPath:indexPath];
        self.selectedCategory = cell.category;
        [self.subTableview reloadData];
    }
    
}
@end
