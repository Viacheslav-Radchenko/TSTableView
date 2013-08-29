//
//  TSTableViewHeaderPanel.h
//  TSUIKit
//
//  Created by Viacheslav Radchenko on 8/9/13.
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

@class TSTableViewHeaderPanel;

@protocol TSTableViewHeaderPanelDelegate <NSObject>

/**
    @abstract Invoked when user manually changing column width
 */
- (void)tableViewHeader:(TSTableViewHeaderPanel *)header columnWidthDidChange:(NSInteger)columnIndex oldWidth:(CGFloat)oldWidth newWidth:(CGFloat)newWidth;

/**
    @abstract Invoked when user tap on section header
 */
- (void)tableViewHeader:(TSTableViewHeaderPanel *)header didSelectColumnAtPath:(NSIndexPath *)columnPath;

@end

/**
    @abstract TSTableViewHeaderPanel is subcomponent of TSTableView. It represents columns structure of the table. 
              Base layout is shown below:
    +--------------------------+------------------------------------------------------------+----------------------------------+
    |                          |                TSTableViewHeaderSection                    |                                  |
    | TSTableViewHeaderSection +----------------------------+-------------------------------+  ...TSTableViewHeaderSection...  |
    |                          |  TSTableViewHeaderSection  | ...TSTableViewHeaderSection   |                                  |
    +--------------------------+----------------------------+-------------------------------+----------------------------------+
 */

@protocol TSTableViewDataSource;
@protocol TSTableViewAppearanceCoordinator;

@interface TSTableViewHeaderPanel : UIScrollView

@property (nonatomic, weak) id<TSTableViewHeaderPanelDelegate> headerDelegate;
@property (nonatomic, weak) id<TSTableViewDataSource, TSTableViewAppearanceCoordinator> dataSource;

/**
    @abstract Allow column selection
 */
@property (nonatomic, assign) BOOL allowColumnSelection;

/**
    @abstract Reload column data
 */
- (void)reloadData;

/**
    @abstract Change width of specified column
 */
- (void)changeColumnWidthOnAmount:(CGFloat)delta forColumn:(NSInteger)columnIndex animated:(BOOL)animated;

/**
    @abstract Width of the table including all columns
 */
- (CGFloat)tableTotalWidth;

/**
    @abstract Width of the specified column
 */
- (CGFloat)widthForColumnAtIndex:(NSInteger)index;

/**
    @abstract Width of the specified column
 */
- (CGFloat)widthForColumnAtPath:(NSIndexPath *)indexPath;

/**
    @abstract X offset of the specified column
 */
- (CGFloat)offsetForColumnAtPath:(NSIndexPath *)indexPath;

/**
    @abstract Height of the table's header. Value updated in reloadData.
 */
- (CGFloat)headerHeight;

@end
