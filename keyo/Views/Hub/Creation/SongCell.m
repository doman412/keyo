//
//  SongCell.m
//  keyo
//
//  Created by User on 1/17/14.
//  Copyright (c) 2014 MakoWare. All rights reserved.
//

#import "SongCell.h"
#import "SongCellObject.h"

#import "Song.h"

@implementation SongCell

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

- (void)setSongObject:(SongCellObject *)obj
{
    self.object = obj;
}

- (void)choose
{
    NSLog(@"choose!");
    NSString *songTitle = [self.song valueForProperty: MPMediaItemPropertyTitle];
    NSString *artistLabel = [self.song valueForProperty: MPMediaItemPropertyArtist];
    
    if(self.accessoryType == UITableViewCellAccessoryCheckmark){
        NSLog(@"item is checked");
        Song *o = self.object.song;

        [o deleteInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if(succeeded){
                NSLog(@"deleted song");                
                self.accessoryType = UITableViewCellAccessoryNone;
                [[NSNotificationCenter defaultCenter] postNotificationName:@"com.makoware.keyo.reloadUserSongs" object:nil];
            } else {
                NSLog(@"failed to delete song from parse");
            }

        }];
        

    } else if(self.accessoryType == UITableViewCellAccessoryNone) {
        NSLog(@"item is NOT checked");
        
        Song *obj = [Song object];
        obj.title = songTitle;
        obj.artist = artistLabel;
        obj.owner = [PFUser currentUser];
        self.object.song = obj;

        [obj saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if(succeeded){
                NSLog(@"saved song");
                self.accessoryType = UITableViewCellAccessoryCheckmark;
                [[NSNotificationCenter defaultCenter] postNotificationName:@"com.makoware.keyo.reloadUserSongs" object:nil];
            } else {
                NSLog(@"failed to save song: %@ for checkmark",self.song);
            }
        }];
//        if([obj save]){
//            NSLog(@"saved song");
//            self.accessoryType = UITableViewCellAccessoryCheckmark;
//        }
        
    }
}

@end
