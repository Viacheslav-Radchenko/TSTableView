//
//  TSTableViewRow.m
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

#import "TSTableViewRow.h"
#import "TSUtils.h"

@implementation TSTableViewRow

- (id)initWithFrame:(CGRect)frame
{
    if(self = [super initWithFrame:frame])
    {
        self.clipsToBounds = YES;
    }
    return self;
}

- (void)setCells:(NSArray *)cells
{
    if(_cells)
        for(UIView *v in _cells)
            [v removeFromSuperview];
    
    _cells = cells;
    
    if(_cells)
        for(UIView *v in _cells)
            [self addSubview:v];
}

@end

/*******************************************************************************************************************/

@interface TSTableViewRowProxy ()
{
    CGRect _originalFrame;
}
@end

@implementation TSTableViewRowProxy

- (void)setFrame:(CGRect)frame
{
    _frame = frame;
    _originalFrame = frame;
    if(_rowView)
        _rowView.frame = frame;
}

- (void)setRowView:(TSTableViewRow *)rowView
{
    _rowView = rowView;
    if(CGRectEqualToRect(_originalFrame, _frame))
    {
        _rowView.frame = _frame;
    }
    else
    {
        _rowView.frame = _originalFrame;
        [TSUtils performViewAnimationBlock:^{
            _rowView.frame = _frame;
        } withCompletion:nil animated:YES];
        _originalFrame = _frame;
    }
}

- (void)setFrame:(CGRect)frame animated:(BOOL)animated
{
    if(animated)
    {
        if(_rowView)
        {
            [TSUtils performViewAnimationBlock:^{
                self.frame = frame;
            } withCompletion:nil animated:YES];
        }
        else
        {
            _originalFrame = _frame;
            _frame = frame;
            [TSUtils performViewAnimationBlock:nil withCompletion:^{
                _originalFrame = _frame;
            } animated:YES];
        }
    }
    else
    {
        self.frame = frame;
    }
}

@end
