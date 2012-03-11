//
//  cPolynomial.m
//  calculator
//
//  Created by Gobbledygook on 2/21/10.
//  Copyright 2010 _My_Company_Name_. All rights reserved.
//

#import "cPolynomial.h"
#import "utilityFunctions.h"

#define POLYNOMIAL_NAN		0xFFFFFFFFFFFFFFFF

@interface cPolynomial (private)

// if these functions return TRUE, this means that currentAnswer contains the result of 
- (double) handleFunction;
- (double) calculateLimit;
- (double) calculateLn;
- (double) calculateLog;
- (double) calculateTangent;
- (double) calculateCosine;
- (double) calculateSine;
- (double) calculateExponent;
- (double) calculateSqareRoot;
- (double) calculateSummation;
- (double) calculateIntegral;

// handle Equation....... between left bracket and right bracket
- (BOOL) handleParenthesizedPortion;

float Coefa, Coefb, Coefc, a=0,b=0,c=0, d=0,e=0,calcPow=0;
float SubCoefa, SubCoefb, SubCoefc, Suba,Subb,Subc;
float Multiple;
double x1, x2; 

@end


//////////////////////////////////
//
// cPolynomial Class implementation
//
//////////////////////////////////

@implementation cPolynomial

@synthesize pMultiplyValues;
@synthesize pTokenizer;
@synthesize fAnswer;
@synthesize bEquation;
@synthesize strEquationSolution,strEquationSolution1;
@synthesize bRadian;
@synthesize iDecimalPlaces;
@synthesize parenthesizedStack;
@synthesize blogFunc;

- (id) init
{
	if(self = [super init])
	{
		blogFunc	=	FALSE;
		bEquation	=	FALSE;
		strEquationSolution = nil;
		strEquationSolution1 = nil;
		fAnswer		=	0.0;
		bRadian		=	TRUE;
		iDecimalPlaces = 0;
		pTokenizer	=	[[NSMutableArray alloc] init];
		parenthesizedStack = [[NSMutableArray alloc] init];
		pMultiplyValues = [[NSMutableArray alloc] init];
	}
	return self;
}

-(void) dealloc
{
	[pMultiplyValues release];
	[pTokenizer release];
	[parenthesizedStack release];
	[super dealloc];
}

#pragma mark String Parser to generate Tokens

- (BOOL) validatePolynomial:(NSString*) strInput
{
	BOOL bXFound = FALSE;
	BOOL bEqualFound = FALSE;
	
	for (int i=0; i<[strInput length]; i++) 
	{
		unichar ch = [strInput characterAtIndex:i];
		if(ch == 'X') bXFound = TRUE;
		if(ch == '=') bEqualFound = TRUE;
		
		if(ch >= 'a' && ch <='z')//handling all sin, cos, tan, log, ln, exp functions
			blogFunc = TRUE;
		
		if(ch == '^')
		{
			if(i+1 < [strInput length])
			{
				if([strInput characterAtIndex:i+1] == '('
				   && [strInput characterAtIndex:i+2] == '-')// indicating ^(- or inverse
					blogFunc = TRUE;
			}
		}
	}
	
	if(bXFound && bEqualFound && !blogFunc)
	{
		bEquation = TRUE;
	}
	
	if (bXFound && blogFunc)
	{
		blogFunc = TRUE;
	}
	else blogFunc = FALSE;
	
	return (bXFound | bEqualFound);
}

