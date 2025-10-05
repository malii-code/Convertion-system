Program Documentation

Project Documentation: Conversion-system Application
Group: Group Q 
Project: A Mobile Number Base Converter Application built with Flutter.

1 Introduction
The application is a single-screen Flutter app that lets a user enter a number, select the number's current base, select the base they want to convert to, and see the result. The code is structured to keep the user interface separate from the conversion logic, making it easier to read and maintain.
2. System Architecture
We structured our app into three main parts, similar to a Model-View-Controller (MVC) pattern.
	The Model (ConversionService): This is the "brain" of our app . It's a Dart class that handles all the math for the base conversions. It knows nothing about the UI; it just takes numbers and converts them.
	The View (The UI Widgets): This is the "face" of our app —what the user sees and interacts with. It includes the screen layout, text fields, buttons, and dropdown menus. Its job is to display information and capture user input.
	The Controller (_NumberConverterScreenState): This is the "nervous system" that connects the Model and the View. It listens for user actions (like a button click), tells the Model to perform a conversion, and then tells the View to update itself with the result.
	3. Code Structure and Key Components
All our code is in the main.dart file, organized into the three parts described above.
ConversionService (The Model) This class contains all the logic for converting numbers.
	It has private methods to convert any valid base (2-16) into a BigInt (a special type for very large numbers) and vice-versa.
	The main public method, convertBase(), is what the Controller calls to perform a full conversion from one base to another.
UI Widgets (The View) This is the build method inside our main screen widget.
	TextField: Where the user types the number.
	DropdownButton: Two of these are used to let the user select the "From Base" and "To Base".
	ElevatedButton: The "Convert" button that starts the calculation.
	Text: A text area at the bottom that displays the final result or an error message. 
_NumberConverterScreenState (The Controller) This class manages the app's interactive state.
	It holds variables for the user's input, the selected bases, and the final result string.
	The most important function here is _performConversion(). When the "Convert" button is pressed, this function is called. It reads the input, calls the ConversionService to get the result, and handles any potential errors (like a user typing invalid characters). Finally, it uses setState() to update the screen and show the result to the user.
	4. How to Run the Application
	Make sure you have the Flutter SDK installed.
	Create a new Flutter project and replace the contents of lib/main.dart with our code.
	Open a terminal in the project folder.
	Run flutter pub get to install any needed packages.
	Run flutter run to start the app on an emulator or a connected device.
