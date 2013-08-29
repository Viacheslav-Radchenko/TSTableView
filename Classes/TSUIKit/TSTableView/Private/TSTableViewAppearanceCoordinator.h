//
//  TSTableViewAppearanceCoordinator.h
//  TSUIKit
//
//  Created by Viacheslav Radchenko on 8/15/13.
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

#import <Foundation/Foundation.h>

/**
    @abstract TSTableViewAppearanceCoordinator is internal protocol for configuring TSTableView appearance. It's implemented by TSTableView.
 */

@protocol TSTableViewAppearanceCoordinator <NSObject>

/**
    @abstract Return YES if row at specified path is expanded
 */
- (BOOL)isRowExpanded:(NSIndexPath *)indexPath;

/**
    @abstract Return YES if row is visible, i.g. all its parent rows are expanded
 */
- (BOOL)isRowVisible:(NSIndexPath *)indexPath;

/**
    @abstract Highlight contorls (slide button in header section and expand button in control panel) on tap
 */
- (BOOL)highlightControlsOnTap;

/**
    @abstract Return YES if line numbers for rows shoulb be displayed in control panel
 */
- (BOOL)lineNumbersAreHidden;

/**
    @abstract Color for line  numbers in expand control panel.
 */
- (UIColor *)lineNumbersColor;

/**
    @abstract Image for expand button normal state (not expanded). Image wouldn't be stretched and will be aligned to bottom left corner of expand section.
 */
- (UIImage *)controlPanelExpandItemNormalBackgroundImage;

/**
    @abstract Image for expand button selected state (expanded). Image wouldn't be stretched and will be aligned to bottom left corner of expand section.
 */
- (UIImage *)controlPanelExpandItemSelectedBackgroundImage;

/**
    @abstract Background image for expand section. Image would be stretched depending on section's size.
 */
- (UIImage *)controlPanelExpandSectionBackgroundImage;

/**
    @abstract Return total width of all columns
 */
- (CGFloat)tableTotalWidth;

/**
    @abstract Return total height of all rows
 */
- (CGFloat)tableTotalHeight;

/**
    @abstract Return height of all visible (not expanded) rows
 */
- (CGFloat)tableHeight;

/**
    @abstract Return current width for column at specified index
 */
- (CGFloat)widthForColumnAtIndex:(NSInteger)columnIndex;

/**
    @abstract Return current width for column at specified path
 */
- (CGFloat)widthForColumnAtPath:(NSIndexPath *)columnPath;

/**
    @abstract Return x offset for column at specified path
 */
- (CGFloat)offsetForColumnAtPath:(NSIndexPath *)columnPath;

/**
    @abstract Return height for header section at specified path
 */
- (TSTableViewCell *)cellViewForRowAtPath:(NSIndexPath *)indexPath cellIndex:(NSInteger)index;

/**
    @abstract Return height for header section at specified path
 */
- (TSTableViewHeaderSectionView *)headerSectionViewForColumnAtPath:(NSIndexPath *)indexPath;

@end