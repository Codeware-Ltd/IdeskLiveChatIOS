# IdeskLiveChatIOS

The IdeskLiveChat iOS SDK allows you to easily integrate live chat functionality into your iOS application. This README provides an overview of how to use the library and get started with live chat in your app.

## Installation

## Swift Package Manager ##
1. Select Xcode -> File -> Swift Packages -> Add Package Dependency...
2. Enter https://github.com/Codeware-Ltd/IdeskLiveChatIOS
3. Click Next, then select the version, complete.

## Swift Package Manager ##
* iOS 14+

##  Usage ##
The chat feature returns you a view. You can use this view anywhere in your project. We prefer to use it on a full screen so that users can chat smoothly with space.

## Parameters ##
Pass IdeskAppData of object in the view. 

## Required fields ##
* resource_uri = String 
* app_uri = String
* page_id =  String 

## Optional fields ##
* Customer data 
    * var cusDictionary =  [String: Any]()
    * cusDictionary["name"] = "XXXX"
    * cusDictionary["rmn"] = "01XXXXXXXXXXX"
* miscellaneous data 
    * var miscellaneousDic =  [String: Any]()
    * miscellaneousDic["float"] = 0

## Permission ##
* Privacy - Camera Usage Description
* Privacy - Photo Library Usage Description


## Implementation ##

```
import SwiftUI
import IdeskLiveChatIOS

struct ContentView: View {
    
    
    var ideskAppData: IdeskAppData?
    
    init() {
                var cusDictionary =  [String: Any]()
                cusDictionary["name"] = "xxxx"
                cusDictionary["rmn"] = "01xxxxxx"
        
        
                var miscellaneousDic =  [String: Any]()
                miscellaneousDic["float"] = 0
        
                 ideskAppData = IdeskAppData(resource_uri: "xxxxxxxxx", app_uri: "xxxxxxxxx", page_id: "xxxxxxxx", customerInfo: cusDictionary, miscellaneousDic: miscellaneousDic)
    }
    var body: some View {
     
        NavigationView{
            VStack {
                IdeskLiveChatIOS(ideskAppData: ideskAppData!)
            }
            .navigationTitle("Sample Idesk Live Chat iOS")
            .navigationBarTitleDisplayMode(.inline)
   
        }
    }
    
}
```
