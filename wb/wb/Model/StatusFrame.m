//
//  StatusFrame.m
//  wb
//
//  Created by Admin on 2022/4/29.
//  Copyright © 2022年 admin. All rights reserved.
//

#import "StatusFrame.h"
#import "Status.h"

#define NameFont [UIFont systemFontOfSize:18.0f]
#define TextFont [UIFont systemFontOfSize:22.0f]
#define OtherFont [UIFont systemFontOfSize:15.0f]

@implementation StatusFrame

//计算文字尺寸 text：需要计算的文字 font：text的字体 maxSize：文字的最大尺寸 
- (CGSize)sizeWithText:(NSString *)text font:(UIFont *)font maxSize:(CGSize)maxSize
{
    NSDictionary *attrs = @{NSFontAttributeName:font};
    return [text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
    
}

//设置各空间位置，尺寸
-(void)setStatus:(Status *)status{
    _status = status;
    CGFloat padding = 10;//间距
    
    CGFloat iconX = padding;
    CGFloat iconY = padding;
    CGFloat iconW = 50;
    CGFloat iconH = 50;
    _iconF = CGRectMake(iconX, iconY, iconW, iconH);
    
    CGSize nameSize = [self sizeWithText:status.name font:NameFont maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
    CGFloat nameX = CGRectGetMaxX(_iconF) + padding;
    CGFloat nameY = iconY + (iconH - nameSize.height)*0.5;
    CGFloat nameW = nameSize.width;
    CGFloat nameH = nameSize.height;
    _nameF = CGRectMake(nameX, nameY, nameW, nameH);
    
    CGSize timeSize = [self sizeWithText:status.time font:OtherFont maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
    CGFloat timeX = nameX;
    CGFloat timeY = CGRectGetMaxY(_nameF);
    CGFloat timeW = timeSize.width;
    CGFloat timeH = timeSize.height;
    _timeF = CGRectMake(timeX, timeY, timeW, timeH);
    
    CGSize textSize = [self sizeWithText:status.text font:TextFont maxSize:CGSizeMake([UIScreen mainScreen].bounds.size.width-2*padding, MAXFLOAT)];
    //宽为屏幕的宽减去两边的间距
    CGFloat textX = iconX;
    CGFloat textY = CGRectGetMaxY(_iconF) + padding;
    CGFloat textW = textSize.width;
    CGFloat textH = textSize.height;
    _textF = CGRectMake(textX, textY, textW, textH);
    
    if (status.source) {
        CGFloat sourceX = textX;
        CGFloat sourceY = CGRectGetMaxY(_textF) + padding;
        CGFloat sourceW = 50;
        CGFloat sourceH = 30;
        _sourceF = CGRectMake(sourceX, sourceY, sourceW, sourceH);
    }
    
    
    //判断有无图片，有才计算尺寸
    if(status.picture){
        CGFloat pictureX = iconX;
        CGFloat pictureY = CGRectGetMaxY(_textF) + padding*4;
        CGFloat pictureW = 150;
        CGFloat pictureH = 150;
        _pictureF = CGRectMake(pictureX, pictureY, pictureW, pictureH);

        _cellHeight = CGRectGetMaxY(_pictureF) + padding * 4;
    }
    else{
        _cellHeight = CGRectGetMaxY(_textF) + padding * 7;
    }
    CGFloat likesCountX = textX + padding;
    CGFloat likesCountY = _cellHeight - padding*3;
    CGFloat likesCountW = 100;
    CGFloat likesCountH = 30;
    _likesCountF = CGRectMake(likesCountX, likesCountY, likesCountW, likesCountH);
    
    CGFloat reportsCountX = CGRectGetMaxX(_likesCountF);
    CGFloat reportsCountY = likesCountY;
    CGFloat reportsCountW = 100;
    CGFloat reportsCountH = 30;
    _reportsCountF = CGRectMake(reportsCountX, reportsCountY, reportsCountW, reportsCountH);
    
    CGFloat commentsCountX = CGRectGetMaxX(_reportsCountF);
    CGFloat commentsCountY = likesCountY;
    CGFloat commentsCountW = 100;
    CGFloat commentsCountH = 30;
    _commentsCountF = CGRectMake(commentsCountX, commentsCountY, commentsCountW, commentsCountH);
}

@end
