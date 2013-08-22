//
//  TSUtils.m
//  TSUIKit
//
//  Created by Viacheslav Radchenko on 6/20/13.
//
//  The MIT License (MIT)
//  Copyright © 2013 Viacheslav Radchenko
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.

#import "TSUtils.h"
#import "TSDefines.h"

#define ANIMATION_DURATION      0.3

@implementation TSUtils

+ (void)performViewAnimationBlock:(void (^)(void))block withCompletion:(void (^)(void))completion animated:(BOOL)animated
{
    VerboseLog();
    if(animated)
    {
        if(block)
        {
            [UIView animateWithDuration:ANIMATION_DURATION
                             animations:^{
                                     block();
                             } completion:^(BOOL finished) {
                                 if(completion)
                                     completion();
                             }];
        }
        else if(completion) // if we don't animate then use simpler api
        {
            double delayInSeconds = ANIMATION_DURATION;
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                completion();
            });
        }
    }
    else
    {
        if(block)
            block();
        if(completion)
            completion();
    }
}

+ (UIColor *)colorWithHexString:(NSString *)stringToConvert
{
    NSString *noHashString = [stringToConvert stringByReplacingOccurrencesOfString:@"#" withString:@""]; // remove the #
    NSScanner *scanner = [NSScanner scannerWithString:noHashString];
    [scanner setCharactersToBeSkipped:[NSCharacterSet symbolCharacterSet]]; // remove + and $
    
    unsigned hex;
    if (![scanner scanHexInt:&hex]) return nil;
    int a = (hex >> 24) & 0xFF;
    int r = (hex >> 16) & 0xFF;
    int g = (hex >> 8) & 0xFF;
    int b = (hex) & 0xFF;
    
    return [UIColor colorWithRed:r / 255.0f green:g / 255.0f blue:b / 255.0f alpha:a / 255.0f];
}

+ (UIImage *)imageWithColor:(UIColor *)color andSize:(CGSize)size
{
    VerboseLog();
    CGRect rect = CGRectMake(0.0f, 0.0f, size.width, size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

+ (UIImage *)imageWithInnerShadow:(CGColorRef)shadowColor blurSize:(CGFloat)blurSize andSize:(CGSize)size
{
    VerboseLog();
    CGRect rect = CGRectMake(0.0f, 0.0f, size.width, size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    [self drawInnerShadowRectInContext:context rect:rect shadowColor:shadowColor blurSize:blurSize];
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

+ (void)drawLinearGradientInContext:(CGContextRef)context rect:(CGRect)rect startColor:(CGColorRef)startColor endColor:(CGColorRef)endColor
{
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGFloat locations[] = { 0.0, 1.0 };
    
    NSArray *colors = @[(__bridge id) startColor, (__bridge id) endColor];
    
    CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, (__bridge CFArrayRef) colors, locations);
    
    CGPoint startPoint = CGPointMake(CGRectGetMidX(rect), CGRectGetMinY(rect));
    CGPoint endPoint = CGPointMake(CGRectGetMidX(rect), CGRectGetMaxY(rect));
    
    CGContextSaveGState(context);
    CGContextAddRect(context, rect);
    CGContextClip(context);
    CGContextDrawLinearGradient(context, gradient, startPoint, endPoint, 0);
    CGContextRestoreGState(context);
    
    CGGradientRelease(gradient);
    CGColorSpaceRelease(colorSpace);
}

+ (void)drawLineInContext:(CGContextRef)context startPoint:(CGPoint)startPoint endPoint:(CGPoint)endPoint color:(CGColorRef)color lineWidth:(CGFloat)lineWidth
{
    CGContextSaveGState(context);
    CGContextSetLineCap(context, kCGLineCapSquare);
    CGContextSetStrokeColorWithColor(context, color);
    CGContextSetLineWidth(context, lineWidth);
    CGContextMoveToPoint(context, startPoint.x, startPoint.y);
    CGContextAddLineToPoint(context, endPoint.x, endPoint.y);
    CGContextStrokePath(context);
    CGContextRestoreGState(context);
}


+ (void)drawPolygonInContext:(CGContextRef)context points:(NSArray *)points fillColor:(CGColorRef)fillColor strokeColor:(CGColorRef)strokeColor strokeSize:(CGFloat)strokeSize
{
    CGContextSaveGState(context);
    CGContextSetLineCap(context, kCGLineCapSquare);
    CGContextSetStrokeColorWithColor(context, strokeColor);
    CGContextSetFillColorWithColor(context, fillColor);
    CGContextSetLineWidth(context, strokeSize);
    for(int i = 0; i < points.count; ++i)
    {
        NSValue *pointVal = points[i];
        CGPoint point = [pointVal CGPointValue];
        if(i == 0)
            CGContextMoveToPoint(context, point.x, point.y);
        else
            CGContextAddLineToPoint(context, point.x, point.y);
    }
    CGContextFillPath(context);
    if(strokeSize > 0)
        CGContextStrokePath(context);
    CGContextRestoreGState(context);
}


+ (void)drawInnerShadowRectInContext:(CGContextRef)context rect:(CGRect)rect shadowColor:(CGColorRef)shadowColor blurSize:(CGFloat)blurSize
{
    CGMutablePathRef visiblePath = CGPathCreateMutable();
    CGPathAddRect(visiblePath, NULL, rect);
    CGPathCloseSubpath(visiblePath);
    
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddRect(path, NULL, CGRectInset(rect, -32, -32));
    CGPathAddRect(path, NULL, rect);
    CGPathCloseSubpath(path);

    CGContextAddPath(context, visiblePath);
    CGContextClip(context);
    
    CGContextSaveGState(context);
    CGContextSetShadowWithColor(context, CGSizeZero, blurSize, shadowColor);
    
    CGContextAddPath(context, path);
    CGContextEOFillPath(context);
  
    CGContextRestoreGState(context);
    
    CGPathRelease(path);
    CGPathRelease(visiblePath);
}

@end
