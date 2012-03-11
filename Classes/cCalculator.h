//
//  cCalculator.h
//  calculator
//
//  Created by Gobbledygook on 2/21/10.
//  Copyright 2010 _My_Company_Name_. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cPolynomial.h"

@interface cCalculator : NSObject 
{	
	cPolynomial *pPolynomial;
	
	BOOL		bTrignometry; // this is true when equation contains sin, cos, tan
	NSInteger	iDecimalPlaces;
	
	NSString	*strRunningInput;
	NSString	*strSolution;
	NSString	*strSolution1;
	
	NSMutableArray *pValueStack;
	
	BOOL		bPolynomial; // this is true when equation contains X and =
}

@property (nonatomic) NSInteger				iDecimalPlaces;
@property (nonatomic) BOOL					bTrignometry;
@property (nonatomic) BOOL					bPolynomial;
@property (nonatomic, retain) cPolynomial *	pPolynomial;
@property (nonatomic, retain) NSString*		strRunningInput;
@property (nonatomic, retain) NSString*		strSolution;
@property (nonatomic, retain) NSString*		strSolution1;

-(void) clearInput;
-(BOOL) clearLastInput;
-(void) solveInput;

-(void) insertAlpha:(NSString*)strAlpha;
@end
