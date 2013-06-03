//
//  LotDetailsViewController.m
//  LasVegas
//
//  Created by GORIN Franck on 16/05/13.
//  Copyright (c) 2013 Franck GORIN & Romain ARDIET. All rights reserved.
//

#import "LotDetailsViewController.h"
#import "NSDictionary+lot.h"
#import "RouletteViewController.h"

@interface LotDetailsViewController ()

@end

@implementation LotDetailsViewController

@synthesize lot;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self buildLotDetailsView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 /-------------------------------------
  METHOD TO BUILD LOT DETAILS VIEW
 /-------------------------------------
 */
- (void)buildLotDetailsView
{
    // title
    self.title = [self.lot lotName];
    // large Image
    NSURL *urlLargeImage = [NSURL URLWithString:self.lot.lotLargeImage];
    [self.largeImageView setImageWithURL:urlLargeImage];
    // large description
    self.largeDescriptionText.text = [self.lot lotLargeDescription];
}

/*
 /-------------------------------------
  METHOD TO GO TO Roulette View
 /-------------------------------------
 */
- (IBAction)tenteTaChanceBtn:(id)sender
{
    UIViewController *rouletteViewController = [[RouletteViewController alloc] initWithNibName:nil bundle:nil];

	[self presentViewController:rouletteViewController animated:YES completion:nil];
}

@end
