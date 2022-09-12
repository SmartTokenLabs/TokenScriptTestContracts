# How to create your August / Yale Door token controller.

First set up your Yale or August smart lock as normal and have a working installation.

To proceed you will need the following:

1. Rooted Android phone running at least Android 5 "Lollipop" OS.
2. ESP32 development board. You can obtain these from most electronics hobby shops (physical or online), eBay or AliExpress.
3. To operate the lock via TokenScript you will need a wallet that supports TokenScript and EIP5169. Currently only AlphaWallet for Android or iOS supports the standard.

Once you have these two pieces of equipment, you can begin to tokenise your lock.

To complete the setup we need the following information:

- ERC721 Token to make 'smart'.
- Cryptographic key for operating the Bluetooth interface for the lock
- A working WiFi you know the credentials for
- Firmware device Ethereum Address

Let's start by minting your token, since this is the easiest. You can either use an existing NFT you already have, or mint a new one. You can mint on OpenSea or just use our Token Minter.

## Mint the "Smart" Token

1. Go to https://jamessmartcell.github.io/
2. Connect the wallet, using WalletConnect or Web3. In doing so, you may be able to choose which chain you want to mint on. It is assumed you know how to obtain eth or testnet eth.
3. Make a note of the address on the site 'Next Contract Addr'.
4. Choose to 'Create TokenScript ERC721'
5. Approve the transaction in your wallet.
6. Once complete, find the contract address you minted and note it, if you didn't note it at step 3. Most wallets will let you find the token address.

## Determine the August or Yale lock cryptographic key

1. Install the official August or Yale app on the rooted phone.
2. Authorise the app to open your August/Yale lock.
3. Disable WiFi on the rooted phone and operate the lock a few times (this will make the app set up BlueTooth credentials).
4. Install the SmartLock decoder, you can either build from Gradle, AndroidStudio, install the pre-built APK or install from PlayStore:

GitHub source: https://github.com/JamesSmartCell/AugustLockCredentials
GitHub pre-built APK: https://github.com/JamesSmartCell/AugustLockCredentials/releases
Direct from PlayStore (at time of writing not yet published): https://play.google.com/store/apps/details?id=com.stormbird.augustcodereader

5. Open the Smartlock decoder app. If the phone is rooted and you have successfully used the bluetooth lock/unlock on the phone, you should see the credentials appear. If they haven't appeared then exit and go back to the August/Yale app, ensure WiFi is off, Bluetooth is on and lock/unlock a few more times.

Warning: These credentials are secret; do not publish them in any article as they could be used to operate your lock.

## Setup and flash the firmware on the ESP32 to find your device's public address.

1. Take the credentials from the previous step, go to VisualStudio Code and ensure PlatformIO is installed (Official Docs: https://docs.platformio.org/en/latest/integration/ide/vscode.html#installation video: https://www.youtube.com/watch?v=5edPOlQQKmo&t=1s)
2. Clone <this repo> on your PC, in the command line: git clone 
3. Open the project in VisualStudio Code.
4. Edit this line in main.cpp: 

AugustLock augustLock( ... );

You will take the credentials from the app result (you can copy/paste the credentials from the app) and write them in here:

AugustLock augustLock("BlueTooth Addr", "BlueTooth Key", Key Index);

It should look like this (with different values):

AugustLock augustLock("00:00:00:00:00:00", "1234567890ABCDEF1234567890ABCDEF", 4);

6. Edit the WiFi credentials so the device can connect to your WiFi.

7. Find the DOOR_CONTRACT define and change the address to the Token address from stage 3 or stage 6 of the 'Mint Token' stage. 

8. Plug in the ESP32 and determine the COM port, it should be in the range 1-20. For windows you can use the Device Manager, look under Ports (COM and LPT). The COM port should appear as something like 'Silicon Labs CP210x USB to UART'.
9. Edit the platform.io file in the project with your COM port. Note, sometimes this is not needed: PlatformIO can automatically detect the ESP32, but not always.
10. Run the firmware by clicking on the right arrow 'PlatformIO: Upload' command in the command pallette, usually at the bottom of the page.
11. Open the serial monitor by clicking on the plug icon (PlatformIO: Serial Monitor). In the feed you will see your device create its own Ethereum Address to uniquely identify itself on the TokenScript bridge. Make a note of this device address.

This is your firmware device's public address, it is not sensitive. It should appear like this in the Serial Monitor feed:

Device Address: 0xXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX

eg:

Device Address: 0xFFAEA1E8345FDEE60D01007BD9ADEA8070F09500

## Edit the TokenScript and lock or unlock the door.

1. Go to the TokenScript and edit the network and address on line 18. You will use the address of the token you minted at the first step (from jamessmartcell.github.io). If you don't know what the networkId for the network you minted on is, go here: https://chainlist.org/ and search for the name, Eg Rinkeby, Mainnet, Klaytn etc. If it's a testnet you'll need to switch on testnets.
2. Edit the IoT address at lines 63 and 159 and replace with your firmware Device Address, from the final step.

Send this file to your mobile device, you can email or I prefer to send it via the 'Saved Messages' in Telegram as it supports intent opening (which makes loading the TokenScript much easier). Once you send it, assuming you send via Telegram. Open the saved messages group on your mobile and click the xml file. One of the open intent apps should be AlphaWallet. Click that and allow AW to open and store the script.

Once installed, click on the Token in your wallet, and once on the NFT page you should have three new verbs, open, lock and mint. The TokenScript you installed adds these verbs and once clicked the JavaScript they contain is executed within the Webview hosted on the app.

Note: we also intend to create a server which automates most of these processes, and even allows you to add graphics. This one would incorporate the new standard EIP5169 which allows a wallet to automatically pick up the TokenScript from a contract call.