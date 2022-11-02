**A Demo Structure Flutter project.**

```bash
├───android                             <-- Android related code
├───assets                              <-- Here we add app icons/image/fonts
│   ├───fonts
│   └───image
├───ios                                 <-- iOS related code
├───lib
│   ├───core                            <-- Core files of apps 
│   │   ├───db                          <-- Core files of apps 
│   │   ├───di
│   │   │   └───api                     <-- API configs
│   │   │       ├───interceptor         <-- API interceptors
│   │   │       ├───repo                <-- Repositories for API calls
│   │   │       ├───response            <-- Response parser fo API calls
│   │   │       │   ├───api_base        <-- Base response parser fo API calls
│   │   │       │   └───base            <-- Common response parser fo API calls
│   │   │       └───service             <-- Services for API calls
│   │   └───navigation                  <-- Navigation service related configs
│   ├───fcm                             <-- Fcm service related configs
│   ├───model                           <-- PODO models of API calls
│   ├───ui                              <-- App UI
│   │   ├───auth                        <-- App UI module
│   │   │   ├───login
│   │   │   │   └───store               <-- store for API call using Mobx structure
│   │   │   └───sign_up
│   │   └───home
│   ├───util                            <-- Utils/Helper
│   │   └───credit_card_validators      <-- Common credit card validator                     
│   ├───values                          <-- Common values, dummy data, App theme,style configs
│   │   └───extensions                  <-- Extension methods
│   └───widget                          <-- Common widgets
├───test                                <-- Widget, Unit, Integration test
└───web                                 <-- Web configs & web files
    └───icons                           <-- icons for web
```


## Environment

**Flutter version** : 3.3.6

**Flutter channel** : Stable

**iOS**
- iOS 11+

**Android**
- Android 5.0+
    - minSdkVersion 21
- targetSdkVersion 32

## Code Style
- [Effective Dart](https://dart.dev/guides/language/effective-dart)

## Assets, Fonts

**If added some assets or fonts**

- Use [AssetsRefGenerator](https://github.com/AndrewShen812/AssetsRefGenerator) **(lib/res.dart)**

## Models

**models for api results**

- Use [QuickType](https://app.quicktype.io/)

#### Architecture

|Working status|Category|Description|
|:---:|---|---|
| ✅ | Base | Using [Mobx](https://pub.dev/packages/mobx) + [build_runner](https://pub.dev/packages/build_runner)  
| ✅ | Networking | Using [dio](https://pub.dev/packages/dio) 
| ✅ | Data | Using [json serializable](https://pub.dev/packages/json_serializable) 
| ✅ | Session Management | Using [Hive](https://pub.dev/packages/hive)