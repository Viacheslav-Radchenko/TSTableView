//
//  TSTableViewController.m
//  TableView
//
//  Created by Viacheslav Radchenko on 8/15/13.
//  Copyright (c) 2013 Viacheslav Radchenko. All rights reserved.
//

#import "TSTableViewController.h"
#import "TSTableViewModel.h"
#import "TSDefines.h"
#import <QuartzCore/QuartzCore.h>

@interface TSTableViewController () <TSTableViewDelegate>
{
    TSTableView *_tableView1;
    TSTableView *_tableView2;
    TSTableViewModel *_model1;
    TSTableViewModel *_model2;
    NSArray *_tables;
    NSArray *_dataModels;
    NSArray *_rowExamples;
    
    
    NSInteger _stepperPreviousValue;
}

@end

@implementation TSTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    self.settingsView.layer.cornerRadius = 4;
    self.settingsView.layer.shadowOpacity = 0.5;
    self.settingsView.layer.shadowOffset = CGSizeMake(2, 4);
    
    // Row examples should correspond to columnsInfo* and rowsInfo* used below
    _rowExamples = @[
        [self rowExample1],
        [self rowExample3],
    ];
    
    NSArray *columns1 = [self columnsInfo1];
    NSArray *rows1 = [self rowsInfo1];

    _tableView1 = [[TSTableView alloc] initWithFrame:CGRectMake(20, 80, self.view.frame.size.width - 40, self.view.frame.size.height/2 - 70)];
    _tableView1.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    _tableView1.delegate = self;
    [self.view addSubview:_tableView1];
    
    _model1 = [[TSTableViewModel alloc] initWithTableView:_tableView1 andStyle:TSTableViewStyleDark];
    [_model1 setColumnsInfo:columns1 andRowsInfo:rows1];
    
    NSArray *columns2 = [self columnsInfo3];
    NSArray *rows2 = [self rowsInfo3];
    
    _tableView2 = [[TSTableView alloc] initWithFrame:CGRectMake(20, self.view.frame.size.height/2 + 50, self.view.frame.size.width - 40, self.view.frame.size.height/2 - 70)];
    _tableView2.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    _tableView2.delegate = self;
    [self.view addSubview:_tableView2];
    
    _model2 = [[TSTableViewModel alloc] initWithTableView:_tableView2 andStyle:TSTableViewStyleLight];
    [_model2 setColumnsInfo:columns2 andRowsInfo:rows2];
    
    _dataModels = @[_model1, _model2];
    _tables = @[_tableView1, _tableView2];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 

- (IBAction)numberOfRowsValueChanged:(UIStepper *)stepper
{
    NSInteger val = [stepper value];
    if(val > _stepperPreviousValue)
    {
        for(int i = 0; i < _dataModels.count;  ++i)
        {
            TSTableView *table = _tables[i];
            TSTableViewModel *model = _dataModels[i];
            NSIndexPath *rowPath = [table pathToSelectedRow];
            if(!rowPath)
                rowPath = [NSIndexPath indexPathWithIndex:0];
            
            TSRow *row = _rowExamples[i];
            [model insertRow:row atPath:rowPath];
        }
    }
    else
    {
        for(int i = 0; i < _dataModels.count;  ++i)
        {
            TSTableView *table = _tables[i];
            TSTableViewModel *model = _dataModels[i];
            NSIndexPath *rowPath = [table pathToSelectedRow];
            if(rowPath)
                [model removeRowAtPath:rowPath];
            
        }
    }
    _stepperPreviousValue = val;
}

- (IBAction)expandAllButtonPressed
{
    for(TSTableView *table in _tables)
    {
        [table expandAllRowsWithAnimation:YES];
    }
}

- (IBAction)collapseAllButtonPressed
{
    for(TSTableView *table in _tables)
    {
        [table collapseAllRowsWithAnimation:YES];
    }
}

- (IBAction)resetSelectionButtonPressed
{
    for(TSTableView *table in _tables)
    {
        [table resetColumnSelectionWithAnimtaion:YES];
        [table resetRowSelectionWithAnimtaion:YES];
    }
}

#pragma mark - TSTableViewDelegate

- (void)tableView:(TSTableView *)tableView willSelectRowAtPath:(NSIndexPath *)rowPath animated:(BOOL)animated
{
    VerboseLog();
}

- (void)tableView:(TSTableView *)tableView didSelectRowAtPath:(NSIndexPath *)rowPath
{
    VerboseLog();
}

- (void)tableView:(TSTableView *)tableView willSelectColumnAtPath:(NSIndexPath *)columnPath animated:(BOOL)animated
{
    VerboseLog();
}

- (void)tableView:(TSTableView *)tableView didSelectColumnAtPath:(NSIndexPath *)columnPath
{
    VerboseLog();
}

- (void)tableView:(TSTableView *)tableView widthDidChangeForColumnAtIndex:(NSInteger)columnIndex
{
    VerboseLog();
}

- (void)tableView:(TSTableView *)tableView expandStateDidChange:(BOOL)expand forRowAtPath:(NSIndexPath *)rowPath
{
    VerboseLog();
}

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
                @{ @"value" : @"Value 4"},
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

@end
