//
//  UserSongsVC.m
//  keyo
//
//  Created by User on 1/10/14.
//  Copyright (c) 2014 MakoWare. All rights reserved.
//

#import "UserSongsVC.h"

@interface UserSongsVC ()

@end

@implementation UserSongsVC

@synthesize data,songQuery;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if(self){
        self.songQuery = [PFQuery queryWithClassName:@"Song"];
        
        [self.songQuery whereKey:@"owner" equalTo:[PFUser currentUser]];
        
//        [self loadSongs];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // set title
    self.title = @"Your Songs";
    
    //1
    self.tableView.dataSource =self;
    self.tableView.delegate = self;
    //2
    self.audioPlayer = [[AVPlayer alloc] init];
    MPMediaQuery *everything = [MPMediaQuery songsQuery];
    NSArray *itemsFromGenericQuery = [everything items];
    self.songsList = [NSMutableArray arrayWithArray:itemsFromGenericQuery];
    //3
    [self.tableView reloadData];
    //4
//    MPMediaItem *song = [self.songsList objectAtIndex:0];
//    AVPlayerItem * currentItem = [AVPlayerItem playerItemWithURL:[song valueForProperty:MPMediaItemPropertyAssetURL]];
//    [self.audioPlayer replaceCurrentItemWithPlayerItem:currentItem];
//    [self.audioPlayer play];
    //5
//    NSString *songTitle = [song valueForProperty: MPMediaItemPropertyTitle];
//    self.songName.text = songTitle;
//    [self.sliderOutlet setMaximumValue:self.audioPlayer.currentItem.duration.value/self.audioPlayer.currentItem.duration.timescale];
    //6
}

-(void)viewWillAppear:(BOOL)animated
{
    [self loadSongs];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadData:) name:@"com.makoware.keyo.reloadUserSongs" object:nil];
}

-(void)viewDidAppear:(BOOL)animated
{
    self.navigationController.delegate = self;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"com.makoware.keyo.reloadUserSongs" object:nil];
}

- (void)reloadData:(NSNotification*)noti
{
    NSLog(@"reloadData");
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)loadSongs
{
   [self.songQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
       if(!error){
           self.data = [[NSMutableArray alloc] init];
           
           for(PFObject *song in objects){
               SongCellObject *obj = [[SongCellObject alloc] init];
               obj.title = song[@"title"];
               obj.artist = song[@"artist"];
               obj.song = song;
               
               [self.data addObject:obj];
           }
           
//           self.data = [NSMutableArray arrayWithArray:objects];
           [self.tableView reloadData];
           
//           self.tabBarItem.badgeValue = [NSString stringWithFormat:@"%li",objects.count];
       } else {
           NSLog(@"err: %@",error);
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
//    return data.count;
    return self.songsList.count;
}
/*
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
    
    
    return cell;
}
*/
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"SongListCell";
    SongCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    MPMediaItem *song = [self.songsList objectAtIndex:indexPath.row];
    NSString *songTitle = [song valueForProperty: MPMediaItemPropertyTitle];
    NSString *artistLabel = [song valueForProperty: MPMediaItemPropertyArtist];
    
    cell.song = song;
    
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"title == %@ && artist == %@",songTitle,artistLabel];
    NSArray *array = [self.data filteredArrayUsingPredicate:pred];
    
    if(array.count >0) { // has an element
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        [cell setSongObject: [array firstObject]];
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    
    
//    cell.textLabel.text = songTitle;
//    cell.detailTextLabel.text = durationLabel;
    UILabel *title = (id)[cell viewWithTag:1];
    title.text = songTitle;
    UILabel *artist = (id)[cell viewWithTag:2];
    artist.text = artistLabel;
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    MPMediaItem *song = [self.songsList objectAtIndex:indexPath.row];
    NSString *songTitle = [song valueForProperty: MPMediaItemPropertyTitle];
    NSString *artistLabel = [song valueForProperty: MPMediaItemPropertyArtist];
    
    AVPlayerItem * currentItem = [AVPlayerItem playerItemWithURL:[song valueForProperty:MPMediaItemPropertyAssetURL]];
    [self.audioPlayer replaceCurrentItemWithPlayerItem:currentItem];
    [self.audioPlayer play];
    
    SongCell *cell = (id)[self tableView:tableView cellForRowAtIndexPath:indexPath];
//    [cell choose];
    
//    __block UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
////    [obj saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
////        cell.accessoryType = UITableViewCellAccessoryCheckmark;
////    }];
    if(cell.accessoryType == UITableViewCellAccessoryCheckmark){
        NSPredicate *pred = [NSPredicate predicateWithFormat:@"title == %@ && artist == %@",songTitle,artistLabel];
        NSArray *array = [self.data filteredArrayUsingPredicate:pred];
        
        if(array.count > 0){
            PFObject *o = ((SongCellObject*)[array firstObject]).song;
            
            [o deleteInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                if(succeeded){
                    NSLog(@"deleted song");
                    cell.accessoryType = UITableViewCellAccessoryNone;
                    [self.data removeObject: [array firstObject]];
                    [self.tableView reloadData];
                } else {
                    NSLog(@"failed to delete song from parse");
                }
                
            }];
            
        } else {
            NSLog(@"cell is checked but none found int db");
        }
        
    } else if(cell.accessoryType == UITableViewCellAccessoryNone) {
        PFObject *obj = [PFObject objectWithClassName:@"Song"];
        obj[@"title"] = songTitle;
        obj[@"artist"] = artistLabel;
        obj[@"owner"] = [PFUser currentUser];
        
        
        
        [obj saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if(succeeded){
                NSLog(@"saved song");
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
                
                SongCellObject *sco = [[SongCellObject alloc] init];
                sco.title = songTitle;
                sco.artist = artistLabel;
                sco.song = obj;
                
                [self.data addObject:sco];
                [self.tableView reloadData];
            } else {
                NSLog(@"failed to save song: %@ for checkmark",song);
            }
        }];
    }
    
    
    
}

-(void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if(viewController != self){
        NSLog(@"about to show another controller: save all");
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
