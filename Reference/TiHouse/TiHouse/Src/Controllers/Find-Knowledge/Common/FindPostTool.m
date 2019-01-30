//
//  FindPostTool.m
//  TiHouse
//
//  Created by yahua on 2018/2/1.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import "FindPostTool.h"

@implementation FindPostTool

// 将 html 转 attr
+(NSAttributedString *)htmlToAttribute:(NSString *)htmlString
{
    
    NSData *data = [htmlString dataUsingEncoding:NSUnicodeStringEncoding];
    NSDictionary *options = @{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType};
    NSAttributedString *html = [[NSAttributedString alloc]initWithData:data
                                                               options:options
                                                    documentAttributes:nil
                                                                 error:nil];
    
    
    return html;
}

// 将 attr 转 html
+(NSString *)attributeToHtml:(NSAttributedString *)attributeString
{
    NSString *htmlString;
    NSDictionary *exportParams = @{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType,NSCharacterEncodingDocumentAttribute:[NSNumber numberWithInt:NSUTF8StringEncoding]};
    
    NSData *htmlData = [attributeString dataFromRange:NSMakeRange(0, attributeString.length) documentAttributes:exportParams error:nil];
    
    htmlString = [[NSString alloc] initWithData:htmlData encoding: NSUTF8StringEncoding];
    return htmlString;
}

@end
