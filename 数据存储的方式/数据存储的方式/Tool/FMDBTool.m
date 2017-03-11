//
//  FMDBTool.m
//  数据存储的方式
//
//  Created by 刘彦铭 on 2017/3/11.
//  Copyright © 2017年 刘彦铭. All rights reserved.
//

#import "FMDBTool.h"
#import "FMDB.h"

@implementation FMDBTool

static FMDatabase *_db;


+ (void)initialize {
    // 1.打开数据库
    NSString *fileName = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"shops2.sqlite"];
    _db = [FMDatabase databaseWithPath:fileName];
    [_db open];
    
    
    // 创表
    [_db executeUpdate:@"create table if not exists t_shop (id integer primary key, name text not null, price real);"];
}

+ (void)addDataShop:(shop *)shop {
    
    NSString *sql = [NSString stringWithFormat:@"insert into t_shop(name, price) values ('%@', %f);", shop.name, shop.price.doubleValue];
    [_db executeUpdate:sql];
    
    // 注意 %@ 不需要添加‘’
//    [_db executeQueryWithFormat:@"insert into t_shop(name, price) values (%@, %f);", shop.name, shop.price.doubleValue];
}

+ (NSArray *)queryAllDatas {
    
    
    NSString *sql = [NSString stringWithFormat:@"select * from t_shop;"];
    
    FMResultSet *set = [_db executeQuery:sql];
    
    NSMutableArray *shops = [NSMutableArray array];
    
    while (set.next) {
        shop *data = [[shop alloc] init];
        data.name = [set stringForColumn:@"name"];
        data.price = [set stringForColumn:@"price"];
        
        [shops addObject:data];
    }
    
    return shops;
}

+ (NSArray *)queryWhereCondition:(NSString *)condition {
    
    NSString *sql = [NSString stringWithFormat:@"select * from t_shop where %@;", condition];
    
    FMResultSet *set = [_db executeQuery:sql];
    
    NSMutableArray *shops = [NSMutableArray array];
    
    while (set.next) {
        shop *data = [[shop alloc] init];
        data.name = [set stringForColumn:@"name"];
        data.price = [set stringForColumn:@"price"];
        
        [shops addObject:data];
    }
    
    return (NSArray *)shops;
}

+ (void)deleteDataWhereCondition:(NSString *)condition {
    
    NSString *sql = [NSString stringWithFormat: @"delete from t_shop where %@;", condition];
    [_db executeUpdate:sql];
}

+ (void)deleteData {
    [_db executeUpdate:@"delete from t_shop where price < 10"];
}

+ (void)updateName:(NSString *)name price:(NSString *)price where:(NSString *)condition {
    
    //  注意：
    // 如果使用executeUpdate  拼接sqlStr的时候 数据库语句有字符串的时候一定要加上''---> name = '%@'
    // 如果使用 executeUpdateWithFormat 则不需要添加''单引号
    
//    NSString *sql = [NSString stringWithFormat:@"update t_shop set name = '%@', price = %f where name = '%@'", name, price.doubleValue,condition];
//    
//    [_db executeUpdate:sql];
    
    [_db executeUpdateWithFormat:@"update t_shop set name = %@, price = %f where name = %@", name, price.doubleValue, condition];
}

@end
