//
//  CToken.m
//  calculator
//
//  Created by Gobbledygook on 3/27/10.
//  Copyright 2010 _My_Company_Name_. All rights reserved.
//

#import "CToken.h"


@implementation CToken

@synthesize iTokenType;
@synthesize fPower;
@synthesize fCoefficient;
@synthesize strValue;

-(id) init
{
	if(self = [super init])
	{
		iTokenType = kValueToken_None;
		fPower = 1.0;
		fCoefficient = 1.0;
		strValue = nil;
	}
	return self;
}

-(void) dealloc
{
	if(strValue)
	{
		[strValue release];
		strValue = nil;
	}
	
	[super dealloc];
}


+ (BOOL) isDigit:(CToken*) pToken
{
	if (pToken.iTokenType == kValueToken_Digit)
		return TRUE;
	
	return FALSE;
}

+ (BOOL) isAlpha:(CToken*) pToken
{
	if (pToken.iTokenType == kValueToken_Alpha)
		return TRUE;
	
	return FALSE;
}

+ (BOOL) isFunction:(CToken*) pToken
{
	if (pToken.iTokenType == kValueToken_SqareRoot)
		return TRUE;
	else if (pToken.iTokenType == kValueToken_Sine)
		return TRUE;
	else if (pToken.iTokenType == kValueToken_Cosine)
		return TRUE;
	else if (pToken.iTokenType == kValueToken_Tangent)
		return TRUE;
	else if (pToken.iTokenType == kValueToken_Limit)
		return TRUE;
	else if (pToken.iTokenType == kValueToken_Log)
		return TRUE;
	else if (pToken.iTokenType == kValueToken_Ln)
		return TRUE;
	else if (pToken.iTokenType == kValueToken_Exponent)
		return TRUE;
	else if (pToken.iTokenType == kValueToken_Integral)
		return TRUE;
	else if (pToken.iTokenType == kValueToken_Summation)
		return TRUE;
	
	return FALSE;
}

+ (BOOL) isOperator:(CToken*) pToken
{
	if(pToken.iTokenType == kValueToken_Plus)
		return TRUE;
	else if(pToken.iTokenType == kValueToken_Minus)
		return TRUE;
	else if(pToken.iTokenType == kValueToken_Multiply)
		return TRUE;
	else if(pToken.iTokenType == kValueToken_Divide)
		return TRUE;
	else if(pToken.iTokenType == kValueToken_Power)
		return TRUE;
	else if(pToken.iTokenType == kValueToken_Equal)
		return TRUE;
	
	return FALSE;
}

+ (CToken *) tokenFromChar:(unichar) ch
{
	CToken *pNewToken = [[CToken alloc] init];
	pNewToken.strValue = [[NSString alloc] initWithFormat:@"%c",ch];
	
	if ([pNewToken.strValue isEqualToString:Symbol_Decimal]) 
		pNewToken.iTokenType = kValueToken_Decimal;
	else if([pNewToken.strValue isEqualToString:Symbol_Complement])
		pNewToken.iTokenType = kValueToken_Complement;
	else if([pNewToken.strValue isEqualToString:Symbol_Divide])
		pNewToken.iTokenType = kValueToken_Divide;
	else if([pNewToken.strValue isEqualToString:Symbol_Equal])
		pNewToken.iTokenType = kValueToken_Equal;
	else if([pNewToken.strValue isEqualToString:Symbol_Exponent])
		pNewToken.iTokenType = kValueToken_Exponent;
	else if([pNewToken.strValue isEqualToString:Symbol_Integral])
		pNewToken.iTokenType = kValueToken_Integral;
	else if([pNewToken.strValue isEqualToString:Symbol_Inverse])
		pNewToken.iTokenType = kValueToken_Inverse;
	else if([pNewToken.strValue isEqualToString:Symbol_LeftBracket])
		pNewToken.iTokenType = kValueToken_LeftParenthesis;
	else if([pNewToken.strValue isEqualToString:Symbol_Minus])
		pNewToken.iTokenType = kValueToken_Minus;
	else if([pNewToken.strValue isEqualToString:Symbol_Multiply])
		pNewToken.iTokenType = kValueToken_Multiply;
	else if([pNewToken.strValue isEqualToString:Symbol_Pi])
		pNewToken.iTokenType = kValueToken_Pi;
	else if([pNewToken.strValue isEqualToString:Symbol_Plus])
		pNewToken.iTokenType = kValueToken_Plus;
	else if([pNewToken.strValue isEqualToString:Symbol_Power])
		pNewToken.iTokenType = kValueToken_Power;
	else if([pNewToken.strValue isEqualToString:Symbol_RightBracket])
		pNewToken.iTokenType = kValueToken_RightParenthesis;
	else if([pNewToken.strValue isEqualToString:Symbol_SqRoot])
		pNewToken.iTokenType = kValueToken_SqareRoot;
	else if([pNewToken.strValue isEqualToString:Symbol_Summation])
		pNewToken.iTokenType = kValueToken_Summation;
	else
	{
		[pNewToken release];
		pNewToken = nil;
	}
	
	return pNewToken;
}

@end
