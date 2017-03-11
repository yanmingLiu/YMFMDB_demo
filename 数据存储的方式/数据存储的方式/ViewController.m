//
//  ViewController.m
//  数据存储的方式
//
//  Created by 刘彦铭 on 2017/3/8.
//  Copyright © 2017年 刘彦铭. All rights reserved.
//

#import "ViewController.h"
#import <sqlite3.h>
#import "shop.h"

@interface ViewController () <UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate>
@property (weak, nonatomic) IBOutlet UITextField *nameField;
@property (weak, nonatomic) IBOutlet UITextField *priceField;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

/** 数据库对象实例 */
@property (assign, nonatomic)  sqlite3 *db;

@property (nonatomic, strong) NSMutableArray *shops;


@end

@implementation ViewController

- (NSMutableArray *)shops {
    if (!_shops) {
        _shops = [NSMutableArray array];
    }
    return _shops;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UISearchBar *searchBar = [[UISearchBar alloc] init];
    searchBar.frame = CGRectMake(0, 0, self.tableView.bounds.size.width, 44);
    searchBar.delegate = self;
    self.tableView.tableHeaderView = searchBar;
 
    
    [self setupDB];
   
    
}


// 初始化数据库
- (void)setupDB {
    // 1.连接数据库 sqlite3_open(<#const char *filename#>, <#sqlite3 **ppDb#>)
    
    NSString *fileName = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"shops.sqlite"];
    NSLog(@"%@", fileName);
    
    //    sqlite3 *db;
    
    int status = sqlite3_open(fileName.UTF8String, &_db);
    
    if (status == SQLITE_OK) { // 打开数据库成功
        
        NSLog(@"打开数据库成功");
        
        const char *sql = "create table if not exists t_shop (id integer primary key, name text not null, price real);";
        char *errmsg = "";
        sqlite3_exec(self.db, sql, NULL, NULL, &errmsg);
        
        if (errmsg) { // 创表失败
            NSLog(@"创表失败--%s", errmsg);
        }
    }else { // 打开数据库失败
        NSLog(@"打开数据库失败");
    }
}

#pragma mark - 查询
- (IBAction)query:(id)sender {
    
    NSString *sql = [NSString stringWithFormat:@"select name, price from t_shop;"];
    
    // -1 ：表示sql的长度，-1会自动计算sql的长度
    // stmt 用来取出查询结果的
    sqlite3_stmt *stmt = NULL;
    int status = sqlite3_prepare_v2(self.db, sql.UTF8String, -1, &stmt, NULL);
    
    if (status == SQLITE_OK) { // 准备成功 = sql语句正确
        while (sqlite3_step(stmt) == SQLITE_ROW) { // 取出成功一条数据
            
            const  char *name = (const char *) sqlite3_column_text(stmt, 0);
            const  char *price = (const char *) sqlite3_column_text(stmt, 1);
            
            shop *data = [[shop alloc] init];
            data.name = [NSString stringWithUTF8String:name];
            data.price = [NSString stringWithUTF8String:price];
            
            [self.shops addObject:data];
            
            [self.tableView reloadData];
            
//            NSLog(@"%s--%s", name, price);
        }
    }
}

#pragma mark - 插入数据
- (IBAction)insert:(id)sender {
    
    NSString *sql = [NSString stringWithFormat:@"insert into t_shop(name, price) values ('%@', %f);", self.nameField.text, self.priceField.text.doubleValue];
    
    sqlite3_exec(self.db, sql.UTF8String, NULL, NULL, NULL);
}


#pragma mark - UISearchBarDelegate
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    
    [self.shops removeAllObjects];
    
    NSString *sql = [NSString stringWithFormat:@"select name, price from t_shop where name like '%%%@%%';", searchText];
    
    sqlite3_stmt *stmt = NULL;
    int status = sqlite3_prepare_v2(self.db, sql.UTF8String, -1, &stmt, NULL);
    
    if (status == SQLITE_OK) { // 准备成功 = sql语句正确
        while (sqlite3_step(stmt) == SQLITE_ROW) { // 取出成功一条数据
            
            const  char *name = (const char *) sqlite3_column_text(stmt, 0);
            const  char *price = (const char *) sqlite3_column_text(stmt, 1);
            
            shop *data = [[shop alloc] init];
            data.name = [NSString stringWithUTF8String:name];
            data.price = [NSString stringWithUTF8String:price];
            
            [self.shops addObject:data];
            
            [self.tableView reloadData];
            
            NSLog(@"%s--%s", name, price);
        }
    }
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

