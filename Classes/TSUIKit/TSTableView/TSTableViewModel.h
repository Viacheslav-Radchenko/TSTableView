//
//  TSTableViewModel.h
//  TSUIKit
//
//  Created by Viacheslav Radchenko on 8/14/13.
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
#import "TSTableView.h"

/**
    @abstract   Classes provided below implement prototype for TSTableViewDataSource.
                It is optional part of TSTableView infrastructure, inluded as an example of possible data source implementation.
 
                This prototype provides enough flexibility for building custom TSTableView containers.
                If you need something completly different you can always implement your own data source entity.
 */

/**************************************************************************************************************************************/

/** TSColumn provides infromation about content and appearance of TSTableViewHederSectionView component. Initialization dictionary can contain values for properties specified in  TSColumn interface. Example:
 
```
    NSDictionary *columnInfo = @{
        @"title" : @"Column 1", 
        @"subtitle" : @"This is first column", 
        @"subcolumns" : @[
                        @{ @"title" : @"Subcolumn 1.1"},
                        @{ @"title" : @"Subcolumn 1.2"}
                      ]
    };
```
 */
@interface TSColumn : NSObject

/** Array of subcolumns/subsections. */
@property (nonatomic, strong) NSArray *subcolumns;
/** Column title. */
@property (nonatomic, strong) NSString *title;
/** Column details. */
@property (nonatomic, strong) NSString *subtitle;
/** Column icon. */
@property (nonatomic, strong) UIImage *icon;
/** Tint color for background. */
@property (nonatomic, strong) UIColor *color;
/** Color for title. */
@property (nonatomic, strong) UIColor *titleColor;
/** Color for details. */
@property (nonatomic, strong) UIColor *subtitleColor;
/** Title font size. */
@property (nonatomic, assign) CGFloat titleFontSize;
/** Details font size. */
@property (nonatomic, assign) CGFloat subtitleFontSize;
/** Default (or initial) column width. */
@property (nonatomic, assign) CGFloat defWidth;
/** Minimal column width. */
@property (nonatomic, assign) CGFloat minWidth;
/** Maximal column width. */
@property (nonatomic, assign) CGFloat maxWidth;
/** Column header height. */
@property (nonatomic, assign) CGFloat headerHeight;
/** Text aligment used for title and details. */
@property (nonatomic, assign) NSTextAlignment textAlignment;

/** Create column with title.
    @param title Title displayed in column header.
 */
+ (id)columnWithTitle:(NSString *)title;
/** Create column with title and subcolumns. 
    @param title Title displayed in column header.
    @param sublolumns Array of TSColumn objects or NSString titles for subcolumns.
 */
+ (id)columnWithTitle:(NSString *)title andSubcolumns:(NSArray *)sublolumns;
/** Create column with dictionary which define content and properties of TSColumn.
    @param info Dictionary containes values for named properties of TSColumn.
 
 ```
     NSDictionary *columnInfo = @{
         @"title" : @"Column 1",
         @"subtitle" : @"This is first column",
         @"subcolumns" : @[
                     @{ @"title" : @"Subcolumn 1.1"},
                     @{ @"title" : @"Subcolumn 1.2"}
                 ]
     };
 ```
 */
+ (id)columnWithDictionary:(NSDictionary *)info;

/** Initialize column with title.
    @param title Title displayed in column header.
 */
- (id)initWithTitle:(NSString *)title;
/** Initialize column with title and subcolumns.
    @param title Title displayed in column header.
    @param sublolumns Array of TSColumn objects or NSString titles for subcolumns.
 */
- (id)initWithTitle:(NSString *)title andSubcolumns:(NSArray *)sublolumns;
/** Initialize column with dictionary which define content and properties of TSColumn.
    @param info Dictionary containes values for named properties of TSColumn.
 
 ```
     NSDictionary *columnInfo = @{
         @"title" : @"Column 1",
         @"subtitle" : @"This is first column",
         @"subcolumns" : @[
                     @{ @"title" : @"Subcolumn 1.1"},
                     @{ @"title" : @"Subcolumn 1.2"}
                   ]
     };
 ```
 */
