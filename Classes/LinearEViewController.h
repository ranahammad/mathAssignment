//
//  LinearEViewController.h
//  EqSolver
//
//  Created by Qaisar Ashraf on 8/1/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface LinearEViewController : UIViewController {
	IBOutlet UITextField *aValOneVarEquation;
	IBOutlet UITextField *bValOneVarEquation;
	IBOutlet UITextField *cValOneVarEquation;
	IBOutlet UITextField *aValTwoVarEquation;
	IBOutlet UITextField *bValTwoVarEquation;
	IBOutlet UITextField *cValTwoVarEquation;
	IBOutlet UITextField *dValTwoVarEquation;
	IBOutlet UITextField *eValTwoVarEquation;
	IBOutlet UITextField *fValTwoVarEquation;
	
	IBOutlet UIButton *SelectViewOne;
	IBOutlet UIButton *SelectViewTwo;
	IBOutlet UIButton *CalcResult_OneVarEq;
	IBOutlet UIButton *CalcResult_TwoVarEq;
	
	
	IBOutlet UILabel *ValOfx_OneVarEq;
	IBOutlet UILabel *ValOfx_TwoVarEq;
	IBOutlet UILabel *ValOfy_TwoVarEq;
	
	IBOutlet UIView *ViewOfOneVarEquation;
	IBOutlet UIView *ViewOfTwoVarEquation;
	
	double a, b, c, d, e, f, x1, x2, y2;

	IBOutlet UISegmentedControl *aValSegmentPlusMinus;
	IBOutlet UISegmentedControl *bValSegmentPlusMinus;
	IBOutlet UISegmentedControl *cValSegmentPlusMinus;
	IBOutlet UISegmentedControl *dValSegmentPlusMinus;
	IBOutlet UISegmentedControl *eValSegmentPlusMinus;
	IBOutlet UISegmentedControl *fValSegmentPlusMinus;
}

@property (nonatomic, retain) IBOutlet UISegmentedControl *aValSegmentPlusMinus;
@property (nonatomic, retain) IBOutlet UISegmentedControl *bValSegmentPlusMinus;
@property (nonatomic, retain) IBOutlet UISegmentedControl *cValSegmentPlusMinus;
@property (nonatomic, retain) IBOutlet UISegmentedControl *dValSegmentPlusMinus;
@property (nonatomic, retain) IBOutlet UISegmentedControl *eValSegmentPlusMinus;
@property (nonatomic, retain) IBOutlet UISegmentedControl *fValSegmentPlusMinus;


@property (nonatomic, retain) IBOutlet UITextField *aValOneVarEquation;
@property (nonatomic, retain) IBOutlet UITextField *bValOneVarEquation;
@property (nonatomic, retain) IBOutlet UITextField *cValOneVarEquation;

@property (nonatomic, retain) IBOutlet UITextField *aValTwoVarEquation;
@property (nonatomic, retain) IBOutlet UITextField *bValTwoVarEquation;
@property (nonatomic, retain) IBOutlet UITextField *cValTwoVarEquation;
@property (nonatomic, retain) IBOutlet UITextField *dValTwoVarEquation;
@property (nonatomic, retain) IBOutlet UITextField *eValTwoVarEquation;
@property (nonatomic, retain) IBOutlet UITextField *fValTwoVarEquation;

@property (nonatomic, retain) UIButton *SelectViewOne;
@property (nonatomic, retain) UIButton *SelectViewTwo;
@property (nonatomic, retain) UIButton *CalcResult_OneVarEq;
@property (nonatomic, retain) UIButton *CalcResult_TwoVarEq;

@property (nonatomic, retain) UILabel *ValOfx_OneVarEq;
@property (nonatomic, retain) UILabel *ValOfx_TwoVarEq;
@property (nonatomic, retain) UILabel *ValOfy_TwoVarEq;

@property (nonatomic, retain) UIView *ViewOfOneVarEquation;
@property (nonatomic, retain) UIView *ViewOfTwoVarEquation;

-(IBAction)gotoHome;
-(IBAction)textFieldDoneEditing;
-(IBAction)CalcResult:(id)sender;
-(IBAction)selectView:(id)sender;
@end
