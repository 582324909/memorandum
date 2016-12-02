//
//  FinishTableViewController.m
//  rili
//
//  Created by 张伟伟 on 2016/10/26.
//  Copyright © 2016年 张伟伟. All rights reserved.
//

#import "FinishTableViewController.h"
#import "DoneTableViewCell.h"
#import "AppDelegate.h"

#import "FMDB.h"

@interface FinishTableViewController ()
{
    FMDatabase *_dataBase;
}

@property (strong, nonatomic) NSMutableArray *dateArray;
@property (strong, nonatomic) NSMutableArray *contentArray;
@property (strong, nonatomic) NSMutableArray *idArray;
@property (strong, nonatomic) NSString *taskID;

@end

@implementation FinishTableViewController

-(void)viewDidAppear:(BOOL)animated {
    [self viewDidLoad];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.dateArray = [[NSMutableArray alloc] init];
    self.contentArray = [[NSMutableArray alloc] init];
    self.idArray = [[NSMutableArray alloc] init];
    [self createData];
}

-(void)createData
{
    NSString *dbPath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"task.sqlite"];
    _dataBase = [FMDatabase databaseWithPath:dbPath];
    if (_dataBase.open) {
        NSString *sql = @"CREATE TABLE IF NOT EXISTS task (task_id INTEGER PRIMARY KEY AUTOINCREMENT,taskContent TEXT,taskDate TEXT ,taskStatus TEXT)";
        BOOL success = [_dataBase executeUpdate:sql];
        if (success) {
            [self loadData];
        }else {
            NSLog(@"创建表失败");
            NSLog(@"%@",[_dataBase lastErrorMessage]);
        }
    }else {
        NSLog(@"创建数据库失败");
    }
}

-(void)loadData
{
    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM task WHERE taskStatus = %@",@"2"];
    FMResultSet *resultSet = [_dataBase executeQuery:sql];
    while ([resultSet next]) {
        [self.dateArray addObject:[resultSet stringForColumn:@"taskDate"]];
        [self.contentArray addObject:[resultSet stringForColumn:@"taskContent"]];
        [self.idArray addObject:[resultSet stringForColumn:@"task_id"]];
    }
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.contentArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DoneTableViewCell *cell = [DoneTableViewCell doneCellWithTableView:self.tableView];
    cell.timeLabel.text = self.dateArray[indexPath.row];
    cell.nameLabel.text = self.contentArray[indexPath.row];
    cell.taskID = self.idArray[indexPath.row];
    return cell;
}

-(NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DoneTableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    self.taskID = cell.taskID;
    UITableViewRowAction *del = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"删除" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
        [self deleteData];
        [self.contentArray removeObjectAtIndex:indexPath.row];
        [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        [self.tableView reloadData];
    }];
    return @[del];
}

-(void)deleteData {
    NSString *sql = [NSString stringWithFormat:@"DELETE FROM task WHERE task_id = %d",[self.taskID intValue]];
    BOOL success = [_dataBase executeStatements:sql];
    if (success) {
        NSLog(@"成功");
    }else {
        NSLog(@"失败 %@",[_dataBase lastErrorMessage]);
    }
}

- (void)dealloc {
    [_dataBase close];
}

@end
