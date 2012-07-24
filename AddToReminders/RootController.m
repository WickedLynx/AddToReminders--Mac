//
//  RootController.m
//  AddToReminders
//
//  Created by Harshad Dange on 22/07/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "RootController.h"
#import <CalendarStore/CalendarStore.h>

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
    
    CalCalendarStore *sharedStore = [CalCalendarStore defaultCalendarStore];
    
    CalTask *newTask = [CalTask task];
    [newTask setTitle:_reminderTitle];
    [newTask setDueDate:_reminderDate];
    
    if ([_priority isEqualToString:@"High"]) {
        [newTask setPriority:CalPriorityHigh];
    } else if ([_priority isEqualToString:@"Medium"]) {
        [newTask setPriority:CalPriorityMedium];
    } else if ([_priority isEqualToString:@"Low"]) {
        [newTask setPriority:CalPriorityLow];
    } else {
        [newTask setPriority:CalPriorityNone];
    }
    
    NSInteger selectedIndex = self.alarmMatrix.selectedColumn;
    
    CalAlarm *alarm = [CalAlarm alarm];
    
    switch (selectedIndex) {
        case 0:
            [newTask setAlarms:nil];
            break;
            
        case 1: {
            [alarm setAbsoluteTrigger:[_reminderDate dateByAddingTimeInterval:-(60 * 15)]];
            [newTask setAlarms:[NSArray arrayWithObject:alarm]];
            break;
        }
            
        case 2: {
            [alarm setAbsoluteTrigger:[_reminderDate dateByAddingTimeInterval:-(60 * 30)]];
            [newTask setAlarms:[NSArray arrayWithObject:alarm]];
            break;
        }
            
        case 3: {
            [alarm setAbsoluteTrigger:[_reminderDate dateByAddingTimeInterval:-(3600)]];
            [newTask setAlarms:[NSArray arrayWithObject:alarm]];
            break;
        }
            
        case 4: {
            [alarm setAbsoluteTrigger:[_reminderDate dateByAddingTimeInterval:-(3600 * 24)]];
            [newTask setAlarms:[NSArray arrayWithObject:alarm]];
            break;
        }
            
        default:
            break;
    }
    
    for (CalCalendar *aCalendar in sharedStore.calendars) {
        if ([aCalendar.title isEqualToString:@"Reminders"]) {
            [newTask setCalendar:aCalendar];
            break;
        }
    }
    
    NSError *error = nil;
    if (![sharedStore saveTask:newTask error:&error]) {
        NSAlert *alert = [NSAlert alertWithMessageText:@"Error while adding reminder" defaultButton:@"Dismiss" alternateButton:nil otherButton:nil informativeTextWithFormat:[NSString stringWithFormat:@"Please report this error to help me fix it: %@", error.localizedDescription]];
        [alert runModal];
    } else {
        [self.inputField setStringValue:@""];
        [self.outputField setStringValue:@"Added to Reminders"];   
    }
}

- (void)textEditingChanged:(id)sender {
    NSLog(@"Text editing changed");
}




@end
