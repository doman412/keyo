//
//  SongListView.m
//  keyo
//
//  Created by Derek Arner on 12/29/13.
//  Copyright (c) 2013 MakoWare. All rights reserved.
//

#import "SongListView.h"

#import "Theme.h"

@interface SongListView ()

@end

@implementation SongListView

@synthesize data,query,hub=_hub;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
//        NSLog(@"init w/ style");
    }
    return self;
}

//- (id)init
//{
//    self = [super init];
//    if(self){
//        NSLog(@"init");
//    }
//    return self;
//}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if(self){
//        NSLog(@"init w/ coder");
        self.data = [[NSMutableArray alloc] init];
    }
    return  self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    /*
    NSLog(@"view did load");
    self.data = [[NSMutableArray alloc] init];
    
    self.query = [PFQuery queryWithClassName:@"Song"];
//    [self.query whereKey:@"hub" equalTo:self.hub];
//    [self.query whereKeyDoesNotExist:@"queue"];
    [self.query whereKey:@"owner" equalTo:[PFUser currentUser]];
//    [self loadSongs];
    */

    self.tableView.backgroundColor = [Theme wellWhite];
    
    self.tabBarController.tabBar.tintColor = [Theme wellWhite];
    self.tabBarController.tabBar.barTintColor = [Theme backgroundBlue];
    
    
//    [[UITabBar appearance] setTintColor:[Theme fontWhite]]; // for unselected items that are gray
//    [[UITabBar appearance] setSelectedImageTintColor:[Theme lightBlue]]; // for selected items that are green
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.parentViewController.navigationItem.rightBarButtonItem = self.navigationItem.rightBarButtonItem;
    self.parentViewController.navigationItem.title = self.navigationItem.title;
    
    [self.query cancel];
    [self loadSongs];
}

- (void)setHub:(PFObject *)hub
{
    _hub = hub;
    self.query = [PFQuery queryWithClassName:@"Song"];
    //    [self.query whereKey:@"hub" equalTo:self.hub];
    //    [self.query whereKeyDoesNotExist:@"queue"];
    
    [self.query whereKey:@"hub" equalTo:self.hub];
    [self loadSongs];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)loadSongs
{
    [self.query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if(!error){
            [self.data removeAllObjects];
            [self.data addObjectsFromArray:objects];
            [self.tableView reloadData];
            self.tabBarItem.badgeValue = [NSString stringWithFormat:@"%li",(unsigned long)objects.count];
        } else {
            NSLog(@"failed to get songs");
        }
    }];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return self.data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"SongListCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    
    PFObject *obj = [self.data objectAtIndex:indexPath.row];
    
//    cell.textLabel.text = obj[@"title"];
    UILabel *title = (id)[cell viewWithTag:1];
    title.text = obj[@"title"];
    UILabel *artist = (id)[cell viewWithTag:2];
    artist.text = obj[@"artist"];
    
    
    // theme the cell
    cell.backgroundColor = [Theme wellWhite];
    title.textColor = [Theme fontBlack];
    artist.textColor = [Theme fontBlack];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    PFObject *obj = [self.data objectAtIndex:indexPath.row];
    
    PFQuery *q = [PFQuery queryWithClassName:@"QueuedSong"];
    [q whereKey:@"song" equalTo:[self.data objectAtIndex:indexPath.row]];
    [q whereKey:@"active" equalTo:@YES];
    
    [q countObjectsInBackgroundWithBlock:^(int number, NSError *error) {
        if(!error){
            if(number>0) { // song exists in the queue
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Sorry"
                                                                message:@"That song is already in the queue."
                                                               delegate:nil
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles: nil];
                [alert show];
            } else {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Confirm Submission"
                                                                message:@"Are you sure you want to add this song to the queue?"
                                                               delegate:self
                                                      cancelButtonTitle:@"No"
                                                      otherButtonTitles:@"Yes", nil];
                
                [alert show];
            }
        }
    }];
    
    
    
}

#pragma mark - Alert view delegate

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex==1){ // yes
        
        PFObject *song = [self.data objectAtIndex:[self.tableView indexPathForSelectedRow].row];
        
        PFObject *queuedSong = [PFObject objectWithClassName:@"QueuedSong"];
        
        queuedSong[@"song"] = song;
        queuedSong[@"hub"] = self.hub;
        queuedSong[@"addedBy"] = [PFUser currentUser];
        queuedSong[@"points"] = @1;
        queuedSong[@"active"] = @YES;
        
        [queuedSong saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if(succeeded){
                [self loadSongs];
            }
        }];
        
//        obj[@"queue"] = self.hub[@"queue"];
//        obj[@"addedToQueueBy"] = [PFUser currentUser];
//        obj[@"dateAddedToQueue"] = [NSDate date];
//        obj[@"points"] = @1;
        
//        [obj saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
//            if(succeeded){
//                [self loadSongs];
//            }
//        }];
    }
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

 */

@end
