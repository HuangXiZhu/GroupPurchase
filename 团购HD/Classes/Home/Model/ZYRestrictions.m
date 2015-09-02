//
//  ZYRestrictions.m
//  团购HD
//
//  Created by 王志盼 on 15/8/31.
//  Copyright (c) 2015年 王志盼. All rights reserved.
//

#import "ZYRestrictions.h"

@implementation ZYRestrictions

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init]) {
        self.is_reservation_required = (int)[[aDecoder decodeObjectForKey:@"is_reservation_required"] integerValue];
        self.is_refundable = (int)[[aDecoder decodeObjectForKey:@"is_refundable"] integerValue];
        self.special_tips = [aDecoder decodeObjectForKey:@"special_tips"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:@(self.is_refundable) forKey:@"is_refundable"];
    [aCoder encodeObject:@(self.is_reservation_required) forKey:@"is_reservation_required"];
    [aCoder encodeObject:self.special_tips forKey:@"special_tips"];
}

@end
