//
//  CoffeeShopInfo.m
//  
//
//  Created by LINCHUNGYAO on 2015/11/5.
//
//

#import "CoffeeShopInfo.h"
#import <SystemConfiguration/SystemConfiguration.h> //檢查連線狀況
#import "DetailViewController.h"
#import "ParseSaveViewController.h"

@implementation CoffeeShopInfo

- (id)initWithCoder:(NSCoder *)aCoder
{
    self = [super initWithCoder:aCoder];
    if (self) {

        self.parseClassName = @"CoffeeShop";

        self.textKey = @"shopName";

        self.pullToRefreshEnabled = YES;

        self.paginationEnabled = NO;
    }
    return self;
}

- (PFQuery *)queryForTable
{
        //檢查連線狀況
    NSString *host = @"www.apple.com";
    SCNetworkReachabilityRef  reachability =SCNetworkReachabilityCreateWithName(nil, host.UTF8String);
    SCNetworkReachabilityFlags flags;
    BOOL result = NO;
    if(reachability) {
        result = SCNetworkReachabilityGetFlags(reachability, &flags);
        CFRelease(reachability);
    }

    NSLog(@"%d %d", result, flags);

    if(!result || !flags) {
        NSLog(@"無網路");
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"網路連線有問題" message:@"請稍後再試，謝謝" preferredStyle:UIAlertControllerStyleAlert];

        UIAlertAction *confirmButton = [UIAlertAction actionWithTitle:@"Confirm" style:UIAlertActionStyleDefault handler:nil];

        [alert addAction:confirmButton];
        
        alert.view.tintColor = [UIColor colorWithRed:0.9 green:0.41 blue:0.15 alpha:1.0];
        
        [self presentViewController:alert animated:YES completion:nil];
    }
    else {
        NSLog(@"有網路");
    }


    PFQuery *query = [PFQuery queryWithClassName:self.parseClassName];

    if ([self.objects count] == 0) {
        query.cachePolicy = kPFCachePolicyCacheThenNetwork;
    }

    [query orderByDescending:@"createdAt"];

    return query;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath object:(PFObject *)object
{
    static NSString *reuseIdentifier = @"parseReuseId";

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];

    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    }

        // Configure the cell
    PFFile *thumbnail = [object objectForKey:@"pictures"];
    PFImageView *thumbnailImageView = (PFImageView*)[cell.contentView viewWithTag:10];
    thumbnailImageView.image = [UIImage imageNamed:@"placeholder.png"];
    thumbnailImageView.file = thumbnail;
    thumbnailImageView.layer.cornerRadius = 2.0f;
    thumbnailImageView.layer.masksToBounds = YES;
    thumbnailImageView.layer.borderWidth = 1.0f;
    thumbnailImageView.layer.borderColor = [UIColor colorWithRed:0.9 green:0.41 blue:0.15 alpha:1.0].CGColor;
    [thumbnailImageView loadInBackground];

    UILabel *shopNameLabel = (UILabel*) [cell.contentView viewWithTag:11];
    shopNameLabel.text = [object objectForKey:@"shopName"];
    shopNameLabel.textColor = [UIColor colorWithRed:0.9 green:0.41 blue:0.15 alpha:1.0];
    [shopNameLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Italic" size:20]];


    UILabel *addressLabel = (UILabel*) [cell.contentView viewWithTag:12];
    addressLabel.text = [object objectForKey:@"address"];
    addressLabel.textColor = [UIColor colorWithRed:0.9 green:0.41 blue:0.15 alpha:1.0];
    [addressLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Italic" size:12]];

    return cell;
}


- (void)viewDidLoad
{
    [super viewDidLoad];

        //隱藏status bar
    UIApplication *app = [UIApplication sharedApplication];
    [app setStatusBarHidden:YES withAnimation:YES];

    CGFloat width = [UIScreen mainScreen].bounds.size.width;

    UINavigationBar *naviBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, width, 50)];
    [self.view addSubview:naviBar];

    UIBarButtonItem *addItem = [[UIBarButtonItem alloc] initWithTitle:@"add"
                                                                style:UIBarButtonItemStylePlain
                                                               target:self
                                                               action:@selector(addButPressed)
                                ];

    UINavigationItem  *naviItem = [[UINavigationItem alloc] init];

    naviItem.rightBarButtonItem = addItem;
        //        menu照片的顏色受leftBarButtonItem.tintColor控制
    naviItem.leftBarButtonItem.tintColor = [UIColor colorWithRed:0.9 green:0.41 blue:0.15 alpha:1.0];
    naviBar.items = [NSArray arrayWithObjects:naviItem,nil];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(refreshTable:)
                                                 name:@"refreshTable"
                                               object:nil];
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    DetailViewController *controllerEvent = [self.storyboard instantiateViewControllerWithIdentifier:@"DetailViewController"];

    PFObject *object = [self.objects objectAtIndex:indexPath.row];

    controllerEvent.shopName = [object objectForKey:@"shopName"];
    controllerEvent.address = [object objectForKey:@"address"];
    controllerEvent.tel = [object objectForKey:@"tel"];
    controllerEvent.webSite = [object objectForKey:@"webSite"];
    controllerEvent.briefs = [object objectForKey:@"briefs"];
    controllerEvent.imageFile = [object objectForKey:@"pictures"];

    [self presentViewController:controllerEvent animated:NO completion:nil];
    
}


-(void)addButPressed{

    ParseSaveViewController *controllerParseEdit = [self.storyboard instantiateViewControllerWithIdentifier:@"ParseSaveViewController"];

    [self presentViewController:controllerParseEdit animated:NO completion:nil];
    
}

- (void)refreshTable:(NSNotification *) notification
{

    [self loadObjects];
}


          // Remove the row from coffee shop list
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{

    PFObject *object = [self.objects objectAtIndex:indexPath.row];
    [object deleteInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        [self refreshTable:nil];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
        // Dispose of any resources that can be recreated.

}


- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
        // Return NO if you do not want the specified item to be editable.
    return YES;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}

- (BOOL)tableView:(UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}

/*
    //移動表格順序位置
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:
(NSIndexPath *)toIndexPath
{
    PFObject *object = [self.objects objectAtIndex:toIndexPath.row];
    [object removeObjectAtIndex:fromIndexPath.row];
    [object insertObject:dic atIndex:toIndexPath.row];
}
*/
@end
