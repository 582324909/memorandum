//
//  DoneTableViewCell.m
//  rili
//
//  Created by 张伟伟 on 2016/10/27.
//  Copyright © 2016年 张伟伟. All rights reserved.
//

#import "DoneTableViewCell.h"

@implementation DoneTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

+(instancetype)doneCellWithTableView:(UITableView *)tableview {
    static NSString *doneCell = @"doneCell";
    DoneTableViewCell *cell = [tableview dequeueReusableCellWithIdentifier:doneCell];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"DoneTableViewCell" owner:nil options:nil]lastObject];
    }
    return cell;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
