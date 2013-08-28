//
//  TSTableViewController+TestDataDefinition.m
//  TSUIKit
//
//  Created by Viacheslav Radchenko on 8/25/13.
//  Copyright (c) 2013 Viacheslav Radchenko. All rights reserved.
//

#import "TSTableViewController+TestDataDefinition.h"
#import "TSTableViewModel.h"

@implementation TSTableViewController (TestDataDefinition)

#pragma mark - Data set 1

- (NSArray *)columnsInfo1
{
    NSArray *columns = @[
                         @{ @"title" : @"Column 1", @"subtitle" : @"This is first column"},
                         @{ @"title" : @"Column 2", @"color" : @"FF1F3F1F"},
                         @{ @"title" : @"Column", @"subcolumns" : @[
                                    @{ @"title" : @"Column 3"},
                                    @{ @"title" : @"Column 4", @"subcolumns" : @[
                                               @{ @"title" : @"Column 4.1",
                                                  @"titleFontSize" : @"10",
                                                  @"headerHeight" : @24,
                                                  @"defWidth" : @64,
                                                  @"titleColor" : @"FF9F0000"},
                                               @{ @"title" : @"Column 4.2",
                                                  @"titleFontSize" : @"10",
                                                  @"headerHeight" : @24,
                                                  @"defWidth" : @64,
                                                  @"titleColor" : @"FF009F00"},
                                               @{ @"title" : @"Column 4.3",
                                                  @"headerHeight" : @24,
                                                  @"defWidth" : @64,
                                                  @"titleFontSize" : @"10",
                                                  @"titleColor" : @"FFCFCF00"}
                                               ]
                                       }
                                    ]
                            },
                         @{ @"title" : @"Column 5", @"subtitle" : @"This is last column with icon", @"icon" : @"NavigationStripIcon.png"},
                         ];
    return columns;
}

- (TSRow *)rowExample1
{
    return [TSRow rowWithDictionary:@{ @"cells" : @[
            @{ @"value" : @"New Row"},
            @{ @"value" : @"Value 100"},
            @{ @"value" : @10},
            @{ @"value" : @10},
            @{ @"value" : @"*"},
            @{ @"value" : @10},
            @{ @"value" : @100}
            ]
            }];
}


