//
//  RepoterDetailsController.m
//  karma-touchbar-reporter
//
//  Created by Christoph Leimbrock on 18.02.18.
//  Copyright © 2018 Christoph Leimbrock. All rights reserved.
//

#import "RepoterDetailsController.h"
#import "RunTracker.h"
#import "ResultsTouchBarItem.h"

static const NSTouchBarItemIdentifier kProjectLabel = @"de.ccl.touchbar.project-label";
static const NSTouchBarItemIdentifier kWaiting = @"de.ccl.touchbar.waiting";
static const NSTouchBarItemIdentifier kResults = @"de.ccl.touchbar.results";
static const NSTouchBarItemIdentifier kRunning = @"de.ccl.touchbar.running";

@interface RepoterDetailsController () <NSTouchBarDelegate>
@property (strong, nonatomic) RunTracker *tracker;
@property (strong, readwrite) NSTouchBar *touchbar;
@end

@implementation RepoterDetailsController
@synthesize tracker=_tracker;

+ (instancetype)controllerWithTracker:(RunTracker*)tracker {
    RepoterDetailsController *instance = [[self alloc] init];
    instance.tracker = tracker;
    return instance;
}

- (instancetype)init {
    if(self = [super init]) {
        [self buildTouchBar];
    }
    
    return self;
}

- (void)setTracker:(RunTracker *)tracker {
    const NSArray * const paths = @[ @"running", @"browsers", @"runs" ];
    if(_tracker) {
        [paths enumerateObjectsUsingBlock:^(id  _Nonnull path, NSUInteger idx, BOOL * _Nonnull stop) {
            [_tracker removeObserver:self forKeyPath:path];
        }];
    }
    
    _tracker = tracker;
    
    [paths enumerateObjectsUsingBlock:^(id  _Nonnull path, NSUInteger idx, BOOL * _Nonnull stop) {
        [_tracker addObserver:self forKeyPath:path options:NSKeyValueObservingOptionInitial context:nil];
    }];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    BOOL prepared = self.tracker.browsers != 0 || self.tracker.isRunning || self.tracker.runs != 0;
    if(prepared) {
        self.touchbar.defaultItemIdentifiers = @[ kProjectLabel, kRunning, kResults ];
        NSTextField *field = (NSTextField *)[self.touchbar itemForIdentifier:kRunning].view;
        field.stringValue = self.tracker.isRunning ? @"[running]" : (self.tracker.failedSpecs ? [NSString stringWithFormat:@"[%ld failed]", self.tracker.failedSpecs] : [NSString stringWithFormat:@"[%ld run]", self.tracker.specs]);
    } else {
        self.touchbar.defaultItemIdentifiers = @[ kProjectLabel, kWaiting ];
    }
}

- (RunTracker*)tracker {
    return _tracker;
}

- (void)buildTouchBar {
    NSTouchBar *touchbar = [[NSTouchBar alloc] init];
    touchbar.defaultItemIdentifiers = @[ kProjectLabel, kWaiting ];
    touchbar.delegate = self;
    touchbar.principalItemIdentifier = kWaiting;
    
    self.touchbar = touchbar;
}

- (void)openBrowser:(id)sender {
    [[NSWorkspace sharedWorkspace] openURL:self.tracker.url];
}

- (nullable NSTouchBarItem *)touchBar:(NSTouchBar *)touchBar makeItemForIdentifier:(NSTouchBarItemIdentifier)identifier
{
    if ([identifier isEqualToString:kProjectLabel])
    {
        NSCustomTouchBarItem *item = [[NSCustomTouchBarItem alloc] initWithIdentifier:identifier];
        item.view = [NSTextField labelWithString:self.tracker.projectName];
        item.visibilityPriority = NSTouchBarItemPriorityNormal;
        
        return item;
    }
    
    if ([identifier isEqualToString:kRunning])
    {
        NSTextField *label = [NSTextField labelWithString:NSLocalizedString(@"[running]", @"")];
        label.textColor = [NSColor secondaryLabelColor];
        label.acceptsTouchEvents = YES;
        
        NSCustomTouchBarItem *item = [[NSCustomTouchBarItem alloc] initWithIdentifier:identifier];
        item.view = label;
        item.visibilityPriority = NSTouchBarItemPriorityLow;
        
        return item;
    }
    
    if ([identifier isEqualToString:kWaiting])
    {
        NSTextField *label = [NSTextField labelWithString:NSLocalizedString(@"waiting for browsers to connect…", @"")];
        label.textColor = [NSColor secondaryLabelColor];
        
        NSCustomTouchBarItem *item = [[NSCustomTouchBarItem alloc] initWithIdentifier:identifier];
        item.view = label;
        item.visibilityPriority = NSTouchBarItemPriorityHigh;
        label.action = @selector(openBrowser:);
        label.target = self;
        
        return item;
    }
    
    if ([identifier isEqualToString:kResults])
    {
        NSCustomTouchBarItem *item = [[ResultsTouchBarItem alloc] initWithIdentifier:identifier andTracker:self.tracker];
        item.visibilityPriority = NSTouchBarItemPriorityHigh;
        return item;
    }
    
    return nil;
}

@end
