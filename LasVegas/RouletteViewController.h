//
//  RouletteViewController.h
//  LasVegas
//
//  Created by GORIN Franck on 17/05/13.
//  Copyright (c) 2013 Franck GORIN & Romain ARDIET. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVAudioPlayer.h>

@interface RouletteViewController : UIViewController <UIPickerViewDelegate, UIPickerViewDataSource>
{
	AVAudioPlayer *MyPlayer;
	NSInteger NumberOfClicks;
}
    @property (nonatomic, retain) NSArray *PickerArray1;
    @property (nonatomic, retain) NSArray *PickerArray2;
    @property (nonatomic, retain) NSArray *PickerArray3;

    @property (weak, nonatomic) IBOutlet UIPickerView *PickerView;
    @property (weak, nonatomic) IBOutlet UIButton *LaunchRouletteButton;
    @property (weak, nonatomic) IBOutlet UIButton *retourBtn;

    - (IBAction)LaunchRoulette:(id)sender;
    - (IBAction)retourBtn:(id)sender;

	@property (weak, nonatomic) IBOutlet UILabel *InfoWin;

@end
