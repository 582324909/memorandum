  //
//  InfoTableViewCell.m
//  rili
//
//  Created by 张伟伟 on 2016/10/26.
//  Copyright © 2016年 张伟伟. All rights reserved.
//

#import "InfoTableViewCell.h"

@implementation InfoTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

+(instancetype)infoCellWithTableView:(UITableView *)tableview {
    static NSString *infoCell = @"infoCell";
    InfoTableViewCell *cell = [tableview dequeueReusableCellWithIdentifier:infoCell];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"InfoTableViewCell" owner:nil options:nil]lastObject];
    }
    return cell;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
