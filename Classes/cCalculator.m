//
//  cCalculator.m
//  calculator
//
//  Created by Gobbledygook on 2/21/10.
//  Copyright 2010 _My_Company_Name_. All rights reserved.
//

#import "cCalculator.h"

#define PI_VALUE	M_PI

float degreeToRadian(float degree)
{
	return ((degree / 180.0) * PI_VALUE);
}

float radianToDegree(float radian)
{
	return ((radian / PI_VALUE) * 180.0);
}

@implementation cCalculator

@synthesize pPolynomial;
@synthesize bTrignometry;
@synthesize strRunningInput;
@synthesize strSolution;
@synthesize strSolution1;
@synthesize iDecimalPlaces;
@synthesize bPolynomial;

-(id) init
{
	if(self = [super init])
	{
		pPolynomial = [[cPolynomial alloc] init];
		pValueStack = [[NSMutableArray alloc] init];
		strRunningInput = @"";
		bTrignometry = FALSE;
	}
	
	return self;
}

-(void) dealloc
{
	if(pPolynomial)
	{
		[pPolynomial release];
		pPolynomial = nil;
	}
	
	if(pValueStack)
	{
		[pValueStack removeAllObjects];
		[pValueStack release];
		pValueStack = nil;
	}
	
	[super dealloc];
}

/// Polynomial arithmetic is done here
// cPolynomial only stores the polynomial in tokenized form

-(void) clearInput
{
	// caller: clearBtnClicked
	strRunningInput = @"";
}

-(BOOL) clearLastInput
{
	BOOL bContainsLeftParenthesis = FALSE;
	if([pValueStack count] > 0)
	{
		NSString *pLastValue = (NSString*)[pValueStack objectAtIndex:[pValueStack count] - 1];
		
		for (int k=0; k<[pLastValue length]; k++) {
			
			unichar ch = [pLastValue characterAtIndex:k];
			if(ch == '(')
				bContainsLeftParenthesis = TRUE;
		}
		
		int length = [pLastValue length];
		
		// loop over strinput and leave the characters of size length;
		NSString *pTempString = @"";
		
		for (int i=0; i<[strRunningInput length] - length; i++)
		{
			unichar ch = [strRunningInput characterAtIndex:i];
			pTempString = [pTempString stringByAppendingFormat:@"%c",ch];
		}
		
		[pValueStack removeLastObject];
		strRunningInput = pTempString;
	}
	return bContainsLeftParenthesis;
}

-(void) solveInput
{
	// caller: solveBtnClicked
	// solve polynomial

	strSolution = nil;
	strSolution1 = nil;
	
	if(bTrignometry)
	{	
		[pPolynomial setBRadian:TRUE];
		BOOL bValidPoly = [pPolynomial parseAndSolvePolynomial:strRunningInput];

		strSolution = @"";
		
		if(bValidPoly)
		{
			switch (iDecimalPlaces) {
				case 0:
					strSolution = [strSolution stringByAppendingFormat:@"[Rad] %.0f", [pPolynomial fAnswer]];
					break;
				case 1:
					strSolution = [strSolution stringByAppendingFormat:@"[Rad] %.1f", [pPolynomial fAnswer]];
					break;
				case 2:
					strSolution = [strSolution stringByAppendingFormat:@"[Rad] %.2f", [pPolynomial fAnswer]];
					break;
				case 3:
					strSolution = [strSolution stringByAppendingFormat:@"[Rad] %.3f", [pPolynomial fAnswer]];
					break;
				case 4:
					strSolution = [strSolution stringByAppendingFormat:@"[Rad] %.4f", [pPolynomial fAnswer]];
					break;
				case 5:
					strSolution = [strSolution stringByAppendingFormat:@"[Rad] %.5f", [pPolynomial fAnswer]];
					break;
			}
		}
		else
		{
			strSolution = [NSString stringWithFormat:@"%@ is invalid!",strRunningInput];
			return;
		}
		
		[pPolynomial setBRadian:FALSE];
		bValidPoly = [pPolynomial parseAndSolvePolynomial:strRunningInput];
		
		if(bValidPoly)
		{
			switch (iDecimalPlaces) {
				case 0:
					strSolution = [strSolution stringByAppendingFormat:@" [Deg] %.0f", [pPolynomial fAnswer]];
					break;
				case 1:
					strSolution = [strSolution stringByAppendingFormat:@" [Deg] %.1f", [pPolynomial fAnswer]];
					break;
				case 2:
					strSolution = [strSolution stringByAppendingFormat:@" [Deg] %.2f", [pPolynomial fAnswer]];
					break;
				case 3:
					strSolution = [strSolution stringByAppendingFormat:@" [Deg] %.3f", [pPolynomial fAnswer]];
					break;
				case 4:
					strSolution = [strSolution stringByAppendingFormat:@" [Deg] %.4f", [pPolynomial fAnswer]];
					break;
				case 5:
					strSolution = [strSolution stringByAppendingFormat:@" [Deg] %.5f", [pPolynomial fAnswer]];
					break;
			}
		}
		else
		{
			strSolution = [NSString stringWithFormat:@"%@ is invalid!",strRunningInput];
			return;
		}		
	}
	else 
	{
		BOOL bValidPoly = [pPolynomial parseAndSolvePolynomial:strRunningInput];
		strSolution = strRunningInput;
		if(bValidPoly)
		{
			
			if([pPolynomial bEquation])
			{
				strSolution = [pPolynomial strEquationSolution];
				if([[pPolynomial strEquationSolution1] length] > 0)
					strSolution1 = [pPolynomial strEquationSolution1];
				
				if(strSolution)
					NSLog(@"sol1 = %@",strSolution);
				if(strSolution1)
					NSLog(@"sol1 = %@",strSolution1);
				
				[pPolynomial setBEquation:FALSE];
				
				return;
			}
			else 
			{
				switch (iDecimalPlaces) 
				{
					case 0:
						strSolution = [strSolution stringByAppendingFormat:@" = %.0f", [pPolynomial fAnswer]];
						break;
					case 1:
						strSolution = [strSolution stringByAppendingFormat:@" = %.1f", [pPolynomial fAnswer]];
						break;
					case 2:
						strSolution = [strSolution stringByAppendingFormat:@" = %.2f", [pPolynomial fAnswer]];
						break;
					case 3:
						strSolution = [strSolution stringByAppendingFormat:@" = %.3f", [pPolynomial fAnswer]];
						break;
					case 4:
						strSolution = [strSolution stringByAppendingFormat:@" = %.4f", [pPolynomial fAnswer]];
						break;
					case 5:
						strSolution = [strSolution stringByAppendingFormat:@" = %.5f", [pPolynomial fAnswer]];
						break;
				}

			}
		}
		else
		{
			strSolution = [NSString stringWithFormat:@"%@ is invalid!",strRunningInput];
			return;
		}		
	}

	if(strSolution)
		NSLog(@"sol1 = %@",strSolution);
	if(strSolution1)
		NSLog(@"sol1 = %@",strSolution1);
//	strSolution		= [NSString stringWithFormat:@"%@  solution:-",strRunningInput];
}

//////////////// insertion methods
-(void) insertAlpha:(NSString*)strAlpha
{
	if(strAlpha)
	{
		NSString *pNewValuw = [[NSString alloc] initWithString:strAlpha];
		[pValueStack addObject:pNewValuw];
		[pNewValuw release];
	}
	
	if([strRunningInput length] == 0)
		strRunningInput = [NSString stringWithFormat:@"%@",strAlpha];
	else
		strRunningInput = [strRunningInput stringByAppendingString:strAlpha];
}

@end
