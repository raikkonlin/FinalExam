//
//  ImageZoomViewController.m
//  CoffeeShop
//
//  Created by LINCHUNGYAO on 2015/11/5.
//  Copyright © 2015年 LINCHUNGYAO. All rights reserved.
//

#import "ImageZoomViewController.h"
#import "ParseUI/ParseUI.h"

@interface ImageZoomViewController () <UIScrollViewDelegate>
{
    PFImageView *imageView;
}

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@end

@implementation ImageZoomViewController


-(void)viewDidAppear:(BOOL)animated{
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    UINavigationBar *naviBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 20, width, 50)];
    [self.view addSubview:naviBar];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:self action:@selector(backButtonPressed)];

    UINavigationItem  *naviItem = [[UINavigationItem alloc] init];
    naviItem.leftBarButtonItem = backItem;
    naviBar.items = [NSArray arrayWithObjects:naviItem,nil];

    CGFloat height = [UIScreen mainScreen].bounds.size.height;

    self.scrollView.contentSize = CGSizeMake(2000, 2000);
    imageView = [[PFImageView alloc] initWithFrame:CGRectMake(0, 50, width, height - 50)];
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.file = self.imageFile;
    [self.scrollView addSubview:imageView];
}


-(void)backButtonPressed{

    [self dismissViewControllerAnimated:NO completion:nil];
}


#pragma mark - UIScrollViewDelegate
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {

    return imageView;
}
@end
