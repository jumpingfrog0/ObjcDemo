//
//  NSURL+JFOSSImageURL.m
//  JFFoundation
//
//  Created by huangdonghong on 2026/06/02.
//

#import "NSURL+JFOSSImageURL.h"

@implementation NSURL (JFOSSImageURL)

+ (instancetype)jf_webpWithUrlStr:(NSString *)urlStr
{
    return [self jf_internalWebpWithUrlStr:urlStr widthNum:nil heightNum:nil qualityNum:nil mode:JFWebpUrlContentModeScaleAspectFill];
}

+ (instancetype)jf_webpWithUrlStr:(NSString *)urlStr width:(CGFloat)width
{
    return [self jf_internalWebpWithUrlStr:urlStr widthNum:@(width) heightNum:nil qualityNum:nil mode:JFWebpUrlContentModeScaleAspectFill];
}

+ (instancetype)jf_webpWithUrlStr:(NSString *)urlStr height:(CGFloat)height
{
    return [self jf_internalWebpWithUrlStr:urlStr widthNum:nil heightNum:@(height) qualityNum:nil mode:JFWebpUrlContentModeScaleAspectFill];
}

+ (instancetype)jf_webpWithUrlStr:(NSString *)urlStr quality:(CGFloat)quality
{
    return [self jf_internalWebpWithUrlStr:urlStr widthNum:nil heightNum:nil qualityNum:@(quality) mode:JFWebpUrlContentModeScaleAspectFill];
}

+ (instancetype)jf_webpWithUrlStr:(NSString *)urlStr width:(CGFloat)width height:(CGFloat)height
{
    return [self jf_internalWebpWithUrlStr:urlStr widthNum:@(width) heightNum:@(height) qualityNum:nil mode:JFWebpUrlContentModeScaleAspectFill];
}

+ (instancetype)jf_webpWithUrlStr:(NSString *)urlStr width:(CGFloat)width quality:(CGFloat)quality
{
    return [self jf_internalWebpWithUrlStr:urlStr widthNum:@(width) heightNum:nil qualityNum:@(quality) mode:JFWebpUrlContentModeScaleAspectFill];
}

+ (instancetype)jf_webpWithUrlStr:(NSString *)urlStr width:(CGFloat)width height:(CGFloat)height quality:(CGFloat)quality
{
    return [self jf_internalWebpWithUrlStr:urlStr widthNum:@(width) heightNum:@(height) qualityNum:@(quality) mode:JFWebpUrlContentModeScaleAspectFill];
}

+ (instancetype)jf_webpWithUrlStr:(NSString *)urlStr width:(CGFloat)width height:(CGFloat)height quality:(CGFloat)quality mode:(JFWebpUrlContentMode)mode
{
    return [self jf_internalWebpWithUrlStr:urlStr widthNum:@(width) heightNum:@(height) qualityNum:@(quality) mode:mode];
}

+ (instancetype)jf_internalWebpWithUrlStr:(NSString *)urlStr widthNum:(NSNumber *)widthNum heightNum:(NSNumber *)heightNum qualityNum:(NSNumber *)qualityNum mode:(JFWebpUrlContentMode)mode
{
    if (![self jf_stringHasValue:urlStr]) {
        return nil;
    }
    
    NSURL *originURL = [NSURL URLWithString:urlStr];
    if (!originURL) {
        return nil;
    }
    
    BOOL hasBs2Param = [originURL.query rangeOfString:@"ips_thumbnail"].location != NSNotFound;
    if (hasBs2Param) {
        NSURLComponents *components = [NSURLComponents componentsWithString:urlStr];
        components.query = nil;
        components.fragment = nil;
        originURL = components.URL;
        if (!originURL) {
            return nil;
        }
    }
    
    NSMutableString *resultStr = [NSMutableString stringWithString:@"image/"];
    
    NSString *resizeStr = [self jf_resizeStrWithWidthNum:widthNum heightNum:heightNum mode:mode];
    if ([self jf_stringHasValue:resizeStr]) {
        [resultStr appendString:resizeStr];
        [resultStr appendString:@"/"];
    }
    
    NSString *qualityStr = [self jf_qualityStrWithQualityNum:qualityNum];
    if ([self jf_stringHasValue:qualityStr]) {
        [resultStr appendString:qualityStr];
        [resultStr appendString:@"/"];
    }
    
    [resultStr appendString:@"format,webp"];
    
    NSString *separatorStr = [self jf_stringHasValue:originURL.query] ? @"&" : @"?";
    NSString *newURLStr = [NSString stringWithFormat:@"%@%@x-oss-process=%@", originURL.absoluteString, separatorStr, resultStr];
    return [NSURL URLWithString:newURLStr];
}

+ (NSString *)jf_resizeStrWithWidthNum:(NSNumber *)widthNum heightNum:(NSNumber *)heightNum mode:(JFWebpUrlContentMode)mode
{
    NSMutableString *resizeStr = [NSMutableString string];
    NSString *widthStr = nil;
    NSString *heightStr = nil;
    CGFloat scale = UIScreen.mainScreen.scale;
    
    if (widthNum && widthNum.floatValue > 0) {
        float adaptWidth = ceilf(widthNum.floatValue * scale);
        widthStr = [NSString stringWithFormat:@"w_%@", @(adaptWidth).stringValue];
    }
    
    if (heightNum && heightNum.floatValue > 0) {
        float adaptHeight = ceilf(heightNum.floatValue * scale);
        heightStr = [NSString stringWithFormat:@"h_%@", @(adaptHeight).stringValue];
    }
    
    if (widthStr || heightStr) {
        [resizeStr appendFormat:@"resize,%@,", [self jf_modeStringWithMode:mode]];
        if (widthStr) {
            [resizeStr appendString:widthStr];
        }
        if (heightStr) {
            if (widthStr) {
                [resizeStr appendString:@","];
            }
            [resizeStr appendString:heightStr];
        }
    }
    
    return [resizeStr copy];
}

+ (NSString *)jf_qualityStrWithQualityNum:(NSNumber *)qualityNum
{
    if (qualityNum && qualityNum.floatValue > 0 && qualityNum.floatValue < 1) {
        NSInteger qualityInt = @(qualityNum.floatValue * 100.0).integerValue;
        if (qualityInt > 0) {
            return [NSString stringWithFormat:@"quality,q_%@", @(qualityInt).stringValue];
        }
    }
    return nil;
}

+ (NSString *)jf_modeStringWithMode:(JFWebpUrlContentMode)mode
{
    switch (mode) {
        case JFWebpUrlContentModeScaleAspectFit:
            return @"m_lfit";
        case JFWebpUrlContentModeScaleAspectFillOver:
            return @"m_mfit";
        case JFWebpUrlContentModeScaleToFill:
            return @"m_fixed";
        case JFWebpUrlContentModeScaleAspectFill:
        default:
            return @"m_fill";
    }
}

+ (BOOL)jf_stringHasValue:(NSString *)string
{
    return [string isKindOfClass:[NSString class]] && string.length > 0;
}

@end
