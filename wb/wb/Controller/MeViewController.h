//
//  MeViewController.h
//  wb
//
//  Created by Admin on 2022/4/26.
//  Copyright © 2022年 admin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoginViewController.h"
#import "UserTableViewCell.h"
#import "MyBlogViewController.h"
NS_ASSUME_NONNULL_BEGIN

@interface MeViewController : UITableViewController
@property(nonatomic,strong) NSArray *mine;
@property(nonatomic,strong) LoginViewController *loginviewController;
@property(nonatomic,strong) MyBlogViewController *myBolgViewController;

@property(nonatomic,strong) NSString *dataFileName;
@end

NS_ASSUME_NONNULL_END
