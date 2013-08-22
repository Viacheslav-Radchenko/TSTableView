//
//  TSTableViewController.h
//  TableView
//
//  Created by Viacheslav Radchenko on 8/15/13.
//  Copyright (c) 2013 Viacheslav Radchenko. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TSTableViewController : UIViewController

@property (nonatomic, weak) IBOutlet UIView *settingsView;
@property (nonatomic, weak) IBOutlet UIStepper *numberOfRows;

- (IBAction)numberOfRowsValueChanged:(UIStepper *)stepper;
- (IBAction)expandAllButtonPressed;
- (IBAction)collapseAllButtonPressed;
- (IBAction)resetSelectionButtonPressed;

@end
