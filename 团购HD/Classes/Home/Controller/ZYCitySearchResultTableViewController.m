//
//  ZYCitySearchResultTableViewController.m
//  团购HD
//
//  Created by 王志盼 on 15/8/16.
//  Copyright (c) 2015年 王志盼. All rights reserved.
//

#import "ZYCitySearchResultTableViewController.h"
#import "MJExtension.h"
#import "ZYCity.h"

@interface ZYCitySearchResultTableViewController ()
@property (nonatomic, strong) NSArray *cities;
@property (nonatomic, strong) NSArray *resultCities;
@end



@implementation ZYCitySearchResultTableViewController

- (NSArray *)cities
{
    if (_cities == nil) {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"cities.plist" ofType:nil];
        _cities = [ZYCity objectArrayWithFile:path];
    }
    return _cities;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setSearchText:(NSString *)searchText
{
    _searchText = searchText;
    searchText = searchText.lowercaseString;
    // 谓词\过滤器:能利用一定的条件从一个数组中过滤出想要的数据
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name contains %@ or pinYin contains %@ or pinYinHead contains %@",searchText, searchText, searchText];
    self.resultCities = [self.cities filteredArrayUsingPredicate:predicate];
    
    [self.tableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.resultCities.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * identifier = @"ZYCitySearchResultTableViewControllerCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    ZYCity *city = self.resultCities[indexPath.row];
    cell.textLabel.text = city.name;
    return cell;
}
@end
