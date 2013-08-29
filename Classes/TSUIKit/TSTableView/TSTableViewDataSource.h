//
//  TSTableViewDataSource.h
//  TSUIKit
//
//  Created by Viacheslav Radchenko on 8/10/13.
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

@class TSTableViewCell;
@class TSTableViewHeaderSectionView;
@class TSTableView;

@protocol TSTableViewDataSource <NSObject>

/**
    @abstract Total number of columns (including subcolumns) in table
 */
- (NSInteger)numberOfColumns;

/**
    @abstract Total number of rows (including subrows) in table
 */
- (NSInteger)numberOfRows;

/**
    @abstract Number of subcolumns at specified path
    @param indexPath - if nil, return number top level columns
 */
- (NSInteger)numberOfColumnsAtPath:(NSIndexPath *)indexPath;

/**
    @abstract Number of subrows at specified path
    @param indexPath - if nil, return number top level rows
 */
- (NSInteger)numberOfRowsAtPath:(NSIndexPath *)indexPath;

/**
    @abstract Return height for row at specified path
 */
- (CGFloat)heightForRowAtPath:(NSIndexPath *)indexPath;

/**
    @abstract Return height for header section at specified path
 */
- (TSTableViewCell *)tableView:(TSTableView *)tableView cellViewForRowAtPath:(NSIndexPath *)indexPath cellIndex:(NSInteger)index;

/**
    @abstract Return height for header section at specified path
 */
- (TSTableViewHeaderSectionView *)tableView:(TSTableView *)tableView headerSectionViewForColumnAtPath:(NSIndexPath *)indexPath;

@optional

/**
    @abstract Return height for header section at specified path
 */
- (CGFloat)heightForHeaderSectionAtPath:(NSIndexPath *)columnPath;

/**
    @abstract Return width for expand item  in left side control of panel
              Total width of control panel would be calculated based on next expression: maxNesingLevel * widthForExpandItem                                           
              where maxNesingLevel is maximal depth of subrows hierarchy
 */
- (CGFloat)widthForExpandItem;

/**
    @abstract Return default/prefered width for column at specified index
 */
- (CGFloat)defaultWidthForColumnAtIndex:(NSInteger)index;

/**
    @abstract Return minimal width for column at specified index
 */
- (CGFloat)minimalWidthForColumnAtIndex:(NSInteger)index;

/**
    @abstract Return maximal width for column at specified index
 */
- (CGFloat)maximalWidthForColumnAtIndex:(NSInteger)index;


@end
