//
//  TSTableViewContentHolder.h
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

@class TSTableViewContentHolder;
@class TSTableViewCell;

@protocol TSTableViewContentHolderDelegate <NSObject>

/**
    @abstract Invoked when user manually changing content offset (i.e. scrolling)
 */
- (void)tableViewContentHolder:(TSTableViewContentHolder *)contentHolder contentOffsetDidChange:(CGPoint)contentOffset animated:(BOOL)animated;

/** Invoked when user manually changing row selection (i.e. tap on row)
 @param contentHolder - Instance of TSTableViewContentHolder class.
 @param rowPath - Instance of TSTableViewContentHolder class.
 @param cellIndex - Index of selected cell (cell that was tapped). 
 */
- (void)tableViewContentHolder:(TSTableViewContentHolder *)contentHolder willSelectRowAtPath:(NSIndexPath *)rowPath selectedCell:(NSInteger)cellIndex animated:(BOOL)animated;

/** Invoked when user manually changing row selection (i.e. tap on row)
 @param contentHolder - Instance of TSTableViewContentHolder class.
 @param rowPath - Instance of TSTableViewContentHolder class.
 @param cellIndex - Index of selected cell (cell that was tapped).
 */
- (void)tableViewContentHolder:(TSTableViewContentHolder *)contentHolder didSelectRowAtPath:(NSIndexPath *)rowPath selectedCell:(NSInteger)cellIndex;

/**
    @abstract Invoked when user manually changing column selection (i.e. tap on column header)
 */
- (void)tableViewContentHolder:(TSTableViewContentHolder *)contentHolder willSelectColumnAtPath:(NSIndexPath *)columnPath animated:(BOOL)animated;
- (void)tableViewContentHolder:(TSTableViewContentHolder *)contentHolder didSelectColumnAtPath:(NSIndexPath *)columnPath;

@end

/**
    @abstract TSTableViewContentHolder is subcomponent of TSTableView. It displays rows hierarchy.
 */

@protocol TSTableViewDataSource;
@protocol TSTableViewAppearanceCoordinator;

@interface TSTableViewContentHolder : UIScrollView

@property (nonatomic, weak) id<TSTableViewContentHolderDelegate> contentHolderDelegate;
@property (nonatomic, weak) id<TSTableViewDataSource, TSTableViewAppearanceCoordinator> dataSource;

/**
    @abstract Color of column selection outline
 */
@property (nonatomic, strong) UIColor *columnSelectionColor;

/**
    @abstract Color of row selection outline
 */
@property (nonatomic, strong) UIColor *rowSelectionColor;

/**
    @abstract Allow row selection on tap
    @def YES
 */
@property (nonatomic, assign) BOOL allowRowSelection;

/**
    @abstract Reload column data
 */
- (void)reloadData;

/**
    @abstract Change width of specified column
 */
- (void)changeColumnWidthOnAmount:(CGFloat)delta forColumn:(NSInteger)columnIndex animated:(BOOL)animated;

/**
    @abstract Change expand state of the row
 */
- (void)changeExpandStateForRow:(NSIndexPath *)rowPath toValue:(BOOL)expanded animated:(BOOL)animated;

/**
    @abstract Expand all rows
 */
- (void)expandAllRowsWithAnimation:(BOOL)animated;

/**
    @abstract Collapse all rows
 */
- (void)collapseAllRowsWithAnimation:(BOOL)animated;

/**
    @abstract Select row at path
 */
- (void)selectRowAtPath:(NSIndexPath *)rowPath animated:(BOOL)animated;

/**
    @abstract Select column at path
 */
- (void)selectColumnAtPath:(NSIndexPath *)columnPath animated:(BOOL)animated;

/**
    @abstract Hide current row selection
 */
- (void)resetRowSelectionWithAnimtaion:(BOOL)animated;

/**
    @abstract Hide current row selection
 */
- (void)resetColumnSelectionWithAnimtaion:(BOOL)animated;

/**
    @abstract Return path to selected row. If no row currently selected return nil.
 */
- (NSIndexPath *)pathToSelectedRow;

/**
    @abstract Return path to selected column. If no column currently selected return nil.
 */
- (NSIndexPath *)pathToSelectedColumn;

/**
    @abstract Reuse cached instance of cell view with specified Id.
 */
- (TSTableViewCell *)dequeueReusableCellViewWithIdentifier:(NSString *)identifier;

/**
    @abstract Clear cached data (reusable rows, cells that aren't used at this moment).
 */
- (void)clearCachedData;

// Modify content
- (void)insertRowAtPath:(NSIndexPath *)path animated:(BOOL)animated;
- (void)removeRowAtPath:(NSIndexPath *)path animated:(BOOL)animated;
- (void)updateRowAtPath:(NSIndexPath *)path;

@end
