//
//  Theme.m
//  keyo
//
//  Created by User on 2/22/14.
//  Copyright (c) 2014 MakoWare. All rights reserved.
//

#import "Theme.h"



@implementation Theme

+(UIColor *)orange
{
    // 225, 105, 0);
    return [UIColor colorWithRed:(225.0/255.0) green:(105.0/255.0) blue:(0.0/255.0) alpha:1.0];
}

+(UIColor *)fontWhite
{
    // (235, 235, 235);
    return [UIColor colorWithRed:(235.0/255.0) green:(235.0/255.0) blue:(235.0/255.0) alpha:1.0];
}

+(UIColor *)backgroundBlue
{
    //(43, 62, 80)
    return [UIColor colorWithRed:(43.0/255.0) green:(62.0/255.0) blue:(80.0/255.0) alpha:1.0];
}

+(UIColor *)lightBlue
{
    //(78, 93, 108)
    return [UIColor colorWithRed:(78.0/255.0) green:(93.0/255.0) blue:(108.0/255.0) alpha:1.0];
}

@end
