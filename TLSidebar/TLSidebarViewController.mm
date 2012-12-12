#import <QuartzCore/QuartzCore.h>

#import "TLSidebarViewController.h"
#import "TLSidebarContentSegue.h"
#import <QuartzCore/QuartzCore.h>

@implementation TLSidebarViewController
{
	UIView *blockerView;
}

@synthesize contentViewController = _contentViewController;

tl_synthesize_signal(willShowSidebarAnimatedSignal, UIViewController *, BOOL);
tl_synthesize_signal(didShowSidebarAnimatedSignal, UIViewController *, BOOL);
tl_synthesize_signal(willHideSidebarAnimatedSignal, UIViewController *, BOOL);
tl_synthesize_signal(didHideSidebarAnimatedSignal, UIViewController *, BOOL);

- ( id ) initWithContentViewController:(UIViewController *)aContentViewController
{
	if ( self = [super init] )
	{
		self.contentViewController = aContentViewController;
	}
	return self;
}

- ( void ) viewDidLoad
{
	[super viewDidLoad];
	_slideInterval = 0.3;
	_sidebarHidden = YES;

	_tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideSidebar)];
	_tapGesture.enabled = NO;
	_tapGesture.cancelsTouchesInView = YES;
	_tapGesture.delaysTouchesBegan = YES;

	_panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panItem:)];
	_panGesture.enabled = NO;
	_panGesture.maximumNumberOfTouches = 2;
	//_panGesture.cancelsTouchesInView = YES;
	//_panGesture.delaysTouchesBegan = YES;
}

- ( void ) viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	if ( !self.contentViewController )
	{
		[self performSegueWithIdentifier:@"contentViewController" sender:self];
	}
}

- ( void ) setCurrentDirection:(TLSidebarMenuDirection)direction
{
	_currentDirection = direction;
	UIViewController *newMenu = _currentDirection == TLSidebarMenuDirectionRight ? self.rightMenu : self.leftMenu;

	if ( newMenu != self.currentMenu )
	{
		[self.currentMenu.view removeFromSuperview];
		_currentMenu = newMenu;
		[self.view insertSubview:self.currentMenu.view atIndex:0];
	}
}


- ( void ) panItem:(UIPanGestureRecognizer *)gesture
{
	UIView *movingView = self.contentViewController.view;
	CGRect movingViewFrame = movingView.frame;
	CGPoint translation = [gesture translationInView:movingView];

	if ( ( movingViewFrame.origin.x + translation.x != 0 ) )
	{
		self.currentDirection = ( movingViewFrame.origin.x + translation.x > 0 ) ? TLSidebarMenuDirectionLeft : TLSidebarMenuDirectionRight;

		if ( self.currentMenu == nil )
		{
			translation.x = 0.0;
			translation.y = 0.0;
		}
	}

	movingViewFrame.origin.x = movingViewFrame.origin.x + translation.x;
	movingView.frame = movingViewFrame;

	[gesture setTranslation:CGPointZero inView:movingView.superview];

	if ( gesture.state == UIGestureRecognizerStateEnded )
	{
		if ( self.currentDirection == TLSidebarMenuDirectionRight )
		{
			[self setSidebarHidden:( ( movingViewFrame.origin.x + movingViewFrame.size.width ) >= ( self.currentMenu.view.frame.size.width + self.currentMenu.view.frame.origin.x ) * 0.5 ) animated:YES];
		}
		else
		{
			[self setSidebarHidden:( movingViewFrame.origin.x <= self.currentMenu.view.frame.size.width * 0.5 ) animated:YES];
		}
	}
}


