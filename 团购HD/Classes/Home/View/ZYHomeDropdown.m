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
//主表中被选的cell的row
@property (nonatomic, assign) int selectedMainRow;
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
        return [self.dataSource numberOfRowsInMainTable:self];
    }
    else{
        return [self.dataSource homeDropdown:self subDataForRowInMainTable:self.selectedMainRow].count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.mainTableView) {
        ZYHomeMainCell *cell = [ZYHomeMainCell mainCellWithTableView:tableView];
        cell.textLabel.text = [self.dataSource homeDropdown:self titleForRowInMainTable:indexPath.row];
        
        if ([self.dataSource respondsToSelector:@selector(homeDropdown:normalIconForRowInMainTable:)]) {
            
            cell.imageView.image = [UIImage imageNamed:[self.dataSource homeDropdown:self normalIconForRowInMainTable:indexPath.row]];
        }
        
        if ([self.dataSource respondsToSelector:@selector(homeDropdown:selectedIconForRowInMainTable:)]) {
            
            cell.imageView.highlightedImage = [UIImage imageNamed:[self.dataSource homeDropdown:self selectedIconForRowInMainTable:indexPath.row]];
        }
        
        NSArray *subData = [self.dataSource homeDropdown:self subDataForRowInMainTable:indexPath.row];
        
        if (subData.count) {
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        else{
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
        
        return cell;
    }
    else{
        ZYHomeSubCell *cell = [ZYHomeSubCell subCellWithTableView:tableView];
        
        NSArray *subData = [self.dataSource homeDropdown:self subDataForRowInMainTable:self.selectedMainRow];
        
        cell.textLabel.text = subData[indexPath.row];
        
        return cell;
    }
}


#pragma mark ----UITabelViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.mainTableView) {
        self.selectedMainRow = (int)indexPath.row;
        [self.subTableview reloadData];
        
        if ([self.delegate respondsToSelector:@selector(homeDropdown:didSelectedRowInMainTable:)]) {
            [self.delegate homeDropdown:self didSelectedRowInMainTable:(int)indexPath.row];
        }
    }
    else{
        if ([self.delegate respondsToSelector:@selector(homeDropdown:didSelectedRowInSubTable:mainRow:)]) {
            [self.delegate homeDropdown:self didSelectedRowInSubTable:(int)indexPath.row mainRow:self.selectedMainRow];
        }
    }
}
@end
