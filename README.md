AddToReminders
===================

##Introduction

_AddToReminders_ allows you to add Reminders to iCal using natural language. New tasks are added to the Reminders list in iCal. With iCloud sync, they will be accessible on your iOS device and using the iCloud web interface.

##Features

1.  Add tasks to the Reminders calendar in iCal
2.  Set due date
3.  Set priority
4.  Set an alarm for the task

##Usage

The App has only one text input field and a few buttons.

1.  Type the reminder text in the field
2.  To add a due date, use the `@` character, followed by a date in natural language (eg. today, tomorrow)
3.  Use a series of exclamation marks (`!`) to set priority
3.  Use the radio buttons to set alarms
4.  Press _return_ to add to iCal

Basic syntax is as follows:

`Reminder title <space> <@optional date and time> <space> <optional priority using !>`

###Example

`Rearrange documents @today 15:30 !!!`

This will create a reminder with title as "Rearrange documents", due date as the current day 3:30 PM and set the priority of the task to High.

If the date info using `@` is not provided, no due date will be assigned to the task. Similarly, if exclamation marks are not typed, no priority will be assigned.

Also note that rigorous checking of characters is not performed and the App as such is not fool proof. 

##System Requirements

1.  An Intel Mac with OS X 10.7.2+
2.  A Reminders calendar in iCal (it is in there by default)
3.  Optional iCloud set up to sync with other devices