- (NSArray *)rowsInfo1_
{
    NSArray *rows = @[
                      @{ @"cells" : @[
                                 @{ @"value" : @"Category 1"},
                                 @{ @"value" : @"Value 1"},
                                 @{ @"value" : @1},
                                 @{ @"value" : @1},
                                 @{ @"value" : @"?"},
                                 @{ @"value" : @1},
                                 @{ @"value" : @1}
                                 ]
                         },
                      @{ @"cells" : @[
                                 @{ @"value" :  @"Category 2"},
                                 @{ @"value" : @"Value 2"},
                                 @{ @"value" : @2},
                                 @{ @"value" : @2},
                                 @{ @"value" : @"?"},
                                 @{ @"value" : @2},
                                 @{ @"value" : @2}
                                 ],
                         @"subrows" : @[
                                 @{ @"cells" : @[
                                            @{ @"value" : [NSNull null]},
                                            @{ @"value" : @"Value 2"},
                                            @{ @"value" : @2},
                                            @{ @"value" : @2},
                                            @{ @"value" : @12},
                                            @{ @"value" : @4},
                                            @{ @"value" : @2}
                                            ],
                                    },
                                 @{ @"cells" : @[
                                            @{ @"value" : [NSNull null]},
                                            @{ @"value" : @"Value 2"},
                                            @{ @"value" : @2},
                                            @{ @"value" : @5},
                                            @{ @"value" : @12},
                                            @{ @"value" : @232},
                                            @{ @"value" : @2}
                                            ],
                                    @"subrows" : @[
                                            @{ @"cells" : @[
                                                       @{ @"value" : @""},
                                                       @{ @"value" : @"Value 2"},
                                                       @{ @"value" : @2},
                                                       @{ @"value" : @221},
                                                       @{ @"value" : @2},
                                                       @{ @"value" : @122},
                                                       @{ @"value" : @2}
                                                       ],
                                               },
                                            @{ @"cells" : @[
                                                       @{ @"value" : @""},
                                                       @{ @"value" : @"Value 2"},
                                                       @{ @"value" : @2},
                                                       @{ @"value" : @2},
                                                       @{ @"value" : @123},
                                                       @{ @"value" : @23},
                                                       @{ @"value" : @2}
                                                       ],
                                               },
                                            @{ @"cells" : @[
                                                       @{ @"value" : @""},
                                                       @{ @"value" : @"Value 2"},
                                                       @{ @"value" : @2},
                                                       @{ @"value" : @2},
                                                       @{ @"value" : @34},
                                                       @{ @"value" : @2345},
                                                       @{ @"value" : @72}
                                                       ],
                                               }
                                            ]
                                    },
                                 @{ @"cells" : @[
                                            @{ @"value" : [NSNull null]},
                                            @{ @"value" : @"Value 2"},
                                            @{ @"value" : @2},
                                            @{ @"value" : @42},
                                            @{ @"value" : @123},
                                            @{ @"value" : @2},
                                            @{ @"value" : @12}
                                            ],
                                    @"subrows" : @[
                                            @{ @"cells" : @[
                                                       @{ @"value" : @""},
                                                       @{ @"value" : @"Value 2"},
                                                       @{ @"value" : @2},
                                                       @{ @"value" : @2},
                                                       @{ @"value" : @1},
                                                       @{ @"value" : @1},
                                                       @{ @"value" : @28}
                                                       ],
                                               },
                                            @{ @"cells" : @[
                                                       @{ @"value" : @""},
                                                       @{ @"value" : @"Value 2"},
                                                       @{ @"value" : @2},
                                                       @{ @"value" : @18},
                                                       @{ @"value" : @27},
                                                       @{ @"value" : @999},
                                                       @{ @"value" : @25}
                                                       ],
                                               },
                                            @{ @"cells" : @[
                                                       @{ @"value" : @""},
                                                       @{ @"value" : @"Value 2"},
                                                       @{ @"value" : @2},
                                                       @{ @"value" : @1},
                                                       @{ @"value" : @27},
                                                       @{ @"value" : @87},
                                                       @{ @"value" : @5}
                                                       ],
                                               }
                                            ]
                                    }
                                 ]
                         },
                      @{ @"cells" : @[
                                 @{ @"value" : @"Category 3"},
                                 @{ @"value" : @"Value 2"},
                                 @{ @"value" : @2},
                                 @{ @"value" : @2},
                                 @{ @"value" : @12},
                                 @{ @"value" : @12},
                                 @{ @"value" : @62}
                                 ]
                         },
                      @{ @"cells" : @[
                                 @{ @"value" : @"Category 3"},
                                 @{ @"value" : @"Value 2"},
                                 @{ @"value" : @2},
                                 @{ @"value" : @2},
                                 @{ @"value" : @12},
                                 @{ @"value" : @12},
                                 @{ @"value" : @62}
                                 ]
                         },
                      @{ @"cells" : @[
                                 @{ @"value" : @"Category 3"},
                                 @{ @"value" : @"Value 2"},
                                 @{ @"value" : @2},
                                 @{ @"value" : @2},
                                 @{ @"value" : @12},
                                 @{ @"value" : @12},
                                 @{ @"value" : @62}
                                 ]
                         },
                      @{ @"cells" : @[
                                 @{ @"value" : @"Category 3"},
                                 @{ @"value" : @"Value 2"},
                                 @{ @"value" : @2},
                                 @{ @"value" : @2},
                                 @{ @"value" : @12},
                                 @{ @"value" : @12},
                                 @{ @"value" : @62}
                                 ]
                         },
                      @{ @"cells" : @[
                                 @{ @"value" : @"Category 1"},
                                 @{ @"value" : @"Value 1"},
                                 @{ @"value" : @1},
                                 @{ @"value" : @1},
                                 @{ @"value" : @"?"},
                                 @{ @"value" : @1},
                                 @{ @"value" : @1}
                                 ]
                         },
                      @{ @"cells" : @[
                                 @{ @"value" :  @"Category 2"},
                                 @{ @"value" : @"Value 2"},
                                 @{ @"value" : @2},
                                 @{ @"value" : @2},
                                 @{ @"value" : @"?"},
                                 @{ @"value" : @2},
                                 @{ @"value" : @2}
                                 ],
                         @"subrows" : @[
                                 @{ @"cells" : @[
                                            @{ @"value" : [NSNull null]},
                                            @{ @"value" : @"Value 2"},
                                            @{ @"value" : @2},
                                            @{ @"value" : @2},
                                            @{ @"value" : @12},
                                            @{ @"value" : @4},
                                            @{ @"value" : @2}
                                            ],
                                    },
                                 @{ @"cells" : @[
                                            @{ @"value" : [NSNull null]},
                                            @{ @"value" : @"Value 2"},
                                            @{ @"value" : @2},
                                            @{ @"value" : @5},
                                            @{ @"value" : @12},
                                            @{ @"value" : @232},
                                            @{ @"value" : @2}
                                            ],
                                    @"subrows" : @[
                                            @{ @"cells" : @[
                                                       @{ @"value" : @""},
                                                       @{ @"value" : @"Value 2"},
                                                       @{ @"value" : @2},
                                                       @{ @"value" : @221},
                                                       @{ @"value" : @2},
                                                       @{ @"value" : @122},
                                                       @{ @"value" : @2}
                                                       ],
                                               },
                                            @{ @"cells" : @[
                                                       @{ @"value" : @""},
                                                       @{ @"value" : @"Value 2"},
                                                       @{ @"value" : @2},
                                                       @{ @"value" : @2},
                                                       @{ @"value" : @123},
                                                       @{ @"value" : @23},
                                                       @{ @"value" : @2}
                                                       ],
                                               },
                                            @{ @"cells" : @[
                                                       @{ @"value" : @""},
                                                       @{ @"value" : @"Value 2"},
                                                       @{ @"value" : @2},
                                                       @{ @"value" : @2},
                                                       @{ @"value" : @34},
                                                       @{ @"value" : @2345},
                                                       @{ @"value" : @72}
                                                       ],
                                               }
                                            ]
                                    },
                                 @{ @"cells" : @[
                                            @{ @"value" : [NSNull null]},
                                            @{ @"value" : @"Value 2"},
                                            @{ @"value" : @2},
                                            @{ @"value" : @42},
                                            @{ @"value" : @123},
                                            @{ @"value" : @2},
                                            @{ @"value" : @12}
                                            ],
                                    @"subrows" : @[
                                            @{ @"cells" : @[
                                                       @{ @"value" : @""},
                                                       @{ @"value" : @"Value 2"},
                                                       @{ @"value" : @2},
                                                       @{ @"value" : @2},
                                                       @{ @"value" : @1},
                                                       @{ @"value" : @1},
                                                       @{ @"value" : @28}
                                                       ],
                                               },
                                            @{ @"cells" : @[
                                                       @{ @"value" : @""},
                                                       @{ @"value" : @"Value 2"},
                                                       @{ @"value" : @2},
                                                       @{ @"value" : @18},
                                                       @{ @"value" : @27},
                                                       @{ @"value" : @999},
                                                       @{ @"value" : @25}
                                                       ],
                                               },
                                            @{ @"cells" : @[
                                                       @{ @"value" : @""},
                                                       @{ @"value" : @"Value 2"},
                                                       @{ @"value" : @2},
                                                       @{ @"value" : @1},
                                                       @{ @"value" : @27},
                                                       @{ @"value" : @87},
                                                       @{ @"value" : @5}
                                                       ],
                                               }
                                            ]
                                    }
                                 ]
                         },
                      @{ @"cells" : @[
                                 @{ @"value" : @"Category 3"},
                                 @{ @"value" : @"Value 2"},
                                 @{ @"value" : @2},
                                 @{ @"value" : @2},
                                 @{ @"value" : @12},
                                 @{ @"value" : @12},
                                 @{ @"value" : @62}
                                 ]
                         },
                      @{ @"cells" : @[
                                 @{ @"value" : @"Category 3"},
                                 @{ @"value" : @"Value 2"},
                                 @{ @"value" : @2},
                                 @{ @"value" : @2},
                                 @{ @"value" : @12},
                                 @{ @"value" : @12},
                                 @{ @"value" : @62}
                                 ]
                         },
                      @{ @"cells" : @[
                                 @{ @"value" : @"Category 3"},
                                 @{ @"value" : @"Value 2"},
                                 @{ @"value" : @2},
                                 @{ @"value" : @2},
                                 @{ @"value" : @12},
                                 @{ @"value" : @12},
                                 @{ @"value" : @62}
                                 ]
                         },
                      @{ @"cells" : @[
                                 @{ @"value" : @"Category 3"},
                                 @{ @"value" : @"Value 2"},
                                 @{ @"value" : @2},
                                 @{ @"value" : @2},
                                 @{ @"value" : @12},
                                 @{ @"value" : @12},
                                 @{ @"value" : @62}
                                 ]
                         }
                      ];
    return rows;
}

