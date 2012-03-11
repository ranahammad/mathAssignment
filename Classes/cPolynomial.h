//
//  cPolynomial.h
//  calculator
//
//  Created by Gobbledygook on 2/21/10.
//  Copyright 2010 _My_Company_Name_. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CToken.h"

//////////////////////////////////////
//
// cPolynomial
//
//////////////////////////////////////

@interface cPolynomial : NSObject 
{
	NSMutableArray *pTokenizer;
	NSMutableArray *pInfixTokens;
	
	NSInteger		iCurrentIdx;
	
	BOOL			bEquation;
	double			fAnswer;
	BOOL			bRadian;
	NSInteger		iDecimalPlaces;
	
	NSMutableArray *parenthesizedStack;
	NSMutableArray *pMultiplyValues;
	
	NSString	*strEquationSolution;
	NSString	*strEquationSolution1;
		BOOL blogFunc;
}

@property (nonatomic, retain) NSMutableArray *pMultiplyValues;
@property (nonatomic) BOOL blogFunc;
@property (nonatomic,retain) NSMutableArray *parenthesizedStack;
@property (nonatomic) NSInteger iDecimalPlaces;
@property (nonatomic) BOOL bRadian;
@property (nonatomic) BOOL bEquation;
@property (nonatomic, retain) NSString *strEquationSolution;
@property (nonatomic, retain) NSString *strEquationSolution1;
@property (nonatomic) double fAnswer;

//@property (nonatomic) NSInteger iPolynomialType;
@property (nonatomic, retain)	NSMutableArray *pTokenizer;

- (BOOL) parseAndSolvePolynomial:(NSString*) strInputPoly;
@end
