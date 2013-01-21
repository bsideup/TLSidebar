//
//  TLLeftSidebarSegue.m
//  TLSidebar
//
//  Created by Sergey Egorov on 16.11.12.
//  Copyright (c) 2012 TryLogic. All rights reserved.
//

#import "TLLeftSidebarSegue.h"
#import "TLSidebarViewController.h"
#import "UIViewController+TLSidebar.h"

@implementation TLLeftSidebarSegue

-(void) perform
{
	[[self.sourceViewController tlSidebarViewController] showSidebar:self.destinationViewController inDirection:TLSidebarMenuDirectionLeft animated:YES ];
}

@end
