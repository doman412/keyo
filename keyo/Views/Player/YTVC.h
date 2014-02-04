//
//  YTVC.h
//  keyo
//
//  Created by User on 1/17/14.
//  Copyright (c) 2014 MakoWare. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LBYouTubePlayerViewController.h"

@interface YTVC : UIViewController<LBYouTubePlayerControllerDelegate,LBYouTubeExtractorDelegate>

@property (strong,nonatomic) LBYouTubePlayerViewController *controller;
@property (strong,nonatomic) MPMoviePlayerController *mp;

@end