- (NSArray *)rowsInfo1
{
    int N = 10;
    NSMutableArray *mutArray = [[NSMutableArray alloc] init];
    for(int i = 0; i < N;  ++i)
    {
        [mutArray addObjectsFromArray:[self rowsInfo1_]];
    }
    return mutArray;
}

#pragma mark  - Data set 2

- (NSArray *)columnsInfo2
{
    NSArray *columns = @[
                         @{ @"title" : @"Column 1", @"subtitle" : @"This is first column"},
                         @{ @"title" : @"Column 2", @"color" : @"FFCFFFCF"},
                         @{ @"title" : @"Column", @"subcolumns" : @[
                                    @{ @"title" : @"Column 3"},
                                    @{ @"title" : @"Column 4", @"subcolumns" : @[
                                               @{ @"title" : @"Column 4.1",
                                                  @"titleFontSize" : @"10",
                                                  @"headerHeight" : @24,
                                                  @"defWidth" : @64,
                                                  @"titleColor" : @"FFFF0000"},
                                               @{ @"title" : @"Column 4.2",
                                                  @"titleFontSize" : @"10",
                                                  @"headerHeight" : @24,
                                                  @"defWidth" : @64,
                                                  @"titleColor" : @"FF00cF00"},
                                               @{ @"title" : @"Column 4.3",
                                                  @"headerHeight" : @24,
                                                  @"defWidth" : @64,
                                                  @"titleFontSize" : @"10",
                                                  @"titleColor" : @"FF0000FF"}
                                               ]
                                       }
                                    ]
                            },
                         @{ @"title" : @"Column 5", @"subtitle" : @"This is last column with icon", @"icon" : @"NavigationStripIcon.png"},
                         ];
    return columns;
}

