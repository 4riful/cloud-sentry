### 🌩️ Cloud Sentry 

---

#### 🚀 Overview

**Cloud Sentry** is your go-to tool for monitoring and enumerating assets using the latest SNI (Server Name Indication) IP ranges. Designed for security researchers and penetration testers, this toolkit leverages a centralized, continuously updated repository of SNI data from `kaeferjaeger.gay`, making it easier than ever to discover assets associated with a specific domain. With automated downloads, intelligent file comparison, and precise filtering, Cloud Sentry ensures you always have the freshest data at your fingertips. 🔍

#### ✨ Features

- **📥 Automated Downloads**: Seamlessly download the latest SNI IP range files from leading cloud providers.
- **📊 Smart Comparison**: Automatically compare new downloads with existing data to ensure you're always working with the most current information.
- **🔎 Domain-Specific Filtering**: Zero in on the SNI IP ranges associated with any domain of your choice.
- **💻 User-Friendly Interface**: A simple, intuitive CLI experience with visual feedback for each step.

#### 🌐 Supported Cloud Providers

Cloud Sentry currently supports SNI IP ranges from these top cloud providers:
- ☁️ **Amazon**
- ☁️ **DigitalOcean**
- ☁️ **Google**
- ☁️ **Microsoft**
- ☁️ **Oracle**

#### 🛠️ Installation

1. **Clone the Repository**:
   ```bash
   git clone https://github.com/4riful/cloud-sentry.git
   cd cloud-sentry
   ```

2. **Make the Script Executable**:
   ```bash
   chmod +x main.sh
   ```

3. **Run the Script**:
   ```bash
   ./main.sh
   ```

#### ⚡ Usage

1. **📥 Download and Update SNI IP Ranges**:
   When you run Cloud Sentry, it automatically downloads the latest SNI IP ranges for all supported providers and updates them if there are any changes.

2. **🔍 Filter by Domain**:
   After downloading and updating, you’ll be prompted to enter a domain (e.g., `.example.com`). Cloud Sentry will filter the SNI IP ranges, revealing all associated subdomains.

3. **👁️ Review Output**:
   The filtered results will be displayed directly in the terminal, providing you with a comprehensive list of subdomains linked to your target domain.

#### 📄 Example

```bash
$ ./cloud-sentry.sh
🚀 Downloading amazon...
✅ amazon updated (size: 45231 bytes)
...
🔍 Filtering for domain: .example.com
subdomain1.example.com
subdomain2.example.com
...
🎉 Cloud Sentry tool completed!
```

#### 🌱 Contribution

We welcome your contributions! 💡 If you have ideas, suggestions, or improvements, feel free to open an issue or submit a pull request. Let's make Cloud Sentry even better together! 🤝

#### 📜 License

This project is licensed under the MIT License. Check out the [LICENSE](LICENSE) file for more details.

#### ⚠️ Disclaimer

Cloud Sentry is intended for ethical and legal use only. Ensure that you have proper authorization to access and analyze the domains targeted by this tool.

---

**Happy Hunting!** 🎯🚀
