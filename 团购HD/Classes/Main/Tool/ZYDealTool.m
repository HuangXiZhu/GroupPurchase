//
//  ZYDealTool.m
//  团购HD
//
//  Created by 王志盼 on 15/9/1.
//  Copyright (c) 2015年 王志盼. All rights reserved.
//

#import "ZYDealTool.h"
#import "FMDB.h"
#import "ZYDeal.h"
@implementation ZYDealTool

static FMDatabase *_database;

+ (void)initialize
{
    NSString *doc = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *path = [doc stringByAppendingPathComponent:@"deal.sqlite"];
    _database = [FMDatabase databaseWithPath:path];
    
    if (![_database open]) return;
    
    [_database executeUpdateWithFormat:@"CREATE TABLE IF NOT EXISTS t_collect_deal(id integer PRIMARY KEY, deal blob NOT NULL, deal_id text NOT NULL);"];
    
    [_database executeUpdateWithFormat:@"CREATE TABLE IF NOT EXISTS t_browse_deal(id integer PRIMARY KEY, deal blob NOT NULL, deal_id text NOT NULL);"];
}

+ (void)addCollectionDeal:(ZYDeal *)deal
{
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:deal];
    [_database executeUpdateWithFormat:@"INSERT INTO t_collect_deal(deal, deal_id) VALUES (%@, %@);",data, deal.deal_id];
}
+ (void)removeCollectionDeal:(ZYDeal *)deal
{
    [_database executeUpdateWithFormat:@"DELETE FROM t_collect_deal WHERE deal_id = %@;", deal.deal_id];
}

+ (NSArray *)collectDeals:(int)page
{
    int size = 10;
    int pos = (page - 1) * size;

    NSMutableArray *deals = [NSMutableArray array];
    FMResultSet *resultSet = [_database executeQueryWithFormat:@"SELECT * FROM t_collect_deal ORDER BY id DESC LIMIT %d,%d;",pos,size];
    
    while (resultSet.next) {
        ZYDeal *deal = [NSKeyedUnarchiver unarchiveObjectWithData:[resultSet objectForColumnName:@"deal"]];
        [deals addObject:deal];
    }
    return deals;
}
+ (int)collectDealsCount
{
    FMResultSet *resultSet = [_database executeQueryWithFormat:@"SELECT count(*) AS deal_count FROM t_collect_deal;"];
    [resultSet next];
    
    return [resultSet intForColumn:@"deal_count"];
}

+ (BOOL)isCollected:(ZYDeal *)deal
{
    FMResultSet *resultSet = [_database executeQueryWithFormat:@"SELECT count(*) AS deal_count FROM t_collect_deal WHERE deal_id = %@;", deal.deal_id];
    
    [resultSet next];
    #warning 索引从1开始
    return [resultSet intForColumn:@"deal_count"] == 1;
}


+ (void)addBrowseDeal:(ZYDeal *)deal
{
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:deal];
    [_database executeUpdateWithFormat:@"INSERT INTO t_browse_deal(deal, deal_id) VALUES (%@, %@);",data, deal.deal_id];
}

+ (void)removeBrowseDeal:(ZYDeal *)deal
{
    [_database executeUpdateWithFormat:@"DELETE FROM t_browse_deal WHERE deal_id = %@;", deal.deal_id];
}

+ (NSArray *)browseDeals:(int)page
{
    int size = 10;
    int pos = (page - 1) * size;
    
    NSMutableArray *deals = [NSMutableArray array];
    FMResultSet *resultSet = [_database executeQueryWithFormat:@"SELECT * FROM t_browse_deal ORDER BY id DESC LIMIT %d,%d;",pos,size];
    
    while (resultSet.next) {
        ZYDeal *deal = [NSKeyedUnarchiver unarchiveObjectWithData:[resultSet objectForColumnName:@"deal"]];
        [deals addObject:deal];
    }
    return deals;
}

+ (int)browseDealsCount
{
    FMResultSet *resultSet = [_database executeQueryWithFormat:@"SELECT count(*) AS deal_count FROM t_browse_deal;"];
    [resultSet next];
    
    return [resultSet intForColumn:@"deal_count"];
}

+ (BOOL)isBrowsed:(ZYDeal *)deal
{
    FMResultSet *resultSet = [_database executeQueryWithFormat:@"SELECT count(*) AS deal_count FROM t_browse_deal WHERE deal_id = %@;", deal.deal_id];
    
    [resultSet next];
#warning 索引从1开始
    return [resultSet intForColumn:@"deal_count"] == 1;
}
@end
