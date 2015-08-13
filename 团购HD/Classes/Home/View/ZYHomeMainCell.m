//
//  ZYHomeMainCell.m
//  团购HD
//
//  Created by 王志盼 on 15/8/12.
//  Copyright (c) 2015年 王志盼. All rights reserved.
//

#import "ZYHomeMainCell.h"
#import "ZYCategory.h"

#define Identifie @"HomeMainCell"

@implementation ZYHomeMainCell

+ (instancetype)mainCellWithTableView:(UITableView *)tableView
{
    ZYHomeMainCell *cell = [tableView dequeueReusableCellWithIdentifier:Identifie];
    if (cell == nil) {
        cell = [[self alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:Identifie];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        UIImageView *bg = [[UIImageView alloc] init];
        bg.image = [UIImage imageNamed:@"bg_dropdown_leftpart"];
        self.backgroundView = bg;
        
        UIImageView *selectedBg = [[UIImageView alloc] init];
        selectedBg.image = [UIImage imageNamed:@"bg_dropdown_left_selected"];
        self.selectedBackgroundView = selectedBg;
    }
    return self;
}

- (void)setCategory:(ZYCategory *)category
{
    _category = category;
    self.imageView.image = [UIImage imageNamed:category.small_icon];
    self.textLabel.text = category.name;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
    if (selected) {
        self.imageView.image = [UIImage imageNamed:_category.small_highlighted_icon];
    }
    else{
        self.imageView.image = [UIImage imageNamed:_category.small_icon];
    }
}

- (void)awakeFromNib {
    // Initialization code
}



@end
