//
//  Waiting.h
//  keyo
//
//  Created by User on 2/27/14.
//  Copyright (c) 2014 MakoWare. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Waiting : UIViewController

@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *ind;

+(id)one;

-(void)showIt:(UIViewController*)vc;

+(void)show:(UIViewController*)vc;

-(void)hideIt;

+(void)hide;

-(void)hideIt:(UIViewController*)vc;

+(void)hide:(UIViewController*)vc;

-(void)startIt;

+(void)start;

-(void)stopIt;

+(void)stop;

@end
