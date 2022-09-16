# How to create your August / Yale Door token controller.

First set up your Yale or August smart lock as normal and have a working installation.

To proceed you will need the following:

1. Rooted Android phone running at least Android 5 "Lollipop" OS.
2. ESP32 development board. You can obtain these from most electronics hobby shops (physical or online), eBay or AliExpress.

Once you have these two pieces of equipment, you can begin to tokenise your lock.

Let's start by finding the BlueTooth key credentials for your lock.

Full instructions for this are on the app repo page here: https://github.com/JamesSmartCell/AugustLockCredentials

In Brief: Install the decoder app by building from source or installing from here: https://play.google.com/store/apps/details?id=com.stormbird.augustcodereader

Operate the lock a few times with WiFi off, then run the app, and ensure you can see the lock details as shown in the screen.

With this you can now create the Smart Token to operate your lock.

Go to the SmartTokenFactory dapp here: http://smarttokenlabs.duckdns.org/

Follow the instructions, preferably from the AlphaWallet dapp browser so your token will appear in the wallet when you're done.

You do not need to type in your WiFi details and lock credentials into the dapp; but it makes it easier. You can simply take the source code the Creator dumps, copy it over the main.cpp in the project in this repo and fill those in once they're in your project. If you pasted them into the dapp then you're done.

At the end of the dapp you should have a smart token and some C++ source code which you can replace in the project in this repo.

Burn the firmware to your ESP32 and you should be able to lock/unlock the August/Yale from your AlphaWallet app using the new token straight away.
