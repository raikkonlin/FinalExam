//
//  ParseSaveViewController.m
//  CoffeeShop
//
//  Created by LINCHUNGYAO on 2015/11/5.
//  Copyright © 2015年 LINCHUNGYAO. All rights reserved.
//

#import "ParseSaveViewController.h"
#import <Parse/Parse.h>
#import "CoffeeShopInfo.h"

@interface ParseSaveViewController () <UITextFieldDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate>

@property (weak, nonatomic) IBOutlet UITextField *shopNameLabel;

@property (weak, nonatomic) IBOutlet UIImageView *shopImageView;
@property (weak, nonatomic) IBOutlet UITextField *briefsLabel;

@property (weak, nonatomic) IBOutlet UITextField *addressLabel;
@property (weak, nonatomic) IBOutlet UITextField *telLabel;
@property (weak, nonatomic) IBOutlet UITextField *webSiteLabel;

@end

@implementation ParseSaveViewController

-(void)viewDidLoad{
    [super viewDidLoad];

    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    UINavigationBar *naviBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 20, width, 50)];
    [self.view addSubview:naviBar];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:self action:@selector(backButtonPressed)];

    UIBarButtonItem *addItem = [[UIBarButtonItem alloc] initWithTitle:@"Add New Data" style:UIBarButtonItemStylePlain target:self action:@selector(addButtonPressed)];
    UINavigationItem  *naviItem = [[UINavigationItem alloc] init];
    naviItem.leftBarButtonItem = backItem;
    naviItem.rightBarButtonItem = addItem;
    naviBar.items = [NSArray arrayWithObjects:naviItem,nil];

    
}

-(void)addButtonPressed{

    PFObject *newShop = [PFObject objectWithClassName:@"CoffeeShop"];
    [newShop setObject:self.shopNameLabel.text forKey:@"shopName"] ;
    [newShop setObject:self.briefsLabel.text forKey:@"briefs"];
    [newShop setObject:self.addressLabel.text forKey:@"address"] ;
    [newShop setObject:self.telLabel.text forKey:@"telLabel"];
    [newShop setObject:self.webSiteLabel.text forKey:@"webSiteLabel"];

    NSData *imageData = UIImageJPEGRepresentation(self.shopImageView.image, 0.5);
    NSString *filename = [NSString stringWithFormat:@"%@.jpg", self.shopNameLabel.text];
    PFFile *imageFile = [PFFile fileWithName:filename data:imageData];
    [newShop setObject:imageFile forKey:@"pictures"];

    [newShop saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {

        if (!error) {

            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Upload Complete" message:@"Successfully saved the new movie info" preferredStyle:UIAlertControllerStyleAlert];

            UIAlertAction *confirmButton = [UIAlertAction actionWithTitle:@"Confirm" style:UIAlertActionStyleDefault handler:nil];
            
            [alert addAction:confirmButton];
            
            alert.view.tintColor = [UIColor colorWithRed:0.9 green:0.41 blue:0.15 alpha:1.0];
            
            [self presentViewController:alert animated:YES completion:nil];

            [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshTable" object:self];

            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];

            PFQueryTableViewController *rootViewController = [storyboard instantiateViewControllerWithIdentifier:@"CoffeeShopInfo"];

            [[UIApplication sharedApplication].keyWindow setRootViewController:rootViewController];

        } else {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Upload Failure" message:@"Check again" preferredStyle:UIAlertControllerStyleAlert];

            UIAlertAction *cancelButton = [UIAlertAction actionWithTitle:@"Noted" style:UIAlertActionStyleDefault handler:nil];

            [alert addAction:cancelButton];
            
            alert.view.tintColor = [UIColor colorWithRed:0.9 green:0.41 blue:0.15 alpha:1.0];
            
            [self presentViewController:alert animated:YES completion:nil];
            
        }
        
    }];

}

-(void)backButtonPressed{
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)imagePickButton:(UIButton *)sender {
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        [picker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
        picker.allowsEditing = true;
        [self presentViewController:picker animated:true completion:nil];
    }
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {

    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];

    self.shopImageView.image = image;

    [self dismissViewControllerAnimated:true completion:nil];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
@end
