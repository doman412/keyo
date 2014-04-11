//
//  OptionsVC.h
//  keyo
//
//  Created by User on 3/11/14.
//  Copyright (c) 2014 MakoWare. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Spotify/Spotify.h>

@interface OptionsVC : UITableViewController

@property (strong, nonatomic) IBOutlet UITableViewCell *spotifyLoginCell;
@property (strong, nonatomic) NSMutableArray *data;


- (IBAction)onClose:(id)sender;



@end
