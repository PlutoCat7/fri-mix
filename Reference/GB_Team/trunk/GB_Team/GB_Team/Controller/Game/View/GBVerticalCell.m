//
//  GBVerticalCell.m
//  GB_Football
//
//  Created by Pizza on 16/8/22.
//  Copyright © 2016年 Go Brother. All rights reserved.
//

#import "GBVerticalCell.h"

@interface GBVerticalCell ()

@end



@implementation GBVerticalCell

@synthesize text = _text;


#pragma mark - 初始化

/** 初始化方法，用于从代码中创建的类实例 */
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        [self defaultInit];
    }
    return self;
}

/** 默认的初始化方法 */
- (void)defaultInit
{
    [self commonInitWithText:@""
                        font:[UIFont boldSystemFontOfSize:15.0]
                   textColor:[UIColor blackColor]
                   alignment:NSTextAlignmentCenter
           verticalAlignment:VerticalAlignmentMiddle];
}

/** 通用初始化方法 */
- (void)commonInitWithText:(NSString *)text
                      font:(UIFont *)font
                 textColor:(UIColor *)textColor
                 alignment:(NSTextAlignment)alignment
         verticalAlignment:(VerticalAlignment)verticalAlignment
{
    _text = text;
    _font = font;
    _textColor = textColor;
    _alignment = alignment;
    _verticalAlignment = verticalAlignment;
}



#pragma mark - 绘制

/** 绘制 */
- (void)drawRect:(CGRect)rect
{
    // 段落属性
    NSMutableParagraphStyle *paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    paragraphStyle.alignment = _alignment;
    
    
    NSDictionary* dict = [NSDictionary dictionaryWithObjectsAndKeys:_font, NSFontAttributeName,
                          _textColor, NSForegroundColorAttributeName,
                          //                                                      [UIColor redColor], NSBackgroundColorAttributeName,
                          paragraphStyle, NSParagraphStyleAttributeName,
                          nil];
    
    // 计算文字宽高
    CGSize size = [_text sizeWithAttributes:dict];
    
    // 根据垂直对齐方向，设置绘制文本的Y坐标
    CGFloat originY;
    CGRect frame = self.bounds;
    switch (_verticalAlignment)
    {
        case VerticalAlignmentTop:
        {
            originY = frame.origin.y;
            break;
        }
        case VerticalAlignmentMiddle:
        {
            originY = frame.origin.y + (frame.size.height - size.height)/2;
            break;
        }
        case VerticalAlignmentBottom:
        {
            originY = frame.size.height - size.height;
            break;
        }
    }
    
    // 绘制文字
    CGRect drawRect = CGRectMake(frame.origin.x, originY, frame.size.width, size.height);
    [_text drawInRect:drawRect withAttributes:dict];
}



#pragma mark - 属性

/** 文字 */
- (void)setText:(NSString *)text
{
    _text = text;
    [self setNeedsDisplay];
}

- (NSString *)text
{
    return _text;
}

/** 文字字体 */
- (void)setFont:(UIFont *)font
{
    _font = font;
    [self setNeedsDisplay];
}

/** 文字颜色 */
- (void)setTextColor:(UIColor *)textColor
{
    _textColor = textColor;
    [self setNeedsDisplay];
}

/** 水平对齐方向 */
- (void)setAlignment:(NSTextAlignment)alignment
{
    _alignment = alignment;
    [self setNeedsDisplay];
}

/** 垂直对齐方向 */
- (void)setVerticalAlignment:(VerticalAlignment)verticalAlignment
{
    _verticalAlignment = verticalAlignment;
    [self setNeedsDisplay];
}

@end
