//
//  ZYCityViewController.m
//  团购HD
//
//  Created by 王志盼 on 15/8/12.
//  Copyright (c) 2015年 王志盼. All rights reserved.
//

#import "ZYCityViewController.h"
#import "UIBarButtonItem+ZYExtension.h"
#import "ZYConst.h"
#import "ZYCityGroup.h"
#import "MJExtension.h"
#import "ZYCitySearchResultTableViewController.h"
#import "UIView+AutoLayout.h"
#import "ZYConst.h"

@interface ZYCityViewController () <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate>
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *coverBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *searchBarTopConstraint;


@property (nonatomic, strong) NSArray *cityGroups;
@property (nonatomic, weak) ZYCitySearchResultTableViewController *citySearchResultVc;

- (IBAction)clickCoverBtn:(id)sender;
@end


@implementation ZYCityViewController

- (ZYCitySearchResultTableViewController *)citySearchResultVc
{
    if (_citySearchResultVc == nil) {
        ZYCitySearchResultTableViewController *citySearchResultVc = [[ZYCitySearchResultTableViewController alloc] init];
        /**
         *  只要一个控制器在另一个控制器内（上），那么这两个控制器一定要互为父子关系
         */
        [self addChildViewController:citySearchResultVc];
        _citySearchResultVc = citySearchResultVc;
        
        [self.view addSubview:citySearchResultVc.view];
        
        //添加约束
        [self.citySearchResultVc.view autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(0, 0, 0, 0) excludingEdge:ALEdgeTop];
        [self.citySearchResultVc.view autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.searchBar withOffset:15];
    }
    return _citySearchResultVc;
}

- (NSArray *)cityGroups
{
    if (_cityGroups == nil) {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"cityGroups.plist" ofType:nil];
        _cityGroups = [ZYCityGroup objectArrayWithFile:path];
    }
    return _cityGroups;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self setupNar];
    [self setupSearchBar];
    [self setupTableView];
    
}

#pragma mark ----setup系列
- (void)setupNar
{
    self.navigationItem.title = @"切换城市";
    
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem barButtonItemWithTarget:self action:@selector(clickLeftBarButton) normalImage:@"btn_navigation_close" highImage:@"btn_navigation_close_hl"];
}

- (void)setupSearchBar
{
    self.searchBar.delegate = self;
    self.searchBar.backgroundImage = [UIImage imageNamed:@"bg_login_textfield"];
}

- (void)setupTableView
{
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
}


#pragma mark ----UISearchBarDelegate
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    self.searchBarTopConstraint.constant = 15;
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    
    [UIView animateWithDuration:0.3 animations:^{
        [self.view layoutIfNeeded];
        self.coverBtn.alpha = 0.4;
    } completion:^(BOOL finished) {
        self.searchBar.showsCancelButton = YES;
    }];
    
    
    self.searchBar.tintColor = ZYColor(32, 191, 179);
    self.searchBar.backgroundImage = [UIImage imageNamed:@"bg_login_textfield_hl"];
    
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    self.searchBarTopConstraint.constant = 59;
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    
    [UIView animateWithDuration:0.3 animations:^{
        [self.view layoutIfNeeded];
        self.coverBtn.alpha = 0;
    } completion:nil];
    self.searchBar.showsCancelButton = NO;
    self.searchBar.backgroundImage = [UIImage imageNamed:@"bg_login_textfield"];
    self.searchBar.text = nil;
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if (searchText == nil || searchText.length == 0) {
        self.citySearchResultVc.view.hidden = YES;
    }
    else{
        self.citySearchResultVc.view.hidden = NO;
        self.citySearchResultVc.searchText = searchText;
    }
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [self.searchBar resignFirstResponder];
}

#pragma mark ----UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.cityGroups.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    ZYCityGroup *cityGroup = self.cityGroups[section];
    return cityGroup.cities.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * identifier = @"CityViewControllerCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    ZYCityGroup *cityGroup = self.cityGroups[indexPath.section];
    cell.textLabel.text = cityGroup.cities[indexPath.row];
    return cell;
}

#pragma mark ----UITableViewDelegate

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    ZYCityGroup *cityGroup = self.cityGroups[section];
    return cityGroup.title;
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    return [self.cityGroups valueForKeyPath:@"title"];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ZYCityGroup *cityGroup = self.cityGroups[indexPath.section];
    [[NSNotificationCenter defaultCenter] postNotificationName:ZYCityDidChangeNotification object:nil userInfo:@{ZYSelectedCityName : cityGroup.cities[indexPath.row]}];
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark ---- click事件
- (void)clickLeftBarButton
{
    [self dismissViewControllerAnimated:YES completion:nil];

}

- (IBAction)clickCoverBtn:(id)sender {
    [self.searchBar resignFirstResponder];
}

#pragma mark ----deallow
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