- ( void ) setSidebarHidden:(BOOL)hidden
				   animated:(BOOL)animated
{
	_sidebarHidden = hidden;

	self.view.userInteractionEnabled = NO;
	self.tapGesture.enabled = !hidden;

	if ( hidden == NO )
	{
        self.willShowSidebarAnimatedSignal->notify(self.currentMenu, animated);

		self.view.backgroundColor = self.currentMenu.view.backgroundColor;
		if ( blockerView == nil )
		{
			blockerView = [[UIView alloc] init];
		}

		blockerView.frame = self.contentViewController.view.frame;

		[self.contentViewController.view addSubview:blockerView];

		[self.contentViewController.view addGestureRecognizer:self.tapGesture];
	}
	else
	{
        self.willHideSidebarAnimatedSignal->notify(self.currentMenu, animated);

		[self.contentViewController.view removeGestureRecognizer:self.tapGesture];
	}

	[UIView animateWithDuration:animated ? self.slideInterval : 0
					 animations:^
					 {
						 CGRect frame = self.contentViewController.view.frame;
						 frame.origin.x = !hidden * ( _currentDirection == TLSidebarMenuDirectionRight ? -1 : 1 ) * self.currentMenu.view.frame.size.width;
						 self.contentViewController.view.frame = frame;
					 }
					 completion:^( BOOL completed )
					 {
						 self.view.userInteractionEnabled = YES;
						 if ( hidden == YES )
						 {
							 [self.currentMenu.view removeFromSuperview];
							 [blockerView removeFromSuperview];
							 _currentMenu = nil;

                             self.didHideSidebarAnimatedSignal->notify(self.currentMenu, animated);
						 }
						 else
						 {
                             self.didShowSidebarAnimatedSignal->notify(self.currentMenu, animated);
						 }
					 }];
}

- ( void ) hideSidebar
{
	[self hideSidebarAnimated:YES];
}

- ( void ) hideSidebarAnimated:(BOOL)animated
{
	[self setSidebarHidden:YES animated:animated];
}

- ( void ) showSidebar:(UIViewController *)sidebar
		   inDirection:(TLSidebarMenuDirection)direction
			  animated:(BOOL)animated
{
	_currentDirection = direction;
	_currentMenu = sidebar;

	CGRect bounds = self.view.bounds;
	bounds.size.width = kDefaultMenuTableSize;
	if ( direction == TLSidebarMenuDirectionLeft )
	{
		_leftMenu = self.currentMenu;
	}
	else if ( direction == TLSidebarMenuDirectionRight )
	{
		_rightMenu = self.currentMenu;
		bounds.origin.x = self.view.bounds.size.width - bounds.size.width;
	}
	self.currentMenu.view.frame = bounds;

	[self.view insertSubview:self.currentMenu.view atIndex:0];

	[self setSidebarHidden:NO animated:animated];
}

- ( void ) prepareForSegue:(UIStoryboardSegue *)segue
					sender:(id)sender
{
	NSAssert([segue isKindOfClass:TLSidebarContentSegue.class], @"TLSidebarViewController only allows TLSidebarContentSegues!");

	if ( [segue.identifier isEqualToString:@"contentViewController"] )
	{
		self.contentViewController = segue.destinationViewController;
	}
	else
	{
		return;
	}
}

- ( void ) setContentViewController:(UIViewController *)aContentViewController
{
	_contentViewController = aContentViewController;

	CALayer *layer = [self.contentViewController.view layer];
	layer.shadowColor = [UIColor blackColor].CGColor;
	layer.shadowOpacity = 0.5;
	layer.shadowRadius = 10;
	//layer.shadowOffset = CGSizeMake( -15, 0 );
	layer.masksToBounds = NO;
	layer.shadowPath = [UIBezierPath bezierPathWithRect:layer.bounds].CGPath;

	[self.contentViewController.view addGestureRecognizer:self.panGesture];

	[self.contentViewController willMoveToParentViewController:self];
	[self addChildViewController:self.contentViewController];
	[self.contentViewController didMoveToParentViewController:self];

	[self.view addSubview:self.contentViewController.view];
}

- ( BOOL ) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
	return [self.contentViewController shouldAutorotateToInterfaceOrientation:toInterfaceOrientation];
}

@end
