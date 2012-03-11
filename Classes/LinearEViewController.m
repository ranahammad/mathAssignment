//
//  LinearEViewController.m
//  EqSolver
//
//  Created by Qaisar Ashraf on 8/1/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "LinearEViewController.h"


@implementation LinearEViewController
@synthesize aValOneVarEquation;
@synthesize bValOneVarEquation;
@synthesize cValOneVarEquation;
@synthesize aValTwoVarEquation;
@synthesize bValTwoVarEquation;
@synthesize cValTwoVarEquation;

@synthesize CalcResult_OneVarEq;
@synthesize CalcResult_TwoVarEq;

@synthesize ValOfx_OneVarEq,ViewOfOneVarEquation,ViewOfTwoVarEquation;
@synthesize ValOfx_TwoVarEq;
@synthesize ValOfy_TwoVarEq,dValTwoVarEquation, eValTwoVarEquation,fValTwoVarEquation,SelectViewOne,SelectViewTwo;

@synthesize aValSegmentPlusMinus;
@synthesize bValSegmentPlusMinus;
@synthesize cValSegmentPlusMinus;
@synthesize dValSegmentPlusMinus;
@synthesize eValSegmentPlusMinus;
@synthesize fValSegmentPlusMinus;


-(IBAction)selectView:(id)sender{
	if([sender isEqual:SelectViewOne]){
		//[ViewOfOneVarEquation setHidden:NO];
		//[ViewOfTwoVarEquation setHidden:YES];
		
	}
	else if([sender isEqual:SelectViewTwo]){
		//[ViewOfOneVarEquation setHidden:YES];
		//[ViewOfTwoVarEquation setHidden:NO];
	}
	
}
-(IBAction)gotoHome{
	//[ViewOfOneVarEquation setHidden:YES];
	//[ViewOfTwoVarEquation setHidden:YES];
	
	aValOneVarEquation.text = nil;
	bValOneVarEquation.text = nil;
	cValOneVarEquation.text = nil;
	
	aValTwoVarEquation.text = nil;
	bValTwoVarEquation.text = nil;
	cValTwoVarEquation.text = nil;
	dValTwoVarEquation.text = nil;
	eValTwoVarEquation.text = nil;
	fValTwoVarEquation.text = nil;
	ValOfx_OneVarEq.text = nil;
	ValOfx_TwoVarEq.text = nil;
	ValOfy_TwoVarEq.text = nil;
	
	//[self dismissModalViewControllerAnimated:YES];
}
-(IBAction)CalcResult:(id)sender
{

	a = [aValTwoVarEquation.text intValue] * (([bValSegmentPlusMinus selectedSegmentIndex]==0)?1:-1);	
	b = [bValTwoVarEquation.text intValue] * (([bValSegmentPlusMinus selectedSegmentIndex]==0)?1:-1);
	c = [cValTwoVarEquation.text intValue] * (([cValSegmentPlusMinus selectedSegmentIndex]==0)?1:-1);
	d = [dValTwoVarEquation.text intValue] * (([dValSegmentPlusMinus selectedSegmentIndex]==0)?1:-1);
	e = [eValTwoVarEquation.text intValue] * (([eValSegmentPlusMinus selectedSegmentIndex]==0)?1:-1);
	f = [fValTwoVarEquation.text intValue] * (([fValSegmentPlusMinus selectedSegmentIndex]==0)?1:-1);
	
	float denominator = ((a*e)-(d*b));

	if(denominator != 0)
	{
		x2 =(float)((f*b)-(c*e))/ denominator;
		y2 = (float)((c*d)-(f*a))/ denominator;
		ValOfx_TwoVarEq.text = [NSString stringWithFormat:@"%.2f", x2];
		ValOfy_TwoVarEq.text = [NSString stringWithFormat:@"%.2f", y2];
	}
	else 
	{
		ValOfx_TwoVarEq.text = @"nan";
		ValOfy_TwoVarEq.text = @"nan";
	}
}

-(IBAction)textFieldDoneEditing;
{ 	
	[aValOneVarEquation resignFirstResponder];
	[bValOneVarEquation resignFirstResponder];
	[cValOneVarEquation resignFirstResponder];
	[aValTwoVarEquation resignFirstResponder];
	[bValTwoVarEquation resignFirstResponder];
	[cValTwoVarEquation resignFirstResponder];
	[dValTwoVarEquation resignFirstResponder];
	[eValTwoVarEquation resignFirstResponder];
	[fValTwoVarEquation resignFirstResponder];
	
} 
/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        // Custom initialization
    }
    return self;
}
*/

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	//[ViewOfOneVarEquation setHidden:YES];
	//[ViewOfTwoVarEquation setHidden:YES];
}


/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
	[aValOneVarEquation release];
	[bValOneVarEquation release];
	[cValOneVarEquation release];
	[aValTwoVarEquation release];
	[bValTwoVarEquation release];
	[cValTwoVarEquation release];
	[dValTwoVarEquation release];
	[eValTwoVarEquation release];
	[fValTwoVarEquation release];
	
	[SelectViewOne release];
	[SelectViewTwo release];
	[CalcResult_OneVarEq release];
	[CalcResult_TwoVarEq release];
	
	
	[ValOfx_OneVarEq release];
	[ValOfx_TwoVarEq release];
	[ValOfy_TwoVarEq release];
	
	[ViewOfOneVarEquation release];
	[ViewOfTwoVarEquation release];
}


@end
