//
//  ZYHomeDropdown.h
//  团购HD
//
//  Created by 王志盼 on 15/8/11.
//  Copyright (c) 2015年 王志盼. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ZYHomeDropdown;

@protocol ZYHomeDropdownDataSource <NSObject>
/**
 *  左边表格一共有多少行
 */
- (NSUInteger)numberOfRowsInMainTable:(ZYHomeDropdown *)homeDropdown;

/**
 *  左边表格每一行的标题
 *
 */
- (NSString *)homeDropdown:(ZYHomeDropdown *)homeDropdown titleForRowInMainTable:(NSUInteger)row;

/**
 *  左边表格每一行的子数据
 *
 */
- (NSArray *)homeDropdown:(ZYHomeDropdown *)homeDropdown subDataForRowInMainTable:(NSUInteger)row;

@optional
/**
 *  左边表格每一行的图标
 *
 */
- (NSString *)homeDropdown:(ZYHomeDropdown *)homeDropdown normalIconForRowInMainTable:(NSUInteger)row;

/**
 *  左边表格每一行的选中图标
 *
 */
- (NSString *)homeDropdown:(ZYHomeDropdown *)homeDropdown selectedIconForRowInMainTable:(NSUInteger)row;
@end

@protocol ZYHomeDropdownDelegate <NSObject>



@end

@interface ZYHomeDropdown : UIView
@property (nonatomic, weak) id<ZYHomeDropdownDataSource>dataSource;

+ (instancetype)homeDropdown;
@end
