//
//  FMDBTool.h
//  数据存储的方式
//
//  Created by 刘彦铭 on 2017/3/11.
//  Copyright © 2017年 刘彦铭. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "shop.h"


@interface FMDBTool : NSObject

// 查询所有数据
+ (NSArray *)queryAllDatas;

// 插入数据
+ (void)addDataShop:(shop *)shop;

// 获取条件内的数据
+ (NSArray *)queryWhereCondition:(NSString *)condition;

// 删除条件内的数据
+ (void)deleteDataWhereCondition:(NSString *)condition;

// 删除所有数据
+ (void)deleteData;

// 修改数据
+ (void)updateName:(NSString *)name price:(NSString *)price where:(NSString *)condition;

@end