- (BOOL) buildTokensFromInput:(NSString*) strInput
{
	int iRunningTokenIdx = 0;
	NSString *strRunningToken = @"";
	
	NSString *strRunningAlpha = @"";
	NSString *strRunningNumber = @"";
	
	int iAlphaFound = 0;
	int iDigitFound = 0;
	int bDecimalFound = FALSE;
	BOOL bOperatorFound = FALSE;
	BOOL bPutMultiplyToken = FALSE;
	BOOL bEqualFound = FALSE;
	BOOL bPiInserted = FALSE;
	int iBracketOpened = 0;
	
	if([pTokenizer count] > 0)
		[pTokenizer removeAllObjects];
	
	for(int i=0; i<[strInput length]; i++)
	{
		unichar ch = [strInput characterAtIndex:i];
		
		if(iRunningTokenIdx > 0 && (ch<'a' || ch>'z'))
		{
			// handling functions here
			iRunningTokenIdx = 0;
		}
		
		bPutMultiplyToken = FALSE;
		if(bPiInserted)
			bPutMultiplyToken = TRUE;
		
		NSString *strToken = [NSString stringWithFormat:@"%c",ch];

		if([strToken isEqualToString:Symbol_Plus]		|| 
		   [strToken isEqualToString:Symbol_Minus]		|| 
		   [strToken isEqualToString:Symbol_Multiply]	|| 
		   [strToken isEqualToString:Symbol_Power]		|| 
		   [strToken isEqualToString:Symbol_Divide])
		{
			// operator found
			bOperatorFound = TRUE;
			bPutMultiplyToken = FALSE;
			bPiInserted = FALSE;
		}
		
		if(iAlphaFound > 0 && (ch < 'A' || ch > 'Z'))
		{
			CToken *pNewToken = [[CToken alloc] init];
			pNewToken.iTokenType = kValueToken_Alpha;
			pNewToken.strValue = [[NSString alloc] initWithFormat:@"%@",strRunningAlpha];
			[pTokenizer addObject:pNewToken];
			[pNewToken release];
			
			strRunningAlpha = @"";
			iAlphaFound = 0;
			
			if(!bOperatorFound)
				bPutMultiplyToken = TRUE;
		}

		if(iDigitFound > 0 && (ch < '0' || ch > '9') && ch != '.')
		{
			CToken *pNewToken = [[CToken alloc] init];
			pNewToken.iTokenType = kValueToken_Digit;
			pNewToken.strValue = [[NSString alloc] initWithFormat:@"%@",strRunningNumber];
			[pTokenizer addObject:pNewToken];
			[pNewToken release];
			
			strRunningNumber = @"";
			iDigitFound = 0;
			bDecimalFound = FALSE;

			if(!bOperatorFound)
				bPutMultiplyToken = TRUE;
		}
		
		// handling input here !!!
		
		if(ch >= 'A' && ch <= 'Z')
		{
			if(iAlphaFound == 0 && bPutMultiplyToken)  
			{
				CToken *pToken = [CToken tokenFromChar:'*'];
				[pTokenizer addObject:pToken];
				[pToken release];
			}
			
			// alphabets
			iAlphaFound++;
			strRunningAlpha = [strRunningAlpha stringByAppendingFormat:@"%c",ch];
		}
		else if((ch >= '0' && ch <= '9') || ch == '.')
		{
			
			if(iDigitFound == 0 && bPutMultiplyToken)  
			{
				CToken *pToken = [CToken tokenFromChar:'*'];
				[pTokenizer addObject:pToken];
				[pToken release];
			}
			
			// digits
			if(ch == '.')
			{
				if(bDecimalFound)
					return FALSE;
				else 
				{
					bDecimalFound = TRUE;
				}

			}
			else
				iDigitFound++;
			
			strRunningNumber = [strRunningNumber stringByAppendingFormat:@"%c",ch];
		}
		else if(ch >= 'a' && ch <= 'z')
		{
			// functions
			
			if(iRunningTokenIdx == 0 && bPutMultiplyToken)
			{
				CToken *pToken = [CToken tokenFromChar:'*'];
				[pTokenizer addObject:pToken];
				[pToken release];
			}
			
			iRunningTokenIdx++;
			//iRunningTokenIdx = 0
			//iRunningTokenIdx = 1 -> e
			//iRunningTokenIdx = 2 -> ln
			//iRunningTokenIdx = 3 -> log, lim, cos, sin, tan
			
			if(iRunningTokenIdx == 1)
			{
				if(ch == 'e')
				{
					CToken *pNewToken = [CToken tokenFromChar:ch];
					if(pNewToken)
					{
						[pTokenizer addObject:pNewToken];
						[pNewToken release];
					}
					iRunningTokenIdx = 0;
				}
				else if(ch == 'l' || ch == 'c' || ch =='s' || ch == 't')
					strRunningToken = [NSString stringWithFormat:@"%c",ch];
				else
					iRunningTokenIdx = 0;
			}
			else if(iRunningTokenIdx == 2)
			{
				if(ch == 'n')
				{
					NSString *tString = [strRunningToken stringByAppendingFormat:@"%c",ch];
					if([tString isEqualToString:@"ln"])
					{
						CToken *pNewToken = [[CToken alloc] init];
						[pNewToken setITokenType:kValueToken_Ln];
						[pTokenizer addObject:pNewToken];
						[pNewToken release];
					}
					iRunningTokenIdx = 0;
				}
				else if(ch == 'o' || ch == 'i' || ch == 'a')
					strRunningToken = [strRunningToken stringByAppendingFormat:@"%c",ch];
				else
					iRunningTokenIdx = 0;					
			}
			else if(iRunningTokenIdx == 3)
			{
				if(ch == 'n')
				{
					NSString *tString = [strRunningToken stringByAppendingFormat:@"%c",ch];
					if([tString isEqualToString:@"sin"])
					{
						CToken *pNewToken = [[CToken alloc] init];
						[pNewToken setITokenType:kValueToken_Sine];
						[pTokenizer addObject:pNewToken];
						[pNewToken release];
					}

					else if([tString isEqualToString:@"tan"])
					{
						CToken *pNewToken = [[CToken alloc] init];
						[pNewToken setITokenType:kValueToken_Tangent];
						[pTokenizer addObject:pNewToken];
						[pNewToken release];
					}
				}
				else if(ch == 's')
				{
					NSString *tString = [strRunningToken stringByAppendingFormat:@"%c",ch];
					if([tString isEqualToString:@"cos"])
					{
						CToken *pNewToken = [[CToken alloc] init];
						[pNewToken setITokenType:kValueToken_Cosine];
						[pTokenizer addObject:pNewToken];
						[pNewToken release];
					}
				}
				else if(ch == 'm')
				{
					NSString *tString = [strRunningToken stringByAppendingFormat:@"%c",ch];
					if([tString isEqualToString:@"lim"])
					{
						CToken *pNewToken = [[CToken alloc] init];
						[pNewToken setITokenType:kValueToken_Limit];
						[pTokenizer addObject:pNewToken];
						[pNewToken release];
					}
				}
				else if(ch == 'g')
				{
					NSString *tString = [strRunningToken stringByAppendingFormat:@"%c",ch];
					if([tString isEqualToString:@"log"])
					{					
						CToken *pNewToken = [[CToken alloc] init];
						[pNewToken setITokenType:kValueToken_Log];
						[pTokenizer addObject:pNewToken];
						[pNewToken release];
					}					
				}
				
				iRunningTokenIdx = 0;							
			}
			
		}
		else if(bOperatorFound)
		{
			bOperatorFound = FALSE;
			// handle operators
			if(ch == '=')
			{
				if(bEqualFound) return FALSE;
				
				bEqualFound = TRUE;
			}
			else if(ch == 178) //²
			{
				CToken *pNewToken2 = [[CToken alloc] init];
				[pNewToken2 setITokenType:kValueToken_Square];
				[pTokenizer addObject:pNewToken2];
				[pNewToken2 release];
			}
			else if([strToken isEqualToString:Symbol_LeftBracket])
			{
				CToken *pNewToken2 = [CToken tokenFromChar:ch];
				[pTokenizer addObject:pNewToken2];
				[pNewToken2 release];				
				
				iBracketOpened++;
			}
			else if([strToken isEqualToString:Symbol_RightBracket])
			{
				CToken *pNewToken2 = [CToken tokenFromChar:ch];
				[pTokenizer addObject:pNewToken2];
				[pNewToken2 release];				
				
				iBracketOpened--;
			}
			else
			{
				CToken *pNewToken = [CToken tokenFromChar:ch];
				if(pNewToken)
				{
					[pTokenizer addObject:pNewToken];
					[pNewToken release];
				}
				else {
					return FALSE;
				}
			}
		}
		else
		{
			
			if(ch == 960) //π
			{
				if(bPutMultiplyToken)
				{
					CToken *pNewToken = [CToken tokenFromChar:'*'];
					[pTokenizer addObject:pNewToken];
					[pNewToken release];
				}
				
				CToken *pNewToken2 = [[CToken alloc] init];
				[pNewToken2 setITokenType:kValueToken_Digit];
				[pNewToken2 setStrValue:[NSString stringWithFormat:@"%.5f",M_PI]];
				[pTokenizer addObject:pNewToken2];
				[pNewToken2 release];
				
				bPiInserted = TRUE;
				
			}
			else if(ch == 178) //²
			{
				CToken *pNewToken2 = [[CToken alloc] init];
				[pNewToken2 setITokenType:kValueToken_Square];
				[pTokenizer addObject:pNewToken2];
				[pNewToken2 release];
			}
			else if([strToken isEqualToString:Symbol_Complement])
			{
				CToken *pNewToken2 = [CToken tokenFromChar:ch];
				[pTokenizer addObject:pNewToken2];
				[pNewToken2 release];				
			}
			else if([strToken isEqualToString:Symbol_LeftBracket])
			{
				if(bPutMultiplyToken)
				{
					CToken *pNewToken = [CToken tokenFromChar:'*'];
					[pTokenizer addObject:pNewToken];
					[pNewToken release];
				}				
				CToken *pNewToken2 = [CToken tokenFromChar:ch];
				[pTokenizer addObject:pNewToken2];
				[pNewToken2 release];				
				
				iBracketOpened++;
			}
			else if([strToken isEqualToString:Symbol_RightBracket])
			{
				CToken *pNewToken2 = [CToken tokenFromChar:ch];
				[pTokenizer addObject:pNewToken2];
				[pNewToken2 release];				
				
				iBracketOpened--;
			}
			else if(ch == 8730)//square root
			{
				CToken *pNewToken2 = [[CToken alloc] init];
				[pNewToken2 setITokenType:kValueToken_SqareRoot];
				[pTokenizer addObject:pNewToken2];
				[pNewToken2 release];				
			}
			else if(ch == 247)//divide
			{
				CToken *pNewToken2 = [[CToken alloc] init];
				[pNewToken2 setITokenType:kValueToken_Divide];
				[pTokenizer addObject:pNewToken2];
				[pNewToken2 release];				
			}
			else 
			{
				CToken *pNewToken2 = [CToken tokenFromChar:ch];
				[pTokenizer addObject:pNewToken2];
				[pNewToken2 release];								
			}

		}
	}
	
	
	if(iAlphaFound > 0)
	{
		CToken *pNewToken = [[CToken alloc] init];
		pNewToken.iTokenType = kValueToken_Alpha;
		pNewToken.strValue = [[NSString alloc] initWithFormat:@"%@",strRunningAlpha];
		[pTokenizer addObject:pNewToken];
		[pNewToken release];
	}
	
	if(iDigitFound > 0)
	{
		CToken *pNewToken = [[CToken alloc] init];
		pNewToken.iTokenType = kValueToken_Digit;
		pNewToken.strValue = [[NSString alloc] initWithFormat:@"%@",strRunningNumber];
		[pTokenizer addObject:pNewToken];
		[pNewToken release];
	}
	
	if(iBracketOpened > 0)
		return FALSE;
	
	return TRUE;
}

-(int) operatorPriority:(int)iOperator
{
	switch (iOperator)
	{
		case kValueToken_Power:		return 3;
		case kValueToken_Divide:	return 2;			
		case kValueToken_Multiply:	return 2;			
		case kValueToken_Plus:		return 1;
		case kValueToken_Minus:		return 1;
		default:					return 0;
	}
}