- (id)initWithDictionary:(NSDictionary *)info;

@end

/**************************************************************************************************************************************/

/** TSRow provides information about table row content (cells) and hierarchy (subrows). */
@interface TSRow : NSObject

/** Array of TSCell objects. */
@property (nonatomic, strong) NSArray *cells;
/** Array of TSRow objects (subrows). */
@property (nonatomic, strong) NSMutableArray *subrows;

/** Create row with set of cells.
    @param cells Array may contain mix of TSCell objects and any other NSObject value (which would be converted to TSCell).
 */
+ (id)rowWithCells:(NSArray *)cells;
/** Create row with set of cells.
    @param cells Array may contain mix of TSCell objects and any other NSObject value (which would be converted to TSCell).
    @param subrows Array may contain mix of TSRow and NSArray objects.
 */
+ (id)rowWithCells:(NSArray *)cells andSubrows:(NSArray *)subrows;
/** Create row with dictionary which define content TSRow.
    @param info Dictionary containes values for cells and subrows.
 
 ```
     NSDictionary *rowInfo = @{
     @"cells" : @[
            @{ @"value" : @1 },  
            @{ @"value" : @1 },  
            @{ @"value" : @1 } 
        ],
     @"subrows" : @[
                 @{ @"cells" : @[ 
                                @{ @"value" : @1 },  
                                @{ @"value" : @1 },  
                                @{ @"value" : @1 } ] },
                 @{ @"cells" : @[ 
                                @{ @"value" : @1 }, 
                                @{ @"value" : @1 },  
                                @{ @"value" : @1 } ] },
         ]
     };
 ```
 */
+ (id)rowWithDictionary:(NSDictionary *)info;
/** Initialize row with set of cells.
    @param cells Array may contain mix of TSCell objects and any other NSObject value (which would be converted to TSCell).
 */
- (id)initWithCells:(NSArray *)cells;
/** Initialize row with set of cells.
    @param cells Array may contain mix of TSCell objects and any other NSObject value (which would be converted to TSCell).
    @param subrows Array may contain mix of TSRow and NSArray objects.
 */
- (id)initWithCells:(NSArray *)cells andSubrows:(NSArray *)subrows;
/** Initialize row with dictionary which define content TSRow.
    @param info Dictionary containes values for cells and subrows.
 
 ```
     NSDictionary *rowInfo = @{
         @"cells" : @[
             @{ @"value" : @1 },
             @{ @"value" : @1 },
             @{ @"value" : @1 }
         ],
         @"subrows" : @[
             @{ @"cells" : @[
                 @{ @"value" : @1 },
                 @{ @"value" : @1 },
                 @{ @"value" : @1 } ] },
             @{ @"cells" : @[
                 @{ @"value" : @1 },
                 @{ @"value" : @1 },
                 @{ @"value" : @1 } ] },
         ]
     };
 ```
 */
- (id)initWithDictionary:(NSDictionary *)info;

@end

/**************************************************************************************************************************************/

/** TSCell provides inforamation about TableView cell content. */
@interface TSCell : NSObject

/** Value for cell (NSString, NSNumber etc). */
@property (nonatomic, strong) NSObject *value;
/** Details text for cell. */
@property (nonatomic, strong) NSString *details;
/** Icon image for cell. */
@property (nonatomic, strong) UIImage *icon;
/** Text aligment in cell. */
@property (nonatomic, assign) NSTextAlignment textAlignment;
/** Text color. */
@property (nonatomic, strong) UIColor *textColor;
/** Details color. */
@property (nonatomic, strong) UIColor *detailsColor;

/** Create cell with value.
    @param value NSObject value type. Provide NSString, NSNumber etc arguments. 
 */
+ (id)cellWithValue:(NSObject *)value;
/** Create cell with dictionary which define content and properties of TSCell.
    @param info Dictionary containes values for named properties of TSCell.
 
 ```
     NSDictionary *cellInfo = @{
        @"value" : @1,
        @"icon" : @"image.png"
     };
 ```
 */
