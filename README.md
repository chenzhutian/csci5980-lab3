QuestCameraKit is a collection of template and reference projects demonstrating how to use Meta Quest’s new **Passthrough Camera API** `(PCA)` for advanced AR/VR vision, tracking, and shader effects.

# LLM+AR For CSCI 5980


----


# Table of Contents
- [Overview](#overview)
- [Getting Started with PCA](#getting-started-with-pca)
- [Running the Samples](#running-the-samples)
- [General Troubleshooting & Known Issues](#general-troubleshooting--known-issues)
- [Acknowledgements & Credits](#acknowledgements--credits)
- [Community Contributions](#community-contributions)
- [News](#news)
- [License](#license)
- [Contact](#contact)

# Overview

## 1. 🎨 Color Picker

- **Purpose:** Convert a 3D point in space to its corresponding 2D image pixel.
- **Description:** This sample shows the mapping between 3D space and 2D image coordinates using the Passthrough Camera API. We use MRUK's EnvironmentRaycastManager to determine a 3D point in our environment and map it to the location on our WebcamTexture. We then extract the pixel on that point, to determine the color of a real world object.

## 2. 🍎 Object Detection with Unity Sentis

- **Purpose:** Convert 2D screen coordinates into their corresponding 3D points in space.
- **Description:** Use the Unity Sentis framework to infer different ML models to detect and track objects. Learn how to convert detected image coordinates (e.g. bounding boxes) back into 3D points for dynamic interaction within your scenes. In this sample you will also see how to filter labels. This means e.g. you can only detect humans and pets, to create a more safe play-area for your VR game. The sample video below is filtered to monitor, person and laptop. The sample is running at around `60 fps`.

## 3. 📱 QR Code Tracking with ZXing

- **Purpose:** Detect and track QR codes in real time. Open webviews or log-in to 3rd party services with ease.
- **Description:** Similarly to the object detection sample, get QR code coordinated and projects them into 3D space. Detect QR codes and call their URLs. You can select between a multiple or single QR code mode. The sample is running at around `70 fps` for multiple QR codes and a stable `72 fps` for a single code.

## 4. 🪟 Shader Samples

- **Purpose:** Apply a custom shader effect to virtual surfaces.
- **Description:** A shader which takes our camera feed as input to manipulate the content behind it. Right now the project contains a Pixelate, Refract, Water, Zoom, and Blur effect. Frosted Glass shader is work in progress!

## 5. 🧠 OpenAI vision model

- **Purpose:** Ask OpenAI's vision model (or any other multi-modal LLM) for context of your current scene.
- **Description:** We use a the OpenAI Speech to text API to create a coommand. We then send this command together with a screenshot to the Vision model. Lastly, we get the response back and use the Text to speech API to turn the response text into an audio file in Unity to speak the response. The user can select different speakers, models, and speed. For the command we can add additional instructions for the model, as well as select an image, image & text, or just a text mode. The whole loop takes anywhere from `2-6 seconds`, depending on the internet connection.


## 6. 🎥 WebRTC video streaming

- **Purpose:** Stream the Passthrough Camera stream over WebRTC to another client using WebSockets.
- **Description:** This sample uses [SimpleWebRTC](https://assetstore.unity.com/packages/tools/network/simplewebrtc-309727), which is a Unity-based WebRTC wrapper that facilitates peer-to-peer audio, video, and data communication over WebRTC using [Unitys WebRTC package](https://docs.unity3d.com/Packages/com.unity.webrtc@3.0/manual/index.html). It leverages [NativeWebSocket](https://github.com/endel/NativeWebSocket) for signaling and supports both video and audio streaming. You will need to setup your own websocket signaling server beforehand, either online or in LAN. You can find more information about the necessary steps [here](https://www.youtube.com/watch?v=-CwJTgt_Z3M)

# Getting Started with PCA

| **Information**        | **Details**                                                                                                                                                                                             |
|------------------------|---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| **Device Requirements**| - Only for Meta `Quest 3` and `3s`<br>- `HorizonOS v74` or later                                                                                                                                        |
| **Unity WebcamTexture**| - Access through Unity’s WebcamTexture<br>- Only one camera at a time (left or right), a Unity limitation                                                                                               |
| **Android Camera2 API**| - Unobstructed forward-facing RGB cameras<br>- Provides camera intrinsics (`camera ID`, `height`, `width`, `lens translation & rotation`)<br>- Android Manifest: `horizonos.permission.HEADSET_CAMERA`  |
| **Public Experimental**| Apps using PCA are not allowed to be submitted to the Meta Horizon Store yet.                                                                                                                           |
| **Specifications**     | - Frame Rate: `30fps`<br>- Image latency: `40-60ms`<br>- Available resolutions per eye: `320x240`, `640x480`, `800x600`, `1280x960`                                                                     |

## Prerequisites

- **Meta Quest Device:** Ensure you are runnning on a `Quest 3` or `Quest 3s` and your device is updated to `HorizonOS v74` or later.
- **Unity:** Recommended is `Unity 6`. Also runs on Unity `2022.3. LTS`.
- **Camera Passthrough API does not work in the Editor or XR Simulator.**
- Get more information from the [Meta Quest Developer Documentation](https://developers.meta.com/horizon/documentation/unity/unity-pca-documentation)

> [!CAUTION]
> Every feature involving accessing the camera has significant impact on your application's performance. Be aware of this and ask yourself if the feature you are trying to implement can be done any other way besides using cameras.

## Installation
1. **Clone the Repository:**
   ```
   git clone https://github.com/xrdevrob/QuestCameraKit.git
   ```

2. **Open the Project in Unity:**
Launch Unity and open the cloned project folder.

3. **Configure Dependencies:**
Follow the instructions in the section below to run one of the samples.

# Running the Samples

## 1. **[Color Picker](https://github.com/xrdevrob/QuestCameraKit?tab=readme-ov-file#-color-picker)**
- Open the `ColorPicker` scene.
- Build the scene and run the APK on your headset.
- Aim the ray onto a surface in your real space and press the A button or pinch your fingers to observe the cube changing it's color to the color in your real environment.

## 2. **[Object Detection with Unity Sentis](https://github.com/xrdevrob/QuestCameraKit?tab=readme-ov-file#-object-detection-with-unity-sentis)**
- Open the `ObjectDetection` scene.
- You will need [Unity Sentis](https://docs.unity3d.com/Packages/com.unity.sentis@2.1/manual/get-started.html) for this project to run (com.unity.sentis@2.1.2).
- Select the labels you would like to track. No label means all objects will be tracked. <details>
  <summary>Show all available labels</summary>
  <table>
    <tr>
      <td>person</td>
      <td>bicycle</td>
      <td>car</td>
      <td>motorbike</td>
      <td>aeroplane</td>
      <td>bus</td>
      <td>train</td>
      <td>truck</td>
    </tr>
    <tr>
      <td>boat</td>
      <td>traffic light</td>
      <td>fire hydrant</td>
      <td>stop sign</td>
      <td>parking meter</td>
      <td>bench</td>
      <td>bird</td>
      <td>cat</td>
    </tr>
    <tr>
      <td>dog</td>
      <td>horse</td>
      <td>sheep</td>
      <td>cow</td>
      <td>elephant</td>
      <td>bear</td>
      <td>zebra</td>
      <td>giraffe</td>
    </tr>
    <tr>
      <td>backpack</td>
      <td>umbrella</td>
      <td>handbag</td>
      <td>tie</td>
      <td>suitcase</td>
      <td>frisbee</td>
      <td>skis</td>
      <td>snowboard</td>
    </tr>
    <tr>
      <td>sports ball</td>
      <td>kite</td>
      <td>baseball bat</td>
      <td>baseball glove</td>
      <td>skateboard</td>
      <td>surfboard</td>
      <td>tennis racket</td>
      <td>bottle</td>
    </tr>
    <tr>
      <td>wine glass</td>
      <td>cup</td>
      <td>fork</td>
      <td>knife</td>
      <td>spoon</td>
      <td>bowl</td>
      <td>banana</td>
      <td>apple</td>
    </tr>
    <tr>
      <td>sandwich</td>
      <td>orange</td>
      <td>broccoli</td>
      <td>carrot</td>
      <td>hot dog</td>
      <td>pizza</td>
      <td>donut</td>
      <td>cake</td>
    </tr>
    <tr>
      <td>chair</td>
      <td>sofa</td>
      <td>pottedplant</td>
      <td>bed</td>
      <td>diningtable</td>
      <td>toilet</td>
      <td>tvmonitor</td>
      <td>laptop</td>
    </tr>
    <tr>
      <td>mouse</td>
      <td>remote</td>
      <td>keyboard</td>
      <td>cell phone</td>
      <td>microwave</td>
      <td>oven</td>
      <td>toaster</td>
      <td>sink</td>
    </tr>
    <tr>
      <td>refrigerator</td>
      <td>book</td>
      <td>clock</td>
      <td>vase</td>
      <td>scissors</td>
      <td>teddy bear</td>
      <td>hair drier</td>
      <td>toothbrush</td>
    </tr>
  </table>
</details>

- Build the scene and run the APK on your headset. Look around your room and see how tracked objects receive a bounding box in accurate 3D space.

## 3. **[QR Code Tracking](https://github.com/xrdevrob/QuestCameraKit?tab=readme-ov-file#-qr-code-tracking-with-zxing)**
- Open the `QRCodeTracking` scene to test real-time QR code detection and tracking.
- Install [NuGet for Unity](https://github.com/GlitchEnzo/NuGetForUnity)
- Click on the `NuGet` menu and then on `Manage NuGet Packages`. Search for the [ZXing.Net package](https://github.com/micjahn/ZXing.Net/) from Michael Jahn and install it.
- Make sure in your `Player Settings` under `Scripting Define Symbols` you see `ZXING_ENABLED`. The ZXingDefineSymbolChecker class should automatically detect if `ZXing.Net` is installed and add the symbol.
- In order to see the label of your QR code, you will also need to install TextMeshPro!
- Build the scene and run the APK on your headset. Look at a QR code to see the marker in 3D space and URL of the QR code.

## 4. **[Shader Samples](https://github.com/xrdevrob/QuestCameraKit?tab=readme-ov-file#shader-samples)**
- Open the `Shader Samples` scene.
- Build the scene and run the APK on your headset.
- Look at the spheres from different angles and observe how objects behind it are changing.

> [!WARNING]  
> The Meta Project Setup Tool (PST) will show a warning and tell you to uncheck it, so do not fix this warning.

## 5. **[OpenAI vision model & voice commands](https://github.com/xrdevrob/QuestCameraKit?tab=readme-ov-file#-openai-vision-model)**
- Open the `ImageLLM` scene.
- Make sure to create an [API key](https://platform.openai.com/api-keys) and enter it in the `OpenAI Manager prefab`.
- Select your desired model and optionally give the LLM some instructions.
- Make sure your headset is connected to the internet (the faster the better).
- Build the scene and run the APK on your headset.

> [!NOTE]  
> File uploads are currently limited to `25 MB` and the following input file types are supported: `mp3`, `mp4`, `mpeg`, `mpga`, `m4a`, `wav`, and `webm`.

You can send commands and receive results in any of these languages:
<details>
  <summary>Show all suppported languages</summary>
<table>
  <tr>
    <td>Afrikaans</td>
    <td>Arabic</td>
    <td>Armenian</td>
    <td>Azerbaijani</td>
    <td>Belarusian</td>
    <td>Bosnian</td>
    <td>Bulgarian</td>
    <td>Catalan</td>
    <td>Chinese</td>
  </tr>
  <tr>
    <td>Croatian</td>
    <td>Czech</td>
    <td>Danish</td>
    <td>Dutch</td>
    <td>English</td>
    <td>Estonian</td>
    <td>Finnish</td>
    <td>French</td>
    <td>Galician</td>
  </tr>
  <tr>
    <td>German</td>
    <td>Greek</td>
    <td>Hebrew</td>
    <td>Hindi</td>
    <td>Hungarian</td>
    <td>Icelandic</td>
    <td>Indonesian</td>
    <td>Italian</td>
    <td>Japanese</td>
  </tr>
  <tr>
    <td>Kannada</td>
    <td>Kazakh</td>
    <td>Korean</td>
    <td>Latvian</td>
    <td>Lithuanian</td>
    <td>Macedonian</td>
    <td>Malay</td>
    <td>Marathi</td>
    <td>Maori</td>
  </tr>
  <tr>
    <td>Nepali</td>
    <td>Norwegian</td>
    <td>Persian</td>
    <td>Polish</td>
    <td>Portuguese</td>
    <td>Romanian</td>
    <td>Russian</td>
    <td>Serbian</td>
    <td>Slovak</td>
  </tr>
  <tr>
    <td>Slovenian</td>
    <td>Spanish</td>
    <td>Swahili</td>
    <td>Swedish</td>
    <td>Tagalog</td>
    <td>Tamil</td>
    <td>Thai</td>
    <td>Turkish</td>
    <td>Ukrainian</td>
  </tr>
  <tr>
    <td>Urdu</td>
    <td>Vietnamese</td>
    <td>Welsh</td>
    <td></td>
    <td></td>
    <td></td>
    <td></td>
    <td></td>
    <td></td>
  </tr>
</table>
</details>

## 6. **[WebRTC video streaming](https://github.com/xrdevrob/QuestCameraKit?tab=readme-ov-file#-webrtc-video-streaming)**

- Open the `Package Manager`, click on the + sign in the upper left/right corner.
	- Select "Add package from git URL".
	- Enter URL: https://github.com/endel/NativeWebSocket.git#upm and click in Install.
	- After the installation finished, click on the + sign in the upper left/right corner again.
	- Enter URL https://github.com/FireDragonGameStudio/SimpleWebRTC.git?path=/Assets/SimpleWebRTC#upm and click on Install
- Open the `WebRTC-Quest` scene.
- Link up your signaling server on the `Client-STUNConnection` component in the `Web Socket Server Address` field.
- Build and deploy the `WebRTC-Quest` scene to your Quest3 device.
- Open the `WebRTC-SingleClient` scene on your Editor.
- Build and deploy the `WebRTC-SingleClient` scene to another device or start it from within the Unity Editor. More information can be found [here](https://www.youtube.com/watch?v=-CwJTgt_Z3M)
- Start the WebRTC app on your Quest and on your other devices. Quest and client streaming devices should connect automatically to the websocket signaling server.
- Perform the Start gesture with your left hand, or press the menu button on your left controller to start streaming from Quest3 to your WebRTC client app.

**Troubleshooting**:
- If there are compiler errors, make sure all packages were imported correctly.
	- Open the `Package Manager`, click on the + sign in the upper left/right corner.
	- Select "Add package from git URL".
	- Enter URL: https://github.com/endel/NativeWebSocket.git#upm and click in Install.
	- After the installation finished, click on the + sign in the upper left/right corner again.
	- Enter URL https://github.com/FireDragonGameStudio/SimpleWebRTC.git?path=/Assets/SimpleWebRTC#upm and click on Install
	- Use the menu `Tools/Update WebRTC Define Symbol` to update the scripting define symbols if needed.
- Make sure your own websocket signaling server is up and running. You can find more information about the necessary steps [here](https://youtu.be/-CwJTgt_Z3M?t=1458).
- If you're going to stream over LAN, make sure the `STUN Server Address` field on `[BuildingBlock] Camera Rig/TrackingSpace/CenterEyeAnchor/Client-STUNConnection` is empty, otherwise leave the default value.
- Make sure to enable the `Web Socket Connection active` flag on `[BuildingBlock] Camera Rig/TrackingSpace/CenterEyeAnchor/Client-STUNConnection` to connect to the websocket server automatically on start.
- WebRTC video streaming does **NOT** work, when the **Graphics API** is set to **Vulkan**. Make sure to switch to **OpenGLES3** under `Project Settings/Player`.
- Make sure to **DISABLE** the **Low Overhead Mode (GLES)** setting for Android in `Project Settings/XR Plug-In Management/Oculus`. Otherwise this optimization will prevent your Quest from sending the video stream to a receiving client.

> [!WARNING] 
> The Meta Project Setup Tool (PST) will show 2 warnings (opaque textures and low overhead mode GLES). Do NOT fix this warnings.

# General Troubleshooting & Known Issues

- Some users have reported that the app crashes the second and every following time the app is opened. A solution described was to go to the Quest settings under `Privacy & Security` and toggle the camera permission and then start the app and accept the permission again. If you encounter this problem please open an issue and send me the crash logs. Thank you!
- If switching betwenn Unity 6 and other versions such as 2023 or 2022 it can happen that your Android Manifest is getting modified and the app won't run anymore. Should this happen to you make sure to go to `Meta > Tools > Update AndroidManifest.xml` or `Meta > Tools > Create store-compatible AndroidManifest.xml`. After that make sure you add back the `horizonos.permission.HEADSET_CAMERA` manually into your manifest file.

# Acknowledgements & Credits

- Thanks to **Meta** for the Passthrough Camera API and [**Passthrough Camera API Samples**](https://github.com/oculus-samples/Unity-PassthroughCameraApiSamples/).
- Thanks to shader wizard [Daniel Ilett](https://www.youtube.com/@danielilett) for helping me in the shader samples.
- Thanks to **[Michael Jahn](https://github.com/micjahn/ZXing.Net/)** for the XZing.Net library used for the QR code tracking samples.
- Thanks to **[Julian Triveri](https://github.com/trev3d/QuestDisplayAccessDemo)** for constantly pushing the boundaries with what is possible with Meta Quest hardware and software.
- Special thanks to [Markus Altenhofer](https://www.linkedin.com/in/markus-altenhofer-176453155/) from [FireDragonGameStudio](https://www.youtube.com/@firedragongamestudio) for contributing the WebRTC sample scene.
- Special thanks to [Thomas Ratliff](https://x.com/devtom7) for contributing his [shader samples](https://x.com/devtom7/status/1902033672041091453) to the repo.

# Community Contributions

- **Tutorials**
  - **XR Dev Rob - XR AI Tutorials**, [Watch on YouTube](https://www.youtube.com/watch?v=1z3pcMJbnRA)
  - **Dilmer Valecillos**, [Watch on YouTube](https://www.youtube.com/watch?v=lhnuP6lJ_yY)
  - **Skarredghost**, [Watch on YouTube](https://www.youtube.com/watch?v=A2ZhJt-SIBU)
  - **FireDragonGameStudio**, [Watch on YouTube](https://www.youtube.com/watch?v=1R9yrXePJ40)
  - **xr masiso**, [Watch on YouTube](https://www.youtube.com/watch?v=FXFgkAmvpgo)
  - **Urals Technologies**, [Watch on YouTube](https://www.youtube.com/playlist?list=PLU7W-ZU9OIiEanYEKtjyHQIoLrf0SflXx)

- **Object Detection**
  - [Udayshankar Ravikumar](https://x.com/uralstechCTO): [Unity Sentis Digit Recognition](https://x.com/uralstechCTO/status/1902056175153377353)
  - [Christoph Spinger](https://www.linkedin.com/in/christoph-spinger-280621190/): [Tracking a real ball and playing some XR football](https://www.linkedin.com/feed/update/urn:li:activity:7314282273791471616/)

- **Shaders**
  - [Thomas Ratcliff](https://x.com/devtom7): [Water, blur, zoom shaders](https://x.com/devtom7/status/1901384363658350612)
  - [Thomas Ratcliff](https://x.com/devtom7): [Pixelate shader](https://x.com/devtom7/status/1902033672041091453)
  - [Chukwfumnanya Christoph-Antoine Okafor](https://x.com/covetthatjam): [Frosted Glass Shader](https://x.com/covetthatjam/status/1902423661102923999)

- **Environment Understanding & Mapping**
  - [Takashi Yoshinaga](https://x.com/Taka_Yoshinaga): [Turning image into colored point cloud](https://x.com/Tks_Yoshinaga/status/1900923909962133782)
  - [Alireza Bahremand](https://x.com/lirezaBahremand): [Quest Passthrough to MAST3R-SLAM for scene ply distribution](https://x.com/lirezaBahremand/status/1901665472069902772)
  - [うえださん](https://x.com/ueda406): [3D Scanner](https://x.com/ueda406/status/1904771581135774042)
  - [Sander Sneek](https://www.linkedin.com/in/sandersneek/): [Mixed Reality Voxel Demo](https://www.linkedin.com/feed/update/urn:li:activity:7312869115583414273/)

- **Light Estimation**
  - [pjchardt on Reddit](https://www.reddit.com/user/pjchardt/): [Prototype combining real lights and virtual objects using light estimation to affect 3d environment.](https://www.reddit.com/r/OculusQuest/comments/1jlvy3o/meta_quest_cameraapi_prototype_combining_real/)

- **Environment Sampling**
  - [Christoph Spinger](https://www.linkedin.com/in/christoph-spinger-280621190/): [Chameleon color picker](https://www.linkedin.com/feed/update/urn:li:activity:7306688023843250176/)
  - [Sid Naik](https://www.linkedin.com/in/sidharthrnaik/): [Copy and paste the lighting in his house](https://www.linkedin.com/posts/sidharthrnaik_augmentedreality-virtualreality-vr-activity-7307523483318566912-NpGr/?utm_source=share&utm_medium=member_ios&rcm=ACoAACRDIgYBe94CQK8Ln4nJhdS1WdG2y9aZHYs)

- **Image to 3D**
  - [Takahiro Horikawa](https://x.com/thorikawa): [Replicate real objects into 3D](https://x.com/thorikawa/status/1901545245944455409)
  - [Matt Hudson](https://x.com/mechpil0t): [Augmented Reality clones](https://x.com/mechpil0t/status/1902879317803294773)
  - [Aman Bohra](https://www.linkedin.com/in/amanbohra/): [Turning drawings into 3D models](https://www.linkedin.com/feed/update/urn:li:activity:7310875897278918656/)

- **Image to Image, Diffusion & Generation**
  - [Hugues Bruyère](https://x.com/smallfly): [MR + Diffusion prototype](https://x.com/smallfly/status/1901403937321750862)
  - [Hugues Bruyère](https://x.com/smallfly): [SAM 2 to our workflow to segment people](https://x.com/smallfly/status/1903560186381377735)
  - [水マヨ](https://x.com/mizzmayo): [AI image description](https://x.com/mizzmayo/status/1901855438083359120)
  - [妹尾雄大](https://x.com/senooyudai): [Img2Img process of SDXL](https://x.com/senooyudai/status/1900799052054491421)
  - [Rolando Masís-Obando](https://www.linkedin.com/in/rmasiso): [Image to image with LCM and SDXL Turbo](https://www.linkedin.com/feed/update/urn:li:activity:7307797312158789632/)
 
- Video recording and replay
  - [Lucas Martinic](https://x.com/lucas_martinic): [Rewind what you saw](https://x.com/lucas_martinic/status/1902700951728693618)

- **OpenCV for Unity**
  - [Takashi Yoshinaga](https://x.com/Taka_Yoshinaga): [Using Passthrough Camera API with the OpenCV for Unity plugin](https://x.com/Tks_Yoshinaga/status/1901187442084098464)
  - [Takashi Yoshinaga](https://x.com/Taka_Yoshinaga): [OpenCV marker detection for object tracking](https://x.com/taka_yoshinaga/status/1901560686603387255)
  - [Takashi Yoshinaga](https://x.com/Taka_Yoshinaga): [OpenCV marker detection for multiple objects](https://x.com/Taka_Yoshinaga/status/1902700309933371558). You can find this project on his [GitHub Repo](https://github.com/TakashiYoshinaga/QuestArUcoMarkerTracking)
  - [Aurelio Puerta Martín](https://x.com/aurepuerta_dev): [OpenCV with multiple trackers](https://x.com/aurepuerta_dev/status/1905220037167751675)
  - [くりやま@システム開発](https://x.com/xamel7): [Positioning 3D objects on markers](https://x.com/xamel7/status/1904400697577394181)

- **QR Code Tracking**
  - [Christoph Spinger](https://www.linkedin.com/in/christoph-spinger-280621190/): [QR code object tracking](https://www.linkedin.com/feed/update/urn:li:activity:7306652200418598912/)
 
# News

- (Mar 21 2025) The Mysticle - [One of Quests Most Exciting Updates is Now Here!](https://www.youtube.com/watch?v=dG1rxxVDb9Y)
- (Mar 18 2025) Road to VR - [Meta Releases Quest Camera Access for Developers, Promising Even More Immersive MR Games](https://www.roadtovr.com/meta-releases-quest-camera-access-for-developers-promising-even-more-immersive-mixed-reality-games/)
- (Mar 17 2025) MIXED Reality News - [Quest developers get new powerful API for mixed reality apps](https://mixed-news.com/en/meta-quest-3-passthrough-camera-api-experimental-release/)
- (Mar 14 2025) UploadVR - [Quest's Passthrough Camera API Is Out Now, Though Store Apps Can't Yet Use It](https://www.uploadvr.com/quest-passthrough-camera-api-experimental-out-now/)
 
# License

This project is licensed under the MIT License. See the LICENSE file for details. Feel free to use the samples for your own projects, though I would appreciate if you would leave some credits to this repo in your work ❤️
