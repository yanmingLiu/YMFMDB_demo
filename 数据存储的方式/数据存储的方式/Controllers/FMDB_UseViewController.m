//
//  FMDB_UseViewController.m
//  数据存储的方式
//
//  Created by 刘彦铭 on 2017/3/11.
//  Copyright © 2017年 刘彦铭. All rights reserved.
//  新浪微博的处理换成的方式
//  里面的代码是伪代码 主要理解存储的思路

#import "FMDB_UseViewController.h"
#import "YMCacheTool.h"

@interface FMDB_UseViewController ()

@property (nonatomic, strong) NSMutableArray *dataArr;

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation FMDB_UseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 先尝试从数据库中加载数据
    NSDictionary *params = [NSDictionary dictionary];
    
    NSArray *statuses = [YMCacheTool datasWithParams:params];
    
    if (statuses.count) { // 数据库有缓存数据
        
        // 将 "微博字典"数组 转为 "微博模型"数组
        NSArray *newStatuses = [NSArray array];  //[HWStatus objectArrayWithKeyValuesArray:statuses];

        // 将最新的微博数据，添加到总数组的最前面
        NSRange range = NSMakeRange(0, newStatuses.count);
        NSIndexSet *set = [NSIndexSet indexSetWithIndexesInRange:range];
        
        [self.dataArr insertObjects:newStatuses atIndexes:set];
        
        // 刷新表格
        [self.tableView reloadData];
        
    }else {
        [self loadNewStatus]; // 下拉刷新
    }
}


/**
 *  加载最新的数据
 */
- (void)loadNewStatus
{
    // 1.拼接请求参数
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"access_token"] = params[@"access_token"];
    
    // 取出最前面的微博（最新的微博，ID最大的微博）
    NSDictionary *firstStatusF = [self.dataArr firstObject];
    if (firstStatusF) {
        // 若指定此参数，则返回ID比since_id大的微博（即比since_id时间晚的微博），默认为0
        params[@"since_id"] = firstStatusF[@"idstr"];
    }
    
    // 2.发送请求
//    [HWHttpTool get:@"https://api.weibo.com/2/statuses/friends_timeline.json" params:params success:^(id json) {
//
#pragma mark - 将请求下来的数据存储到缓存中
        // 将请求下来的数据存储到缓存中，把数组丢给工具类，工具类将数组里面的每一个字典存到缓存文件，而不是直接存储数组
//        [HWStatusTool saveStatuses:json[@"statuses"]];
//        
//        
//        NSArray *newStatuses = [HWStatus objectArrayWithKeyValuesArray:statuses];
//        
//        
//        NSArray *newFrames = [self stausFramesWithStatuses:newStatuses];
//        
//        // 将最新的微博数据，添加到总数组的最前面
//        NSRange range = NSMakeRange(0, newFrames.count);
//        NSIndexSet *set = [NSIndexSet indexSetWithIndexesInRange:range];
//        [self.statusFrames insertObjects:newFrames atIndexes:set];
//        
//        
//        [self.tableView reloadData];
//        
//        [self.tableView headerEndRefreshing];
//        
//        // 显示最新微博的数量
//        [self showNewStatusCount:newStatuses.count];
//        
//    } failure:^(NSError *error) {
//        HWLog(@"请求失败-%@", error);
//        
//        [self.tableView headerEndRefreshing];
//    }];
    
}

@end
