//
//  ViewController.h
//  BlocBrowser
//
//  Created by Catherine Washburn on 6/1/16.
//  Copyright © 2016 Catherine Washburn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController

/**
 Replaces the web view with a fresh one, erasing all history. Also updates the URL field and toolbar buttons appropriately.
 */
- (void) resetWebView;

@end

