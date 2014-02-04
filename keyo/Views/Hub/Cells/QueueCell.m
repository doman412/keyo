//
//  QueueCell.m
//  keyo
//
//  Created by Derek Arner on 12/30/13.
//  Copyright (c) 2013 MakoWare. All rights reserved.
//

#import "QueueCell.h"

@implementation QueueCell{
    NSInteger points;
}

@synthesize songTitle,pointsLabel,stepper,queuedSong,submittedByLabel,artistName;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(NSInteger)getPoints
{
    return points;
}

-(void)setPoints:(NSInteger)p
{
    points = p;
}

- (IBAction)onStepperChanged:(UIStepper*)step
{
//    NSLog(@"stepper value: %f",step.value);
    self.pointsLabel.text = [NSString stringWithFormat:@"%.0f",step.value];
//    [self.pointsLabel sizeToFit];
    
    self.queuedSong[@"points"] = [NSNumber numberWithDouble:step.value];
    [self.queuedSong saveInBackground];
    
}

- (IBAction)onRateUp:(id)sender
{
    points++;
    
    self.pointsLabel.text = [NSString stringWithFormat:@"%li",(long)points];
    self.queuedSong[@"points"] = [NSNumber numberWithInteger:points];
    [self.queuedSong saveInBackground];
}

- (IBAction)onRateDown:(id)sender
{
    points--;
    
    self.pointsLabel.text = [NSString stringWithFormat:@"%li",(long)points];
    self.queuedSong[@"points"] = [NSNumber numberWithInteger:points];
    [self.queuedSong saveInBackground];
}

@end