-(BOOL) solvePolynomial
{
	// implement a DFA........
	/*
	 
	 Function
	 @"√"	 @"∫"	 @"∑"
	 @"sin"	 @"cos"	 @"tan"	 @"lim"	 @"log"	 @"ln"	 @"e"
	 
	 Unary Operators
	 @"²"	 @"'"
	 
	 Binary Operators with 2 operands
	 @"+"	 @"-"	 @"÷"	 @"*"	 @"="	 @"^"
	 
	 Values
	 @"."	 @"π"	 
	 
	 Precedence Operators
	 @"("	 @")"
	 
	 */
	
	/// if something is found between brackets solve that and store the solution
	/// solve the functions and store the solution
	
	/*
	 
	 to perform calculations over stream,
	 
	 go through each equation, solve it and store its result in array
	 check if there is an operator which requires 2 operands then get second equation and operate it with the 
	 previous stored result and modify the result
	 check if there is a unary operator, then operate it on the previos stored result and modify the result
	 
	 */
	iCurrentIdx = 0;
	pInfixTokens = [[NSMutableArray alloc] init];
	
	// while loop to minimize the tokens to digits and operators with priority in infix notation
	while (iCurrentIdx < [pTokenizer count]) 
	{
		CToken *pToken = [pTokenizer objectAtIndex:iCurrentIdx];
				
		if(([pToken iTokenType] == kValueToken_Square || [pToken iTokenType] == kValueToken_Power)
		   && iCurrentIdx==0)
		{
			[pInfixTokens removeAllObjects];
			[pInfixTokens release];
			return FALSE;
		}
		
		if([CToken isOperator:pToken] || [pToken iTokenType] == kValueToken_Square || [pToken iTokenType] == kValueToken_Complement)
		{
			iCurrentIdx++;
			if(pToken.iTokenType == kValueToken_Square)
			{
				CToken *pNewToken = [[CToken alloc] init];
				[pNewToken setITokenType:kValueToken_Power];
				[pInfixTokens addObject:pNewToken];
				[pNewToken release];

				pNewToken = [[CToken alloc] init];
				[pNewToken setStrValue:[[NSString alloc] initWithFormat:@"2"]];
				[pNewToken setITokenType:kValueToken_Digit];
				[pInfixTokens addObject:pNewToken];
				[pNewToken release];				
			}
			else
			{
				CToken *pNewToken = [[CToken alloc] init];
				[pNewToken setITokenType:pToken.iTokenType];
				[pInfixTokens addObject:pNewToken];
				[pNewToken release];
				
			}
			continue;
		}
		else if([CToken isFunction:pToken])
		{
			double fAnswer1 = [self handleFunction];
			if(fAnswer1 == POLYNOMIAL_NAN)
			{
				[pInfixTokens removeAllObjects];
				[pInfixTokens release];
				
				return FALSE;
			}
						
			CToken *pNewToken = [[CToken alloc] init];
			[pNewToken setStrValue:[[NSString alloc] initWithFormat:@"%.5f",fAnswer1]];
			[pNewToken setITokenType:kValueToken_Digit];
			[pInfixTokens addObject:pNewToken];
			[pNewToken release];
		}
		else if([CToken isDigit:pToken] || [pToken iTokenType] == kValueToken_Pi)
		{
			iCurrentIdx++;
			
			CToken *pNewToken = [[CToken alloc] init];
			[pNewToken setStrValue:[[NSString alloc] initWithFormat:@"%.5f",[[pToken strValue] floatValue]]];
			[pNewToken setITokenType:kValueToken_Digit];
			[pInfixTokens addObject:pNewToken];
			[pNewToken release];
			
		}
		else if([pToken iTokenType] == kValueToken_LeftParenthesis)
		{
			if([self handleParenthesizedPortion] == FALSE)
			{
				[pInfixTokens removeAllObjects];
				[pInfixTokens release];
				
				return FALSE;
			}
			else
			{
				NSString* fCurrentAnswer = [parenthesizedStack objectAtIndex:[parenthesizedStack count]-1];
				
				CToken *pNewToken = [[CToken alloc] init];
				[pNewToken setStrValue:[[NSString alloc] initWithFormat:@"%.5f",[fCurrentAnswer floatValue]]];
				[pNewToken setITokenType:kValueToken_Digit];
				[pInfixTokens addObject:pNewToken];
				[pNewToken release];
				
				[parenthesizedStack removeLastObject];
			}
		}
	}
	
	CToken *pOp1, *pOp2;

	// solve the equation by converting it into prefix notation
	// just to bring operator precedance in use
	if([pInfixTokens count] > 0)
	{
		NSMutableArray *pPreFixTokens = [[NSMutableArray alloc] init];
		NSMutableArray *pStack = [[NSMutableArray alloc] init];
		
		for (int l=[pInfixTokens count]-1; l>=0; l--)
		{
			CToken *cToken = [pInfixTokens objectAtIndex:l];
			if([cToken iTokenType] == kValueToken_Digit)
				[pPreFixTokens addObject:cToken];
			else
			{
				if([pStack count] == 0)
				{
					[pStack addObject:cToken];
				}
				else
				{
					CToken *pLastToken = [pStack lastObject];
					int iLastTokenPr, iCurrentTokenPr;
					iCurrentTokenPr = [self operatorPriority:[cToken iTokenType]];
					iLastTokenPr = [self operatorPriority:[pLastToken iTokenType]];
					
					while ([pStack count] > 0 && iCurrentTokenPr < iLastTokenPr)
					{
						switch ([pLastToken iTokenType]) 
						{
							case kValueToken_Power:
								pOp1 = [pPreFixTokens lastObject];
								[pPreFixTokens removeLastObject];
								
								pOp2 = [pPreFixTokens lastObject];
								[pOp2 setStrValue:[NSString stringWithFormat:@"%.5f",
												   pow([[pOp1 strValue] doubleValue],[[pOp2	strValue]doubleValue])]];
								
								break;
							case kValueToken_Divide:
								pOp1 = [pPreFixTokens lastObject];
								[pPreFixTokens removeLastObject];
								
								pOp2 = [pPreFixTokens lastObject];
								[pOp2 setStrValue:[NSString stringWithFormat:@"%.5f",
												   [[pOp1 strValue] doubleValue] / 
												   [[pOp2 strValue]doubleValue]]];
								
								break;
							case kValueToken_Multiply:
								pOp1 = [pPreFixTokens lastObject];
								[pPreFixTokens removeLastObject];
								
								pOp2 = [pPreFixTokens lastObject];
								[pOp2 setStrValue:[NSString stringWithFormat:@"%.5f",
												   [[pOp1 strValue] doubleValue] * 
												   [[pOp2 strValue]doubleValue]]];
								break;
							case kValueToken_Plus:
								pOp1 = [pPreFixTokens lastObject];
								[pPreFixTokens removeLastObject];
								
								pOp2 = [pPreFixTokens lastObject];
								[pOp2 setStrValue:[NSString stringWithFormat:@"%.5f",
												   [[pOp1 strValue] doubleValue] + 
												   [[pOp2 strValue]doubleValue]]];
								break;
							case kValueToken_Minus:
								pOp1 = [pPreFixTokens lastObject];
								[pPreFixTokens removeLastObject];
								
								pOp2 = [pPreFixTokens lastObject];
								[pOp2 setStrValue:[NSString stringWithFormat:@"%.5f",
												   [[pOp1 strValue] doubleValue] - 
												   [[pOp2 strValue] doubleValue]]];
								break;
						}
						[pStack removeLastObject];	
						if([pStack count] == 0)
							break;
						pLastToken = [pStack lastObject];
						iLastTokenPr = [self operatorPriority:[pLastToken iTokenType]];
					}
					[pStack addObject:cToken];
				}
			}
		}
		
		CToken *pLastToken = [pStack lastObject];

		while ([pStack count] > 0)
		{
			switch ([pLastToken iTokenType]) 
			{
				case kValueToken_Power:
					pOp1 = [pPreFixTokens lastObject];
					[pPreFixTokens removeLastObject];
					
					pOp2 = [pPreFixTokens lastObject];
					[pOp2 setStrValue:[NSString stringWithFormat:@"%.5f",
									   pow([[pOp1 strValue] doubleValue],[[pOp2	strValue]doubleValue])]];
					
					break;
				case kValueToken_Divide:
					pOp1 = [pPreFixTokens lastObject];
					[pPreFixTokens removeLastObject];
					
					pOp2 = [pPreFixTokens lastObject];
					[pOp2 setStrValue:[NSString stringWithFormat:@"%.5f",
									   [[pOp1 strValue] doubleValue] / 
									   [[pOp2 strValue]doubleValue]]];
					
					break;
				case kValueToken_Multiply:
					pOp1 = [pPreFixTokens lastObject];
					[pPreFixTokens removeLastObject];
					
					pOp2 = [pPreFixTokens lastObject];
					[pOp2 setStrValue:[NSString stringWithFormat:@"%.5f",
									   [[pOp1 strValue] doubleValue] * 
									   [[pOp2 strValue]doubleValue]]];
					break;
				case kValueToken_Plus:
					pOp1 = [pPreFixTokens lastObject];
					[pPreFixTokens removeLastObject];
					
					pOp2 = [pPreFixTokens lastObject];
					[pOp2 setStrValue:[NSString stringWithFormat:@"%.5f",
									   [[pOp1 strValue] doubleValue] + 
									   [[pOp2 strValue]doubleValue]]];
					break;
				case kValueToken_Minus:
					pOp1 = [pPreFixTokens lastObject];
					[pPreFixTokens removeLastObject];
					
					pOp2 = [pPreFixTokens lastObject];
					[pOp2 setStrValue:[NSString stringWithFormat:@"%.5f",
									   [[pOp1 strValue] doubleValue] - 
									   [[pOp2 strValue] doubleValue]]];
					break;
			}
			[pStack removeLastObject];	
			if([pStack count] == 0)
				break;
			pLastToken = [pStack lastObject];
		}
		
		fAnswer = [[[pPreFixTokens lastObject] strValue] doubleValue];

		NSLog(@"answer = %f",fAnswer);
		[pPreFixTokens removeAllObjects];
		[pPreFixTokens release];
		return TRUE;
	}
	return FALSE;
}

/********************************************************************************
 ///////////Algebraic Equation Solver////////////
 ********************************************************************************/
