//
//  AppDelegate.m
//  helper
//
//  Created by Christoph Leimbrock on 18.02.18.
//  Copyright © 2018 Christoph Leimbrock. All rights reserved.
//

#import "AppDelegate.h"

#import "NSTouchbar.h"
#import "NSTouchbarItem.h"
#import "DFRFoundation.h"

#import "MessageReader.h"
#import "RunTracker.h"
#import "ReporterTrayItem.h"
#import "RepoterDetailsController.h"

static const NSTouchBarItemIdentifier kGroupButton = @"de.ccl.touchbar.group";

@interface AppDelegate () <NSTouchBarDelegate>
@property (strong) MessageReader *reader;
@property (strong) ReporterTrayItem *trayItem;
@property (strong) RepoterDetailsController *detailsController;
@property (strong) RunTracker *tracker;
@end

@implementation AppDelegate
- (void)presentDetails:(id)sender {
    [NSTouchBar presentSystemModalFunctionBar:self.detailsController.touchbar systemTrayItemIdentifier:kGroupButton];
}

- (void)applicationWillFinishLaunching:(NSNotification *)notification {
    NSArray <NSString*>* arguments =[[NSProcessInfo processInfo] arguments];
    NSAssert(arguments.count == 3, @"Arguments must be <project-name> <url>");
    
    NSString *name = arguments[1];
    NSURL *url = [NSURL URLWithString:arguments[2]];
    self.tracker = [[RunTracker alloc] initWithName:name at:url];
    self.detailsController = [RepoterDetailsController controllerWithTracker:self.tracker];
    self.trayItem = [self makeGroupItem];
    
    NSFileHandle *input = [NSFileHandle fileHandleWithStandardInput];
    self.reader = [MessageReader readerWithHandle:input andDelegate:self.tracker];
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    [NSTouchBarItem addSystemTrayItem:self.trayItem];
    DFRElementSetControlStripPresenceForIdentifier(self.trayItem.identifier, YES);
}

- (ReporterTrayItem*)makeGroupItem {
    ReporterTrayItem *item = [[ReporterTrayItem alloc] initWithIdentifier:kGroupButton andTracker:self.tracker];
    item.target = self;
    item.action = @selector(presentDetails:);
    
    return item;
}

@end

