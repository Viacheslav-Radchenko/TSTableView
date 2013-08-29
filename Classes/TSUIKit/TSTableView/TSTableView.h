//
//  TSTableView.h
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

#import "TSTableViewDataSource.h"
#import "TSTableViewDelegate.h"

/**
    @abstract   TSTableView is UI component for displaying multicolumns tabular data. It supports hierarchical rows and columns structure.
                Component optimized to display big sets of data: row and cell views are cached internaly and reused during scrolling/expanding.
                Basic layout is shown below:
 *
    +-----+-------------------------------------------+
    |     |          TSTableViewHeaderPanel           |  
    +-----+-------------------------------------------+
    |     |                                           |
    |  T  |                                           |
    |  S  |                                           |
    |  S  |                                           | 
    |  i  |                                           |
    |  d  |                                           |
    |  e  |                                           |
    |  C  |                                           |
    |  o  |        TSTableViewContentHolder           |
    |  n  |                                           |
    |  t  |                                           |
    |  r  |                                           |
    |  o  |                                           |
    |  l  |                                           |
    |     |                                           |
    +-----+-------------------------------------------+
 *
 *
 */

@interface TSTableView : UIView

@property (nonatomic, weak) id<TSTableViewDataSource> dataSource;
@property (nonatomic, weak) id<TSTableViewDelegate> delegate;

/**
    @abstract Maximum nesting level in rows hierarchy
 */
@property (nonatomic, assign, readonly) NSInteger maxNestingLevel;

/**
    @abstract Show hihlights when user taps control (slide control in header secrion and expand control in side panel)
 */
@property (nonatomic, assign) BOOL highlightControlsOnTap;

/**
    @abstract Allow row selection on tap
    @def YES
 */
@property (nonatomic, assign) BOOL allowRowSelection;

/**
    @abstract Allow column selection on tap
    @def YES
 */
@property (nonatomic, assign) BOOL allowColumnSelection;

/**
    @abstract If NO then line numbers are displayed in side panel
 */
@property (nonatomic, assign) BOOL lineNumbersHidden;

/**
    @abstract If YES then header niew isn't shown
    @def NO
 */
@property (nonatomic, assign) BOOL headerPanelHidden;

/**
    @abstract If YES then expand niew isn't shown
    @def NO
 */
@property (nonatomic, assign) BOOL expandPanelHidden;

/**
    @abstract Color for row line numbers in side panel
 */
@property (nonatomic, strong) UIColor *lineNumbersColor;

/**
    @abstract Set background image for header panel to customize appearance
 */
@property (nonatomic, strong) UIImage *headerBackgroundImage;

/**
    @abstract Set background image for expand panel to customize appearance
 */
@property (nonatomic, strong) UIImage *expandPanelBackgroundImage;

/**
    @abstract Set background image for top left panel to customize appearance
 */
@property (nonatomic, strong) UIImage *topLeftCornerBackgroundImage;

/**
    @abstract  This image is used for expand item control in normal (not expanded) state.
               Image wouldn't be stretched and will have bottom left alignment
 */
@property (nonatomic, strong) UIImage *expandItemNormalBackgroundImage;

/**
    @abstract  This image is used for expand item control in selected (expanded) state.
               Image wouldn't be stretched and will have bottom left alignment
 */
@property (nonatomic, strong) UIImage *expandItemSelectedBackgroundImage;

/**
    @abstract  Provide background image for expand section in side control panel.
               Image would be stretched depending on the size of section.
 */
@property (nonatomic, strong) UIImage *expandSectionBackgroundImage;

/**
    @abstract  Background color for header panel
 */
@property (nonatomic, strong) UIColor *headerBackgroundColor;

/**
    @abstract  Background color for expand panel
 */
@property (nonatomic, strong) UIColor *expandPanelBackgroundColor;

/**
    @abstract Reload content. Both columns and rows are updated
 */
- (void)reloadData;

/**
    @abstract Reload rows data
 */
- (void)reloadRowsData;

/**
    @abstract Reuse cached instance of cell view with specified Id.
 */
- (TSTableViewCell *)dequeueReusableCellViewWithIdentifier:(NSString *)identifier;

/**
    @abstract Clear cached data (reusable rows, cells that aren't used at this moment).
 */
- (void)clearCachedData;

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
    @abstract Hide current selection
 */
- (void)resetRowSelectionWithAnimtaion:(BOOL)animated;

/**
    @abstract Select row at path
 */
- (void)selectColumnAtPath:(NSIndexPath *)rowPath animated:(BOOL)animated;

/**
    @abstract Hide current selection
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
    @abstract Modify content
 */
- (void)insertRowAtPath:(NSIndexPath *)path animated:(BOOL)animated;
- (void)removeRowAtPath:(NSIndexPath *)path animated:(BOOL)animated;
- (void)updateRowAtPath:(NSIndexPath *)path;

// Not implemented yet
- (void)insertRowsAtPathes:(NSArray *)pathes animated:(BOOL)animated;
- (void)updateRowsAtPathes:(NSArray *)pathes animated:(BOOL)animated;
- (void)removeRowsAtPathes:(NSArray *)pathes animated:(BOOL)animated;

@end
