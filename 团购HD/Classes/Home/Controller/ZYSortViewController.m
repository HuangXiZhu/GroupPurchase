//
//  ZYSortViewController.m
//  团购HD
//
//  Created by 王志盼 on 15/8/20.
//  Copyright (c) 2015年 王志盼. All rights reserved.
//

#import "ZYSortViewController.h"
#import "ZYMetaTool.h"
#import "ZYSort.h"
#import "UIView+Extension.h"
#import "ZYConst.h"

@interface ZYSortButton : UIButton
@property (nonatomic, strong) ZYSort *sort;
@end

@implementation ZYSortButton
- (instancetype)initWithFrame:(CGRect)frame
{
    if(self = [super initWithFrame:frame]) {
        [self setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
        [self setBackgroundImage:[UIImage imageNamed:@"btn_filter_normal"] forState:UIControlStateNormal];
        [self setBackgroundImage:[UIImage imageNamed:@"btn_filter_selected"] forState:UIControlStateHighlighted];
    }
    return self;
}

- (void)setSort:(ZYSort *)sort
{
    _sort = sort;
    
    [self setTitle:sort.label forState:UIControlStateNormal];
}
@end

@interface ZYSortViewController ()

@end

@implementation ZYSortViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSArray *sorts = [ZYMetaTool sorts];
    NSUInteger count = sorts.count;
    CGFloat btnW = 100;
    CGFloat btnH = 30;
    CGFloat btnX = 15;
    CGFloat btnStartY = 15;
    CGFloat btnMargin = 15;
    CGFloat height = 0;
    for (NSUInteger i = 0; i<count; i++) {
        ZYSortButton *button = [[ZYSortButton alloc] init];
        // 传递模型
        button.sort = sorts[i];
        button.width = btnW;
        button.height = btnH;
        button.x = btnX;
        button.y = btnStartY + i * (btnH + btnMargin);
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        button.tag = i;
        [self.view addSubview:button];
        
        height = CGRectGetMaxY(button.frame);
    }
    
    // 设置控制器在popover中的尺寸
    CGFloat width = btnW + 2 * btnX;
    height += btnMargin;
    self.preferredContentSize = CGSizeMake(width, height);
}

- (void)buttonClick:(ZYSortButton *)button
{
    [[NSNotificationCenter defaultCenter] postNotificationName:ZYSortDidChangeNotification object:nil userInfo:@{ZYSelectSort : button.sort}];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
