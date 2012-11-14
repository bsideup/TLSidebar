//
//  TLSidebarViewController.m
//  SASlideMenu
//
//  Created by Stefano Antonelli on 7/29/12.
//  Copyright (c) 2012 Stefano Antonelli. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

#import "TLSidebarViewController.h"
#import <QuartzCore/QuartzCore.h>


@interface TLSidebarViewController ()
{
	UIViewController *content;
	UIViewController *menu;
}

@end

@implementation TLSidebarViewController

@synthesize panGesture = _panGesture;
@synthesize tapGesture = _tapGesture;
@synthesize slideInternal = _slideInterval;

- ( id ) initWithCoder:(NSCoder *)aDecoder
{
	if ( self == [super initWithCoder:aDecoder] )
	{
		_slideInterval = 0.3;
	}

	return self;
}

- ( id ) initWithNibName:(NSString *)nibNameOrNil
				  bundle:(NSBundle *)nibBundleOrNil
{
	if ( self == [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil] )
	{
		_slideInterval = 0.3;
	}

	return self;
}

#pragma mark -
#pragma mark - TLSidebarViewController

- ( void ) panItem:(UIPanGestureRecognizer *)gesture
{
	UIView *movingView = content.view;
	UIView *panningView = gesture.view;
	CGPoint translation = [gesture translationInView:panningView];

	if ( ( movingView.frame.origin.x + translation.x < 0 ) || ( movingView.frame.origin.x + translation.x > kMenuTableSize ) )
	{
		translation.x = 0.0;
	}

	[movingView setCenter:CGPointMake( [movingView center].x + translation.x, [movingView center].y )];

	[gesture setTranslation:CGPointZero inView:[panningView superview]];

	if ( [gesture state] == UIGestureRecognizerStateEnded )
	{
		[self setSidebarHidden:movingView.center.x <= content.view.bounds.size.width animated:YES];
	}
}


- ( void ) setSidebarHidden:(BOOL)hidden
				   animated:(BOOL)animated
{
	self.view.userInteractionEnabled = NO;

	_tapGesture.enabled = !hidden;

	[UIView animateWithDuration:animated ? _slideInterval : 0 animations:^
	{
		content.view.frame = CGRectMake( hidden ? 0 : kMenuTableSize, content.view.frame.origin.y, content.view.frame.size.width, content.view.frame.size.height );
	} completion:^(BOOL completed)
	{
		self.view.userInteractionEnabled = YES;
	}];
}

- ( BOOL ) sidebarHidden
{
	return _tapGesture.enabled;
}

- ( void ) showSideBar
{
	[self setSidebarHidden:YES animated:YES];
}

#pragma mark -
#pragma mark - UIViewController

- ( void ) prepareForSegue:(UIStoryboardSegue *)segue
					sender:(id)sender
{
	if ( [segue.identifier isEqualToString:@"content"] )
	{
		content = segue.destinationViewController;

		CALayer *layer = [content.view layer];
		layer.shadowColor = [UIColor blackColor].CGColor;
		layer.shadowOpacity = 0.3;
		layer.shadowOffset = CGSizeMake( -15, 0 );
		layer.shadowRadius = 10;
		layer.masksToBounds = NO;
		layer.shadowPath = [UIBezierPath bezierPathWithRect:layer.bounds].CGPath;

		[content.view addGestureRecognizer:_tapGesture];
		[content.view addGestureRecognizer:_panGesture];


		content.view.frame = CGRectMake( self.view.frame.origin.x, self.view.frame.origin.y, self.view.bounds.size.width, self.view.bounds.size.height );
	}
	else if ( [segue.identifier isEqualToString:@"menu"] )
	{
		menu = segue.destinationViewController;

		menu.view.frame = CGRectMake( self.view.bounds.origin.x, self.view.bounds.origin.y, kMenuTableSize, self.view.bounds.size.height );
	}
	else
	{
		return;
	}

	[self addChildViewController:segue.destinationViewController];
	[self.view addSubview:( (UIViewController *) segue.destinationViewController ).view];
	[segue.destinationViewController didMoveToParentViewController:self];
}

- ( BOOL ) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
	return YES;
}

- ( void ) viewDidLoad
{
	[super viewDidLoad];

	_tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showSideBar)];
	_tapGesture.enabled = NO;
	_tapGesture.cancelsTouchesInView = YES;
	_tapGesture.delaysTouchesBegan = YES;

	_panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panItem:)];
	_panGesture.maximumNumberOfTouches = 2;
	_panGesture.cancelsTouchesInView = YES;
	_panGesture.delaysTouchesBegan = YES;
}

- ( void ) viewWillAppear:(BOOL)animated
{
	[self performSegueWithIdentifier:@"menu" sender:nil];
	[self performSegueWithIdentifier:@"content" sender:nil];
	[super viewWillAppear:animated];
}


@end
