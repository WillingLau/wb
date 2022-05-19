//
//  HomeTableViewCell.h
//  wb
//
//  Created by Admin on 2022/5/1.
//  Copyright © 2022年 admin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JumpToURL_Protocol.h"
#import "StatusFrame.h"


#define NameFont [UIFont systemFontOfSize:18.0f]
#define TextFont [UIFont systemFontOfSize:22.0f]
#define OtherFont [UIFont systemFontOfSize:15.0f]

@class StatusFrame;
NS_ASSUME_NONNULL_BEGIN

@interface HomeTableViewCell : UITableViewCell

@property (nonatomic,strong) StatusFrame *statusFrame;

@property (nonatomic,weak) id<JumpToURL_Protocol> delegate;

+(instancetype)cellWithTableView:(UITableView *)tableView;

@end

NS_ASSUME_NONNULL_END