- (BOOL)evaluate:(NSString*) strProblem{
//	self.String = pTxtProblem.text;
	
	
    NSString *input = strProblem;
	NSLog(@"equation Question string is %@",input);
	int  chklenth=(int)[input length];
	//NSString*	input = [expInputTextField.text stringValue];
	NSMutableArray *characters = [[NSMutableArray alloc] init];
	BOOL bSqrt = FALSE;
//	int isqrtBracket = 0;
	
	if([input length] > 2 )
	{
		
		for (int i=0; i < [input length]; i++) {
			//NSString *ichar  = [NSString stringWithFormat:@"%c", [input characterAtIndex:i]];
			unichar ichar = [input characterAtIndex:i];
			if(ichar == 178)
			{
				[characters addObject:@"^"];
				[characters addObject:@"2"];
				chklenth++;
			}
			else if(ichar == 8730) // sqrt
			{
				if(bSqrt == FALSE)
					bSqrt = TRUE;
				[characters addObject:[NSString stringWithFormat:@"%c",ichar]];
			}
			else if(ichar == 42)
			{
				[characters addObject:[NSString stringWithFormat:@"%c",ichar]];
			}
			else if(ichar == 247) // divide
			{
				[characters addObject:[NSString stringWithFormat:@"/"]];
			}
			else
			{
				[characters addObject:[NSString stringWithFormat:@"%c",ichar]];
			}
		}
		NSString *stringX=@"X";
		NSString *stringXPow=@"^";
		NSString *stringPlus=@"+";
		NSString *stringMinus=@"-";
		NSString *stringMult=@"*";
		NSString *stringDiv=@"/";
		NSString *stringEqual=@"=";
		NSString *stringLeftB=@"(";
		NSString *stringRightB=@")";
		NSString *string0=@"0";
		NSString *string1=@"1";
		NSString *string2=@"2";
		NSString *string3=@"3";
		NSString *string4=@"4";
		NSString *string5=@"5";
		NSString *string6=@"6";
		NSString *string7=@"7";
		NSString *string8=@"8";
		NSString *string9=@"9";
		NSString * strAtPlusOneIndx;
		NSString * strAtMinusOneIndx;
		NSString * strAtMinusTwoIndx;
		NSString * strAtPlusTwoIndx;
		/****************************************************************
		 //main loop
		 ****************************************************************/
		for (int i=0; i < [characters count]; i++) {
			//if([input characterAtIndex:i]==2){//if([characters objectAtIndex:i]==2){//k=[[characters objectAtIndex:(i-1)]unsignedIntegerValue];
			//NSLog(@"a value is is %d",k);//NSString * letterchk=[input substringWithRange:NSMakeRange((chklenth-1),1)];//NSLog(@"input string is %@",letterchk);//remove the number from th field.
			NSString * strAtPresentIndx = [characters objectAtIndex:i];
			if(i<chklenth-1){
				strAtPlusOneIndx = [characters objectAtIndex:i+1];
				
				//NSLog(@"string +1 is %@",stringFromArray2);
			}
			
			
			if(i>0){
				strAtMinusOneIndx = [characters objectAtIndex:i-1];
				//	NSLog(@"string -1 is %@",stringFromArray3);
			}
			
			
			if(i>1){
				strAtMinusTwoIndx = [characters objectAtIndex:i-2];
				//	NSLog(@"string -2 is %@",stringFromArray4);
			}
			
			
			if(i<chklenth-2){
				strAtPlusTwoIndx = [characters objectAtIndex:i+2];
				//	NSLog(@"string +2 is %@",stringFromArray4);
			}
			/////////New bracket usage
			//int RightBraketVal = [stringRightB intValue];
			//NSLog(@"RightBraketVal  is %i",RightBraketVal);
			//NSInteger RightBraketVal=(int)[NSString stringWithFormat:@"%@",stringRightB];
			
			if([strAtPresentIndx isEqualToString:stringDiv])
			{	
				if([strAtPlusOneIndx isEqualToString:@"0"]) return FALSE;
				
				[pMultiplyValues addObject:[NSString stringWithFormat:@"%f",[strAtPlusOneIndx doubleValue]]];
				continue;
			}
			else if([strAtPresentIndx isEqualToString:stringMult])
			{
				if([strAtPlusOneIndx isEqualToString:@"0"]) return FALSE;

				[pMultiplyValues addObject:[NSString stringWithFormat:@"%f",1.0/[strAtPlusOneIndx doubleValue]]];
				continue;
			}
			
			if([stringLeftB isEqualToString:strAtPresentIndx])
			{
				NSLog(@" (is begining now");
				NSString *checkStr = [characters objectAtIndex:i];
				//int a1 = [checkStr intValue];
				//NSInteger a1=(int)[NSString stringWithFormat:@"%@",checkStr];
				//NSLog(@"CheckStr int value is %d",a1);
				while([checkStr compare: @")"])
				{
					/*************************************************************************************/
					//NSLog(@"reading x^2 at %d",i);
					
					if ([stringX isEqualToString:strAtPresentIndx] && [stringXPow isEqualToString:strAtPlusOneIndx] )
						//if ([[characters objectAtIndex:i] intValue]==[@"x" intValue]) 
					{
						//NSLog(@"here i is %d",i);
						//NSLog(@"coefficient of x is %d",[[characters objectAtIndex:i] intValue]);
						//NSLog(@"coefficient of x is %@",[characters objectAtIndex:i+1]);
						NSLog(@"coefficient of x^2 is %@",[characters objectAtIndex:i-1]);
						/////////
						///if(i==0){
						//NSLog(@"here 1 i is %d",i);
						//a=1;
						//	Coefa=Coefa+a; 
						//}
						
						if([stringLeftB isEqualToString:strAtMinusOneIndx] || [stringPlus isEqualToString:strAtMinusOneIndx])
						{
							Suba=1;
							SubCoefa=SubCoefa+Suba; 
						}
						else if([stringMinus isEqualToString:strAtMinusOneIndx])
						{
							Suba=1;
							SubCoefa=SubCoefa-Suba; 
						}
						else if ([stringPlus isEqualToString:strAtMinusTwoIndx])
						{
							Suba = [[characters objectAtIndex:i-1] intValue];
							SubCoefa=SubCoefa+Suba;
						}
						else if ([stringMinus isEqualToString:strAtMinusTwoIndx])
						{
							Suba = [[characters objectAtIndex:i-1] intValue];
							SubCoefa=SubCoefa-Suba;
						}
						else if ([stringLeftB isEqualToString:strAtMinusTwoIndx])
						{
							Suba = [[characters objectAtIndex:i-1] intValue];
							SubCoefa=SubCoefa+Suba;
						}
						
						
						Suba=0;
					}
					else if([stringX isEqualToString:strAtPresentIndx] )
					{
						
						if([stringLeftB isEqualToString:strAtMinusOneIndx] || [stringPlus isEqualToString:strAtMinusOneIndx])
						{
							Subb=1;
							SubCoefb=SubCoefb+Subb; 
							NSLog(@"coefficient of x is %d",Subb);
						}
						else if([stringMinus isEqualToString:strAtMinusOneIndx])
						{
							Subb=1;
							SubCoefb=SubCoefb-Subb; 
							NSLog(@"coefficient of x is %d",Subb);
						}
						else if ([stringPlus isEqualToString:strAtMinusTwoIndx])
						{
							Subb = [[characters objectAtIndex:i-1] intValue];
							SubCoefb=SubCoefb+Subb;
							NSLog(@"coefficient of x is %@",[characters objectAtIndex:i-1]);
						}
						else if ([stringMinus isEqualToString:strAtMinusTwoIndx])
						{
							Subb = [[characters objectAtIndex:i-1] intValue];
							SubCoefb=SubCoefb-Subb;
							NSLog(@"coefficient of x is %@",[characters objectAtIndex:i-1]);
						}
						else if ([stringLeftB isEqualToString:strAtMinusTwoIndx])
						{
							Subb = [[characters objectAtIndex:i-1] intValue];
							SubCoefb=SubCoefb+Subb;
							NSLog(@"coefficient of x is %@",[characters objectAtIndex:i-1]);
						}
						Subb=0;
					}
					else if([string0 isEqualToString:strAtPresentIndx] || [string1 isEqualToString:strAtPresentIndx]|| [string2 isEqualToString:strAtPresentIndx]||[string3 isEqualToString:strAtPresentIndx]||[string4 isEqualToString:strAtPresentIndx]||[string5 isEqualToString:strAtPresentIndx]||[string6 isEqualToString:strAtPresentIndx]|| [string7 isEqualToString:strAtPresentIndx]||[string8 isEqualToString:strAtPresentIndx]||[string9 isEqualToString:strAtPresentIndx])
					{
						NSLog(@"Reading constant at %i",i);
						if([stringLeftB isEqualToString:strAtMinusOneIndx] && ([stringMinus isEqualToString:strAtPlusOneIndx] ||[stringPlus isEqualToString:strAtPlusOneIndx]))
						{
							
							Subc = [[characters objectAtIndex:i] intValue];
							NSLog(@"reading constant Subc 1%.f",Subc);
							SubCoefc=SubCoefc+Subc; 
						}
						//else if(([stringMinus isEqualToString:strAtMinusOneIndx] || [stringPlus isEqualToString:strAtMinusOneIndx]) && ([stringMinus isEqualToString:strAtPlusOneIndx] ||[stringMinus isEqualToString:strAtPlusOneIndx]))
						else if([stringMinus isEqualToString:strAtMinusOneIndx] && [stringMinus isEqualToString:strAtPlusOneIndx])
						{
							Subc = [[characters objectAtIndex:i] intValue];
							NSLog(@"reading constant Subc 2a %.f",Subc);
							//if([stringMinus isEqualToString:strAtMinusOneIndx])
							//{
							//Subc = [[characters objectAtIndex:i] intValue];
							SubCoefc=SubCoefc-Subc;
							//}
							//if([stringPlus isEqualToString:strAtMinusOneIndx])
							//{
							//Subc = [[characters objectAtIndex:i] intValue];
							//	SubCoefc=SubCoefc+Subc;
							//}
						}
						else if([stringPlus isEqualToString:strAtMinusOneIndx] && [stringPlus isEqualToString:strAtPlusOneIndx])
						{
							Subc = [[characters objectAtIndex:i] intValue];
							SubCoefc=SubCoefc+Subc;
							NSLog(@"reading constant Subc 2b %.f",Subc);
						}
						else if([stringPlus isEqualToString:strAtMinusOneIndx] && [stringMinus isEqualToString:strAtPlusOneIndx])
						{
							Subc = [[characters objectAtIndex:i] intValue];
							SubCoefc=SubCoefc+Subc;
							NSLog(@"reading constant Subc 2c %.f",Subc);
						}
						else if([stringMinus isEqualToString:strAtMinusOneIndx] && [stringPlus isEqualToString:strAtPlusOneIndx])
						{
							Subc = [[characters objectAtIndex:i] intValue];
							SubCoefc=SubCoefc-Subc;
							NSLog(@"reading constant Subc 2d %f",Subc);
						}
						else if([stringRightB isEqualToString:strAtPlusOneIndx])
						{
							Subc = [[characters objectAtIndex:i] intValue];
							NSLog(@"reading Last Subc constant 3 %.f",Subc);
							if([stringMinus isEqualToString:strAtMinusOneIndx])
							{
								//Subc = [[characters objectAtIndex:i] intValue];
								SubCoefc=SubCoefc-Subc;
							}
							if([stringPlus isEqualToString:strAtMinusOneIndx])
							{
								//Subc = [[characters objectAtIndex:i] intValue];
								SubCoefc=SubCoefc+Subc;
							}
						}
						Subc=0;
						
					}
					Suba=0;
					Subb=0;
					Subc=0;	
					/////////while loop
					if(i==(int)[input length]-1){
						UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Invalid equation entered" message:@"Please enter correct equation"
																	   delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
						[alert show];
						[alert release];				
						return FALSE;
						
					}
					i++;
					checkStr = [characters objectAtIndex:i];
					strAtPresentIndx = [characters objectAtIndex:i];
					if(i<chklenth-1){
						strAtPlusOneIndx = [characters objectAtIndex:i+1];
						
						//NSLog(@"string +1 is %@",stringFromArray2);
					}
					
					
					if(i>0){
						strAtMinusOneIndx = [characters objectAtIndex:i-1];
						//	NSLog(@"string -1 is %@",stringFromArray3);
					}
					
					
					if(i>1){
						strAtMinusTwoIndx = [characters objectAtIndex:i-2];
						//	NSLog(@"string -2 is %@",stringFromArray4);
					}
					
					
					if(i<chklenth-2){
						strAtPlusTwoIndx = [characters objectAtIndex:i+2];
						//	NSLog(@"string +2 is %@",stringFromArray4);
					}
					
					//int a1=[checkStr intValue];
					//NSInteger a1=(int)[NSString stringWithFormat:@"%@",checkStr];
					//NSLog(@"CheckStr int value is %d",a1);
				}
				
				NSLog(@"SubCoefa %d",SubCoefa);
				NSLog(@"SubCoefb %d",SubCoefb);
				NSLog(@"SubCoefc %d",SubCoefc);
				NSLog(@") Closed now");
			}//end of while loop
			
			else
			{
				if ([stringX isEqualToString:strAtPresentIndx] && [stringXPow isEqualToString:strAtPlusOneIndx] )
					//if ([[characters objectAtIndex:i] intValue]==[@"x" intValue]) 
				{
					//NSLog(@"here i is %d",i);
					//NSLog(@"coefficient of x is %d",[[characters objectAtIndex:i] intValue]);
					//NSLog(@"coefficient of x is %@",[characters objectAtIndex:i+1]);
					//NSLog(@"coefficient of x^2 is %@",[characters objectAtIndex:i-1]);
					if(i==0){
						NSLog(@"here 1 i is %d",i);
						a=1;
						Coefa=Coefa+a; 
					}
					else if(i>1){
						NSLog(@"reading x^2 at %d",i);
						
						//NSLog(@"here2 i is %d",i);
						a = [[characters objectAtIndex:i-1] intValue];
						if([stringMinus isEqualToString:strAtMinusTwoIndx])
						{
							Coefa=Coefa-a; 
						}
						if([stringPlus isEqualToString:strAtMinusTwoIndx])
						{
							Coefa=Coefa+a; 
						}
						if([stringMult isEqualToString:strAtMinusTwoIndx])
						{
							Coefa=Coefa*a; 
						}
						//if([stringDiv isEqualToString:strAtMinusTwoIndx])
						//{
						//	Coefa=Coefa/a; 
						//}
						if([stringPlus isEqualToString:strAtMinusOneIndx] || [stringMinus isEqualToString:strAtMinusOneIndx])
						{
							a=1;
							if([stringPlus isEqualToString:strAtMinusOneIndx])
								Coefa=Coefa+a; 
							else if([stringMult isEqualToString:strAtMinusOneIndx])
							{
								Coefa=Coefa*a; 
							}
							else if([stringMinus isEqualToString:strAtMinusOneIndx])
							{
								Coefa=Coefa-a; 
							}	//Coefa=Coefa-a;
						}
					}
					else{
						//NSLog(@"here3 i is %d",i);
						a = [[characters objectAtIndex:i-1] intValue];
						Coefa=Coefa+a;
					}
					
					//Coefa=Coefa+a;
					a=0;
					
					
					//if([letterchk isEqual: @" "])
					//{ 
				}
				else if([stringX isEqualToString:strAtPresentIndx] )
				{
					NSLog(@"reading x at %d",i);
					//NSLog(@"i is %d",i);
					//NSLog(@"coefficient of x is %@",[characters objectAtIndex:i-1]);
					if(i==0){
						//	NSLog(@"here 1 i is %d",i);
						b=1;
						Coefb=Coefb+b; 
						
					}
					else if(i>1){
						// 2 - x = 10
						if(([stringMinus isEqualToString:strAtMinusOneIndx] && [stringEqual isEqualToString:strAtMinusTwoIndx]) || [stringEqual isEqualToString:strAtMinusOneIndx])
						{
							b=1;
							if([stringMinus isEqualToString:strAtMinusOneIndx] && [stringEqual isEqualToString:strAtMinusTwoIndx])
								Coefb=Coefb+b;
							else
								Coefb=Coefb-b;
							
						}
						else if(([string0 isEqualToString:strAtMinusOneIndx] || [string1 isEqualToString:strAtMinusOneIndx]|| [string2 isEqualToString:strAtMinusOneIndx]||[string3 isEqualToString:strAtMinusOneIndx]||[string4 isEqualToString:strAtMinusOneIndx]||[string5 isEqualToString:strAtMinusOneIndx]||[string6 isEqualToString:strAtMinusOneIndx]|| [string7 isEqualToString:strAtMinusOneIndx]||[string8 isEqualToString:strAtMinusOneIndx]||[string9 isEqualToString:strAtMinusOneIndx]) && [stringEqual isEqualToString:strAtMinusTwoIndx])
						{
							//
							b = [[characters objectAtIndex:i-1] intValue];
							Coefb=Coefb-b;
						}
						else
							b = [[characters objectAtIndex:i-1] intValue];
						if([stringMinus isEqualToString:strAtMinusTwoIndx])
						{
							Coefb=Coefb-b; 
						}
						if([stringPlus isEqualToString:strAtMinusTwoIndx])
						{
							Coefb=Coefb+b; 
						}
						if([stringMult isEqualToString:strAtMinusTwoIndx])
						{
							Coefb=Coefb*b; 
						}
						if([stringPlus isEqualToString:strAtMinusOneIndx] || [stringMinus isEqualToString:strAtMinusOneIndx])
						{
							b=1;
							if([stringPlus isEqualToString:strAtMinusOneIndx])
								Coefb=Coefb+b;  
							else
								Coefb=Coefb-b; 
						}
					}
					
					else{
						b = [[characters objectAtIndex:i-1] intValue];
						Coefb=Coefb+b;
					}
					//b = [[characters objectAtIndex:i-1] intValue];
					//Coefb=Coefb+b;
					b=0;
				}
				else if([string0 isEqualToString:strAtPresentIndx] || [string1 isEqualToString:strAtPresentIndx]|| [string2 isEqualToString:strAtPresentIndx]||[string3 isEqualToString:strAtPresentIndx]||[string4 isEqualToString:strAtPresentIndx]||[string5 isEqualToString:strAtPresentIndx]||[string6 isEqualToString:strAtPresentIndx]|| [string7 isEqualToString:strAtPresentIndx]||[string8 isEqualToString:strAtPresentIndx]||[string9 isEqualToString:strAtPresentIndx])
				{
					NSLog(@"reading constant at %d",i);
					NSString *strAtPlus;
					if(i<chklenth-1){
						strAtPlus = [characters objectAtIndex:i+1];
						
						//NSLog(@"string +1 is %@",stringFromArray2);
					}
					//NSString *checkdigit = [characters objectAtIndex:i+1];
					//if(i==0 && [strAtPlusOneIndx compare: @"X"])
					if(i==0 && [stringX isEqualToString:strAtPlus])
					{
						//c = [[characters objectAtIndex:i] intValue];
						//Coefc=Coefc+c;
						//NSLog(@"i=0 %d",i);
					}
					else if(i==0 && ([string0 isEqualToString:strAtPlusOneIndx] || [string1 isEqualToString:strAtPlusOneIndx]|| [string2 isEqualToString:strAtPlusOneIndx]||[string3 isEqualToString:strAtPlusOneIndx]||[string4 isEqualToString:strAtPlusOneIndx]||[string5 isEqualToString:strAtPlusOneIndx]||[string6 isEqualToString:strAtPlusOneIndx]|| [string7 isEqualToString:strAtPlusOneIndx]||[string8 isEqualToString:strAtPlusOneIndx]||[string9 isEqualToString:strAtPlusOneIndx])){
						NSInteger localVariable;
						c = [[characters objectAtIndex:i] intValue];
						localVariable = [[characters objectAtIndex:i+1] intValue];
						c=c*10;
						c=c+localVariable;
						Coefc=Coefc+c;
						//c = [[characters objectAtIndex:i] intValue];
						//Coefc=Coefc+c;
						//	NSLog(@"i=0 %d",i);
					}
					else if(i==0)
					{
						c = [[characters objectAtIndex:i] intValue];
						Coefc=Coefc+c;
					}
					if(i>0){
						if((i!=chklenth-1) && ([stringMinus isEqualToString:strAtMinusOneIndx] || [stringPlus isEqualToString:strAtMinusOneIndx] || [stringEqual isEqualToString:strAtMinusOneIndx]) && ([string0 isEqualToString:strAtPlusOneIndx] || [string1 isEqualToString:strAtPlusOneIndx]|| [string2 isEqualToString:strAtPlusOneIndx]||[string3 isEqualToString:strAtPlusOneIndx]||[string4 isEqualToString:strAtPlusOneIndx]||[string5 isEqualToString:strAtPlusOneIndx]||[string6 isEqualToString:strAtPlusOneIndx]|| [string7 isEqualToString:strAtPlusOneIndx]||[string8 isEqualToString:strAtPlusOneIndx]||[string9 isEqualToString:strAtPlusOneIndx]) )
						{
							NSInteger localVariable;
							c = [[characters objectAtIndex:i] intValue];
							localVariable = [[characters objectAtIndex:i+1] intValue];
							c=c*10;
							c=c+localVariable;
							//	NSLog(@"c for current node  constant %d",c);
							if([stringMinus isEqualToString:strAtMinusOneIndx] && [stringEqual isEqualToString:strAtMinusTwoIndx])///need amendments
							{
								
								NSLog(@"Coefc is %d",Coefc);
								Coefc=Coefc+c;
								NSLog(@"c of double figure is added %d",c);
								NSLog(@"figure is added 1a now Coefc is %d",Coefc);
								//}
								
							}
							else if([stringMinus isEqualToString:strAtMinusOneIndx])
							{
								
								NSLog(@"Coefc is %d",Coefc);
								Coefc=Coefc-c;
								NSLog(@"c of double figure is added %d",c);
								NSLog(@"figure is added 1b now Coefc is %d",Coefc);
								//}
								
							}
							else if(([stringPlus isEqualToString:strAtMinusOneIndx] || [stringEqual isEqualToString:strAtMinusOneIndx]) && (Coefc<0))
							{
								NSLog(@"Coefc is %d",Coefc);
								Coefc=Coefc-c;
								NSLog(@"c of double figure is added %d",c);
								NSLog(@"figure is added 2a now Coefc is %d",Coefc);
								
							}
							else if([stringPlus isEqualToString:strAtMinusOneIndx])
							{
								NSLog(@"Coefc is %d",Coefc);
								Coefc=Coefc+c;
								NSLog(@"c of double figure is added %d",c);
								NSLog(@"figure is added 2b now Coefc is %d",Coefc);
								
							}
							else
							{
								NSLog(@"Coefc is %d",Coefc);
								Coefc=Coefc-c;
								NSLog(@"c of double figure is subtracted %d",c);
								NSLog(@"figure is subtracted 3 now Coefc is %d",Coefc);
							}
							c=0;
							localVariable=0;
						}
						else if(([stringMinus isEqualToString:strAtPlusOneIndx] || [stringPlus isEqualToString:strAtPlusOneIndx] || [stringEqual isEqualToString:strAtPlusOneIndx] || [stringDiv isEqualToString:strAtPlusOneIndx] ) 
								&& ([stringMinus isEqualToString:strAtMinusOneIndx] || [stringPlus isEqualToString:strAtMinusOneIndx] || [stringEqual isEqualToString:strAtMinusOneIndx] || [stringDiv isEqualToString:strAtPlusOneIndx] ) )
						{
							//	NSLog(@"i is %d",i);
							//	NSLog(@"constants are %@",[characters objectAtIndex:i]);
							c = [[characters objectAtIndex:i] intValue];
							
							if([stringMinus isEqualToString:strAtPlusOneIndx] && [stringEqual isEqualToString:strAtMinusOneIndx])
							{
								Coefc=Coefc-c; 
								NSLog(@"1 is %d",Coefc);
							}
							else if([stringPlus isEqualToString:strAtPlusOneIndx] && [stringEqual isEqualToString:strAtMinusOneIndx])
							{
								Coefc=Coefc+c; 
								NSLog(@"2 is %d",Coefc);
							}
							else if([stringMinus isEqualToString:strAtMinusOneIndx])
							{
								Coefc=Coefc-c;
								NSLog(@"3 is %d",Coefc);
							}
							else if([stringPlus isEqualToString:strAtMinusOneIndx] && [stringEqual isEqualToString:strAtPlusOneIndx])
							{
								//if(Coefc<0)
								//	Coefc=Coefc+c;
								//else
								Coefc=Coefc+c; 
								NSLog(@"4 is %d",Coefc);
							}
							else if([stringPlus isEqualToString:strAtMinusOneIndx])
							{
								Coefc=Coefc+c; 
								NSLog(@"5 is %d",Coefc);
							}
							else if([stringEqual isEqualToString:strAtMinusOneIndx])
							{
								if(Coefc<0)
									Coefc=Coefc-c;
								else
									Coefc=Coefc+c; 
								NSLog(@"6 is %d",Coefc);
							}
							//Coefc=Coefc+c;
							c=0;
							//b = [[characters objectAtIndex:i-1] intValue];
							//b=b+b;
						}
						else if([stringEqual isEqualToString:strAtMinusOneIndx])
						{
							c = [[characters objectAtIndex:i] intValue];
							
							Coefc=Coefc-c;
						}
						////
						/*
						 if(i==chklenth-1){
						 if([stringEqual isEqualToString:strAtMinusOneIndx] || [stringMinus isEqualToString:strAtMinusOneIndx])
						 {
						 //		NSLog(@"constants are %@",[characters objectAtIndex:i]);
						 
						 c = [[characters objectAtIndex:i] intValue];
						 if([stringMinus isEqualToString:strAtMinusOneIndx])
						 Coefc=Coefc+c;
						 else
						 Coefc=Coefc-c;
						 NSLog(@"7 is %d",Coefc);
						 c=0;
						 }
						 
						 }
						 */
					}
				}
				else{
				}
				
			}
			
			
			
		}/////////end else
		////Multiple /////for looop
		for (int i=0; i < [input length]; i++) {
			//if([input characterAtIndex:i]==2){
			//if([characters objectAtIndex:i]==2){
			//k=[[characters objectAtIndex:(i-1)]unsignedIntegerValue];
			//NSLog(@"a value is is %d",k);
			//NSString * letterchk=[input substringWithRange:NSMakeRange((chklenth-1),1)];
			//NSLog(@"input string is %@",letterchk);
			//remove the number from th field.
			NSString * strAtPresentIndx = [characters objectAtIndex:i];
			if(i<chklenth-1){
				strAtPlusOneIndx = [characters objectAtIndex:i+1];
				
				//NSLog(@"string +1 is %@",stringFromArray2);
			}
			
			
			if(i>0){
				strAtMinusOneIndx = [characters objectAtIndex:i-1];
				//	NSLog(@"string -1 is %@",stringFromArray3);
			}
			
			
			if(i>1){
				strAtMinusTwoIndx = [characters objectAtIndex:i-2];
				//	NSLog(@"string -2 is %@",stringFromArray4);
			}
			
			
			if(i<chklenth-2){
				strAtPlusTwoIndx = [characters objectAtIndex:i+2];
				//	NSLog(@"string +2 is %@",stringFromArray4);
			}
			
			if([stringLeftB isEqualToString:strAtPlusOneIndx])
			{
				if([stringMinus isEqualToString:strAtPresentIndx])
				{
					SubCoefa=-SubCoefa;
					SubCoefb=-SubCoefb;
					SubCoefc=-SubCoefc;
					
				}
				else if([string0 isEqualToString:strAtPresentIndx] || [string1 isEqualToString:strAtPresentIndx]|| [string2 isEqualToString:strAtPresentIndx]||[string3 isEqualToString:strAtPresentIndx]||[string4 isEqualToString:strAtPresentIndx]||[string5 isEqualToString:strAtPresentIndx]||[string6 isEqualToString:strAtPresentIndx]|| [string7 isEqualToString:strAtPresentIndx]||[string8 isEqualToString:strAtPresentIndx]||[string9 isEqualToString:strAtPresentIndx])
				{
					int digit0 = [[characters objectAtIndex:i] intValue];
					//NSString *digit0 = [characters objectAtIndex:i];
					
					if([stringMinus isEqualToString:strAtMinusOneIndx])
					{
						//Coefa=Coefa-digit0;
						//Coefb=Coefb-digit0;
						Coefc=Coefc+digit0;
						
						SubCoefa=-digit0*SubCoefa;
						SubCoefb=-digit0*SubCoefb;
						SubCoefc=-digit0*SubCoefc;
					}
					else{
						//Coefa=Coefa+digit0;
						//Coefb=Coefb+digit0;
						Coefc=Coefc-digit0;
						
						SubCoefa=digit0*SubCoefa;
						SubCoefb=digit0*SubCoefb;
						SubCoefc=digit0*SubCoefc;
					}
					
				}
				
			}
		}/// End of Multiple for loop
		NSLog(@"After multiply SubCoefa %d",SubCoefa);
		NSLog(@"After multiply SubCoefb %d",SubCoefb);
		NSLog(@"After multiply SubCoefc %d",SubCoefc);
		Coefa=Coefa+SubCoefa;
		Coefb=Coefb+SubCoefb;
		Coefc=Coefc+SubCoefc;
		
//		if([pMultiplyValues count] > 0)
//		{
//			for (int mul=0; mul<[pMultiplyValues count]; mul++)
//			{
//				float fVal = [[pMultiplyValues objectAtIndex:mul] floatValue];
//				if(fVal != 0)
//				{
//					Coefa *= fVal;
//					Coefb *= fVal;
//					Coefc *= fVal;
//				}
//			}
//		}
		//k = [[back objectAtIndex:0]unsignedIntegerValue];
		SubCoefa=0;
		SubCoefb=0;
		SubCoefc=0;
		
	}
	
	[characters removeAllObjects];
	[characters release];
	return bSqrt;
//	else{
//		pLabelFirst.text = [NSString stringWithFormat:@"Invalid input entered"];
//	}
	
	//NSLog(@"input string is %@",input);
	//NSLog(@"Array length is %d",[input length]);
	//	NSLog(@"Array of string is %@",characters);
	
	//expInputTextField.text=nil;
	//ResultlblX1.text = [NSString stringWithFormat:@"%f", x1];
}

