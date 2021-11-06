# UEKSchedule

##### Version 1.0.0
##### Min iOS: 15.0

### About
UEKSchedule is an app that allows to create calendar with events from "Cracow University of Economics" public schedule.

### How it works
The application is based on data downloaded and scraped from the official website of the University of Economics in Crakow "https://planzajec.uek.krakow.pl/", 
which contains schedules available for individual faculties and groups.

1. After starting the application, a list of available faculties is presented.
2. After selecting the faculty, a list of available groups is presented.
3. After selecting the group, the list of events is downloaded.
4. The user can create a calendar with fetched events. 
5. The application stores the identifiers of created calendars. 
6. If a calendar for selected group already exists, we have the option to update the calendar.

Calendar permission is required. The application includes basic error handling.

### Technologies
- SwiftSoup
- SwiftUI
- Combine

### TODO
1. Background calendars update periodically.
2. Error handling improvements.
3. Calendar settings when creating calendar.
4. Handling additional information presented in the timetable, e.g. rescheduled classes.
5. Notifications about rescheduled classes.

### Illustrations

Video: https://www.youtube.com/watch?v=8l5GdIUYP7A

<img src="https://github.com/SebastianStasz/UEKSchedule/blob/master/Screenshots/UEK%20Schedule%201.PNG" width="30%" height="30%">
<img src="https://github.com/SebastianStasz/UEKSchedule/blob/master/Screenshots/UEK%20Schedule%202.PNG" width="30%" height="30%">
<img src="https://github.com/SebastianStasz/UEKSchedule/blob/master/Screenshots/UEK%20Schedule%203.PNG" width="30%" height="30%">
