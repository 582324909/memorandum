//
//  InfoTableViewCell.h
//  rili
//
//  Created by 张伟伟 on 2016/10/26.
//  Copyright © 2016年 张伟伟. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InfoTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *numberLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (strong, nonatomic) NSString *taskID;

+(instancetype)infoCellWithTableView:(UITableView *)tableview;

@end
