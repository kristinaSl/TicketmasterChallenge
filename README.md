# Ticketmaster Technical Challenge

This repo contains a small iOS project which fetches events from Ticketmaster API and displays them in a pagginated table. More details for the event can be viewed by selecting the event. 

## How to run the application

* Download [Xcode](https://apps.apple.com/gb/app/xcode/id497799835?mt=12)
* Clone this repository
* Navigate to Config.xcconfig and put your API key instead of <API_KEY>. More information can be found [here](https://developer.ticketmaster.com/products-and-docs/apis/getting-started).

## Code structure

The code follows the MVVM architecture and the navigation is handled by a coordinator.

It is organised in a few folders:
* ```API``` API integration.
* ```Categories``` Categories extending existing functionality
* ```Coordinators``` Coordinators handling navigation
* ```Helpers``` Classes for supporting functinality
* ```Model``` Data models
* ```ViewControllers``` ViewControllers 
* ```ViewModels``` ViewModels 
* ```Views``` Custom views

CoreData is used to save downloaded images from the app as Data for faster loading when possible. 

Note: The above image chashing machanisim is not suggested or optimal. Expesially considering that right now it does not clear the saved data. It was implemented with the sole puspose of demostrating the usage of CoreData. More suitable solution can be using a framework like SDWebImage.

## Testing

### Unit Tests

There is unit tests coverage for the main data model and viewModels.

### UI Tests

Simple UI test case for the happy path has been written in Behavior-Driven Development (BDD) manner. All supporting files to utilise BDD has been added as well. 

## Possible Next Steps

1. Increase Unit/UI tests coverage
2. UI improvements - such as serach bar visibility, date formatting, images size/fit, etc. 
3. Exdended functionality for the details screen
4. Building filters screen 
5. Custom errors screen

## Troubleshooting

If you see the following error in the console when starting the application. Please review have you set up your API key correctly.
```swift
   TicketMasterChallenge/AppCoordinator.swift:52: Fatal error: Error: Config file not set up correctly
```

