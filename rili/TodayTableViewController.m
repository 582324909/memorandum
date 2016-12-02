//
//  TodayTableViewController.m
//  rili
//
//  Created by 张伟伟 on 2016/10/26.
//  Copyright © 2016年 张伟伟. All rights reserved.
//

#import "TodayTableViewController.h"
#import "InfoTableViewCell.h"
#import "AppDelegate.h"

#import "FMDB.h"

@interface TodayTableViewController ()
{
    FMDatabase *_dataBase;
}

@property (nonatomic, strong) AppDelegate *appDelegate;
@property (strong, nonatomic) NSMutableArray *idArray;
@property (strong, nonatomic) NSMutableArray *contentArray;
@property (strong, nonatomic) NSString *taskID;

@end

@implementation TodayTableViewController

-(void)viewDidAppear:(BOOL)animated
{
    [self viewDidLoad];
}
 
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    self.appDelegate.finishArray = [[NSMutableArray alloc] init];
    self.appDelegate.deleteArray = [[NSMutableArray alloc] init];
    self.idArray = [[NSMutableArray alloc] init];
    self.contentArray = [[NSMutableArray alloc] init];
    [self timeStr];
    [self createData];
    
}

-(void)timeStr
{
    NSDate * date=[NSDate date];
    NSDateFormatter *dateformatter = [[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"MM-dd"];
    NSString *dateStr = [dateformatter stringFromDate:date];
    self.appDelegate.dateStr = dateStr;
    self.navigationItem.title = dateStr;
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
    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM task WHERE taskStatus = %@",@"1"];
    FMResultSet *resultSet = [_dataBase executeQuery:sql];
    while ([resultSet next]) {
        [self.idArray addObject:[resultSet stringForColumn:@"task_id"]];
        [self.contentArray addObject:[resultSet stringForColumn:@"taskContent"]];
    }
    [self.tableView reloadData];
}

-(void)finishTaskWithTaskid:(int)task_id {
    NSString *updateSql = [NSString stringWithFormat:
                           @"UPDATE task SET taskStatus = %@ WHERE task_id = %d",@"2",task_id
                           ];
    
    BOOL success = [_dataBase executeUpdate:updateSql];
    if (success) {
        NSLog(@"插入成功");
    }else {
        NSLog(@"插入失败 %@",[_dataBase lastErrorMessage]);
    }
}

-(void)deleteTaskWithTaskid:(int)task_id {
    NSString *updateSql = [NSString stringWithFormat:
                           @"UPDATE task SET taskStatus = %@ WHERE task_id = %d",@"3",task_id
                           ];

    BOOL success = [_dataBase executeUpdate:updateSql];
    if (success) {
        NSLog(@"插入成功");
    }else {
        NSLog(@"插入失败 %@",[_dataBase lastErrorMessage]);
    }
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
    InfoTableViewCell *cell = [InfoTableViewCell infoCellWithTableView:self.tableView];
    cell.contentLabel.text = self.contentArray[indexPath.row];
    NSInteger num = [self.contentArray indexOfObject:self.contentArray[indexPath.row]];
    cell.numberLabel.text = [NSString stringWithFormat:@"%ld、",num + 1];
    cell.taskID = self.idArray[indexPath.row];
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
}

-(NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath
{
    InfoTableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    self.taskID = cell.taskID;
    
    UITableViewRowAction *deleteRoWAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"撤销" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
        [self deleteTaskWithTaskid:[self.taskID intValue]];
        [self.contentArray removeObjectAtIndex:indexPath.row];
        [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        [self.tableView reloadData];
    }];
    UITableViewRowAction *test = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"完成" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
        [self finishTaskWithTaskid:[self.taskID intValue]];
        [self.contentArray removeObjectAtIndex:indexPath.row];
        [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        [self.tableView reloadData];
    }];
    test.backgroundColor = [UIColor blueColor];
    UITableViewRowAction *del = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"删除" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
        [self deleteData];
        [self.contentArray removeObjectAtIndex:indexPath.row];
        [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        [self.tableView reloadData];
    }];
    deleteRoWAction.backgroundColor = [UIColor grayColor];
    return @[deleteRoWAction,test,del];
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
