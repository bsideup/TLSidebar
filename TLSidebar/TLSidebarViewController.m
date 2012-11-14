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

- ( id ) initWithCoder:(NSCoder *)aDecoder
{
	if ( self == [super initWithCoder:aDecoder] )
	{
		[self internalInit];
	}

	return self;
}

- ( id ) initWithNibName:(NSString *)nibNameOrNil
				  bundle:(NSBundle *)nibBundleOrNil
{
	if ( self == [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil] )
	{
		[self internalInit];
	}

	return self;
}

- ( void ) internalInit
{
	_slideInterval = 0.3;
	_sidebarHidden = YES;

	_tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showSideBar)];
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
	UIView *movingView = content.view;
	CGPoint translation = [gesture translationInView:movingView];

	if ( ( movingView.frame.origin.x + translation.x < 0 ) ||
			( movingView.frame.origin.x + translation.x > kMenuTableSize ) )
	{
		translation.x = 0.0;
	}

	[movingView setCenter:CGPointMake( movingView.center.x + translation.x, movingView.center.y )];

	[gesture setTranslation:CGPointZero inView:movingView.superview];

	if ( [gesture state] == UIGestureRecognizerStateEnded )
	{
		[self setSidebarHidden:movingView.center.x <= content.view.bounds.size.width animated:YES];
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
						 CGRect frame = content.view.frame;
						 frame.origin.x = hidden ? 0 : kMenuTableSize;
						 content.view.frame = frame;
					 }
					 completion:^( BOOL completed )
					 {
						 self.view.userInteractionEnabled = YES;
					 }];
}

- ( void ) showSideBar
{
	[self setSidebarHidden:YES animated:YES];
}

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

		[content.view addGestureRecognizer:self.tapGesture];
		[content.view addGestureRecognizer:self.panGesture];

		content.view.frame = self.view.frame;
	}
	else if ( [segue.identifier isEqualToString:@"menu"] )
	{
		menu = segue.destinationViewController;

		CGRect bounds = self.view.bounds;
		bounds.size.width = kMenuTableSize;
		menu.view.frame = bounds;
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

- ( void ) viewWillAppear:(BOOL)animated
{
	[self performSegueWithIdentifier:@"menu" sender:nil];
	[self performSegueWithIdentifier:@"content" sender:nil];
	[super viewWillAppear:animated];
}

@end
