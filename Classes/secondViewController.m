//
//  secondViewController.m
//  calculator
//
//  Created by Gobbledygook on 2/21/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "secondViewController.h"


@implementation secondViewController

@synthesize pLabelSecond;
@synthesize pLabelFirst;
@synthesize pTxtProblem;
@synthesize pScrollViewForShift;
@synthesize pScrollViewForUnshift;
@synthesize pCalculator;
@synthesize pSliderDecimalPlaces;
@synthesize pLabelDP;

-(IBAction) sliderMoved
{
	int value = [pSliderDecimalPlaces value];
	
	[pLabelDP setText:[NSString stringWithFormat:@"%d dp",value]];
	[pCalculator setIDecimalPlaces:value];
}

-(IBAction) clearBtnClicked
{
	[pCalculator setBTrignometry:FALSE];
	if([[pTxtProblem text] isEqualToString:@""])
	{
		if([[pLabelFirst text] isEqualToString:@""])
		{
			[pLabelSecond setText:@""];
		}
		else {
			[pLabelFirst setText:@""];
		}
	}
	else
	{
		[pCalculator clearInput];
		[pTxtProblem setText:[pCalculator strRunningInput]];
	}
}

-(IBAction) backSpaceBtnClicked
{
	// backspace button pressed, handle this
	if([pCalculator clearLastInput])
		iBracketCount--;
	
	[pTxtProblem setText:[pCalculator strRunningInput]];
}

-(IBAction) solveBtnClicked
{
	if ([[pTxtProblem text] length] == 0) {
//		UIAlertView *pAlert = [[UIAlertView alloc] initWithTitle:@"Solving equation" 
//														 message:@"Enter an equation" 
//														delegate:nil
//											   cancelButtonTitle:@"OK"
//											   otherButtonTitles:nil];
//		[pAlert show];
//		[pAlert release];
		return;
	}
	if (iBracketCount<0) {
//		UIAlertView *pAlert = [[UIAlertView alloc] initWithTitle:@"Solving equation" 
//														 message:@"There are less LEFT Parenthesis" 
//														delegate:nil
//											   cancelButtonTitle:@"OK"
//											   otherButtonTitles:nil];
//		[pAlert show];
//		[pAlert release];
		return;
	}
	else if(iBracketCount > 0)
	{
		while (iBracketCount>0) {
			[self clickedRightParenthesis];
		}
	}
	
	[pCalculator solveInput];
	
	if([pCalculator bTrignometry])
	{
		[pLabelSecond setTextAlignment:UITextAlignmentLeft];
		[pLabelSecond setText:[pCalculator strRunningInput]];
		[pLabelFirst	setText:[pCalculator strSolution]];
	}
	else if([pCalculator strSolution1])
	{
		[pLabelFirst setTextAlignment:UITextAlignmentLeft];
		[pLabelSecond setTextAlignment:UITextAlignmentLeft];
		[pLabelSecond setText:[pCalculator strSolution]];
		[pLabelFirst setText:[pCalculator strSolution1]];
	}
	else
	{
		[pLabelFirst setTextAlignment:UITextAlignmentRight];
		[pLabelSecond setTextAlignment:UITextAlignmentRight];
		[pLabelSecond setText:[pLabelFirst text]];
		[pLabelFirst	setText:[pCalculator strSolution]];
	}

	[pTxtProblem setText:@""];
	[pCalculator clearInput];
	[pCalculator setBTrignometry:FALSE];
}

/// non shift btns

-(IBAction) clicked0
{
	[pCalculator insertAlpha:@"0"];	
	[pTxtProblem setText:[pCalculator strRunningInput]];
}

-(IBAction) clicked1
{
	[pCalculator insertAlpha:@"1"];	
	[pTxtProblem setText:[pCalculator strRunningInput]];
}

-(IBAction) clicked2
{
	[pCalculator insertAlpha:@"2"];	
	[pTxtProblem setText:[pCalculator strRunningInput]];
}

-(IBAction) clicked3
{
	[pCalculator insertAlpha:@"3"];	
	[pTxtProblem setText:[pCalculator strRunningInput]];
}

-(IBAction) clicked4
{
	[pCalculator insertAlpha:@"4"];	
	[pTxtProblem setText:[pCalculator strRunningInput]];
}

-(IBAction) clicked5
{
	[pCalculator insertAlpha:@"5"];	
	[pTxtProblem setText:[pCalculator strRunningInput]];
}

-(IBAction) clicked6
{
	[pCalculator insertAlpha:@"6"];	
	[pTxtProblem setText:[pCalculator strRunningInput]];
}

-(IBAction) clicked7
{
	[pCalculator insertAlpha:@"7"];	
	[pTxtProblem setText:[pCalculator strRunningInput]];
}

-(IBAction) clicked8
{
	[pCalculator insertAlpha:@"8"];	
	[pTxtProblem setText:[pCalculator strRunningInput]];
}

-(IBAction) clicked9
{
	[pCalculator insertAlpha:@"9"];	
	[pTxtProblem setText:[pCalculator strRunningInput]];
}

-(IBAction) clickedLeftParenthesis
{
	[pCalculator insertAlpha:@"("];	
	[pTxtProblem setText:[pCalculator strRunningInput]];
	iBracketCount++;
}

-(IBAction) clickedRightParenthesis
{
	[pCalculator insertAlpha:@")"];	
	[pTxtProblem setText:[pCalculator strRunningInput]];
	iBracketCount--;
}

-(IBAction) clickedSin
{
	[pCalculator setBTrignometry:TRUE];
	[pCalculator insertAlpha:@"sin("];
	iBracketCount++;

	[pTxtProblem setText:[pCalculator strRunningInput]];
}

