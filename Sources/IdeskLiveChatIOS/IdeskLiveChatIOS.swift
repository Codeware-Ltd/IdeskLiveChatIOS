import SwiftUI
public struct IdeskLiveChatIOS : View {
    
    @State private var showingAlert = false
    @State private var alertMessage = ""
    @State private var isAppeared = false
    

    @StateObject var dataFetcher = DataFetcher()
    
    var ideskAppData: IdeskAppData?
    
    public init(ideskAppData: IdeskAppData?){
        
        self.ideskAppData = ideskAppData
        
    }
    
    public var body: some View {
        
        
            ZStack{
                if dataFetcher.isLoading {
                    VStack(spacing: 20)  {
                        ProgressView()
                        Text("Loading")
                            .foregroundColor(.gray)
                        
                    }
                } else if dataFetcher.errorMessage != nil{
                    VStack {
                        
                        Image(systemName: "xmark.octagon.fill").resizable().foregroundColor(.black).frame(width: 60, height: 60)
                        
                        Text(dataFetcher.errorMessage ?? "").multilineTextAlignment(.center).padding(EdgeInsets(top: 10, leading: 0, bottom: 10, trailing: 0))
                        
                        Button {
                            
                            dataFetcher.getIdeskData(ideskAppdata: self.ideskAppData!)
                            
                        } label: {
                            Text("Retry").fontWeight(.bold).foregroundColor(.black)
                        }.padding().background(Color(hex: AppConstants.gray)).clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous ))
                        
                    }.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center).background(Color(hex: UInt(AppConstants.white)))
                }else {
                    
                
                        WebViewTS(ideskAppData: dataFetcher.ideskChatDataRes?.data ?? ""){ result in
                            print(result.isSuccess)
                            if result.isSuccess {
                                showingAlert = true
                                alertMessage = "Download Successful"
                        
                            }else {
                                showingAlert = true
                                alertMessage = "Download Failed"
                            }
                            
                        }
                 
                }
                
            }
            
            .alertPatched(isPresented: $showingAlert, content: {
               
                Alert(title: Text(self.alertMessage), dismissButton: .default(Text("Dissmiss")))
            })

        
            .onFirstAppear {

            dataFetcher.getIdeskData(ideskAppdata: ideskAppData!)
            isAppeared = true
        }
       
        
    }
}

//struct iDeskChatUIView_Previews: PreviewProvider {
//    static var previews: some View {
//        iDeskChatUIView()
//    }
//}

@available(macOS 10.15, *)
extension Color {
    init(hex: UInt, alpha: Double = 1) {
        self.init(
            .sRGB,
            red: Double((hex >> 16) & 0xff) / 255,
            green: Double((hex >> 08) & 0xff) / 255,
            blue: Double((hex >> 00) & 0xff) / 255,
            opacity: alpha
        )
    }
    
}

