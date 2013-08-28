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
 *  @abstract   Classes provided below implement prototype for TSTableViewDataSource.
 *              It is optional part of TSTableView infrastructure, inluded as an example of possible data source implementation.
 *
 *              This prototype provides enough flexibility for building custom TSTableView containers.
 *              If you need something completly different you can always implement your own data source entity.
 */


/**************************************************************************************************************************************/

/**
 *  @abstract  TSColumn provides infromation about content and appearance of TSTableViewHederSectionView component.
 *             Initialization dictionary can contain values for properties specified in  TSColumn interface. 
 *             Example:
 *
 *              NSDictionary *columnInfo = @{ 
 *                  @"title" : @"Column 1", 
 *                  @"subtitle" : @"This is first column", 
 *                  @"subcolumns" : @[
 *                                      @{ @"title" : @"Subcolumn 1.1"},
 *                                      @{ @"title" : @"Subcolumn 1.2"}
 *                                    ]
 *              };
 */

@interface TSColumn : NSObject

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *subtitle;
@property (nonatomic, strong) UIImage *icon;
@property (nonatomic, strong) UIColor *color;
@property (nonatomic, strong) UIColor *titleColor;
@property (nonatomic, strong) UIColor *subtitleColor;
@property (nonatomic, strong) NSArray *subcolumns;
@property (nonatomic, assign) CGFloat titleFontSize;
@property (nonatomic, assign) CGFloat subtitleFontSize;
@property (nonatomic, assign) CGFloat defWidth;
@property (nonatomic, assign) CGFloat minWidth;
@property (nonatomic, assign) CGFloat maxWidth;
@property (nonatomic, assign) CGFloat headerHeight;
@property (nonatomic, assign) NSTextAlignment textAlignment;

+ (id)columnWithTitle:(NSString *)title;
+ (id)columnWithTitle:(NSString *)title andSubcolumns:(NSArray *)sublolumns;
+ (id)columnWithDictionary:(NSDictionary *)info;

- (id)initWithTitle:(NSString *)title;
- (id)initWithTitle:(NSString *)title andSubcolumns:(NSArray *)sublolumns;
- (id)initWithDictionary:(NSDictionary *)info;

@end

/**************************************************************************************************************************************/

/**
 *  @abstract TSRow provides information about table row content (cells) and hierarchy (subrows)
 */

@interface TSRow : NSObject

@property (nonatomic, strong) NSArray *cells;
@property (nonatomic, strong) NSMutableArray *subrows;

+ (id)rowWithCells:(NSArray *)cells;
+ (id)rowWithCells:(NSArray *)cells andSubrows:(NSArray *)subrows;
+ (id)rowWithDictionary:(NSDictionary *)info;
- (id)initWithCells:(NSArray *)cells;
- (id)initWithCells:(NSArray *)cells andSubrows:(NSArray *)subrows;
- (id)initWithDictionary:(NSDictionary *)info;

@end

/**************************************************************************************************************************************/

/**
 *  @abstract TSCell provides inforamation about TableView cell content
 */

@interface TSCell : NSObject

@property (nonatomic, strong) NSObject *value;
@property (nonatomic, strong) NSString *details;
@property (nonatomic, strong) UIImage *icon;
@property (nonatomic, assign) NSTextAlignment textAlignment;
@property (nonatomic, strong) UIColor *textColor;
@property (nonatomic, strong) UIColor *detailsColor;

+ (id)cellWithValue:(NSObject *)value;
+ (id)cellWithDictionary:(NSDictionary *)info;
- (id)initWithValue:(NSObject *)value;
- (id)initWithDictionary:(NSDictionary *)info;

@end

/**************************************************************************************************************************************/

/**
 *  @abstract   TSTableViewModel is a prototype for TSTableViewDataSource
 *              There are two ready-to-use appearance styles: kTSTableViewStyleDark and kTSTableViewStyleLight.
 */

@class TSTableView;

typedef enum {
    kTSTableViewStyleDark,
    kTSTableViewStyleLight
} TSTableViewStyle;

@interface TSTableViewModel : NSObject <TSTableViewDataSource>
{
    NSMutableArray *_columns;
    NSMutableArray *_bottomEndColumns;
    NSMutableArray *_rows;
    TSTableView *_tableView;
}

@property (nonatomic, strong, readonly) NSArray *columns;
@property (nonatomic, strong, readonly) NSArray *rows;
@property (nonatomic, strong, readonly) TSTableView *tableView;
@property (nonatomic, assign, readonly) TSTableViewStyle tableStyle;

