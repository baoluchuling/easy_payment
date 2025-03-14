# Easy Payment Example

This example demonstrates how to integrate and use the Easy Payment plugin in a Flutter application.

## Features Demonstrated

- Basic payment flow implementation
- Error handling and status display
- Payment logging integration
- UI feedback during payment processing

## Running the Example

1. Clone the repository
2. Navigate to the example directory
3. Run `flutter pub get` to install dependencies
4. Run `flutter run` to start the app

## Code Structure

The example demonstrates:
- Setting up the IAPManager with DefaultIAPService
- Implementing a purchase flow with loading states
- Handling various payment outcomes and errors
- Integration with the logging system

## Testing

For testing purposes, the example uses a test product ID ('test_product_1'). In a real application, you would replace this with your actual product IDs from the App Store or Google Play Store.

## Notes

- The DefaultIAPService in this example is a mock implementation for demonstration purposes
- In a production environment, you should implement proper verification and error handling
- Make sure to properly configure your app in the respective app stores before testing real purchases
