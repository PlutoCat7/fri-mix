//
//  NSString+MD5.m
//  YHCommonDemo
//
//  Created by yahua on 16/3/4.
//  Copyright © 2016年 wangsw. All rights reserved.
//

#import "NSString+Hash_YAH.h"
#import "NSData+MD5.h"

#import <CommonCrypto/CommonCrypto.h>

@implementation NSString (Hash_YAH)

- (NSString *)MD5
{
    NSData * value;
    
    value = [self dataUsingEncoding:NSUTF8StringEncoding];
    value = [value MD5];
    
    if ( value )
    {
        char			tmp[16];
        unsigned char *	hex = (unsigned char *)malloc( 2048 + 1 );
        unsigned char *	bytes = (unsigned char *)[value bytes];
        unsigned long	length = [value length];
        
        hex[0] = '\0';
        
        for ( unsigned long i = 0; i < length; ++i )
        {
            sprintf( tmp, "%02X", bytes[i] );
            strcat( (char *)hex, tmp );
        }
        
        NSString * result = [NSString stringWithUTF8String:(const char *)hex];
        free( hex );
        return [result lowercaseString];
    }
    else
    {
        return nil;
    }
}

- (NSString *)hmacSha1WithKey:(NSString*)key {
    
    const char *cKey  = [key cStringUsingEncoding:NSUTF8StringEncoding];
    
    const char *cData = [self cStringUsingEncoding:NSUTF8StringEncoding];
    
    
    
    uint8_t cHMAC[CC_SHA1_DIGEST_LENGTH];
    
    
    
    CCHmac(kCCHmacAlgSHA1, cKey, strlen(cKey), cData, strlen(cData), cHMAC);
    
    
    
    //NSData *HMAC = [[NSData alloc] initWithBytes:cHMAC length:CC_SHA1_DIGEST_LENGTH];
    
    NSString *hash;
    
    NSMutableString* output = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_SHA1_DIGEST_LENGTH; i++)
        
        [output appendFormat:@"%02x", cHMAC[i]];
    
    hash = output;
    
    
    return hash;
}

@end
