//
//  RootController.m
//  AddToReminders
//
//  Created by Harshad Dange on 22/07/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "RootController.h"
#import <EventKit/EventKit.h>

@implementation RootController

@synthesize inputField = _inputField;
@synthesize outputField = _outputField;
@synthesize alarmMatrix = _alarmMatrix;

- (void)textChanged:(NSNotification *)aNotification {
    
    NSString *currentText = self.inputField.stringValue;
    
    if (!currentText || currentText.length ==  0) {
        _reminderTitle = @"";
        [self.outputField setStringValue:@""];
    }
    
    if ([currentText rangeOfString:@" !!!"].location != NSNotFound) {
        _priority = @"High";
    } else if ([currentText rangeOfString:@" !!"].location != NSNotFound) {
        _priority = @"Medium";
    } else if ([currentText rangeOfString:@" !"].location != NSNotFound) {
        _priority = @"Low";
    } else {
        _priority = @"None";
    }
    
    if ([currentText rangeOfString:@"@"].location != NSNotFound) {
        NSArray *components = [currentText componentsSeparatedByString:@" @"];
        
        NSString *theComponent = [components lastObject];
        
        _reminderDate = [NSDate dateWithNaturalLanguageString:theComponent];   
        
        _reminderTitle = [components objectAtIndex:0];
        _reminderTitle = [[_reminderTitle componentsSeparatedByString:@"!"] componentsJoinedByString:@""];
    } else {
        _reminderDate = nil;
        _reminderTitle = [[currentText componentsSeparatedByString:@"!"] componentsJoinedByString:@""];
    }
    
    if (_reminderDate) {
        [self.outputField setStringValue:[NSString stringWithFormat:@"%@ on %@ priority: %@", _reminderTitle, [_dateFormatter stringFromDate:_reminderDate], _priority]];
    } else {
        [self.outputField setStringValue:[NSString stringWithFormat:@"%@ priority: %@", _reminderTitle, _priority]];
    }
    return;
}

- (id)init {
    if (self = [super init]) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textChanged:) name:NSTextDidChangeNotification object:nil];
        _dateFormatter = [[NSDateFormatter alloc] init];
        [_dateFormatter setDateFormat:@"MMM dd, yyyy h:mm a"];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.inputField becomeFirstResponder];

}

- (void)touchAdd:(id)sender {
    if (!_reminderTitle || [_reminderTitle isKindOfClass:[NSNull class]] || _reminderTitle.length == 0) {
        return;
    }
    
    EKEventStore *anEventStore = [[EKEventStore alloc] initWithAccessToEntityTypes:EKEntityTypeReminder];
    EKReminder *aReminder = [EKReminder reminderWithEventStore:anEventStore];
    [aReminder setTitle:_reminderTitle];
    [aReminder setCalendar:[anEventStore defaultCalendarForNewReminders]];
    if (_reminderDate && _reminderDate != nil) {
        [aReminder setDueDateComponents:[[NSCalendar currentCalendar] components:(NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit) fromDate:_reminderDate]];
        
        NSInteger selectedIndex = self.alarmMatrix.selectedColumn;
        switch (selectedIndex) {
            case 1:
                [aReminder addAlarm:[EKAlarm alarmWithAbsoluteDate:[_reminderDate dateByAddingTimeInterval:-(60 * 15)]]];
                break;
                
            case 2:
                [aReminder addAlarm:[EKAlarm alarmWithAbsoluteDate:[_reminderDate dateByAddingTimeInterval:-(60 * 30)]]];
                
            case 3:
                [aReminder addAlarm:[EKAlarm alarmWithAbsoluteDate:[_reminderDate dateByAddingTimeInterval:-(3600)]]];
                
            case 4:
                [aReminder addAlarm:[EKAlarm alarmWithAbsoluteDate:[_reminderDate dateByAddingTimeInterval:-(3600 * 24)]]];
                
            default:
                break;
        }
        _reminderDate = nil;
    }
    
    NSNumber *priorityNumber = nil;
    
    if ([_priority isEqualToString:@"High"]) {
        priorityNumber = [NSNumber numberWithInt:1];
    } else if ([_priority isEqualToString:@"Medium"]) {
        priorityNumber = [NSNumber numberWithInt:5];
    } else if ([_priority isEqualToString:@"Low"]) {
        priorityNumber = [NSNumber numberWithInt:9];
    } else {
        priorityNumber = [NSNumber numberWithInt:0];
    }
    
    if ([aReminder respondsToSelector:@selector(setPriorityNumber:)]) {
        [aReminder performSelector:@selector(setPriorityNumber:) withObject:priorityNumber];
    }
    

    NSError *error = nil;
    if (![anEventStore saveReminder:aReminder commit:YES error:&error]) {
        NSLog(@"%@", error.localizedDescription);
    } else {
        [self.inputField setStringValue:@""];
        [self.outputField setStringValue:@"Added to Reminders"];
        _reminderDate = nil;
        _reminderTitle = nil;
        _priority = nil;
    }
}

@end
