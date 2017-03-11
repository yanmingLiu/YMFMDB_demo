//
//  FMDBViewController.m
//  数据存储的方式
//
//  Created by 刘彦铭 on 2017/3/11.
//  Copyright © 2017年 刘彦铭. All rights reserved.
//

#import "FMDBViewController.h"
//#import "FMDB.h"
//#import "shop.h"

#import "FMDBTool.h"

@interface FMDBViewController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITextField *nameField;
@property (weak, nonatomic) IBOutlet UITextField *priceField;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

//@property (nonatomic, strong) FMDatabase *db;

@property (nonatomic, strong) NSMutableArray *shops;
@end

@implementation FMDBViewController

- (NSMutableArray *)shops {
    if (!_shops) {
        _shops = [NSMutableArray array];
    }
    return _shops;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    // 1.打开数据库
//    NSString *fileName = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"shops2.sqlite"];
//    self.db = [FMDatabase databaseWithPath:fileName];
//    [self.db open];
//    
//    /**
//     // executeQuery：查询
//     [self.db executeQuery:<#(NSString *), ...#>];
//     
//     // executeUpdate：除查询以外的其它操作都使用这个函数
//     [self.db executeUpdate:<#(NSString *), ...#>];
//     */
//    
//    // 创表
//    [self.db executeUpdate:@"create table if not exists t_shop (id integer primary key, name text not null, price real);"];
    
}

- (IBAction)update:(id)sender {
    
    for (shop *data in self.shops) {
        if ([data.name isEqualToString:@"华为p10"]) {
            
            [FMDBTool updateName:@"华为p10" price:@"4000" where:data.name];
            
            self.shops = (NSMutableArray *)[FMDBTool queryAllDatas];
            
            [self.tableView reloadData];
        }
    }
}


- (IBAction)delete:(id)sender {
    
//    [self.db executeUpdate:@"delete from t_shop where price < 10"];
    
    [FMDBTool deleteDataWhereCondition:@"price < 5"];
    
    self.shops = (NSMutableArray *)[FMDBTool queryAllDatas];
    
    [self.tableView reloadData];
    
}

// 查询
- (IBAction)query:(id)sender {
    
//    NSString *sql = [NSString stringWithFormat:@"select * from t_shop where price > 10;"];
//    
//    FMResultSet *set = [self.db executeQuery:sql];
//    
//    while (set.next) {
//        shop *data = [[shop alloc] init];
//        data.name = [set stringForColumn:@"name"];
//        data.price = [set stringForColumn:@"price"];
//        
//        [self.shops addObject:data];
//        
//        [self.tableView reloadData];
//    }
    
//    self.shops = (NSMutableArray *)[FMDBTool queryAllDatas];
    
    self.shops = (NSMutableArray *)[FMDBTool queryWhereCondition:@"price > 7"];
    
    [self.tableView reloadData];
}

// 插入
- (IBAction)insert:(id)sender {
//    NSString *sql = [NSString stringWithFormat:@"insert into t_shop(name, price) values ('%@', %f);", self.nameField.text, self.priceField.text.doubleValue];
//    [self.db executeUpdate:sql];
    
    shop *data = [[shop alloc] init];
    data.name = self.nameField.text;
    data.price = self.priceField.text;
    
    [FMDBTool addDataShop:data];
}


#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.shops.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
    }
    
    shop *data = self.shops[indexPath.row];
    cell.textLabel.text = data.name;
    cell.detailTextLabel.text = data.price;
    
    return cell;
}




@end
