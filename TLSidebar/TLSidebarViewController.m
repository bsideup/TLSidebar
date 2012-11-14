#import <QuartzCore/QuartzCore.h>

#import "TLSidebarViewController.h"
#import "TLSidebarSegue.h"
#import <QuartzCore/QuartzCore.h>

@interface TLSidebarViewController ()
{
}

@end

@implementation TLSidebarViewController

- ( void ) viewDidLoad
{
	_slideInterval = 0.3;
	_sidebarHidden = YES;

	_tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideSidebar)];
	_tapGesture.enabled = NO;
	_tapGesture.cancelsTouchesInView = YES;
	_tapGesture.delaysTouchesBegan = YES;

	_panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panItem:)];
	_panGesture.maximumNumberOfTouches = 2;
	_panGesture.cancelsTouchesInView = YES;
	_panGesture.delaysTouchesBegan = YES;
}

- ( void ) panItem:(UIPanGestureRecognizer *)gesture
{
	UIView *movingView = self.content.view;
	CGRect movingViewFrame = movingView.frame;
	CGPoint translation = [gesture translationInView:movingView];

	if ( ( movingViewFrame.origin.x + translation.x < 0 ) )
	{
		translation.x = 0.0;
	}

	movingViewFrame.origin.x = movingViewFrame.origin.x + translation.x;
	movingView.frame = movingViewFrame;

	[gesture setTranslation:CGPointZero inView:movingView.superview];

	if ( gesture.state == UIGestureRecognizerStateEnded )
	{
		[self setSidebarHidden:( movingViewFrame.origin.x <= self.menu.view.frame.size.width * 0.5 ) animated:YES];
	}
}

- ( void ) setSidebarHidden:(BOOL)hidden
				   animated:(BOOL)animated
{
	_sidebarHidden = hidden;

	self.view.userInteractionEnabled = NO;
	self.tapGesture.enabled = !hidden;

	[UIView animateWithDuration:animated ? self.slideInterval : 0
					 animations:^
					 {
						 CGRect frame = self.content.view.frame;
						 frame.origin.x = !hidden * self.menu.view.frame.size.width;
						 self.content.view.frame = frame;
					 }
					 completion:^( BOOL completed )
					 {
						 self.view.userInteractionEnabled = YES;
					 }];
}

- ( void ) hideSidebar
{
	[self setSidebarHidden:YES animated:YES];
}

- ( void ) prepareForSegue:(UIStoryboardSegue *)segue
					sender:(id)sender
{
	NSAssert([segue isKindOfClass:TLSidebarSegue.class], @"TLSidebarViewController only allows TLSidebarSegues!");

	if ( [segue.identifier isEqualToString:@"content"] )
	{
		_content = segue.destinationViewController;

		CALayer *layer = [self.content.view layer];
		layer.shadowColor = [UIColor blackColor].CGColor;
		layer.shadowOpacity = 0.3;
		layer.shadowOffset = CGSizeMake( -15, 0 );
		layer.shadowRadius = 10;
		layer.masksToBounds = NO;
		layer.shadowPath = [UIBezierPath bezierPathWithRect:layer.bounds].CGPath;

		[self.content.view addGestureRecognizer:self.tapGesture];
		[self.content.view addGestureRecognizer:self.panGesture];

		self.content.view.frame = self.view.frame;

		[self.view addSubview:self.content.view];
	}
	else if ( [segue.identifier isEqualToString:@"menu"] )
	{
		_menu = segue.destinationViewController;

		CGRect bounds = self.view.bounds;
		bounds.size.width = kDefaultMenuTableSize;
		self.menu.view.frame = bounds;

		self.view.backgroundColor = self.menu.view.backgroundColor;

		[self.view insertSubview:self.menu.view atIndex:0];
	}
	else
	{
		return;
	}

	[self addChildViewController:segue.destinationViewController];
	[segue.destinationViewController didMoveToParentViewController:self];
}

- ( BOOL ) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
	return YES;
}

- ( void ) viewWillAppear:(BOOL)animated
{
	if ( !self.menu )
	{
		[self performSegueWithIdentifier:@"menu" sender:nil];
	}

	if ( !self.content )
	{
		[self performSegueWithIdentifier:@"content" sender:nil];
	}

	[super viewWillAppear:animated];
}

@end
