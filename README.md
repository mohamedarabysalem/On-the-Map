# On-the-Map
On The Map - Udacity iOS Nanodegree project

The On The Map is result of **iOS Networking with Swift** lesson of **Udacity's iOS Developer Nanodegree** course.

The On The Map app allows udacity students to share their location and a URL with their fellow students. To visualize this data, On The Map uses a map with pins for location and pin annotations for student names and URLs.

First, the user logs in to the app using their Udacity username and password.

After login, the app downloads locations and links previously posted by other students. These links can point to any URL that a student shares. After viewing the information posted by other students, a user can post their own location and link. The locations are specified with a string and forward geocoded. They can be as specific as a full street address or as generic as “Moscow, Russia” or “Palo Alto, CA”

# Implementation
The app has four view controller scenes:

* **LoginController** - allows the user to log in using their Udacity credentials.

When the user taps the Login button, the app will attempt to authenticate with Udacity’s servers. Clicking on the Sign Up link will open Safari to the Udacity sign-in page.

If the login does not succeed, the user will be presented with an alert view specifying whether it was a failed network connection, or an incorrect email and password.

* **MapController** - displays a map with pins specifying the last 100 locations posted by students.

When the user taps a pin, it displays the pin annotation popup, with the student’s name (pulled from their Udacity profile) and the link associated with the student’s pin.

Tapping anywhere within the annotation will launch Safari and direct it to the link associated with the pin.

* **ListController** - displays the most recent 100 locations posted by students in a table. Each row displays the name from the student’s Udacity profile. Tapping on the row launches Safari and opens the link associated with the student.

* **PinController** - allows users to input data in two steps: first adding their location string, then their link.

When the user clicks on the “Find on the Map” button, the app will forward geocode the string. If the forward geocode fails, the app will display an alert view notifying the user.

# Requirements
* Xcode 7.2
* Swift 2.0
