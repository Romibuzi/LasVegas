//
//  LotDetailsViewController.h
//  LasVegas
//
//  Created by GORIN Franck on 16/05/13.
//  Copyright (c) 2013 Franck GORIN & Romain ARDIET. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LotDetailsViewController : UIViewController

    @property (nonatomic, strong) NSDictionary *lot;
    @property (weak, nonatomic) IBOutlet UIButton *tenteTaChanceBtn;
    @property (weak, nonatomic) IBOutlet UIImageView *largeImageView;
    @property (weak, nonatomic) IBOutlet UITextView *largeDescriptionText;

    - (void)buildLotDetailsView;
    - (IBAction)tenteTaChanceBtn:(id)sender;

@end
