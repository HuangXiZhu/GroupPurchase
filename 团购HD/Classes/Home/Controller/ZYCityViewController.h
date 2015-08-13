//
//  ZYCityViewController.h
//  团购HD
//
//  Created by 王志盼 on 15/8/12.
//  Copyright (c) 2015年 王志盼. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ZYCityViewController;

@protocol ZYCityViewControllerDelegate <NSObject>

@optional
- (void)ZYCityViewController:(ZYCityViewController *)cityVc didClickLeftBarButton:(UIBarButtonItem *)leftBarButton;

@end

@interface ZYCityViewController : UIViewController
@property (nonatomic, weak) id<ZYCityViewControllerDelegate>delegate;
@end
