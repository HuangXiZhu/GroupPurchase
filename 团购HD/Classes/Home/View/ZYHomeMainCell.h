//
//  ZYHomeMainCell.h
//  团购HD
//
//  Created by 王志盼 on 15/8/12.
//  Copyright (c) 2015年 王志盼. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ZYCategory;
@interface ZYHomeMainCell : UITableViewCell
@property (nonatomic, strong) ZYCategory *category;

+ (instancetype)mainCellWithTableView:(UITableView *)tableView;
@end
