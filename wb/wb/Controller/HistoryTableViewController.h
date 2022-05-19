//
//  HistoryTableViewController.h
//  wb
//
//  Created by Admin on 2022/5/11.
//  Copyright © 2022年 admin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DetailViewController.h"
#import "JumpToURL_Protocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface HistoryTableViewController : UITableViewController

@property (nonatomic,strong) NSMutableArray *historyIndex;
@property (nonatomic,strong) NSString *historyDataFileName;

//点击网页链接后跳转的view
@property (nonatomic,strong) DetailViewController *detailViewController;

@end

NS_ASSUME_NONNULL_END
