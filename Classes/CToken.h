//
//  CToken.h
//  calculator
//
//  Created by Gobbledygook on 3/27/10.
//  Copyright 2010 _My_Company_Name_. All rights reserved.
//

#import <Foundation/Foundation.h>



#define Symbol_Decimal		@"."

#define Symbol_Plus			@"+"
#define Symbol_Minus		@"-"
#define Symbol_Divide		@"÷"
#define Symbol_Multiply		@"*"
#define Symbol_Equal		@"="

#define Symbol_Square		@"²"
#define Symbol_SqRoot		@"√"

#define Symbol_Pi			@"π"
#define Symbol_Integral		@"∫"
#define Symbol_Summation	@"∑"

#define Symbol_LeftBracket	@"("
#define Symbol_RightBracket	@")"
#define Symbol_Sine			@"sin"
#define Symbol_Cosine		@"cos"
#define Symbol_Tangent		@"tan"
#define Symbol_Limit		@"lim"
#define Symbol_Log			@"log"
#define Symbol_Ln			@"ln"
#define Symbol_Exponent		@"e"
#define Symbol_Power		@"^"
#define Symbol_Complement	@"'"
#define Symbol_Inverse		@"^-1"

enum _ValueToken_
{
	kValueToken_None = 0,
	kValueToken_Digit,
	kValueToken_Alpha,
	kValueToken_Decimal,
	kValueToken_Plus,
	kValueToken_Minus,
	kValueToken_Divide,
	kValueToken_Multiply,
	kValueToken_Equal,
	kValueToken_Square,
	kValueToken_SqareRoot,
	kValueToken_Power,
	kValueToken_Pi,
	kValueToken_Summation,
	//brackets
	kValueToken_LeftParenthesis,
	kValueToken_RightParenthesis,
	//trignometry
	kValueToken_Sine,
	kValueToken_Cosine,
	kValueToken_Tangent,
	//other operations
	kValueToken_Integral,
	kValueToken_Inverse,
	kValueToken_Complement,
	kValueToken_Limit,
	//logarithmic
	kValueToken_Log,
	kValueToken_Ln,
	kValueToken_Exponent
} ValueToken;


@interface CToken : NSObject
{
	NSInteger	iTokenType;
	float fPower;
	float fCoefficient;// if digit
	NSString *strValue;// if alpha
}

@property (nonatomic) NSInteger iTokenType;
@property (nonatomic) float fPower;
@property (nonatomic) float fCoefficient;
@property (nonatomic,retain) NSString *strValue;

+ (BOOL) isDigit:(CToken*) pToken;
+ (BOOL) isAlpha:(CToken*) pToken;
+ (BOOL) isFunction:(CToken*) pToken;
+ (BOOL) isOperator:(CToken*) pToken;
+ (CToken *) tokenFromChar:(unichar) ch;


@end
