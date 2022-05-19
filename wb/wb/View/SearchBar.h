//
//  SearchBar.h
//  wb
//
//  Created by Admin on 2022/5/14.
//  Copyright © 2022年 admin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PushSearchedProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface SearchBar : UIView

@property (nonatomic,weak)id<PushSearchedProtocol> delegate;

@end

NS_ASSUME_NONNULL_END
