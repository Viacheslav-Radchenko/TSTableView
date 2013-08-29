//
//  TSTableViewCell.h
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

#import <UIKit/UIKit.h>

/**
    @abstract   TSTableViewCell is base class for cell in TSTableView row.
                Inherit from TSTableViewCell to provide additinal functionality or another appearance.
 *
    @remark     textLabel, detailsLabel, iconView and backgroundImageView - are lazy loaded on first call.
                If your code wouldn't use these properties they wouldn't be part of TSTableViewHeaderSectionView hierarchy.
 */

@interface TSTableViewCell : UIView

@property (nonatomic, strong, readonly) NSString *reuseIdentifier;
@property (nonatomic, strong) UILabel *textLabel;
@property (nonatomic, strong) UILabel *detailsLabel;
@property (nonatomic, strong) UIImageView *iconView;
@property (nonatomic, strong) UIImageView *backgroundImageView;

- (id)initWithReuseIdentifier:(NSString *)reuseId;

/**
    @abstract   Override to reset cell settings before it would be reused.
                Method would be called by owner object before return cell from reuse queue.
 */
- (void)prepareForReuse;

@end
