//
//  ZYHomeDropdown.m
//  团购HD
//
//  Created by 王志盼 on 15/8/11.
//  Copyright (c) 2015年 王志盼. All rights reserved.
//

#import "ZYHomeDropdown.h"

@interface ZYHomeDropdown () <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *mainTableView;
@property (weak, nonatomic) IBOutlet UITableView *subTableview;

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
    return 20;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc] init];
    return cell;
}
@end
