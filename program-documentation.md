Program Documentation



Project Documentation: Conversion-system Application

Group: Group M

Project: A Flutter-based Mobile Number Base Converter Application.



1 Introduction

The application is a one-page Flutter application that enables a user to enter a number, select the number base, select the target base to convert to, and see the result. The code organization is such that the user interface remains separate from the process of conversion for ease of reading and maintenance.

2. System Architecture

We broke our app into three pieces, similar to a Model-View-Controller (MVC) design pattern.

The Model (ConversionService): It is the "brain" of our app. It's a Dart class that does all the calculation for the base conversions. It's not aware of the UI; it just takes numbers and converts them.

The View (The UI Widgets): This is the "face" of our application —what the user sees and interacts with. It includes the screen organization, text entries, buttons, and drop-down menus. It's tasked with displaying information and capturing user input.

Controller (_NumberConverterScreenState): This is the "nervous system" that connects the Model and the View. It listens for user action (e.g., a button press), tells the Model to perform a conversion, and then tells the View to reload itself with the result.

3. Code Structure and Key Components

We have all of our code in the main.dart file, broken into the three components described above.

ConversionService (The Model) It contains all the number conversion code.

Private methods to convert any valid base (2-16) to a BigInt (a special number type for very large numbers) and back again.

The public main method, convertBase(), is the one that gets called by the Controller to perform a full conversion between bases.

UI Widgets (The View) This is the build method in our main screen widget.

TextField: Where the user types in the number.

DropdownButton: Two of these to enable the user to select the "From Base" and "To Base".

ElevatedButton: The "Convert" button that performs the calculation.

Text: A bottom text field that displays the resultant result or an error message.

_NumberConverterScreenState (The Controller) This screen contains the app's interactive state.

It holds variables for the user input, the selected bases, and the resultant result string.

The most important method here is _performConversion(). When the "Convert" button is pressed, this method is called. It gets the input, calls the ConversionService for the result, and also handles any potential errors (for example, if a user types in non-convertible symbols). It then uses setState() to update the screen and show the result to the user.

4. Running the Application

Make sure you have the Flutter SDK installed.

Make a new Flutter project and copy our code into lib/main.dart in lieu of its contents.

Open a terminal for the project directory.

Run flutter pub get to get any packages needed.

Run flutter run to launch the app on an emulator or attached device.

