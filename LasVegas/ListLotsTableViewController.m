//
//  ListLotsTableViewController.m
//  LasVegas
//
//  Created by GORIN Franck on 16/05/13.
//  Copyright (c) 2013 Franck GORIN & Romain ARDIET. All rights reserved.
//

#import "ListLotsTableViewController.h"
#import "NSDictionary+lots.h"
#import "NSDictionary+lot.h"
#import "UIImageView+AFNetworking.h"
#import "LotDetailsViewController.h"

static NSString *const BaseURLString = @"http://romainbellina.fr/lasVegas/"; // Our JSON URL  (Bilou on compte sur toi !)
//static NSString *const BaseURLString = @"http://webservice.etuwebdev.fr/lasVegas/"; // Our JSON URL (ne marche pas)

@interface ListLotsTableViewController ()

    @property(strong) NSDictionary *lotsJSON;

@end

@implementation ListLotsTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self loadJson]; // load JSON
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

/*
 /-------------------------------------
  METHOD TO LOAD JSON FILE
 /-------------------------------------
 */
- (void) loadJson
{
    // Load JSON file in background to don't disturb display
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),
        ^{
            // You form the full URL from the base URL. The full URL then makes its way into an NSURL object, and then into an NSURLRequest
            NSString *LasVegasJsonURL = [NSString stringWithFormat:@"%@lots.json", BaseURLString];
            NSURL *listLotsURL = [NSURL URLWithString:LasVegasJsonURL];
            NSURLRequest *request = [NSURLRequest requestWithURL:listLotsURL];

            // AFJSONRequestOperation is the all-in-one class that fetches data across the network and then parses the JSON response
            AFJSONRequestOperation *operation =
            [AFJSONRequestOperation JSONRequestOperationWithRequest:request
                // The success block runs when the request succeeds. The parsed lot data comes back as a dictionary in the JSON variable, which is stored in the lot property
                success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON)
                {
                    self.lotsJSON = (NSDictionary *)JSON;
                    [self.tableView reloadData];
                }
                // The failure block runs if something goes wrong, such as when the network isn’t available. If that happens, you display an alert view with an error message
                failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON)
                {
                    UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Erreur pour parser lots.json" message:[NSString stringWithFormat:@"%@",error] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                    [av show];
                }
             ];
            [operation start];
        }
    );
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section
    if(!self.lotsJSON)
    {
        return 0;
    }else
    {
        NSArray *listLots = [self.lotsJSON listLots];
        return [listLots count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *currentLot;
    NSArray *listLots = [self.lotsJSON listLots];
    static NSString *CellIdentifier = @"LotCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];

    // Fill the cell
    currentLot = [listLots objectAtIndex:indexPath.row];
    cell.textLabel.text = [currentLot lotName]; // Title label
    cell.detailTextLabel.text = [currentLot lotDescription]; // Description label

    // Image thumbnail
    __weak UITableViewCell *weakCell = cell;
    [cell.imageView setImageWithURLRequest:[[NSURLRequest alloc] initWithURL:[NSURL URLWithString: currentLot.lotSmallImage]]
        placeholderImage:[UIImage imageNamed:@"placeholder.png"]
                success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image)
                {
                    weakCell.imageView.image = image;
                    [weakCell setNeedsLayout];
                }
                failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error)
                {

                }
     ];

    return cell;
}

/*
 /-------------------------------------
  METHOD TO SEND 'lot' OBJECT TO lotDetailsView
 /-------------------------------------
 */
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // verify the identifier of segue
    if ([segue.identifier isEqualToString:@"showLotDetails"]) {

        // invokes the tableView:indexPathForSelectedRow to retrieve the selected table row
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];

        // Once we have the selected row, we’ll pass it to the LotDetailsViewController
        LotDetailsViewController *lotDetailsViewController = segue.destinationViewController;
        NSArray *listLots = [self.lotsJSON listLots];
        lotDetailsViewController.lot = [listLots objectAtIndex:indexPath.row];
    }
}

@end
