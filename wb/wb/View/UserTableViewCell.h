//
//  UserTableViewCell.h
//  wb
//
//  Created by Admin on 2022/5/5.
//  Copyright © 2022年 admin. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UserTableViewCell : UITableViewCell

//@property (nonatomic,strong) NSDictionary *userData;


@property (nonatomic,strong,readwrite) UILabel *name;
@property (nonatomic,strong,readwrite) UILabel *fans;
@property (nonatomic,strong,readwrite) UIImageView *icon;

@end

NS_ASSUME_NONNULL_END
