//
//  RouletteViewController.m
//  LasVegas
//
//  Created by GORIN Franck on 17/05/13.
//  Copyright (c) 2013 Franck GORIN & Romain ARDIET. All rights reserved.
//

#import "RouletteViewController.h"

@interface RouletteViewController ()

@end

@implementation RouletteViewController

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

	// Initialize NumberOfClicks variable
	NumberOfClicks = 0;

	self.InfoWin.text = @"Clique pour tenter ta chance (3 essais)";
	[self preparePlayerWithSong:@"dora"];

	 // IMAGES FOR PICKER VIEW
	 UIImage *banana = [UIImage imageNamed:@"banana.png"];
	 UIImage *cerise = [UIImage imageNamed:@"cerise.png"];
	 UIImage *dollar = [UIImage imageNamed:@"dollar.png"];
	 UIImage *donkeyKong = [UIImage imageNamed:@"donkey_kong.jpg"];

	 // FOR EACH ROW, BUILD ARRAY OF NSMutableArray of UIImageView AND ADD IT TO THE ROW
	 for (int i = 1; i <= 3; i++) {
		 UIImageView *bananaView = [[UIImageView alloc] initWithImage:banana];
		 bananaView.tag=1;

		 UIImageView *ceriseView = [[UIImageView alloc] initWithImage:cerise];
		 ceriseView.tag=2;

		 UIImageView *dollarView = [[UIImageView alloc] initWithImage:dollar];
		 dollarView.tag=3;

		 UIImageView *donkeyKongView = [[UIImageView alloc] initWithImage:donkeyKong];
		 donkeyKongView.tag=4;

		 NSString *rowName = [[NSString alloc] initWithFormat:@"PickerArray%d", i];
		 NSMutableArray *imagesViewArray = [[NSMutableArray alloc] initWithCapacity:1];

		 // Add 20 times Images in the array
		 for (int j = 0; j <= 20; j++) {
			 [imagesViewArray addObject:bananaView];
			 [imagesViewArray addObject:ceriseView];
			 [imagesViewArray addObject:dollarView];
			 [imagesViewArray addObject:donkeyKongView];
		 }
		 [self setValue:imagesViewArray forKey:rowName];
	 }
}

- (void) viewDidUnload
{
	MyPlayer = nil;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)retourBtn:(id)sender
{
	[self returnOtherViewWithSuccess];
}

/*
/-------------------------------------
 IMPLEMENTATION METHODS FOR UIPicker
/-------------------------------------
*/
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)SongPicker
{
	// 3 columns
	return 3;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
	switch (component) {
		case 0:
			return [self.PickerArray1 count];
			break;
		case 1:
			return [self.PickerArray2 count];
			break;
		case 2:
			return [self.PickerArray3 count];
			break;
		default:
			return [self.PickerArray1 count];
			break;
	}
}

/*
/-------------------------------------
 IMPLEMENTS THIS FUNCTION TO MAKE POSSIBLE TO ADD UIVIEWS IN ROW INSTEAD OF STRINGS
	--> problem solved here : http://stackoverflow.com/a/7075723/1995266
/-------------------------------------
*/

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
	switch (component) {
		case 0:
			return [self.PickerArray1 objectAtIndex:row];
			break;
		case 1:
			return [self.PickerArray2 objectAtIndex:row];
			break;
		case 2:
			return [self.PickerArray3 objectAtIndex:row];
			break;
		default:
			return [self.PickerArray1 objectAtIndex:row];
			break;
	}
}

// SET CUSTOM HEIGHT FOR ROW
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
	// height in pixels
	CGFloat customHeightRow = 80;
	return customHeightRow;
}
/*
/-------------------------------------
END IMPLEMENTATION METHODS FOR UIPicker
/-------------------------------------
*/


/*
/-------------------------------------
METHOD TO ROTATE UIPICKER WHEN LAUNCH BUTTON WAS TAPPED
/-------------------------------------
*/
- (IBAction)LaunchRoulette:(id)sender
{
	NumberOfClicks+=1;

	if (NumberOfClicks>=3) {
		[self.LaunchRouletteButton setTitle:@"Retente ta chance plus tard !!" forState:UIControlStateNormal]; // Set the title
		[self.LaunchRouletteButton setEnabled:NO]; // set Disabled
		[self.LaunchRouletteButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
		self.InfoWin.text = @" :(";
	}

	for (int i = 0; i < 3; i++) {
		int newValue = arc4random() % [self.PickerArray1 count];
		[self.PickerView selectRow:newValue inComponent:i animated:YES];
	}

	//  recup tags for each row
	int row0 = [self.PickerView selectedRowInComponent:0];
	int row1 = [self.PickerView selectedRowInComponent:1];
	int row2 = [self.PickerView selectedRowInComponent:2];
	UIImageView *imageRow0 = [self.PickerArray1 objectAtIndex:row0 ];
	UIImageView *imageRow1 = [self.PickerArray1 objectAtIndex:row1 ];
	UIImageView *imageRow2 = [self.PickerArray1 objectAtIndex:row2 ];

	if (imageRow0.tag == imageRow1.tag &&
		imageRow0.tag == imageRow2.tag) {
		// call the player which was loaded asynchronously
		[MyPlayer play];
		[self.LaunchRouletteButton setTitle:@"Gagné !!" forState:UIControlStateNormal]; // To set the title
		[self.LaunchRouletteButton setEnabled:NO];
		[self.LaunchRouletteButton setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
		self.InfoWin.text = @" Bien joué Lolo !";
		[NSTimer scheduledTimerWithTimeInterval:10 target:self selector:@selector(returnOtherViewWithSuccess) userInfo:nil repeats:NO];
	}
}

- (void)returnOtherViewWithSuccess
{
	[self dismissViewControllerAnimated:YES completion:NULL];
}

/*
/-------------------------------------
LOAD THE PLAYER IN BACKGROUND TO PUT IT IN THE BUFFER AND PREPARE IT
/-------------------------------------
*/
- (void)preparePlayerWithSong:(NSString *) song
{
	dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0),
				   ^{
					   NSString *soundPath = [[NSBundle mainBundle] pathForResource:song ofType:@"mp3"];
					   NSURL *fileUrl = [[NSURL alloc] initFileURLWithPath:soundPath];
					   MyPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:fileUrl error:nil];
					   [MyPlayer prepareToPlay];
				   });
}




@end
