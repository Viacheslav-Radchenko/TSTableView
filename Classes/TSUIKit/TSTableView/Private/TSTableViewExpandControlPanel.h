//
//  TSTableViewExpandControlPanel.h
//  TSUIKit
//
//  Created by Viacheslav Radchenko on 8/12/13.
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

@class TSTableViewExpandControlPanel;

/** Provide delegate object that implement TSTableViewExpandControlPanelDelegate to TSTableViewExpandControlPanel to be notified on expand state changes. */
@protocol TSTableViewExpandControlPanelDelegate <NSObject>

/** Invoked when user manually changing expand state 
    @param controlPanel Instance of TSTableViewExpandControlPanel.
    @param expand Updated expand state.
    @param rowPath Path to row where state was changed.
 */
- (void)tableViewSideControlPanel:(TSTableViewExpandControlPanel *)controlPanel expandStateDidChange:(BOOL)expand forRow:(NSIndexPath *)rowPath;

@end

@protocol TSTableViewDataSource;
@protocol TSTableViewAppearanceCoordinator;


/** TSTableViewExpandControlPanel is subcomponent of TSTableView. It represents rows hierarchy of the table.
    Base layout is shown below:
 
 +--------------------------------------------+
 | TSTableViewExpandSection                   |
 |                                            |
 |       +------------------------------------+
 |       |  TSTableViewExpandSection          |
 |       |                                    |
 |       |       +----------------------------+
 |       |       |  TSTableViewExpandSection  |
 |       |       |                            |
 |       |       +----------------------------+
 |       |       |  TSTableViewExpandSection  |
 |       |       |                            |
 |       |       +----------------------------+
 |       |       |  TSTableViewExpandSection  |
 |       |       |                            |
 +-------+-------+----------------------------+
 */
@interface TSTableViewExpandControlPanel : UIScrollView

@property (nonatomic, weak) id<TSTableViewExpandControlPanelDelegate> controlPanelDelegate;
@property (nonatomic, weak) id<TSTableViewDataSource, TSTableViewAppearanceCoordinator> dataSource;

@property (nonatomic, assign, readonly) NSInteger maxNestingLevel;

/**
    @abstract Reload expand rows data
 */
- (void)reloadData;

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
    @abstract Return row expand state
 */
- (BOOL)isRowExpanded:(NSIndexPath *)rowPath;

/**
    @abstract Return YES if all its parents are expanded
 */
- (BOOL)isRowVisible:(NSIndexPath *)rowPath;

/**
    @abstract Height of the table taking into account expanded/collapsed rows
 */
- (CGFloat)tableHeight;

/**
    @abstract Height of the table with all rows expanded
 */
- (CGFloat)tableTotalHeight;

/**
    @abstract Width of expand control panel. Updated in reloadData.
              Equal to maxNestingLevel * widthOfExpandItem
 */
- (CGFloat)panelWidth;

// Modify content
- (void)insertRowAtPath:(NSIndexPath *)path animated:(BOOL)animated;
- (void)removeRowAtPath:(NSIndexPath *)path animated:(BOOL)animated;

@end
