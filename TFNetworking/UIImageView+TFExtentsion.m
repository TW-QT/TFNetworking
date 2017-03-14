//
//  UIImageView+TFExtentsion.m
//
//  Created by 陶飞 on 16/6/8.
//  Copyright © 2016年 taofei. All rights reserved.
//

#import "UIImageView+TFExtentsion.h"
#import "UIImageView+WebCache.h"


@implementation UIImageView (TFExtentsion)

-(void)setCircleHeader:(NSString *)url{
    
    UIImage *placeholder=[[UIImage imageNamed:@"defaultUserIcon"] circleImage];
    
    [self sd_setImageWithURL:[NSURL URLWithString:url] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
        self.image=image?[image circleImage]:placeholder;
    }];

    

}

@end
