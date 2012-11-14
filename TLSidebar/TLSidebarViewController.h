//
//  TLSidebarViewController.h
//  SASlideMenu
//
//  Created by Stefano Antonelli on 7/29/12.
//  Copyright (c) 2012 Stefano Antonelli. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kVisiblePortion 40
#define kMenuTableSize 280

@interface TLSidebarViewController : UIViewController

@property ( readonly)UIPanGestureRecognizer *panGesture;
@property ( readonly)UITapGestureRecognizer *tapGesture;

@property ( nonatomic) float slideInternal;

- ( BOOL ) sidebarHidden;

- ( void ) setSidebarHidden:(BOOL)hidden
				   animated:(BOOL)animated;

@end
