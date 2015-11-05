//
//  DetailViewController.h
//  CoffeeShop
//
//  Created by LINCHUNGYAO on 2015/11/5.
//  Copyright © 2015年 LINCHUNGYAO. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface DetailViewController : UIViewController

@property (nonatomic, strong) NSString *shopName;
@property (nonatomic, strong) NSString *address;
@property (nonatomic, strong) NSString *tel;
@property (nonatomic, strong) NSString *webSite;
@property (nonatomic, strong) NSString *briefs;
@property (nonatomic, strong) PFFile *imageFile;


@end
