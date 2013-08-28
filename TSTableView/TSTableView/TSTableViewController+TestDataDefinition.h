//
//  TSTableViewController+TestDataDefinition.h
//  TSUIKit
//
//  Created by Viacheslav Radchenko on 8/25/13.
//  Copyright (c) 2013 Viacheslav Radchenko. All rights reserved.
//

#import "TSTableViewController.h"

@class TSRow;

@interface TSTableViewController (TestDataDefinition)

#pragma mark - Data set 1

- (NSArray *)columnsInfo1;

- (TSRow *)rowExample1;
- (NSArray *)rowsInfo1_;
- (NSArray *)rowsInfo1;

#pragma mark  - Data set 2

- (NSArray *)columnsInfo2;
- (TSRow *)rowExample2;
- (NSArray *)rowsInfo2;

#pragma mark  - Data set 3

- (NSArray *)columnsInfo3;
- (NSArray *)rowsInfo3_;
- (TSRow *)rowExample3;
- (NSArray *)rowsInfo3;

#pragma mark  - Data set 4

- (NSArray *)columnsInfo4;
- (NSArray *)rowsInfo4;
- (TSRow *)rowExample4;
- (NSArray *)rowsInfo4_;

@end