- (TSRow *)rowExample2
{
    return [self rowExample1];
}

- (NSArray *)rowsInfo2
{
    return [self rowsInfo1];
}

#pragma mark  - Data set 3

- (NSArray *)columnsInfo3
{
    NSArray *columns = @[
                         @{ @"title" : @"Column 1", @"subtitle" : @"This is first column", @"headerHeight" : @48},
                         @{ @"title" : @"Column 2", @"subtitle" : @"This is second column"},
                         @{ @"title" : @"Column 3", @"subtitle" : @"This is third column"}
                         ];
    return columns;
}

- (NSArray *)rowsInfo3_
{
    NSArray *rows = @[
                      @{ @"cells" : @[
                                 @{ @"value" : @"Value 1"},
                                 @{ @"value" : @123},
                                 @{ @"value" : @4431}
                                 ]
                         },
                      @{ @"cells" : @[
                                 @{ @"value" : @"Value 2"},
                                 @{ @"value" : @122},
                                 @{ @"value" : @2431}
                                 ]
                         },
                      @{ @"cells" : @[
                                 @{ @"value" : @"Value 3"},
                                 @{ @"value" : @123},
                                 @{ @"value" : @4431}
                                 ]
                         },
                      @{ @"cells" : @[
                                 @{ @"value" : @"Value 4"},
                                 @{ @"value" : @123},
                                 @{ @"value" : @4431}
                                 ]
                         },
                      @{ @"cells" : @[
                                 @{ @"value" : @"Value 5"},
                                 @{ @"value" : @123},
                                 @{ @"value" : @4431}
                                 ]
                         },
                      @{ @"cells" : @[
                                 @{ @"value" : @"Value 6"},
                                 @{ @"value" : @123},
                                 @{ @"value" : @4431}
                                 ]
                         },
                      @{ @"cells" : @[
                                 @{ @"value" : @"Value 7"},
                                 @{ @"value" : @123},
                                 @{ @"value" : @4431}
                                 ]
                         },
                      @{ @"cells" : @[
                                 @{ @"value" : @"Value 8"},
                                 @{ @"value" : @123},
                                 @{ @"value" : @4431}
                                 ]
                         },
                      @{ @"cells" : @[
                                 @{ @"value" : @"Value 9"},
                                 @{ @"value" : @123},
                                 @{ @"value" : @4431}
                                 ]
                         },
                      @{ @"cells" : @[
                                 @{ @"value" : @"Value 10"},
                                 @{ @"value" : @123},
                                 @{ @"value" : @4431}
                                 ]
                         },
                      @{ @"cells" : @[
                                 @{ @"value" : @"Value 11"},
                                 @{ @"value" : @123},
                                 @{ @"value" : @4431}
                                 ]
                         },
                      @{ @"cells" : @[
                                 @{ @"value" : @"Value 12"},
                                 @{ @"value" : @123},
                                 @{ @"value" : @4431}
                                 ]
                         },
                      @{ @"cells" : @[
                                 @{ @"value" : @"Value 1"},
                                 @{ @"value" : @123},
                                 @{ @"value" : @4431}
                                 ]
                         },
                      @{ @"cells" : @[
                                 @{ @"value" : @"Value 2"},
                                 @{ @"value" : @122},
                                 @{ @"value" : @2431}
                                 ]
                         },
                      @{ @"cells" : @[
                                 @{ @"value" : @"Value 3"},
                                 @{ @"value" : @123},
                                 @{ @"value" : @4431}
                                 ]
                         },
                      @{ @"cells" : @[
                                 @{ @"value" : @"Value 4"},
                                 @{ @"value" : @123},
                                 @{ @"value" : @4431}
                                 ]
                         },
                      @{ @"cells" : @[
                                 @{ @"value" : @"Value 5"},
                                 @{ @"value" : @123},
                                 @{ @"value" : @4431}
                                 ]
                         },
                      @{ @"cells" : @[
                                 @{ @"value" : @"Value 6"},
                                 @{ @"value" : @123},
                                 @{ @"value" : @4431}
                                 ]
                         },
                      @{ @"cells" : @[
                                 @{ @"value" : @"Value 7"},
                                 @{ @"value" : @123},
                                 @{ @"value" : @4431}
                                 ]
                         },
                      @{ @"cells" : @[
                                 @{ @"value" : @"Value 8"},
                                 @{ @"value" : @123},
                                 @{ @"value" : @4431}
                                 ]
                         },
                      @{ @"cells" : @[
                                 @{ @"value" : @"Value 9"},
                                 @{ @"value" : @123},
                                 @{ @"value" : @4431}
                                 ]
                         },
                      @{ @"cells" : @[
                                 @{ @"value" : @"Value 10"},
                                 @{ @"value" : @123},
                                 @{ @"value" : @4431}
                                 ]
                         },
                      @{ @"cells" : @[
                                 @{ @"value" : @"Value 11"},
                                 @{ @"value" : @123},
                                 @{ @"value" : @4431}
                                 ]
                         },
                      @{ @"cells" : @[
                                 @{ @"value" : @"Value 12"},
                                 @{ @"value" : @123},
                                 @{ @"value" : @4431}
                                 ]
                         },
                      ];
    return rows;
}

