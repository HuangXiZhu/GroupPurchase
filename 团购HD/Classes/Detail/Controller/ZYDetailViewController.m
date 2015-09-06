//
//  ZYDetailViewController.m
//  团购HD
//
//  Created by 王志盼 on 15/8/31.
//  Copyright (c) 2015年 王志盼. All rights reserved.
//

#import "ZYDetailViewController.h"
#import "DPAPI.h"
#import "ZYConst.h"
#import "ZYDeal.h"
#import "MJExtension.h"
#import "ZYRestrictions.h"
#import "MBProgressHUD+MJ.h"
#import "UIImageView+WebCache.h"
#import "ZYDealCell.h"
#import "MBProgressHUD+MJ.h"
#import "ZYDealTool.h"

@interface ZYDetailViewController () <UIWebViewDelegate, DPRequestDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *webView;
- (IBAction)back;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *descLabel;
- (IBAction)buy;
- (IBAction)collect;
- (IBAction)share;
@property (weak, nonatomic) IBOutlet UIButton *collectButton;
@property (weak, nonatomic) IBOutlet UIButton *refundableAnyTimeButton;
@property (weak, nonatomic) IBOutlet UIButton *refundableExpireButton;
@property (weak, nonatomic) IBOutlet UIButton *leftTimeButton;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@end
@implementation ZYDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = ZYGlobalBg;
    self.webView.delegate = self;
    
    self.webView.hidden = YES;
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.deal.deal_h5_url]]];
    
    self.titleLabel.text = self.deal.title;
    self.descLabel.text = self.deal.desc;
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:self.deal.s_image_url] placeholderImage:[UIImage imageNamed:@"placeholder_deal"]];
    NSDateFormatter *fZY = [[NSDateFormatter alloc] init];
    fZY.dateFormat = @"yyyy-MM-dd";
    NSDate *dead = [fZY dateFromString:self.deal.purchase_deadline];
    dead = [dead dateByAddingTimeInterval:24 * 60 * 60];
    NSDate *now = [NSDate date];
    NSCalendarUnit unit = NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute;
    NSDateComponents *cmps = [[NSCalendar currentCalendar] components:unit fromDate:now toDate:dead options:0];
    if (cmps.day > 365) {
        [self.leftTimeButton setTitle:@"一年内不过期" forState:UIControlStateNormal];
    } else {
        [self.leftTimeButton setTitle:[NSString stringWithFormat:@"%d天%d小时%d分钟", cmps.day, cmps.hour, cmps.minute] forState:UIControlStateNormal];
    }
    
    DPAPI *api = [[DPAPI alloc] init];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"deal_id"] = self.deal.deal_id;
    [api requestWithURL:@"v1/deal/get_single_deal" params:params delegate:self];
    
}

/**
 *  返回控制器支持的方向
 */
- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskLandscape;
}

#pragma mark - DPRequestDelegate
- (void)request:(DPRequest *)request didFinishLoadingWithResult:(id)result
{
    self.deal = [ZYDeal objectWithKeyValues:[result[@"deals"] firstObject]];
    // 设置退款信息
    self.refundableAnyTimeButton.selected = self.deal.restrictions.is_refundable;
    self.refundableExpireButton.selected = self.deal.restrictions.is_refundable;
}

- (void)request:(DPRequest *)request didFailWithError:(NSError *)error
{
    [MBProgressHUD showError:@"网络繁忙,请稍后再试" toView:self.view];
}

#pragma mark - UIWebViewDelegate
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    if ([webView.request.URL.absoluteString isEqualToString:self.deal.deal_h5_url]) {
        // 旧的HTML5页面加载完毕
        NSString *ID = [self.deal.deal_id substringFromIndex:[self.deal.deal_id rangeOfString:@"-"].location + 1];
        NSString *urlStr = [NSString stringWithFormat:@"http://lite.m.dianping.com/group/deal/moreinfo/%@", ID];
        [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlStr]]];
    } else { // 详情页面加载完毕
        
        webView.hidden = NO;
    }
}

- (IBAction)back {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)buy {
    
    
}

- (IBAction)collect {
    
    self.collectButton.selected = !self.collectButton.isSelected;
    
    NSMutableDictionary *info = [NSMutableDictionary dictionary];
    
    if (self.collectButton.selected) {
        info[ZYIsCollectKey] = @(YES);
        [ZYDealTool addCollectionDeal:self.deal];
        [MBProgressHUD showSuccess:@"收藏成功..." toView:self.view];
    }
    else{
        info[ZYIsCollectKey] = @(NO);
        [ZYDealTool removeCollectionDeal:self.deal];
        [MBProgressHUD showSuccess:@"取消收藏成功..." toView:self.view];
    }
    info[ZYCollectDealKey] = self.deal;
    
    [[NSNotificationCenter defaultCenter] postNotificationName:ZYCollectStateDidChangeNotification object:nil userInfo:info];
}

- (IBAction)share {
    
}

@end