-(BOOL)solvingEquation:(NSString*)strInput
{
	NSString *strIp = [strInput retain];
	//a = [ScndDegree_TxtFld.text intValue];
	//b = [FrstDegree_TxtFld.text intValue];
	//c = [ConstVal_TxtFld.text intValue];
	if([strInput length] < 2)
		return FALSE;
	
	
	a=0;
	Coefa=0;
	b=0;
	Coefb=0;
	c=0;
	Coefc=0;
	x1=0;
	x2=0;
	
	[pMultiplyValues removeAllObjects];
	
	
	BOOL bSqrt = [self evaluate:strInput];
	a=Coefa;
	b=Coefb;
	c=Coefc;
	NSLog(@"%f,%f,%f",Coefa, Coefb, Coefc);
	if(a!=0)
	{
		int powerofb = pow(b,2);
		float partTerm= (float)(powerofb -4*a*c);
		//if()
		if(partTerm<0){
			float denum=(float)(2*a);
			strEquationSolution = [NSString stringWithFormat:@"%@ X2 ~ (%d +sqrt(%.1f ))/%.1f",strIp, -b,partTerm,denum];
			strEquationSolution1 = [NSString stringWithFormat:@"%@ X1 ~ (%d -sqrt(%.1f ))/%.1f",strIp, -b,partTerm,denum];
			NSLog(@"a is %f",a);
			NSLog(@"b is %f",b);
			NSLog(@"c is %f",c);
			//	NSLog(@"b^2 is %i",powerofb);
			//	NSLog(@"part term is %.2f",partTerm);
			//NSLog(@"common term is %i",comonTerm);
			//	NSLog(@"X1 is %i",x1);
		}
		else{
			float comonTerm=(float)sqrt(powerofb -4*a*c);
			x1 =(float)((-b)+comonTerm)/(2*(a));
			x2 =(float)((-b)-comonTerm)/(2*(a));
			NSLog(@"a is %f",a);
			NSLog(@"b is %f",b);
			NSLog(@"c is %f",c);
			//	NSLog(@"b^2 is %i",powerofb);
			//	NSLog(@"part term is %.2f",partTerm);
			////	NSLog(@"common term is %i",comonTerm);
			NSLog(@"X1 is %f",x1);
			NSLog(@"X2 is %f",x2);			
			
			strEquationSolution = [NSString stringWithFormat:@"%@ X2 ~ %.4f",strIp, x1];
			strEquationSolution1 = [NSString stringWithFormat:@"%@ X1 ~ %.4f",strIp, x2];
		}
	}
	else if(b!=0) 
	{
		NSLog(@"a is %f",a);
		NSLog(@"b is %f",b);
		NSLog(@"c is %f",c);
		x1=-(float)c/b;
		
		if(bSqrt)
			x1 = pow(x1, 2.0);
		
		for (int mul=0; mul<[pMultiplyValues count]; mul++) 
		{
			float fVal = [[pMultiplyValues objectAtIndex:mul] floatValue];
			if(fVal != 0)
				x1 *= fVal;
		}
		
		NSLog(@"X1 is %f",x1);
		strEquationSolution = [NSString stringWithFormat:@"%@, X1 ~ %.4f",strIp, x1];
		strEquationSolution1 = [NSString stringWithFormat:@""];
	}
	else
		return FALSE;
	//ResultlblX2.text = [NSString stringWithFormat:@"%f", x2];
	//NSLog(@"a is %i",a);
	//NSLog(@"b is %i",b);
	//NSLog(@"c is %i",c);
	
	a=0;
	Coefa=0;
	b=0;
	Coefb=0;
	c=0;
	Coefc=0;
	x1=0;
	x2=0;
	
	return TRUE;
}

