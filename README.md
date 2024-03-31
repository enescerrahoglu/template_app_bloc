# Template App with [flutter_bloc](https://pub.dev/packages/flutter_bloc)

This project provides an application template using the bloc state management method with Flutter. The project includes user CRUD (Create, Read, Update, Delete) operations and authentication, serving as a realistic example for real-world scenarios.\
In order to prove that native-looking applications can be developed with Flutter if desired, Cupertino widgets were preferred instead of Material widgets in the user interface of the project.

![TEMPLATE_APP](https://github.com/enescerrahoglu/template_app_bloc/assets/76053138/9ca45272-5487-4b9b-8223-1a26e99eca6c)

## Getting Started

#### API Integration
A Rest API is used for user operations, and the API code is not included in this repository. You can develop API endpoints according to the UserModel class in the project to make it suitable for use. You need to update the BASE_URL value in the '.env' file content to match your API structure. You can find the naming used for CRUD and authentication endpoints in the UserService class, and you may need to revise it according to your API structure.

#### Firebase Integration
The project uses Storage for uploading images and accessing them via URL, Extensions and Firestore Database for email infrastructure and Functions for triggering email sending. Therefore, you will need a Firebase project. Since the firebase_options.dart file is not included in the Template App project content, it will throw an error when you clone the repo. Perform Firebase integration to add this file to the project.

#### Firebase Trigger Email Extension Integration
For email verification, a verification code is sent to the email address provided by the user. The Firebase Trigger Email extension is used for email infrastructure. You need to activate this extension via the Firebase console. Besides verification code sending, the email infrastructure is used for different scenarios as well. Email sending is triggered by Firebase Cloud Functions.

#### Firebase Cloud Functions Integration
The project already includes the functions folder and firebase.json file for integrating with Cloud Functions. When integrating cloud functions, if you specify to overwrite the functions/index.js file, you will remove the cloud functions in the file needed for email infrastructure. You can proceed with the "No" option for overwriting, or if overwritten, you can copy the functions from the relevant file in my Github repo and deploy them again.

## Screenshoots
###### [info] Hover the mouse over the images for explanations.
<img src="https://github.com/enescerrahoglu/template_app_bloc/assets/76053138/0c261807-6554-4296-83ba-ca2007fd81e1" title="Login Screen" height="500">
<img src="https://github.com/enescerrahoglu/template_app_bloc/assets/76053138/f2ca64dd-1c0e-4cab-917b-10422d5152ad" title="Forgot Password Screen" height="500">
<img src="https://github.com/enescerrahoglu/template_app_bloc/assets/76053138/c9b5879d-d167-47d1-aee2-c2ea1b04e828" title="Register Screen" height="500">
<img src="https://github.com/enescerrahoglu/template_app_bloc/assets/76053138/4af3da17-a98c-409b-a5d2-ab70384948c6" title="Verificaton Code Screen" height="500">
<img src="https://github.com/enescerrahoglu/template_app_bloc/assets/76053138/78905109-f0b5-489c-a07d-77a46c16a7a9" title="Verification code and welcome emails" height="500">
<img src="https://github.com/enescerrahoglu/template_app_bloc/assets/76053138/c290e25a-38af-405f-a2a8-cea9cd27d8b5" title="Update Profile Screen" height="500">
<img src="https://github.com/enescerrahoglu/template_app_bloc/assets/76053138/681425e4-9848-4892-9b4a-eeac1a9f1b44" title="View/Edit Profile Photo Screen" height="500">
<img src="https://github.com/enescerrahoglu/template_app_bloc/assets/76053138/74a98cd5-9317-4889-b168-6d4be3086ce6" title="Home Screen" height="500">
<img src="https://github.com/enescerrahoglu/template_app_bloc/assets/76053138/4f0c7aed-be1e-4239-9893-6b8632367544" title="Settings Screen" height="500">
<img src="https://github.com/enescerrahoglu/template_app_bloc/assets/76053138/dd0145be-f13c-4043-a096-5d63132750a9" title="Change app theme" height="500">
<img src="https://github.com/enescerrahoglu/template_app_bloc/assets/76053138/40b2e5e8-84c4-424f-a94f-67bc9ad8d599" title="Change app language" height="500">