-(IBAction) clickedCos
{
	[pCalculator setBTrignometry:TRUE];
	[pCalculator insertAlpha:@"cos("];	
	iBracketCount++;
	[pTxtProblem setText:[pCalculator strRunningInput]];
}

-(IBAction) clickedTan
{
	[pCalculator setBTrignometry:TRUE];
	[pCalculator insertAlpha:@"tan("];	
	iBracketCount++;
	[pTxtProblem setText:[pCalculator strRunningInput]];
}

-(IBAction) clickedPower
{
	[pCalculator insertAlpha:@"^("];	
	iBracketCount++;
	[pTxtProblem setText:[pCalculator strRunningInput]];
}

-(IBAction) clickedLog
{
	[pCalculator insertAlpha:@"log("];	
	iBracketCount++;
	[pTxtProblem setText:[pCalculator strRunningInput]];
}

-(IBAction) clickedLn
{
	[pCalculator insertAlpha:@"ln("];	
	iBracketCount++;
	[pTxtProblem setText:[pCalculator strRunningInput]];
}

-(IBAction) clickedExponent
{
	[pCalculator insertAlpha:@"e^("];	
	iBracketCount++;
	[pTxtProblem setText:[pCalculator strRunningInput]];
}

-(IBAction) clickedMultiply
{
	[pCalculator insertAlpha:@"*"];	
	[pTxtProblem setText:[pCalculator strRunningInput]];
}

-(IBAction) clickedMinus
{
	//unichar ch = [[pCalculator strRunningInput] characterAtIndex:[[pCalculator strRunningInput] length] - 1];
	if([[pCalculator strRunningInput] hasSuffix:@"+"] ||
	   [[pCalculator strRunningInput] hasSuffix:@"*"] ||
	   [[pCalculator strRunningInput] hasSuffix:@"÷"] ||
	   [[pCalculator strRunningInput] hasSuffix:@"-"] ||
	   [[pCalculator strRunningInput] length] == 0)
	{
		[pCalculator insertAlpha:@"(-"];
		iBracketCount++;
		bNegating = TRUE;
	}
	else
		[pCalculator insertAlpha:@"-"];	
	
	[pTxtProblem setText:[pCalculator strRunningInput]];
}

-(IBAction) clickedPlus
{
	if([[pCalculator strRunningInput] hasSuffix:@"+"] ||
	   [[pCalculator strRunningInput] hasSuffix:@"*"] ||
	   [[pCalculator strRunningInput] hasSuffix:@"÷"] ||
	   [[pCalculator strRunningInput] hasSuffix:@"-"] ||
	   [[pCalculator strRunningInput] length] == 0)
	{
		[pCalculator insertAlpha:@"(+"];
		iBracketCount++;

	}
	else
		[pCalculator insertAlpha:@"+"];	
	[pTxtProblem setText:[pCalculator strRunningInput]];
}

-(IBAction) clickedDivide
{	
	[pCalculator insertAlpha:@"÷"];	// Divide symbol
	[pTxtProblem setText:[pCalculator strRunningInput]];
}

-(IBAction) clickedPi
{	
	[pCalculator insertAlpha:@"π"]; // Pi symbol
	[pTxtProblem setText:[pCalculator strRunningInput]];
}


-(IBAction) clickedInv
{	
	[pCalculator insertAlpha:@"^(-1)"];	// Inverse symbol
	[pTxtProblem setText:[pCalculator strRunningInput]];
}

-(IBAction) clickedSquare
{	
	if([[pCalculator strRunningInput] hasSuffix:@"²"])
		return;
	
	[pCalculator insertAlpha:@"²"];	// Square symbol
	[pTxtProblem setText:[pCalculator strRunningInput]];
}

-(IBAction) clickedSquareRoot
{	
	[pCalculator insertAlpha:@"√("];	// Square Root symbol
	iBracketCount++;
	[pTxtProblem setText:[pCalculator strRunningInput]];
}

-(IBAction) clickedDecimal
{
	//check for valid input
	if([[pCalculator strRunningInput] hasSuffix:@"."])
		return;
	
	[pCalculator insertAlpha:@"."];	
	[pTxtProblem setText:[pCalculator strRunningInput]];
}

-(IBAction) clickedX
{
	if([[pCalculator strRunningInput] hasSuffix:@"X"])
		return;
	
	[pCalculator insertAlpha:@"X"];
	[pTxtProblem setText:[pCalculator strRunningInput]];
}

-(IBAction) clickedNegate
{
	[self clickedMinus];
	
//	if([[pCalculator strRunningInput] length] > 0)
//	{
//		[pCalculator setStrRunningInput:[NSString stringWithFormat:@"-(%@)",pCalculator.strRunningInput]];
//		[pTxtProblem setText:[pCalculator strRunningInput]];
//	}
}

-(IBAction) clickedEqual
{
	[pCalculator insertAlpha:@"="];
	[pTxtProblem setText:[pCalculator strRunningInput]];
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad 
{	
	pCalculator = [[cCalculator alloc] init];
	
	bNegating = FALSE;
	bXEntered = FALSE;
	bLogarithmicEntered = FALSE;
	[pLabelFirst setText:@""];
	[pLabelSecond setText:@""];

	[pSliderDecimalPlaces setValue:4];
	[pLabelDP setText:[NSString stringWithFormat:@"%d dp",4]];
	[pCalculator setIDecimalPlaces:4];

	iBracketCount = 0;
    [super viewDidLoad];
	
}

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
}


@end
