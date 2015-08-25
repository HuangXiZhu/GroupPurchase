//
//  ZYCenterLineLabel.m
//  团购HD
//
//  Created by 王志盼 on 15/8/24.
//  Copyright (c) 2015年 王志盼. All rights reserved.
//

#import "ZYCenterLineLabel.h"

@implementation ZYCenterLineLabel

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
    CGContextRef ref = UIGraphicsGetCurrentContext();
    [[UIColor blackColor] set];
    CGContextMoveToPoint(ref, 0, rect.size.height * 0.5);
    CGContextAddLineToPoint(ref, rect.size.width, rect.size.height * 0.5);
    CGContextSetLineWidth(ref, 1);
    CGContextStrokePath(ref);
}

@end
