//
//  calculatorAppDelegate.h
//  calculator
//
//  Created by Gobbledygook on 2/21/10.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface calculatorAppDelegate : NSObject <UIApplicationDelegate, UITabBarControllerDelegate> {
    UIWindow *window;
    UITabBarController *tabBarController;
	
	NSMutableArray *pSupportedFunctions;
}

@property (nonatomic, retain) NSMutableArray *pSupportedFunctions;
@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UITabBarController *tabBarController;

@end
