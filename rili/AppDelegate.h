//
//  AppDelegate.h
//  rili
//
//  Created by 张伟伟 on 2016/10/26.
//  Copyright © 2016年 张伟伟. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) NSString *dateStr;
@property (strong, nonatomic) NSString *tomorrowStr;
@property (strong, nonatomic) NSMutableArray *deleteArray;
@property (strong, nonatomic) NSMutableArray *finishArray;

+ (instancetype)shareAppDelegate;

@end

