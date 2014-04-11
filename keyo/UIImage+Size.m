//
//  UIImage+Size.m
//  keyo
//
//  Created by User on 3/16/14.
//  Copyright (c) 2014 MakoWare. All rights reserved.
//

#import "UIImage+Size.h"

@implementation UIImage (Size)

+(UIImage *)imageNamed:(NSString *)name andSize:(CGSize)size
{
    UIImage *image = [UIImage imageNamed:name];
    //    UIImageView *iv = [[UIImageView alloc] initWithImage:image];

    
    UIGraphicsBeginImageContextWithOptions(size, NO, 0.0);
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

@end
