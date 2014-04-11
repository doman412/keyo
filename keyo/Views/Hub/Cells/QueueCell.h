//
//  QueueCell.h
//  keyo
//
//  Created by Derek Arner on 12/30/13.
//  Copyright (c) 2013 MakoWare. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface QueueCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIButton *downButton;
@property (strong, nonatomic) IBOutlet UIButton *upButton;
@property (weak, nonatomic) IBOutlet UILabel *songTitle;
@property (weak, nonatomic) IBOutlet UILabel *artistName;
@property (weak, nonatomic) IBOutlet UILabel *submittedByLabel;
@property (weak, nonatomic) IBOutlet UIStepper *stepper;
@property (weak, nonatomic) IBOutlet UILabel *pointsLabel;
@property (strong,nonatomic) PFObject *queuedSong;
@property (weak, nonatomic) UITableView *tableView;


-(NSInteger)getPoints;
-(void)setPoints:(NSInteger)p;

-(void)evalScore;

- (IBAction)onStepperChanged:(id)sender;
- (IBAction)onRateUp:(id)sender;
- (IBAction)onRateDown:(id)sender;


@end
