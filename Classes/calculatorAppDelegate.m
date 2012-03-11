//
//  calculatorAppDelegate.m
//  calculator
//
//  Created by Gobbledygook on 2/21/10.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import "calculatorAppDelegate.h"


@implementation calculatorAppDelegate

@synthesize window;
@synthesize tabBarController;
@synthesize pSupportedFunctions;

- (void)applicationDidFinishLaunching:(UIApplication *)application 
{
	pSupportedFunctions = [[NSMutableArray alloc] init];
	
	NSString *pFunction = [[NSString alloc] initWithString:@"sin"];
	[pSupportedFunctions addObject:pFunction];
	[pFunction release];
	
	pFunction = [[NSString alloc] initWithString:@"cos"];
	[pSupportedFunctions addObject:pFunction];
	[pFunction release];
	pFunction = [[NSString alloc] initWithString:@"tan"];
	[pSupportedFunctions addObject:pFunction];
	[pFunction release];
	pFunction = [[NSString alloc] initWithString:@"e^x"];
	[pSupportedFunctions addObject:pFunction];
	[pFunction release];
	pFunction = [[NSString alloc] initWithString:@"log"];
	[pSupportedFunctions addObject:pFunction];
	[pFunction release];
	pFunction = [[NSString alloc] initWithString:@"ln"];
	[pSupportedFunctions addObject:pFunction];
	[pFunction release];
	
	
	[[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackTranslucent];
    
    // Add the tab bar controller's current view as a subview of the window
    [window addSubview:tabBarController.view];
}


/*
// Optional UITabBarControllerDelegate method
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController {
}
*/

/*
// Optional UITabBarControllerDelegate method
- (void)tabBarController:(UITabBarController *)tabBarController didEndCustomizingViewControllers:(NSArray *)viewControllers changed:(BOOL)changed {
}
*/


- (void)dealloc {
	
	[pSupportedFunctions removeAllObjects];
	[pSupportedFunctions release];
	pSupportedFunctions = nil;
	
    [tabBarController release];
    [window release];
    [super dealloc];
}

@end