+ (id)cellWithDictionary:(NSDictionary *)info;
/** Initialize cell with value.
    @param value NSObject value type. Provide NSString, NSNumber etc arguments.
 */
- (id)initWithValue:(NSObject *)value;
/** Initialize cell with dictionary which define content and properties of TSCell.
    @param info Dictionary containes values for named properties of TSCell.
 
 ```
     NSDictionary *cellInfo = @{
         @"value" : @1,
         @"icon" : @"image.png"
     };
 ```
 */
- (id)initWithDictionary:(NSDictionary *)info;

@end

/**************************************************************************************************************************************/

@class TSTableView;

/* Default appearance styles of TSTableView provided by TSTableViewModel */
typedef enum {
    kTSTableViewStyleDark,  /* Dark color scheme is used for backgrounds and light colors for font */
    kTSTableViewStyleLight  /* Light color scheme is used for backgrounds and dark colors for font */
} TSTableViewStyle;

/** TSTableViewModel is a prototype for TSTableViewDataSource.
    There are two default ready-to-use appearance styles kTSTableViewStyleDark and kTSTableViewStyleLight provided by TSTableViewModel.
 */
@interface TSTableViewModel : NSObject <TSTableViewDataSource>
{
    NSMutableArray *_columns;
    NSMutableArray *_bottomEndColumns;
    NSMutableArray *_rows;
    TSTableView *_tableView;
}
/** Readonly array with information about columns hierarchy. */
@property (nonatomic, strong, readonly) NSArray *columns;
/** Readonly array with information about rows data. */
@property (nonatomic, strong, readonly) NSArray *rows;
/** Readonly reference to TSTableView instance managed by this model. */
@property (nonatomic, strong, readonly) TSTableView *tableView;
/** TSTableView style choosen during initialization */
@property (nonatomic, assign, readonly) TSTableViewStyle tableStyle;
/** Row height. 
    @warning This data model use fixed row height. Override TSTableViewModel to provide varied row height functionality.  TSTableView support rows with varied height.
 */
@property (nonatomic, assign) CGFloat heightForRow;
/** Width of one nesting level in expand panel. Total panel width would be widthForExpandItem * maxRowNestingLevel. */
@property (nonatomic, assign) CGFloat widthForExpandItem;  

/** Initialize instance of TSTableViewModel with corresponding TSTableView object and appearance style. 
    @param tableView Instance of TSTableView which would be managed by this data model.
    @param style Appearance style of TSTableView.
 */
- (id)initWithTableView:(TSTableView *)tableView andStyle:(TSTableViewStyle)style;

/** Initialize with array of columns and rows.
    @param columns Array can contain objects of mixed types (TSColumn, NSDictionary, NSString). TSColumn objects would be constructed if needed.  
    @param rows Array can contain objects of mixed types (TSRow, NSDictionary, NSString). TSRow objects would be constructed if needed.
 */
- (void)setColumns:(NSArray *)columns andRows:(NSArray *)rows;
/** Initialize with rows data. Columns hierarchy remains the same. 
    @param rows  Array can contain objects of mixed types (TSRow, NSDictionary, NSString). TSRow objects would be constructed if needed.
 */
- (void)setRows:(NSArray *)rows;
/** Insert new row at specified path. TSTableView would be notified about changes in data model. 
    @param rowInfo TSRow instance with new data.
    @param indexPath Insert positon.
 */
- (void)insertRow:(TSRow *)rowInfo atPath:(NSIndexPath *)indexPath;
/** Remove row at specified path. TSTableView would be notified about changes in data model.
    @param indexPath Remove positon.
 */
- (void)removeRowAtPath:(NSIndexPath *)indexPath;
/** Replace (update) information in row at specified path. TSTableView would be notified about changes in data model.
    @param indexPath Updated row positon.
    @param rowInfo TSRow instance with new data.
 */
- (void)replcaceRowAtPath:(NSIndexPath *)indexPath withRow:(TSRow *)rowInfo;

@end
