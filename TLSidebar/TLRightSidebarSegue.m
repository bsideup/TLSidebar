//
//  TLRightSidebarSegue.m
//  TLSidebar
//
//  Created by Sergey Egorov on 16.11.12.
//  Copyright (c) 2012 TryLogic. All rights reserved.
//

#import "TLRightSidebarSegue.h"
#import "TLSidebarViewController.h"
#import "UIViewController+TLSidebar.h"

@implementation TLRightSidebarSegue

-(void) perform
{
	[[self.sourceViewController tlSidebarViewController] showSidebar:self.destinationViewController inDirection:TLSidebarMenuDirectionRight animated:YES ];
}

@end