- (BOOL) parseAndSolvePolynomial:(NSString*) strInputPoly
{
	if(strInputPoly == nil)
		return FALSE;
	
	blogFunc = FALSE;
	bEquation = FALSE;
	[pTokenizer removeAllObjects];
	[parenthesizedStack removeAllObjects];
	
	BOOL bIsPolynomial = [self validatePolynomial:strInputPoly];
	BOOL bTokenizerBuild = FALSE;

	if(blogFunc)
		return FALSE;
	
	if(!bIsPolynomial)
	{
		// 1. parse the polynomial and insert tokens in the array....
		bTokenizerBuild = [self buildTokensFromInput:strInputPoly];

		// Tokens are generated and are stored in form of In-Fix notation
		if(bTokenizerBuild == FALSE)
			return FALSE;

		return [self solvePolynomial];
	}
	else
	{
		if(bEquation == FALSE)
		{
			// the equation contains either x or = but not both
			return FALSE;
		}

		return [self solvingEquation:strInputPoly];
		// if the equation is a polynomial,
		// solve and calculate X
	}
	return FALSE;
}

#pragma mark Function handling

- (double) getCurrentValue:(CToken*)pToken
{
	if([CToken isFunction:pToken])
		return [self handleFunction];
	
	if([CToken isDigit:pToken])
	{
		iCurrentIdx++;
		return [[pToken strValue] doubleValue];
	}
	
	if([pToken iTokenType] == kValueToken_Pi)
	{
		iCurrentIdx++;
		return M_PI;
	}
	
	// handle bracket value here
	if([pToken iTokenType] == kValueToken_LeftParenthesis)
	{
		if([self handleParenthesizedPortion] == TRUE)
		{
			double value = [(NSString*)[parenthesizedStack objectAtIndex:[parenthesizedStack count]-1] doubleValue];
			[parenthesizedStack removeLastObject];
			return value;
		}
	}	
	return POLYNOMIAL_NAN;
}