@property (nonatomic, assign) CGFloat heightForRow; // This model use fixed row height. TSTableView support rows with varied height
@property (nonatomic, assign) CGFloat widthForExpandItem; // Width of one nesting level in expand panel. Total panel width would be widthForExpandItem * maxRowNestingLevel

- (id)initWithTableView:(TSTableView *)tableView andStyle:(TSTableViewStyle)style;

/**
 *  @abstract Initialize with array of TSColumn objects and array TSRow objects
 */
- (void)setColumns:(NSArray *)columns andRows:(NSArray *)rows;

/**
 *  @abstract Initialize with array of NSDictionary decriptions for columns and array of NSDictionary decriptions for rows
 */
- (void)setColumnsInfo:(NSArray *)columns andRowsInfo:(NSArray *)rows;

/**
 *  @abstract Initialize with array of TSRow objects. Columns hierarchy remains the same
 */
- (void)setRows:(NSArray *)rows;

/**
 *  @abstract Initialize array of NSDictionary decriptions for rows. Rows hierarchy remains the same
 */
- (void)setRowsInfo:(NSArray *)rows;

/**
 *  @abstract Modify data model
 */
- (void)insertRow:(TSRow *)rowInfo atPath:(NSIndexPath *)indexPath;
- (void)removeRowAtPath:(NSIndexPath *)indexPath;
- (void)replcaceRowAtPath:(NSIndexPath *)indexPath withRow:(TSRow *)rowInfo;

@end

//TSTableViewModel *model = [[TSTableViewModel alloc] initWithTableView:tableView];
//[model setColumns:@[@"Column 1", @"Column 2", [TSColumn  columnWithTitle:@"Column" andSubcolumns:@[@"Column 3", @"Column 4"]]]
//          andRows:@[@[@"Category 1", @"Value 1", @1, @1],
//                     [TSRow rowWithCells:@[@"Category 2", @"Value 2", @2, @2] andSubrows:@[
//                          @[[NSNull null], @"Value 2", @2, @2],
//                          @[[NSNull null], @"Value 3", @3, @5],
//                          @[[NSNull null], @"Value 4", @4, @5]
//                      ]],
//                    @[@"Category 3", @"Value 3", @3, @3],
//                    @[@"Category 4", @"Value 4", @4, @4]
// ]];
//
//TSTableViewModel *model1 = [[TSTableViewModel alloc] initWithTableView:tableView];
//[model1 setColumnsInfo:@[
//         @{ @"title" : @"Column 1"},
//         @{ @"title" : @"Column 2"},
//         @{ @"title" : @"Column", @"subcolumns" : @[
//                                                        @{ @"title" : @"Column 3"},
//                                                        @{ @"title" : @"Column 4"}
//                                                    ]
//          }
//       ]
//           andRowsInfo:@[
//         @{ @"cells" : @[
//                         @{ @"value" : @"Category 1"},
//                         @{ @"value" : @"Value 1"},
//                         @{ @"value" : @1},
//                         @{ @"value" : @1}
//                        ]
//         },
//        @{ @"cells" : @[
//                         @{ @"value" :  @"Category 2"},
//                         @{ @"value" : @"Value 2"},
//                         @{ @"value" : @2},
//                         @{ @"value" : @2}
//                        ],
//            @"subrows" : @[
//                         @{ @"cells" : @[
//                                 @{ @"value" : [NSNull null]},
//                                 @{ @"value" : @"Value 2"},
//                                 @{ @"value" : @2},
//                                 @{ @"value" : @2}
//                                 ],
//                         },
//                         @{ @"cells" : @[
//                                 @{ @"value" : [NSNull null]},
//                                 @{ @"value" : @"Value 2"},
//                                 @{ @"value" : @2},
//                                 @{ @"value" : @2}
//                                 ],
//                         },
//                         @{ @"cells" : @[
//                                 @{ @"value" : [NSNull null]},
//                                 @{ @"value" : @"Value 2"},
//                                 @{ @"value" : @2},
//                                 @{ @"value" : @2}
//                                 ],
//                          }
//                        ]
//         },
//         @{ @"cells" : @[
//                         @{ @"value" : @"Category 2"},
//                         @{ @"value" : @"Value 2"},
//                         @{ @"value" : @2},
//                         @{ @"value" : @2}
//                        ]
//         },
//    ]
// ];
