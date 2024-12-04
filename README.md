# easyPKU

easyPKU, a mobile application specifically designed for UTM students. This app aims to upgrade the appointment process at PKU, providing an efficient and user-friendly platform that meets the unique needs of its users.

## Installation Guide

This installation process is designed for Windows operating systems.

---

### 1. Development IDE

#### Install Visual Studio Code (VS Code)
1. [Download and install VS Code](https://code.visualstudio.com/).
2. Configure VS Code for Flutter:
   - Open VS Code and navigate to the Extensions Marketplace.
   - Search for and install the **Flutter extension**.

---

### 2. Flutter Installation

#### 1. Download Flutter SDK
- [Download the Flutter SDK](https://docs.flutter.dev/get-started/install) based on your system.
- Extract the downloaded archive to a directory.

#### 2. Set Environment Variables
- Add the `bin` directory of the Flutter SDK to your system's `PATH` environment variable:
  - Go to **System Properties > Environment Variables > Path > Edit > Add the Flutter SDK path** 

#### 3. Verify Installation
- Open a terminal and run the following command:
  ```bash
  flutter doctor

---

### 3. Setting Up Android Development

1. **Install Android Studio:**
   - [Download and install Android Studio](https://developer.android.com/studio).
   - Ensure **Android SDK**, **Android Virtual Device (AVD)**, and required tools are selected.
     
2. **Configure AVD (Android Emulator):**
   - Open Android Studio and go to **Tools > AVD Manager**.
   - Create a new virtual device:
     - Select a hardware profile (e.g., **Medium Phone**).
     - Choose a system image (**VanillaIceCream, API 35**).
       
3. **Install Java Development Kit (JDK):**
   - Install the JDK if not already present. [Download JDK 17.0.13](https://www.oracle.com/java/technologies/javase-jdk17-downloads.html).
   - Set `JAVA_HOME`:
     - Identify the JDK installation path (e.g., `C:\Program Files\Java\jdk-17.0.13`).
     - Add it to your system's environment variables:
       - Open **System Properties > Environment Variables**.
       - Under **System Variables**, click **New** and set:
         - **Variable Name**: `JAVA_HOME`
         - **Variable Value**: `<JDK Installation Path>`
           
4. **Verify Android Setup:**
   - Run:
     ```bash
     flutter doctor
     ```

---

### 4. Clone the Repository
1. Open a terminal.
   
2. Navigate to the directory where you want to clone the repository.
   
3. Run:
   ```bash
   git clone https://github.com/NickolasChen04/easyPKU.git
   cd easyPKU

---

### 5. Open the Project in VS Code
1. Launch Visual Studio Code.
   
2. Open the cloned project directory.

---
   
### 6. Set Up Test Card for Google Pay

Join the Google Pay Developer Group to access test cards.

---

### 7. Install Flutter Dependencies
In VS Code, open the terminal (`Ctrl + ``).
- Run:
     ```bash
     flutter pub get
     ```

---

### 8. Launch the Emulator

1. In VS Code, press Ctrl + Shift + P to open the Command Palette.

2. Type Flutter: Launch Emulator and select it.

3. Choose the Medium Phone API 35 emulator from the list.

---

### 9. Run the Project
In VS Code, open the terminal (`Ctrl + ``).
   - Run:
     ```bash
     flutter run
     ```