#pragma mark sqlite3基本介绍
- (void)sqlite3 {

#pragma mark - 数据库操作步骤：
    /*
     1.新建一张表(table)
     2.添加多个字段(column、列、属性)
     3.添加多行记录(row、record、 每行存放字段对应的值)
     */
    
    /*SQLite字段类型
     blobl : 二进制（文件）
     text : 字符串
     real : 浮点
     integer : 整型
     
     >>> 实际上SQLite是无类型的, 就算声明integer类型，还是能存储字符串文本、除主键外
     */
#pragma mark - SQL语句
    /*********************************
     SQL语句
     SQL是一种对关系型数据库中的数据定义和操作的语言。
     数据库的操作一般有：增删改查->CRUD
     
     语言特点：
     1.不区分大小写
     2.语句以分号；结尾
     3.不能以关键字命名字段
     
     语句种类：
     1.DDL语句：Data Definition Language -> 数据库定义语句
     包括create(创建表) 和 drop（删除表）等操作
     
     2.DML语句：Data manipulation Language -> 数据库操作语句
     包括 insert\update\delete
     
     3.DQL语句：Data Query Language -> 数据库查询语句
     select是DQL最多的操作，其他：wher\order by\group by\having
     */
#pragma mark - DDL
    // 创表: create tabel 表名 (字段名1 字段类型1，字段名1 字段类型1);
    NSString *create = @"CREATE TABLE IF NOT EXISTS t_student (name text, age integer);";
    /**
     字段值约束
     1.not null : 不为空
     2.unique   : 不能重复
     3.default  : 可以指定默认值
     */
    NSString *create_1 = @"create table if not exists t_shop (name text not null unique, price integer not null default 1);";
    // 主键 id （必须是integer类型） sqlite一般自动增长 MySQL需要添加autoincrement
    NSString *create_2 = @"create table if not exists t_shop (id integer primary key autoincrement, name text not null unique, price integer not null default 1);";
    
    // 外键
    // 建立表和表之间的关系：一张表的某个字段引用另一张表的主键, 外键一般是建在数据多的一边 一对多的关系
    NSString *t_class = @"create table if not exists t_class (id integer primary key, name text not null unique);";
    NSString *t_student = @"create table if not exists t_student (id integer primary key, name text not null, class_id integer constraint fk_student_rel_class foreign key(class_id) references t_class(id));";
    
    // 表连接
    
    // 删表
    NSString *drop = @"DROP TABLE IF EXISTS t_student;";
    
#pragma mark - DML
    // 插入: insert into 表名 (字段1,字段2) values (值1，值2);
    NSString *insert = @"INSERT INTO t_shop (name,price，left_count) VALUES ('手机',200.5,500);";
    // 更新：update 表名 set 字段1 = 值1；
    NSString *update = @"UPDATE t_shop SET price = 99.0, left_count = 0;";
    // 删除：delete frome 表名;
    NSString *delete = @"DELETE FROME t_dog;";

#pragma mark - DQL
    /*
     条件语句：
     where 字段  =  值； 等价于  where 字段 is 值；
     where 字段  != 值； 等价于  where 字段 is not 值；
     where 字段  >  值；
     where 字段1 =  值1  and 字段2 > 值2；
     where 字段1 =  值1  or  字段2 < 值2；
     */
    // 查询：
    NSString *select = @"SELECT * FROM t_shop WHERE price > 900;";
    // 别名 给表一个别名，查询的时候可以直接用表的别名.字段  方便查询
    NSString *select1 = @"SELECT s.name, s.age FROM t_student s;";
    // 也可以给字段取别名 显示name的时候为 shop_name 别名给中文也可
    NSString *select1_1 = @"SELECT s.name shop_name, s.age FROM t_student s;";
    
    // count : 关键函数 可以查询符合条件的数据有多少条
    NSString *select2 = @"SELECT count(name) FROM t_shop WHERE price > 900;";
    // 算东西最好的方式 用 *
    NSString *select2_1 = @"SELECT count(*) 剩余数量 FROM t_shop WHERE price > 900;";
    
    // 排序 order by
    // 按照商品价格降序
    NSString *order = @"SELECT * FROM t_shop ORDER BY price DESC"; // DESC:降序 ASC:升序
    // 按照价格升序 库存的降序
    NSString *order1 = @"SELECT * FROM t_shop ORDER BY price ASC, left_count DESC";
    
    // limit 控制查询结果的数量
    // select * from 表名 limit 数值1（页数）,数值2（每页个数量）,
    // 从第4条数据往后取8条
    NSString *select3 = @"select * frome t_shop limit 4,8;";
    // 取价格最高的10条  limit 0,10; == limit 10;
    NSString *select3_1 = @"select * frome t_shop order by price desc limit 10;";
}




#pragma mark - 系统目录查询
- (void)flilePath {
    //获取根目录
    NSString *homePath = NSHomeDirectory();
    NSLog(@"Home目录：%@",homePath);
    
    //获取Documents文件夹目录,第一个参数是说明获取Doucments文件夹目录，第二个参数说明是在当前应用沙盒中获取，所有应用沙盒目录组成一个数组结构的数据存放
    NSArray *docPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString *documentsPath = [docPath objectAtIndex:0];
    NSLog(@"Documents目录：%@",documentsPath);
    
    //获取Cache目录
    NSArray *cacPath = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *cachePath = [cacPath objectAtIndex:0];
    NSLog(@"Cache目录：%@",cachePath);
    
    //Library目录
    NSArray *libsPath = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    NSString *libPath = [libsPath objectAtIndex:0];
    NSLog(@"Library目录：%@",libPath);
    
    //temp目录
    NSString *tempPath = NSTemporaryDirectory();
    NSLog(@"temp目录：%@",tempPath);
}









@end
