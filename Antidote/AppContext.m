//
//  AppContext.m
//  Antidote
//
//  Created by Dmytro Vorobiov on 19.05.15.
//  Copyright (c) 2015 dvor. All rights reserved.
//

#import "AppContext.h"
#import "EventsManager.h"
#import "UserDefaultsManager.h"
#import "AppearanceManager.h"

@interface AppContext()

@property (strong, nonatomic, readwrite) AppearanceManager *appearance;
@property (strong, nonatomic, readwrite) EventsManager *events;
@property (strong, nonatomic, readwrite) UserDefaultsManager *userDefaults;

@end

@implementation AppContext

#pragma mark -  Lifecycle

- (id)init
{
    return nil;
}

- (id)initPrivate
{
    self = [super init];

    if (! self) {
        return nil;
    }

    _userDefaults = [UserDefaultsManager new];
    [self createUserDefaultsValuesIfNeeded];

    AppearanceManagerColorscheme colorscheme = _userDefaults.uCurrentColorscheme.unsignedIntegerValue;
    _appearance = [[AppearanceManager alloc] initWithColorscheme:colorscheme];

    _events = [EventsManager new];

    return self;
}

+ (instancetype)sharedInstance
{
    static AppContext *instance;
    static dispatch_once_t onceToken;

    dispatch_once(&onceToken, ^{
        instance = [[AppContext alloc] initPrivate];
    });

    return instance;
}

#pragma mark -  Private

- (void)createUserDefaultsValuesIfNeeded
{
    if (! self.userDefaults.uShowMessageInLocalNotification) {
        self.userDefaults.uShowMessageInLocalNotification = @(YES);
    }

    if (! self.userDefaults.uIpv6Enabled) {
        self.userDefaults.uIpv6Enabled = @(1);
    }

    if (! self.userDefaults.uUdpDisabled) {
        self.userDefaults.uUdpDisabled = @(1);
    }

    if (! self.userDefaults.uCurrentColorscheme) {
        self.userDefaults.uCurrentColorscheme = @(AppearanceManagerColorschemeRed);
    }
}

@end
