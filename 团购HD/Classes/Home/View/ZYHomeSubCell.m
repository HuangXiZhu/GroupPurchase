//
//  ZYHomeSubCell.m
//  团购HD
//
//  Created by 王志盼 on 15/8/12.
//  Copyright (c) 2015年 王志盼. All rights reserved.
//

#import "ZYHomeSubCell.h"

#define Identifier @"HomeSubCell"
@implementation ZYHomeSubCell

+ (instancetype)subCellWithTableView:(UITableView *)tableView
{
    ZYHomeSubCell *cell  = [tableView dequeueReusableCellWithIdentifier:Identifier];
    if (cell == nil) {
        cell = [[self alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:Identifier];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        UIImageView *bg = [[UIImageView alloc] init];
        bg.image = [UIImage imageNamed:@"bg_dropdown_rightpart"];
        self.backgroundView = bg;
        
        UIImageView *selectedBg = [[UIImageView alloc] init];
        selectedBg.image = [UIImage imageNamed:@"bg_dropdown_right_selected"];
        self.selectedBackgroundView = selectedBg;
        
    }
    return self;
}


- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
