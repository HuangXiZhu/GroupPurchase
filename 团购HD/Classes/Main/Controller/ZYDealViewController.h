//
//  ZYDealViewController.h
//  团购HD
//
//  Created by 王志盼 on 15/8/25.
//  Copyright (c) 2015年 王志盼. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZYDealViewController : UICollectionViewController
/**  设置请求参数:交给子类去实现  */
- (void)setParams:(NSMutableDictionary *)params;
@end
