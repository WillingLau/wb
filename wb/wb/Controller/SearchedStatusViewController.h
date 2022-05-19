//
//  SearchedStatusViewController.h
//  wb
//
//  Created by Admin on 2022/5/14.
//  Copyright © 2022年 admin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DetailViewController.h"


NS_ASSUME_NONNULL_BEGIN

@interface SearchedStatusViewController : UITableViewController

@property (nonatomic,strong) NSString *StatusFileName;
@property (nonatomic,strong) NSString *historyDataFileName;
@property (nonatomic,strong) NSString *likeStatusDataFileName;

@property (nonatomic,strong) NSArray *StatusDataArr;
@property (nonatomic,strong) NSMutableArray *historyStatusFrameTostore;
@property (nonatomic,strong) NSMutableArray *likeStatusTostore;

//点击网页链接后跳转的view
@property (nonatomic,strong) DetailViewController *detailViewController;

-(void)jumpToURL:(UITapGestureRecognizer *)param;

@end

NS_ASSUME_NONNULL_END
