//
//  ImageZoomViewController.h
//  CoffeeShop
//
//  Created by LINCHUNGYAO on 2015/11/5.
//  Copyright © 2015年 LINCHUNGYAO. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface ImageZoomViewController : UIViewController

@property (nonatomic, strong) PFFile *imageFile;
@end
