//
//  DetailViewController.m
//  CoffeeShop
//
//  Created by LINCHUNGYAO on 2015/11/5.
//  Copyright © 2015年 LINCHUNGYAO. All rights reserved.
//

#import "DetailViewController.h"
#import "ParseUI/ParseUI.h"
#import "ImageZoomViewController.h"
#import "MapViewController.h"

@interface DetailViewController ()
@property (weak, nonatomic) IBOutlet PFImageView *shopImageView;
@property (weak, nonatomic) IBOutlet UILabel *shopNameLabel;
@property (weak, nonatomic) IBOutlet UIButton *addressButton;
@property (weak, nonatomic) IBOutlet UIButton *telButton;
@property (weak, nonatomic) IBOutlet UIButton *webSiteButton;
@property (weak, nonatomic) IBOutlet UILabel *briefsLabel;

@end

@implementation DetailViewController


-(void)viewDidAppear:(BOOL)animated{
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    UINavigationBar *naviBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 20, width, 50)];
    [self.view addSubview:naviBar];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:self action:@selector(backButtonPressed)];

    UINavigationItem  *naviItem = [[UINavigationItem alloc] init];
    naviItem.leftBarButtonItem = backItem;
    naviBar.items = [NSArray arrayWithObjects:naviItem,nil];

    self.shopImageView.file = self.imageFile;

    self.shopNameLabel.text = self.shopName;

     self.addressButton.backgroundColor = [UIColor colorWithRed:0.9 green:0.41 blue:0.15 alpha:1.0];
     self.addressButton.layer.borderWidth = 2.0f;
     self.addressButton.layer.cornerRadius = 2.0f;
     self.addressButton.layer.borderColor = [UIColor whiteColor].CGColor;
    [self.addressButton setTitle:self.address forState:UIControlStateNormal];
    [self.addressButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.addressButton setShowsTouchWhenHighlighted:YES];
    [self.addressButton addTarget:self
                        action:@selector(mapAddressButton)
              forControlEvents:UIControlEventTouchUpInside];

     self.telButton.backgroundColor = [UIColor colorWithRed:0.9 green:0.41 blue:0.15 alpha:1.0];
     self.telButton.layer.borderWidth = 2.0f;
     self.telButton.layer.cornerRadius = 2.0f;
     self.telButton.layer.borderColor = [UIColor whiteColor].CGColor;
    [self.telButton setTitle:self.tel forState:UIControlStateNormal];
    [self.telButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.telButton setShowsTouchWhenHighlighted:YES];
    [self.telButton addTarget:self
                           action:@selector(dialTelButton)
                 forControlEvents:UIControlEventTouchUpInside];


     self.webSiteButton.backgroundColor = [UIColor colorWithRed:0.9 green:0.41 blue:0.15 alpha:1.0];
     self.webSiteButton.layer.borderWidth = 2.0f;
     self.webSiteButton.layer.cornerRadius = 2.0f;
     self.webSiteButton.layer.borderColor = [UIColor whiteColor].CGColor;
    [self.webSiteButton setTitle:self.webSite forState:UIControlStateNormal];
    [self.webSiteButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.webSiteButton setShowsTouchWhenHighlighted:YES];
    [self.webSiteButton addTarget:self
                       action:@selector(openMapButton)
             forControlEvents:UIControlEventTouchUpInside];


     self.briefsLabel.text = self.briefs;

}

-(void)backButtonPressed{

    [self dismissViewControllerAnimated:NO completion:nil];
}

-(void)mapAddressButton{

    MapViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"MapViewController"];
    controller.address = self.address;
    controller.shopName = self.shopName;
    [self presentViewController:controller animated:NO completion:nil];
}

-(void)dialTelButton{

    NSString *phoneNumber = [@"tel://" stringByAppendingString:self.tel];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phoneNumber]];

}

-(void)openMapButton{

    NSURL *url = [NSURL URLWithString:self.webSite];
    NSLog(@"url %@",self.webSite);
    [[UIApplication sharedApplication] openURL:url];
}

- (IBAction)tapToZoomImage:(UITapGestureRecognizer *)sender {

    ImageZoomViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"ImageZoomViewController"];
    controller.imageFile = self.imageFile;
    NSLog(@"tapToZoomImage");
    [self presentViewController:controller animated:NO completion:nil];
}

@end
