## Build tools & versions used
- Xcode Version: 14.2
- Swift Version: 5.7
- iOS Version: 14 and above

## Steps to run the app
- Click on the EmployeeDirectory app icon to launch the app.
- After the splash screen is shown, the employee directory list screen is displayed which initially loads all the employees. While initially loading the employees, a center screen loader is shown. 
- On pull to refresh, every second time, loads malformed employees. Since the employees are malformed, none of them are shown. Instead, an error message is shown on the screen - Malformed employees found.
- Every third time the pull to refresh is used, loads no employees. So, an error message is shown on the screen - No employees found.
- On further pull to refresh, loads all employees again. And this cycle keeps on repeating to refresh employee list for all the cases - All, Malformed, No Employees.
- Employee information shown in the list includes full name, profile photo, biography, phone, email and the team they belong to. 
- Employees are grouped by the team. And teams are sorted in ascending order. 
- A default user image is shown while the profile photo of an employee is getting loaded.
- If any kind of error occurs while loading the list of employees, for example, no internet connection, then appropriate error message is shown on the screen.

## What areas of the app did you focus on?
- I focussed on these main areas:
1. Adopting a suitable design pattern to develop this app.
2. Suitable data Parsing and model handling for the successful response from API.
3. Appropriate error message handling.
4. Used applicable strategies while writing code to make unit testing of code easier later. 

## What was the reason for your focus? What problems were you trying to solve?
1. Used a structural design pattern: MVVM (Model-View-ViewModel) to allow debugging, testing, and reading code easier. This pattern separates all the UI logic (presenting the data) from the business logic (processing the data). There is a transparent communication between the layers of the application:
- Model: App data that the app operates on.
- View: The user interface’s visual elements. In iOS, the view controller is inseparable from the concept of the view.
- ViewModel: Updates the model from view inputs and updates views from model outputs.
2. If the data models are designed correctly, it makes it easier to represent the UI effectively. For example, I first used a basic model - "Employee" to contain raw employee data from API, but only with the fields I am interested to show on the UI where photo_url_large and employee_type were skipped. Then another model - "EmployeeCellViewModel" is taken to contain the data presentable to user per field. While showing phone number, I needed to indicate the phone number with a label - Contact No. So, this label is appended with the phone number in this model. Lastly, used a model - GroupedEmployeeCellViewModel to contain team and it's employees per group, where the group from this model is used to show section header and employees from this model is used to show employee list per section.
3. If the error messages are not handled correctly, the user may not know the reason for not loading the list. Error messages from the API are properly handled and shown on UI. In addition to this, internet connection check is made without hitting the API using NWPathMonitor class to avoid unnecessary network resources and adding additional load to the server. Also, I have made sure to choose appropriate UI to show error messages, which is a label always present on screen until user refreshes the list using pull to refresh. If some other UI like alert was chosen, then it would have been annoying for the user to click Ok to go away with the alert and then refresh the list. Tried to reduce number of steps the user had to take to refresh list on receiving any error.
4. If the code is not written in a way which allows writing unit tests easier, then you have to revisit the code again and again to be able to write tests. For example, I used dependency injection in EmployeeListViewModel class to provide dependencies from the outside, making it easier to substitute dependencies with mock objects like MockNetworkClient during testing.

## How long did you spend on this project?
- I spent around 5 hours to complete this project. Apart from developing the app features I have been asked to, I spent sometime to design my app icon and launch screen. Since I am really fond of presenting the app appropriately that I build, I took that extra time by finding a suitable icon from https://www.iconfinder.com website and modifiying it and then generating assets from https://icon.kitchen website.

## Did you make any trade-offs for this project? What would you have done differently with more time?
- I compromised on using a third party library - SDWebImage for downloading/caching the images considering the time constraints. If I could take more time to build this app, I would have designed my own solution to download and cache images.
- I could not spend time on these 2 features which should be considered while delivering an app on appstore:
1. App compatiblity with dark mode.
2. Basic accessiblity features.


## What do you think is the weakest part of your project?
- I could include more test cases. Due to time constraints, I could write only 4.

## Did you copy any code or dependencies? Please make sure to attribute them here!
- I used 2 dependencies and someone's code file in my project -
1. https://github.com/SDWebImage/SDWebImage
2. https://github.com/realm/SwiftLint
3. https://gist.github.com/UdayKiran-M/aeaee726832a005f0dc5bb4af5e9df18#file-networkmonitor-swift

## Is there any other information you’d like us to know?
- Used Instruments to profile the app.
- Localization of the string files has been enabled by default for future language support.
- The app is compatible with iPhone and iPad.
- Device Orientations supported: Portrait, Landscape Left & Landscape Right.

## Contributors

- [Arshdeep Kaur](https://www.linkedin.com/in/arshdeep-kaur-2590b237/)

