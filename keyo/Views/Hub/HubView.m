//
//  HubView.m
//  keyo
//
//  Created by Derek Arner on 12/27/13.
//  Copyright (c) 2013 MakoWare. All rights reserved.
//

#import "HubView.h"
#import "QueueCell.h"

@interface HubView ()

@end

@implementation HubView

@synthesize data,hub,songQuery;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.songQuery = [PFQuery queryWithClassName:@"QueuedSong"];
//    [self.songQuery whereKey:@"hub" equalTo:self.hub];
//    [self.songQuery whereKey:@"queue" equalTo:self.hub[@"queue"]];
    [self.songQuery whereKey:@"hub" equalTo:self.hub];
//    [self.songQuery whereKey:@"active" equalTo:@YES];
    [self.songQuery orderByDescending:@"points"];
    [self.songQuery addAscendingOrder:@"createdAt"];
    [self.songQuery includeKey:@"song"];
    
//    NSLog(@"first: %p/%p",[NSDate date], [NSDate date]);
    
    self.navigationItem.title = self.hub[@"title"];
    
    self.tabBarItem.title = @"Queue";
    
    
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setToolbarHidden:YES];
    [self loadSongs];
}

//-(void)viewDidAppear:(BOOL)animated
//{
//    [self.navigationController setToolbarHidden:YES];
//}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)loadSongs
{
    [self.songQuery findObjectsInBackgroundWithTarget:self selector:@selector(onSongsLoaded:error:)];
}

-(void)onSongsLoaded:(NSArray *)objects error:(NSError *)err
{
    if(!err){
        self.data = [NSMutableArray arrayWithArray:objects];
        [self.tableView reloadData];
        self.tabBarItem.badgeValue = [NSString stringWithFormat:@"%li",objects.count];
    } else {
        NSLog(@"failed to get songs");
    }
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

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 58.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"QueueCell";
    QueueCell *cell = (id)[tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    PFObject *queuedSong = [self.data objectAtIndex:indexPath.row];
    
    PFObject *obj = queuedSong[@"song"];
    
    cell.queuedSong = queuedSong;
    [cell setPoints: [queuedSong[@"points"] integerValue]];
    cell.songTitle.text = obj[@"title"];
    cell.artistName.text = obj[@"artist"];
    cell.pointsLabel.text = [NSString stringWithFormat:@"%li", (long)[queuedSong[@"points"] integerValue]];
//    cell.pointsLabel.text = @"0"; // temp
    
    return cell;
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
