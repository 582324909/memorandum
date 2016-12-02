//
//  DoneTableViewCell.h
//  rili
//
//  Created by 张伟伟 on 2016/10/27.
//  Copyright © 2016年 张伟伟. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DoneTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (strong, nonatomic) NSString *taskID;

+(instancetype)doneCellWithTableView:(UITableView *)tableview;

@end