- (double) handleFunction
{
	CToken *pToken = [pTokenizer objectAtIndex:iCurrentIdx++];
	
	double fRunningAnswer = 0.0;
	
	switch (pToken.iTokenType)
	{
		case kValueToken_Sine:
			fRunningAnswer = [self calculateSine];
			break;
			
		case kValueToken_Cosine:
			fRunningAnswer = [self calculateCosine];
			break;
			
		case kValueToken_Tangent:
			fRunningAnswer = [self calculateTangent];
			break;
			
		case kValueToken_Limit:
			fRunningAnswer = [self calculateLimit];
			break;
			
		case kValueToken_Log:
			fRunningAnswer = [self calculateLog];
			break;
			
		case kValueToken_Ln:
			fRunningAnswer = [self calculateLn];
			break;
			
		case kValueToken_Exponent:
			iCurrentIdx+=1;//skip ^x and handle (
			fRunningAnswer = [self calculateExponent];
			break;
			
		case kValueToken_SqareRoot:
			fRunningAnswer = [self calculateSqareRoot];
			break;
	}	
	return fRunningAnswer;
}

- (double) calculateSine
{
	double fTempVal = [self	getCurrentValue:[pTokenizer objectAtIndex:iCurrentIdx]];
	
	if(fTempVal == POLYNOMIAL_NAN)
		return fTempVal;
	
	if (bRadian)
		return sin(fTempVal);
	else
		return sin((fTempVal * M_PI) / 180.0);
}

