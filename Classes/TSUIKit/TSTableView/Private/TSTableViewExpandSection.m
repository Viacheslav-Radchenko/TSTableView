//
//  TSTableViewExpandSection.m
//  TSUIKit
//
//  Created by Viacheslav Radchenko on 8/13/13.
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

#import "TSTableViewExpandSection.h"
#import "TSUtils.h"
#import <QuartzCore/QuartzCore.h>


@interface TSTableViewExpandSection ()

@property (nonatomic, strong, readwrite) UILabel *lineLabel;
@property (nonatomic, strong, readwrite) UIImageView *backgroundImage;


@end

@implementation TSTableViewExpandSection

- (id)initWithFrame:(CGRect)frame
{
    if(self = [super initWithFrame:frame])
    {
        self.clipsToBounds = YES;
    }
    return self;
}

#pragma mark - Getters & Setters

- (void)setExpanded:(BOOL)expanded
{
    self.expandButton.selected = expanded;
}

- (BOOL)expanded
{
    return self.expandButton.selected;
}

- (UILabel *)lineLabel
{
    if(!_lineLabel)
    {
        _lineLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0,self.bounds.size.width, _rowHeight)];
        _lineLabel.backgroundColor = [UIColor colorWithWhite:0 alpha:0.1f];
        _lineLabel.textAlignment = NSTextAlignmentCenter;
        _lineLabel.textColor = [UIColor blackColor];
        _lineLabel.font = [UIFont italicSystemFontOfSize:7];
        _lineLabel.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin;
        _lineLabel.layer.cornerRadius = 3;
        _lineLabel.layer.masksToBounds = YES;
        [self addSubview:_lineLabel];
        [self updateLineLabelLayout];
    }
    return _lineLabel;
}

- (UIImageView *)backgroundImage
{
    if(!_backgroundImage)
    {
        _backgroundImage = [[UIImageView alloc] initWithFrame:self.bounds];
        _backgroundImage.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        [self addSubview:_backgroundImage];
    }
    return _backgroundImage;
}

- (void)setRowHeight:(CGFloat)rowHeight
{
    _rowHeight = rowHeight;
    [self updateLineLabelLayout];
}

- (void)setLineNumber:(NSInteger)lineNumber
{
    self.lineLabel.text = [NSString stringWithFormat:@"%d", lineNumber];
    
    [self updateLineLabelLayout];
}

- (void)updateLineLabelLayout
{
    if(_lineLabel)
    {
        [self.lineLabel sizeToFit];
        self.lineLabel.frame = CGRectMake(0, 2,  self.lineLabel.frame.size.width + 4,  self.lineLabel.frame.size.height);
    }
}

- (void)setExpandButton:(UIButton *)expandButton
{
    if(_expandButton)
        [_expandButton removeFromSuperview];
    
    _expandButton = expandButton;
    
    if(_expandButton)
        [self addSubview:_expandButton];
    
    [self updateLineLabelLayout];
}

- (void)setSubrows:(NSMutableArray *)subrows
{
    if(_subrows)
        for(UIView *v in _subrows)
            [v removeFromSuperview];
    
    _subrows = subrows;
    
    if(_subrows)
        for(UIView *v in _subrows)
            [self addSubview:v];
}

@end
