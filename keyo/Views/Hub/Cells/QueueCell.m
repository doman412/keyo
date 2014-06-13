//
//  QueueCell.m
//  keyo
//
//  Created by Derek Arner on 12/30/13.
//  Copyright (c) 2013 MakoWare. All rights reserved.
//

#import "QueueCell.h"
#import "Theme.h"
#import "UIImage+Color.h"

#import "Hub.h"
#import "Song.h"
#import "QueuedSong.h"

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
    
    self.queuedSong.score = [NSNumber numberWithDouble:step.value];
    [self.queuedSong saveInBackground];
    
}

-(void)evalScore
{
    
}

- (IBAction)onRateUp:(UIButton*)sender
{
//    points++;
//    
//    self.pointsLabel.text = [NSString stringWithFormat:@"%li",(long)points];
//    self.queuedSong[@"points"] = [NSNumber numberWithInteger:points];
    
    /*
     var userId = request.params.userId;
     var queuedSongId = request.params.queuedSongId;
     var vote = request.params.vote;
     */
    
    NSArray *ups = self.queuedSong[@"ups"];
    
    
    if(![ups containsObject:[PFUser currentUser].objectId]){
        [self.queuedSong addObject:[PFUser currentUser].objectId forKey:@"ups"];
        [self.queuedSong removeObject:[PFUser currentUser].objectId forKey:@"downs"];
//        self.upButton.imageView.image = [self.upButton.imageView.image imageWithColor:[UIColor greenColor]];
//        self.downButton.imageView.image = [self.downButton.imageView.image imageWithColor:[Theme fontBlack]];
//        [PFCloud callFunctionInBackground:@"vote"
//                           withParameters:@{@"userId": [PFUser currentUser].objectId, @"queuedSongId":self.queuedSong.objectId, @"vote": @"up"}
//                                    block:^(id object, NSError *error) {
//                                        if(!error){
////                                            NSLog(@"saved vote up");
//                                            [self.queuedSong fetchInBackgroundWithBlock:^(PFObject *object, NSError *error) {
//                                                if(!error){
//                                                    NSLog(@"refreshed queued song");
//                                                    [self.tableView reloadData];
//                                                } else {
//                                                    NSLog(@"failed to refresh queued song");
//                                                }
//                                            }];
//                                        } else {
//                                            NSLog(@"failed to save vote up");
//                                        }
//                                    }];
        [self.queuedSong saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if(!error){
                [self.tableView reloadData];
            } else {
                NSLog(@"failed to save queued song");
            }
        }];
        
        

    }
    
}

- (IBAction)onRateDown:(UIButton*)sender
{
//    points--;
//    
//    self.pointsLabel.text = [NSString stringWithFormat:@"%li",(long)points];
//    self.queuedSong[@"points"] = [NSNumber numberWithInteger:points];
    
    NSArray *downs = self.queuedSong[@"downs"];
    
    if(![downs containsObject:[PFUser currentUser].objectId]){
        [self.queuedSong addUniqueObject:[PFUser currentUser].objectId forKey:@"downs"];
        [self.queuedSong removeObject:[PFUser currentUser].objectId forKey:@"ups"];
//        self.upButton.imageView.image = [self.upButton.imageView.image imageWithColor:[Theme fontBlack]];
//        self.downButton.imageView.image = [self.downButton.imageView.image imageWithColor:[UIColor redColor]];
//        [PFCloud callFunctionInBackground:@"vote"
//                           withParameters:@{@"userId": [PFUser currentUser].objectId, @"queuedSongId":self.queuedSong.objectId, @"vote": @"down"}
//                                    block:^(id object, NSError *error) {
//                                        if(!error){
////                                            NSLog(@"saved vote down");
//                                            [self.queuedSong fetchInBackgroundWithBlock:^(PFObject *object, NSError *error) {
//                                                if(!error){
////                                                    NSLog(@"refreshed queued song");
//                                                    [self.tableView reloadData];
//                                                } else {
//                                                    NSLog(@"failed to refresh queued song");
//                                                }
//                                            }];
//                                        } else {
//                                            NSLog(@"failed to save vote down");
//                                        }
//                                    }];
        [self.queuedSong saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if(!error){
                [self.tableView reloadData];
            } else {
                NSLog(@"failed to save queued song");
            }
        }];
        

    }
    
}

@end