- (double) calculateCosine
{	
	double fTempVal = [self	getCurrentValue:[pTokenizer objectAtIndex:iCurrentIdx]];
	if(fTempVal == POLYNOMIAL_NAN)
		return fTempVal;

	if (bRadian)
		return cos(fTempVal);
	else
		return cos((fTempVal * M_PI) / 180.0);
}

- (double) calculateTangent
{
	double fTempVal = [self	getCurrentValue:[pTokenizer objectAtIndex:iCurrentIdx]];
	if(fTempVal == POLYNOMIAL_NAN)
		return fTempVal;

	if (bRadian)
		return tan(fTempVal);
	else
		return tan((fTempVal * M_PI) / 180.0);
}

- (double) calculateLog
{
	double fTempVal = [self	getCurrentValue:[pTokenizer objectAtIndex:iCurrentIdx]];	
	if(fTempVal == POLYNOMIAL_NAN)
		return fTempVal;

	return log10(fTempVal);
}

- (double) calculateLn
{
	double fTempVal = [self	getCurrentValue:[pTokenizer objectAtIndex:iCurrentIdx]];
	if(fTempVal == POLYNOMIAL_NAN)
		return fTempVal;

	return log(fTempVal);
}

- (double) calculateExponent
{
	double fTempVal = [self	getCurrentValue:[pTokenizer objectAtIndex:iCurrentIdx]];
	if(fTempVal == POLYNOMIAL_NAN)
		return fTempVal;
	return exp(fTempVal);
}


- (double) calculateSqareRoot
{
	double fTempVal = [self	getCurrentValue:[pTokenizer objectAtIndex:iCurrentIdx]];
	if(fTempVal == POLYNOMIAL_NAN)
		return fTempVal;

	return sqrt(fTempVal);
}

#pragma mark Parenthesis handling between left bracket and right bracket
- (BOOL) handleParenthesizedPortion
{
	// start from left parenthesis and handle complete equation until right parenthesis
	// calculate value and put it in
	int iStartingIndex = iCurrentIdx++;
	CToken *pToken = [pTokenizer objectAtIndex:iStartingIndex];
	
	NSMutableArray *pArrayOfNumbers = [[NSMutableArray alloc] init];
	
	int		iOperatorFound = kValueToken_None;
	
	while (iCurrentIdx < [pTokenizer count] && [pToken iTokenType] != kValueToken_RightParenthesis) 
	{
		pToken = [pTokenizer objectAtIndex:iCurrentIdx];
		
		if([CToken isOperator:pToken] || [pToken iTokenType] == kValueToken_Square || [pToken iTokenType] == kValueToken_Complement)
		{
			iCurrentIdx++;
			if (pToken.iTokenType == kValueToken_Square && [pArrayOfNumbers count] > 0) 
			{
				double operand1 = [(NSString*)[pArrayOfNumbers objectAtIndex:[pArrayOfNumbers count] - 1] doubleValue];
				operand1 = pow(operand1, 2);
				NSString *pOper1 = [[NSString alloc] initWithFormat:@"%.5f",operand1];
				[pArrayOfNumbers removeLastObject];
				[pArrayOfNumbers addObject:pOper1];
				[pOper1 release];
				continue;
			}
			
			if(pToken.iTokenType != kValueToken_Square || pToken.iTokenType != kValueToken_Complement)
			{
				if ([pArrayOfNumbers count] < 2) {
					iOperatorFound = pToken.iTokenType;
					continue;
				}
				double operand1 = [(NSString*)[pArrayOfNumbers objectAtIndex:[pArrayOfNumbers count] - 2] doubleValue];
				double operand2 = [(NSString*)[pArrayOfNumbers objectAtIndex:[pArrayOfNumbers count] - 1] doubleValue];
				
				if(iOperatorFound == kValueToken_Plus)
					operand1 += operand2;
				else if(iOperatorFound == kValueToken_Minus)
					operand1 -= operand2;
				else if(iOperatorFound == kValueToken_Multiply)
					operand1 *= operand2;
				else if(iOperatorFound == kValueToken_Divide)
				{
					if(operand2 == 0)
					{
						[pArrayOfNumbers release];
						return FALSE;
					}
					operand1 /= operand2;
				}
				else if(iOperatorFound == kValueToken_Power)
				{
					operand1 = pow(operand1, operand2);
				}
				else if(iOperatorFound == kValueToken_Square)
				{
					operand2 = pow(operand2, 2);
					NSString *pOper2 = [[NSString alloc] initWithFormat:@"%.5f",operand2];
					[pArrayOfNumbers removeLastObject];
					[pArrayOfNumbers addObject:pOper2];
					[pOper2 release];
					continue;
				}
				NSString *pOper1 = [[NSString alloc] initWithFormat:@"%.5f",operand1];
				[pArrayOfNumbers removeLastObject];
				[pArrayOfNumbers removeLastObject];
				[pArrayOfNumbers addObject:pOper1];
				[pOper1 release];
				
				iOperatorFound = pToken.iTokenType;
				continue;
			}
			
			iOperatorFound = kValueToken_None;
			continue;
		}
		else if([CToken isFunction:pToken])
		{
			double fAnswer1 = [self handleFunction];
			if(fAnswer1 == POLYNOMIAL_NAN)
				return FALSE;
			NSString *pAnswer = [[NSString alloc] initWithFormat:@"%.5f",fAnswer1];
			[pArrayOfNumbers addObject:pAnswer];
			[pAnswer release];
		}
		else if([CToken isDigit:pToken] || [pToken iTokenType] == kValueToken_Pi)
		{
			iCurrentIdx++;
			NSString *pAnswer = nil;
			pAnswer = [[NSString alloc] initWithFormat:@"%.5f",[[pToken strValue] floatValue]];
			
			[pArrayOfNumbers addObject:pAnswer];
			[pAnswer release];
		}
		else if([pToken iTokenType] == kValueToken_LeftParenthesis)
		{
			if([self handleParenthesizedPortion] == FALSE)
			{
				[pArrayOfNumbers release];
				return FALSE;
			}
			else
			{
				NSString* fCurrentAnswer = [parenthesizedStack objectAtIndex:[parenthesizedStack count]-1];
				NSString *pAnswer = [[NSString alloc] initWithFormat:@"%.5f",[fCurrentAnswer floatValue]];
				[pArrayOfNumbers addObject:pAnswer];
				[pAnswer release];
				[parenthesizedStack removeLastObject];
			}
			
		}
		else if([pToken iTokenType] == kValueToken_RightParenthesis)
		{
			iCurrentIdx++;
		}
	}
	
	if(iOperatorFound != kValueToken_None)
	{
		if([pArrayOfNumbers count] == 1)
		{
			double operand1 = [(NSString*)[pArrayOfNumbers objectAtIndex:0] doubleValue];
			if(iOperatorFound == kValueToken_Square)
			{
				operand1 = pow(operand1, 2);
				NSString *pOper2 = [[NSString alloc] initWithFormat:@"%.5f",operand1];
				[pArrayOfNumbers removeLastObject];
				[pArrayOfNumbers addObject:pOper2];
				[pOper2 release];
			}
			else if(iOperatorFound == kValueToken_Minus)
			{
				operand1 = -1 * operand1;
				NSString *pOper2 = [[NSString alloc] initWithFormat:@"%.5f",operand1];
				[pArrayOfNumbers removeLastObject];
				[pArrayOfNumbers addObject:pOper2];
				[pOper2 release];
			}	
			
			iOperatorFound = kValueToken_None;
		}
		if([pArrayOfNumbers count] == 2)
		{
			double operand1 = [(NSString*)[pArrayOfNumbers objectAtIndex:0] doubleValue];
			double operand2 = [(NSString*)[pArrayOfNumbers objectAtIndex:1] doubleValue];
			if(iOperatorFound == kValueToken_Plus)
				operand1 += operand2;
			else if(iOperatorFound == kValueToken_Minus)
				operand1 -= operand2;
			else if(iOperatorFound == kValueToken_Multiply)
				operand1 *= operand2;
			else if(iOperatorFound == kValueToken_Divide)
			{
				if(operand2 == 0)
				{
					[pArrayOfNumbers release];
					return FALSE;
				}
				operand1 /= operand2;
			}
			else if(iOperatorFound == kValueToken_Power)
			{
				operand1 = pow(operand1, operand2);
			}
			NSString *pOper1 = [[NSString alloc] initWithFormat:@"%.5f",operand1];
			[pArrayOfNumbers removeLastObject];
			[pArrayOfNumbers removeLastObject];
			[pArrayOfNumbers addObject:pOper1];
			[pOper1 release];
			iOperatorFound = kValueToken_None;
		}
	}
	
	if([pArrayOfNumbers count] == 0)
		return FALSE;
	
	NSString *pAnswer = [[NSString alloc] initWithFormat:@"%@",[pArrayOfNumbers objectAtIndex:0]];
	[parenthesizedStack addObject:pAnswer];
	[pArrayOfNumbers release];
	[pAnswer release];
	
	return TRUE;
}

@end
