//
//  UserTableViewCell.m
//  wb
//
//  Created by Admin on 2022/5/5.
//  Copyright © 2022年 admin. All rights reserved.
//

#import "UserTableViewCell.h"


@interface UserTableViewCell()

@end

@implementation UserTableViewCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self) {
       NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *plistPath = [paths objectAtIndex:0];
        NSString *path = [plistPath stringByAppendingPathComponent:@"UserInfo.plist"];
        NSMutableDictionary *userData = [[NSMutableDictionary alloc]initWithContentsOfFile:path];
        
        [self.contentView addSubview:({
            self.name = [[UILabel alloc]initWithFrame:CGRectMake(20, 15, 300, 50)];
            self.name.font = [UIFont systemFontOfSize:24];
            self.name.textColor = [UIColor blackColor];
            self.name.text = userData[@"name"];
            self.name;
        })];
        
        [self.contentView addSubview:({
            self.fans = [[UILabel alloc]initWithFrame:CGRectMake(20, 70, 50, 20)];
            self.fans.font = [UIFont systemFontOfSize:16];
            self.fans.textColor = [UIColor blackColor];
            
            NSString *fan1 = [userData[@"fans"] stringValue];
            NSString *fans_count = [@" 粉丝:" stringByAppendingString:fan1];
            
            self.fans.text =fans_count;
            [self.fans sizeToFit];
            self.fans;
        })];
        
        [self.contentView addSubview:({
            self.icon = [[UIImageView alloc] initWithFrame:CGRectMake(330, 15, 70, 70)];
            self.icon.contentMode = UIViewContentModeScaleAspectFit;
            NSURL *icon_url = [[NSURL alloc]initWithString:userData[@"iconUrl"]];
            NSData *iconData = [NSData dataWithContentsOfURL:icon_url];
            self.icon.image = [UIImage imageWithData:iconData];
            self.icon;
        })];
        
    }
    return self;
}

@end
