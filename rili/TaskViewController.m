//
//  TaskViewController.m
//  rili
//
//  Created by 张伟伟 on 2016/10/26.
//  Copyright © 2016年 张伟伟. All rights reserved.
//

#import "TaskViewController.h"
#import "AppDelegate.h"

#import "FMDB.h"

static NSString *status_normal = @"1";

@interface TaskViewController ()<UITextFieldDelegate>
{
    FMDatabase *_dataBase;
}

@property (nonatomic, strong) AppDelegate *appDelegate;
@property (weak, nonatomic) IBOutlet UITextField *name;
@property (weak, nonatomic) IBOutlet UITextField *place;
@property (weak, nonatomic) IBOutlet UITextField *time;
@property (weak, nonatomic) IBOutlet UITextField *other;
@property (weak, nonatomic) IBOutlet UITextField *people;

@end

@implementation TaskViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self createData];
    self.appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    self.other.delegate = self;
    self.people.delegate = self;
}

#pragma mark-创建本地数据
-(void)createData
{
    NSString *dbPath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"task.sqlite"];
    _dataBase = [FMDatabase databaseWithPath:dbPath];
    if (_dataBase.open) {
        NSString *sql = @"CREATE TABLE IF NOT EXISTS task (task_id INTEGER PRIMARY KEY AUTOINCREMENT,taskContent TEXT,taskDate TEXT,taskStatus TEXT)";
        BOOL success = [_dataBase executeUpdate:sql];
        if (success) {
            NSLog(@"创建表成功");
        }else {
            NSLog(@"创建表失败");
            NSLog(@"%@",[_dataBase lastErrorMessage]);
        }
    }else {
        NSLog(@"创建数据库失败");
    }
}

//,taskPeople,taskTime,taskPlace,taskOther  ,?,?,?,?
//,self.people.text,self.time.text,self.place.text,self.other.text
#pragma -mark 保存至本地
-(void)saveTask
{
    BOOL success = [_dataBase executeUpdate:@"INSERT INTO task (taskContent,taskDate,taskStatus) VALUES (?,?,?)",self.name.text,self.appDelegate.dateStr,status_normal];
    if (success) {
        NSLog(@"插入成功");
        [self.navigationController popViewControllerAnimated:YES];
    }else {
        NSLog(@"插入失败 %@",[_dataBase lastErrorMessage]);
    }
}

#pragma mark-UITextFieldDelegate
//开始编辑输入框的时候，软键盘出现，执行此事件
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    CGRect frame = textField.frame;
    int offset = frame.origin.y + 85 - (self.view.frame.size.height - 216.0);//键盘高度216
    
    NSTimeInterval animationDuration = 0.30f;
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    
    //将视图的Y坐标向上移动offset个单位，以使下面腾出地方用于软键盘的显示
    if(offset > 0)
        self.view.frame = CGRectMake(0.0f, -offset, self.view.frame.size.width, self.view.frame.size.height);
    
    [UIView commitAnimations];
}

//当用户按下return键或者按回车键，keyboard消失
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

//输入框编辑完成以后，将视图恢复到原始状态
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    self.view.frame =CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self textResignFirstResponder];
}

#pragma mark-完成编辑
- (IBAction)finshClick:(id)sender {
    [self textResignFirstResponder];
    [self saveTask];
}



#pragma mark-解除键盘相应
-(void)textResignFirstResponder {
    [self.name resignFirstResponder];
    [self.place resignFirstResponder];
    [self.time resignFirstResponder];
    [self.people resignFirstResponder];
    [self.other resignFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
