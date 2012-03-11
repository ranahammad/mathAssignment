//
//  secondViewController.h
//  calculator
//
//  Created by Gobbledygook on 2/21/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "cCalculator.h"

@interface secondViewController : UIViewController 
{
	UILabel *pLabelSecond;
	UILabel *pLabelFirst;
	
	UITextField *pTxtProblem;
		
	UIScrollView	*pScrollViewForShift;
	UIScrollView	*pScrollViewForUnshift;
	
	cCalculator		*pCalculator;
	
	UISlider	*pSliderDecimalPlaces;
	UILabel		*pLabelDP;
	
	NSInteger	iBracketCount;
	
	BOOL bNegating;
	
	
	BOOL bXEntered;
	BOOL bLogarithmicEntered;
}

@property (nonatomic, retain) IBOutlet UILabel*				pLabelDP;
@property (nonatomic, retain) IBOutlet UISlider*			pSliderDecimalPlaces;
@property (nonatomic, retain) IBOutlet UILabel*				pLabelSecond;
@property (nonatomic, retain) IBOutlet UILabel*				pLabelFirst;
@property (nonatomic, retain) IBOutlet UITextField*			pTxtProblem;
@property (nonatomic, retain) IBOutlet UIScrollView*		pScrollViewForShift;
@property (nonatomic, retain) IBOutlet UIScrollView*		pScrollViewForUnshift;
@property (nonatomic, retain) cCalculator*					pCalculator;

-(IBAction) sliderMoved;
-(IBAction) clearBtnClicked;
-(IBAction) solveBtnClicked;
-(IBAction) backSpaceBtnClicked;

/// non shift btns
-(IBAction) clickedInv;
-(IBAction) clickedSin;
-(IBAction) clickedCos;
-(IBAction) clickedTan;
-(IBAction) clickedPower;
-(IBAction) clickedSquare;
-(IBAction) clickedPi;
-(IBAction) clickedLeftParenthesis;
-(IBAction) clickedRightParenthesis;
-(IBAction) clickedDivide;
-(IBAction) clickedLog;
-(IBAction) clicked7;
-(IBAction) clicked8;
-(IBAction) clicked9;
-(IBAction) clickedMultiply;
-(IBAction) clickedLn;
-(IBAction) clicked4;
-(IBAction) clicked5;
-(IBAction) clicked6;
-(IBAction) clickedMinus;
-(IBAction) clickedSquareRoot;
-(IBAction) clicked1;
-(IBAction) clicked2;
-(IBAction) clicked3;
-(IBAction) clickedPlus;
-(IBAction) clickedExponent;
-(IBAction) clicked0;
-(IBAction) clickedDecimal;


-(IBAction) clickedX;
-(IBAction) clickedNegate;
-(IBAction) clickedEqual;
@end
