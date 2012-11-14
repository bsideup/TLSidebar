//
// Created by bsideup on 14.11.12.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "UIViewController+TLSidebar.h"
#import "TLSidebarViewController.h"


@implementation UIViewController (TLSidebar)


- ( TLSidebarViewController * ) tlSidebarViewController
{
	if(self.parentViewController)
	{
		if([self.parentViewController isKindOfClass:[TLSidebarViewController class]])
		{
			return (TLSidebarViewController *) self.parentViewController;
		}
		else
		{
			return self.parentViewController.tlSidebarViewController;
		}
	}

	return nil;
}

@end