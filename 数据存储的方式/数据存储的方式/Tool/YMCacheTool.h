//
//  YMCacheTool.h
//  数据存储的方式
//
//  Created by 刘彦铭 on 2017/3/11.
//  Copyright © 2017年 刘彦铭. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YMCacheTool : NSObject

/**
 *  根据请求参数去沙盒中加载缓存的数据
 *
 *  @param params 请求参数
 */
+ (NSArray *)datasWithParams:(NSDictionary *)params;

/**
 *  存储数据到沙盒中
 *
 *  @param datas 需要存储的微博数据
 */
+ (void)saveDatas:(NSArray *)datas;

@end
