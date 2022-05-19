//
//  HomeTableViewCell.m
//  wb
//
//  Created by Admin on 2022/5/1.
//  Copyright © 2022年 admin. All rights reserved.
//

#import "HomeTableViewCell.h"
#import "StatusFrame.h"
#import "Status.h"

@interface HomeTableViewCell()
//头像
@property (nonatomic,weak) UIImageView *iconView;
//名字
@property (nonatomic,weak) UILabel *nameView;
//正文
@property (nonatomic,weak) UILabel *textView;
//配图
@property (nonatomic,weak) UIImageView *pictureView;
//发布时间
@property (nonatomic,weak) UILabel *timeView;
//点赞数
@property (nonatomic,weak) UILabel *likesCountView;
//评论数
@property (nonatomic,weak) UILabel *commentsCountView;
//转发数
@property (nonatomic,weak) UILabel *reportsCountView;
//网页链接
@property (nonatomic,weak) UILabel *sourceView;


@end

@implementation HomeTableViewCell

+ (instancetype) cellWithTableView:(UITableView *)tableView{
    static NSString *ID = @"status";
    HomeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if(cell == nil){
        cell = [[HomeTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
        if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
            //
            UIImageView *iconView = [[UIImageView alloc]init];
            [self.contentView addSubview:iconView];
            self.iconView = iconView;
            //
            UILabel *nameView = [[UILabel alloc]init];
            nameView.font = NameFont;
            [self.contentView addSubview:nameView];
            self.nameView = nameView;
            //
            UILabel *textView = [[UILabel alloc]init];
            textView.font = TextFont;
            textView.numberOfLines = 0;
            [self.contentView addSubview:textView];
            self.textView = textView;
            //
            UILabel *timeView = [[UILabel alloc]init];
            timeView.font = OtherFont;
            [self.contentView addSubview:timeView];
            self.timeView = timeView;
            //
            UIImageView *pictureView = [[UIImageView alloc]init];
            [self.contentView addSubview:pictureView];
            self.pictureView = pictureView;
            //
            UILabel *likesCountView = [[UILabel alloc]init];
            likesCountView.font = OtherFont;
             self.likesCountView = likesCountView;
            [self.contentView addSubview:likesCountView];
            //
            UILabel *commentsCountView = [[UILabel alloc]init];
            commentsCountView.font = OtherFont;
            self.commentsCountView = commentsCountView;
            [self.contentView addSubview:commentsCountView];
            //
            UILabel *reportsCountView = [[UILabel alloc]init];
            reportsCountView.font = OtherFont;
            self.reportsCountView = reportsCountView;
            [self.contentView addSubview:reportsCountView];
            //
            UILabel *sourceView = [[UILabel alloc]init];
            sourceView.font = [UIFont systemFontOfSize:19];
            self.sourceView = sourceView;
            [self.contentView addSubview:sourceView];
            
            
    }
    
    return self;
}

- (void)setStatusFrame:(StatusFrame *)statusFrame{
    
    _statusFrame = statusFrame;
    
    [self settingData];
    [self settingFrame];
    [self sourceDidSelected];
}

- (void)settingData{
    //
    NSURL *iconUrl = [[NSURL alloc]initWithString:self.statusFrame.status.icon];
    NSData *iconData = [NSData dataWithContentsOfURL:iconUrl];
    self.iconView.image = [UIImage imageWithData:iconData];
    //
    self.nameView.text = self.statusFrame.status.name;
    //
    self.textView.text = self.statusFrame.status.text;
    //
    self.timeView.text = self.statusFrame.status.time;
    self.timeView.layer.borderWidth = 1;
    self.timeView.layer.borderColor = [[UIColor grayColor]CGColor];
    //
    if (self.statusFrame.status.picture) {
        self.pictureView.hidden = NO;
        NSURL *pictureUrl = [[NSURL alloc]initWithString:self.statusFrame.status.picture];
        NSData *pictureData = [NSData dataWithContentsOfURL:pictureUrl];
        self.pictureView.image = [UIImage imageWithData:pictureData];
    }
    else{
        self.pictureView.hidden = YES;
    }
    //
    NSNumber *likesCount = @([self.statusFrame.status.likeCount floatValue]);
    NSString *like = [likesCount stringValue];
    self.likesCountView.text = [@" 点赞 :" stringByAppendingString:like];
    self.likesCountView.layer.borderWidth = 1;
    self.likesCountView.layer.borderColor = [[UIColor grayColor]CGColor];
    //
    NSNumber *reportsCount = @([self.statusFrame.status.reportsCount floatValue]);
    NSString *reports = [reportsCount stringValue] ;
    self.reportsCountView.text = [@" 转发 :" stringByAppendingString:reports];
    self.reportsCountView.layer.borderWidth = 1;
    self.reportsCountView.layer.borderColor = [[UIColor grayColor]CGColor];
    //
    NSNumber *commentsCount = @([self.statusFrame.status.commentsCount floatValue]);
    NSString *comments = [commentsCount stringValue];
    self.commentsCountView.text = [@" 评论 :" stringByAppendingString:comments];
    self.commentsCountView.layer.borderWidth = 1;
    self.commentsCountView.layer.borderColor = [[UIColor grayColor]CGColor];
    
    if (self.statusFrame.status.source) {
        self.sourceView.text = @"@网页链接@";
        self.sourceView.textColor = [UIColor blueColor];
    }
    else{
        self.sourceView.hidden = YES;
    }
}

//设置各个lableview的大小
- (void)settingFrame{
    //
    self.iconView.frame = self.statusFrame.iconF;
    //
    self.nameView.frame = self.statusFrame.nameF;
    //
    self.textView.frame = self.statusFrame.textF;
   //
    self.timeView.frame = self.statusFrame.timeF;
    //
    if (self.statusFrame.status.picture) {
         self.pictureView.frame = self.statusFrame.pictureF;
    }
    self.commentsCountView.frame = self.statusFrame.commentsCountF;
    //
    self.likesCountView.frame = self.statusFrame.likesCountF;
    //
    self.reportsCountView.frame = self.statusFrame.reportsCountF;
    //
    self.sourceView.frame = self.statusFrame.sourceF;
    [self.sourceView sizeToFit];
}

//点击网页链接
-(void)sourceDidSelected{
    UITapGestureRecognizer *uiTap = [[UITapGestureRecognizer alloc]initWithTarget:self.delegate action:@selector(jumpToURL:)];
    self.sourceView.userInteractionEnabled = YES;
    [self.sourceView addGestureRecognizer:uiTap];
}

@end
    