- (TSRow *)rowExample3
{
    return [TSRow rowWithDictionary:@{ @"cells" : @[
            @{ @"value" : @"New Value"},
            @{ @"value" : @123},
            @{ @"value" : @4431}
            ]
            }];
}

- (NSArray *)rowsInfo3
{
    int N = 10;
    NSMutableArray *mutArray = [[NSMutableArray alloc] init];
    for(int i = 0; i < N;  ++i)
    {
        [mutArray addObjectsFromArray:[self rowsInfo3_]];
    }
    return mutArray;
}



#pragma mark  - Data set 4

- (NSArray *)columnsInfo4
{
    NSArray *columns = @[
                         @{ @"title" : @"Column 1", @"subtitle" : @"This is first column"},
                         @{ @"title" : @"Column 2", @"subcolumns" : @[
                                    @{ @"title" : @"Column 2.1", @"headerHeight" : @20},
                                    @{ @"title" : @"Column 2.2", @"headerHeight" : @20}]},
                         @{ @"title" : @"Column 3", @"titleColor" : @"FF00CF00"}
                         ];
    return columns;
}

- (NSArray *)rowsInfo4
{
    NSArray *rows = @[
                      @{ @"cells" : @[
                                 @{ @"value" : @"Value 1"},
                                 @{ @"value" : @1},
                                 @{ @"value" : @2},
                                 @{ @"value" : @3}
                                 ]
                         },
                      @{ @"cells" : @[
                                 @{ @"value" : @"Value 2"},
                                 @{ @"value" : @2},
                                 @{ @"value" : @3},
                                 @{ @"value" : @4}
                                 ]
                         }
                      ];
    return rows;
}

- (TSRow *)rowExample4
{
    return [TSRow rowWithDictionary:@{ @"cells" : @[
            @{ @"value" : @"New Value"},
            @{ @"value" : @1},
            @{ @"value" : @2},
            @{ @"value" : @3}
            ]
            }];
}

- (NSArray *)rowsInfo4_
{
    int N = 10;
    NSMutableArray *mutArray = [[NSMutableArray alloc] init];
    for(int i = 0; i < N;  ++i)
    {
        [mutArray addObjectsFromArray:[self rowsInfo3_]];
    }
    return mutArray;
}

@end
