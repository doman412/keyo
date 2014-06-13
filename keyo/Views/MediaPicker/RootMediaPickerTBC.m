//
//  RootMediaPickerTBC.m
//  Juke
//
//  Created by Derek Arner on 6/9/14.
//  Copyright (c) 2014 MakoWare. All rights reserved.
//

#import "RootMediaPickerTBC.h"

#import "SongsMediaPickerVC.h"

@interface RootMediaPickerTBC ()

@end

@implementation RootMediaPickerTBC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    for(UINavigationController *nav in self.viewControllers){
        id vc = nav.topViewController;
        
        if( [vc respondsToSelector:@selector(setSongs:)]){
//            NSLog(@"responds");
            [vc setSongs:self.songs];
        } else {
            NSLog(@"no response");
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
