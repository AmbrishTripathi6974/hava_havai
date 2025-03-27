# 🌟 HavaHavai_Assignment

![Flutter](https://img.shields.io/badge/Flutter-3.4.4-blue?style=flat-square&logo=flutter&logoColor=white)  
![License](https://img.shields.io/badge/License-MIT-green?style=flat-square)  
![Build](https://img.shields.io/badge/Build-Passing-brightgreen?style=flat-square)  

**Hava Havai** Shopping Cart is a Flutter-based app for seamless **e-commerce** experiences. 🛒 It features real-time cart updates, discount calculations, and smooth pagination using **BLoC** or **Riverpod**. With clean architecture and modular design, it ensures performance and scalability. 🚀

---  

## ✨ Features

- **Seamless API Calls**: Make effective & fast API calls.
- **Modern State Management**: Leveraging the BLoC pattern for efficiency.
- **Error-Handling States**: Provides a resilient user experience.
- **Animations**: Stunning micro-interactions using **Lottie**.
- **Responsive UI**: Designed for exceptional usability across all device sizes.

---  

## 🛠️ Tech Stack

| Aspect              | Technology           | Description                      |  
|---------------------|----------------------|----------------------------------|  
| **Framework**       | [Flutter](https://flutter.dev)   | Cross-platform mobile development. |  
| **Animated-Splash** | [Supabase](https://pub.dev/packages/animated_splash_screen) | Animated & Responsive Splash UI |  
| **State Management**| [Flutter BLoC](https://bloclibrary.dev/) | Simplified state handling. |  
| **Networking**      | [Dio](https://pub.dev/packages/dio) | Robust HTTP client.             |  
| **Routing**         | [GoRouter](https://pub.dev/packages/go_router) | Dynamic navigation.  |  
| **Local Storage**   | [Hive](https://pub.dev/packages/hive) | Efficient lightweight storage.|  

---  

## 🚀 Getting Started

### Prerequisites

Ensure the following are installed on your system:
- **Flutter SDK**: Version `>=3.4.4 <4.0.0`.
- **Dart SDK**.
- **Android/iOS Setup**: For Flutter development.

### Installation

1. **Clone the Repository**:
   ```bash  
   git clone https://github.com/AmbrishTripathi6974/hava_havai.git  
   cd hava_havai  
   ```  

2. **Install Dependencies**:
   ```bash  
   flutter pub get  
   ```  

3. **Run the App**:
   ```bash  
   flutter run  
   ```  

---  

## 📦 Dependencies

A glimpse at the major dependencies:

| Dependency            | Version | Purpose                                  |  
|-----------------------|---------|------------------------------------------|  
| `flutter_bloc`        | ^8.1.6  | State management.                        |  
| `hydrated_bloc`       | ^9.1.5  | Persistent state management.             |  
| `dio`                 | ^5.7.0  | Advanced HTTP client.                    |  
| `go_router`           | ^14.6.1 | Simplified navigation management.        |  
| `hive`                | ^2.2.3  | Lightweight local database.              |  

For a complete list, check out the [`pubspec.yaml`](./pubspec.yaml).

---  

## 📖 Project Structure

The project follows **clean architecture principles** to ensure scalability and maintainability:

```
│── lib/
│   ├── main.dart
│   ├── app.dart
│   ├── core/
│   │   ├── theme.dart
│   │   ├── constants.dart
│   │   ├── services/
│   │   │   ├── api_service.dart  # Handles API calls
│   │   │   ├── local_storage.dart  # Handles local storage (cart persistence)
│   ├── models/
│   │   ├── product_model.dart  # Product model
│   │   ├── cart_model.dart  # Cart model
│   ├── blocs/
│   │   ├── product/
│   │   │   ├── product_bloc.dart
│   │   │   ├── product_event.dart
│   │   │   ├── product_state.dart
│   │   ├── cart/
│   │   │   ├── cart_bloc.dart
│   │   │   ├── cart_event.dart
│   │   │   ├── cart_state.dart
│   ├── repositories/
│   │   ├── product_repository.dart  # Fetch products from API
│   │   ├── cart_repository.dart  # Manages cart logic
│   ├── views/
│   │   ├── home_screen.dart  # Entry point with navigation
│   │   ├── product_list_screen.dart  # Displays products
│   │   ├── product_detail_screen.dart  # Product details page
│   │   ├── cart_screen.dart  # Cart page with items
│   ├── widgets/
│   │   ├── product_tile.dart  # UI component for product list item
│   │   ├── cart_tile.dart  # UI component for cart list item
│   │   ├── custom_button.dart  # Reusable button component
│   │   ├── loading_indicator.dart  # Loading widget
│   ├── test/
│── pubspec.yaml
│── assets/


```  

---  

## 🖥️ Screenshots

### Coming Soon

---  

## 🌐 Hava Havai

This application is an intellectual property of **Hava Havai** and is not open-source. Unauthorized duplication, sharing, or modification is prohibited.

---   

Made with 💙 by **Ambrish**.  
