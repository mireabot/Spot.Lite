//
//  ContentView.swift
//  Hack1
//
//  Created by Mikhail Kolkov  on 11.07.2020.
//  Copyright © 2020 MKM.LLC. All rights reserved.
//

import SwiftUI
import Combine

struct ContentView: View {
    @State var status = UserDefaults.standard.value(forKey: "status") as? Bool ?? false
    var body: some View {
           VStack{
               
               if status{
                   Home()
               }
               else{
                   
                   Login()
               }
               
           }.animation(.spring())
           .onAppear {
                   
               NotificationCenter.default.addObserver(forName: NSNotification.Name("statusChange"), object: nil, queue: .main) { (_) in
                   
                   let status = UserDefaults.standard.value(forKey: "status") as? Bool ?? false
                   self.status = status
               }
           }
            // for light status bar...
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
struct DataClass: Codable {
    let id: Int
    let token: String
}
struct ServerMessage1 : Decodable {
    let message: String
}
struct ServerMessage : Decodable {
    let status, message: String
    let data: DataClass
    
}
class NetworkManager: ObservableObject {
    var objectWillChange = PassthroughSubject<NetworkManager, Never>()

    var fetchedSongsResults = [Datum]() {
        willSet {
            objectWillChange.send(self)
        }
    }
    init() {
        fetchTest()
    }
    func fetchTest() {
        guard let url = URL(string: "https://hrspot.me/api/protest") else { return }
        var urlRequest = URLRequest(url: url)
        urlRequest.setValue("Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpZCI6N30.ZyrFzat4Og42ESS9qw0MJdpOsOu9k0C-B7t7iDBiv6s", forHTTPHeaderField: "Authorization")

      URLSession.shared.dataTask(with: urlRequest) { (data, response, error ) in
          guard let data = data else { return }
          let finalData = try! JSONDecoder().decode(ServerMessage1.self, from: data)
          print(finalData)
      }.resume()
    }
}

class HttpSendBar: ObservableObject {
    var didChange = PassthroughSubject<HttpSendBar, Never>()
    var auth = false {
        didSet {
            didChange.send(self)
        }
    }
    func checkDet(adaptability: String, creativity: String, enforceability: String, healthiness: String, intelligence: String, leadership_skills: String, loyalty: String, organizational_skills: String, sociability: String, diligence: String, user_id: String) {
        guard let url = URL(string: "https://hrspot.me/api/users/skillsbar") else { return }
        
        let body: [String: String] = ["user_id" : user_id, "adaptability" : adaptability, "creativity" : creativity, "enforceability" : enforceability, "healthiness" : healthiness, "intelligence" : intelligence, "leadership_skills" : leadership_skills, "loyalty" : loyalty, "organizational_skills" : organizational_skills, "sociability" : sociability, "diligence" : diligence]
        let finalBody = try! JSONSerialization.data(withJSONObject: body)
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = finalBody
        request.setValue("Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpZCI6N30.ZyrFzat4Og42ESS9qw0MJdpOsOu9k0C-B7t7iDBiv6s", forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request) { (data, response, error ) in
            guard let data = data else { return }
            let finalData = try! JSONDecoder().decode(ServerMessage1.self, from: data)
            print(finalData)
        }.resume()
    }
}
class HttpAuth: ObservableObject {
    var didChange = PassthroughSubject<HttpAuth, Never>()
    
    var auth = false {
        didSet {
            didChange.send(self)
        }
    }
    func checkDetails(email: String, password: String){
        guard let url = URL(string: "https://hrspot.me/api/auth") else { return }
        
        let body: [String: String] = ["email": email, "password" : password]
        let finalBody = try! JSONSerialization.data(withJSONObject: body)
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = finalBody
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        URLSession.shared.dataTask(with: request) { (data, response, error ) in
            guard let data = data else { return }
            let finalData = try! JSONDecoder().decode(ServerMessage.self, from: data)
            print(finalData)
        }.resume()
    }
}
class HttpReg: ObservableObject {
    var didChange = PassthroughSubject<HttpReg, Never>()
    var auth = false {
        didSet {
            didChange.send(self)
        }
    }
    func checkDetails(name: String, surname: String, email: String, password: String, photo: Image){
        guard let url = URL(string: "https://hrspot.me/api/register") else { return }
        
        let body: [String: Any] = ["email": email, "password" : password, "name" : name, "surname" : surname, "photo" : photo]
        let finalBody = try! JSONSerialization.data(withJSONObject: body)
        
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = finalBody
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        URLSession.shared.dataTask(with: request) { (data, response, error ) in
            guard let data = data else { return }
            let finalData = try! JSONDecoder().decode(ServerMessage.self, from: data)
            print(finalData)
        }.resume()
    }
}
struct Login : View {
    
    @State var email = ""
    @State var password = ""
    @State var msg = ""
    @State var alert = false
    var manager = HttpAuth()
    
    var body : some View{
        
        VStack{
            
            Image("Image")
            
            Text("Sign In").fontWeight(.heavy).font(.largeTitle).foregroundColor(.black)
            
            VStack {
                VStack (alignment: .leading){
                    
                    Text("E-mail").font(.headline).fontWeight(.light).foregroundColor(.black)
                    
                    HStack{
                        
                        TextField("Enter Your E-mail", text: $email)
                            .autocapitalization(.none)
                        
                        if email != ""{
                            
                            Image("check").foregroundColor(Color.init(.label))
                        }
                        
                    }
                    
                    Divider()
                    
                }.padding(.bottom, 15)
                
                VStack(alignment: .leading){
                    
                    Text("Password").font(.headline).fontWeight(.light).foregroundColor(.black)
                        
                    SecureField("Enter Your Password", text: $password)
                    
                    Divider()
                }

            }.padding(.horizontal, 6)
            
            Button(action: {
                
                print(self.email)
                print(self.password)
                self.manager.checkDetails(email: self.email, password: self.password)
                
                
                UserDefaults.standard.set(true, forKey: "status")
                NotificationCenter.default.post(name: NSNotification.Name("statusChange"), object: nil)
            }) {
                
                Text("Sign In").foregroundColor(.white).frame(width: UIScreen.main.bounds.width - 120).padding()
                
                
            }.background(
            
                LinearGradient(gradient: .init(colors: [.purple,.red]), startPoint: .leading, endPoint: .trailing)
            )
            .clipShape(Capsule())
            .padding(.top, 45)
            
            bottomView()
            
        }.padding()
        .alert(isPresented: $alert) {
                
            Alert(title: Text("Error"), message: Text(self.msg), dismissButton: .default(Text("Ok")))
        }
    }
}

struct bottomView : View{
    
    @State var show = false
    
    var body : some View{
        
        VStack{
            
            Text("(or)").foregroundColor(Color.gray.opacity(0.5)).padding(.top,30)
            
            HStack(spacing: 8){
                
                Text("Don't Have An Account ?").foregroundColor(Color.gray.opacity(0.5))
                
                Button(action: {
                    
                    self.show.toggle()
                    
                }) {
                    
                   Text("Join Us")
                    
                }.foregroundColor(.purple)
                
            }.padding(.top, 25)
            
        }.sheet(isPresented: $show) {
            
            Signup(show: self.$show)
        }
    }
}
struct ImagePicker : UIViewControllerRepresentable {
    
    @Binding var picker : Bool
    @Binding var imagedata : Data
    
    func makeCoordinator() -> ImagePicker.Coordinator {
        
        return ImagePicker.Coordinator(parent1: self)
    }
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<ImagePicker>) -> UIImagePickerController {
        
        let picker = UIImagePickerController()
        picker.sourceType = .photoLibrary
        picker.delegate = context.coordinator
        return picker
    }
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: UIViewControllerRepresentableContext<ImagePicker>) {
        
        
    }
    
    class Coordinator : NSObject,UIImagePickerControllerDelegate,UINavigationControllerDelegate{
        
        var parent : ImagePicker
        
        init(parent1 : ImagePicker) {
            
            parent = parent1
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            
            self.parent.picker.toggle()
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            
            
            let image = info[.originalImage] as! UIImage
            
            let data = image.jpegData(compressionQuality: 0.45)
            
            
            self.parent.imagedata = data!
            
            self.parent.picker.toggle()
        }
    }
}

struct Indicator : UIViewRepresentable {
    
    func makeUIView(context: UIViewRepresentableContext<Indicator>) -> UIActivityIndicatorView {
        
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.startAnimating()
        return indicator
    }
    
    func updateUIView(_ uiView: UIActivityIndicatorView, context: UIViewRepresentableContext<Indicator>) {
        
        
    }
}
struct Signup : View {
    @State var email = ""
    @State var password = ""
    @State var name = ""
    @State var surname = ""
    @State var alert = false
    @State var msg = ""
    @State var ret = ""
    @State var ret1 = ""
    @Binding var show : Bool
    @State var picker = false
    @State var imagedata : Data = .init(count: 0)
    @State var bar = false
    @Environment(\.presentationMode) var present
    var manager = HttpReg()
    var img = Image("Image")
    var body : some View{
        
        VStack{
                Image("Image1")
                Text("Registration").fontWeight(.heavy).font(.largeTitle)
                    .padding(.top, 30.0)
                
            HStack {
                Spacer()
                Button(action: {
                    
                    self.picker.toggle()
                    
                }) {
                    
                    if self.imagedata.count == 0{
                        
                       Image(systemName: "person.crop.circle.badge.plus").resizable().frame(width: 90, height: 70).foregroundColor(.gray)
                    }
                    else{
                        
                     Image(uiImage: UIImage(data: self.imagedata)!).resizable().renderingMode(.original).frame(width: 90, height: 90).clipShape(Circle())
                    }
                }
                    Spacer()
                }
                .padding(.vertical, 15)
            
                VStack(alignment: .leading){
                    
                    
                    VStack(alignment: .leading){
                        
                        Text("Name").font(.headline).fontWeight(.light).foregroundColor(Color.init(.label).opacity(0.75))
                        
                        HStack{
                            
                            TextField("Enter Your Name", text: $name)
                            
                            if email != ""{
                                
                                Image("check").foregroundColor(Color.init(.label))
                            }
                            
                        }
                        
                        Divider()
                        
                    }.padding(.bottom, 15)
                    
                    VStack(alignment: .leading){
                        
                        Text("Surname").font(.headline).fontWeight(.light).foregroundColor(Color.init(.label).opacity(0.75))
                        
                        HStack{
                            
                            TextField("Enter Your Surname", text: $surname)
                            
                            if surname != ""{
                                
                                Image("check").foregroundColor(Color.init(.label))
                            }
                            
                        }
                        
                        Divider()
                        
                    }.padding(.bottom, 15)
                    
                    VStack(alignment: .leading){
                        
                        Text("E-mail").font(.headline).fontWeight(.light).foregroundColor(Color.init(.label).opacity(0.75))
                        
                        HStack{
                            
                            TextField("Enter Your E-mail", text: $email)
                                .autocapitalization(.none)
                            
                            if email != ""{
                                
                                Image("check").foregroundColor(Color.init(.label))
                            }
                            
                        }
                        
                        Divider()
                        
                    }.padding(.bottom, 15)
                    
                    VStack(alignment: .leading){
                        
                        Text("Password").font(.headline).fontWeight(.light).foregroundColor(Color.init(.label).opacity(0.75))
                            
                        SecureField("Enter Your Password", text: $password)
                        
                        Divider()
                    }

                }.padding(.horizontal, 6)
            
                    Button(action: {
                        UserDefaults.standard.set(self.name, forKey: "Name")
                        UserDefaults.standard.set(self.surname, forKey: "Surname")
                        UserDefaults.standard.set(self.email, forKey: "Email")
                        print(self.name)
                        print(self.surname)
                        print(self.email)
                        print(self.password)
                        print(self.img)
                       // self.manager.checkDetails(name: self.name, surname: self.surname, email: self.email, password: self.password,photo: Image("profile"))
                        //self.manager.checkDetails1(photo: self.img)
                        
                        //if self.manager.auth {
                            
                            UserDefaults.standard.set(true, forKey: "status")
                            
                          //  self.show.toggle()
                            
                            NotificationCenter.default.post(name: NSNotification.Name("statusChange"), object: nil)
                            
                       // }
                }) {
                    
                    Text("Join Us").foregroundColor(.white).frame(width: UIScreen.main.bounds.width - 120).padding()
                    
                    
                }.background(
                
                    LinearGradient(gradient: .init(colors: [.purple, .red]), startPoint: .leading, endPoint: .trailing)
                )
                .clipShape(Capsule())
                .padding(.top, 45)
                .opacity((self.name == "" || self.surname == "" || self.email == "" || self.password == "") ? 0.35 : 1)
                .disabled((self.name == "" || self.surname == "" || self.email == "" || self.password == "") ? true : false)
            
            
        }
        .padding()
            .sheet(isPresented: self.$picker, content: {
                
                ImagePicker(picker: self.$picker, imagedata: self.$imagedata)
            })
        .alert(isPresented: $alert) {
                
            Alert(title: Text("Error"), message: Text(self.msg), dismissButton: .default(Text("Ok")))
        }
        
    }
}
struct Home : View {
    @State var isBar = false
    @State var index = 0
    @State var isSet = false
    @State var isTest = false
    var name: String = UserDefaults.standard.value(forKey: "Name") as! String
    var surname: String = UserDefaults.standard.value(forKey: "Surname") as! String
    var email: String = UserDefaults.standard.value(forKey: "Email") as! String
    var body: some View{
        VStack{
            
            HStack(spacing: 15){
                
                Text("Profile")
                    .font(.title)
                
                Spacer(minLength: 0)
                Button(action: {
                    self.isSet.toggle()
                }) {
                    Image(systemName: "gear")
                }.sheet(isPresented: $isSet){
                    Setting()
                }
            }
            .padding()
            
            HStack{
                
                VStack(spacing: 0){
                    
                    Rectangle()
                    .fill(Color("Color"))
                    .frame(width: 80, height: 3)
                    .zIndex(1)
                    
                    
                    // going to apply shadows to look like neuromorphic feel...
                    
                    Image("profile")
                    .resizable()
                    .frame(width: 100, height: 100)
                    .padding(.top, 6)
                    .padding(.bottom, 4)
                    .padding(.horizontal, 8)
                    .background(Color("Color1"))
                    .cornerRadius(10)
                    .shadow(color: Color.black.opacity(0.1), radius: 5, x: 8, y: 8)
                    .shadow(color: Color.white.opacity(0.5), radius: 5, x: -8, y: -8)
 
                }
                
                VStack(alignment: .leading, spacing: 12){
                    
                    Text("\(name)")
                        .font(.title)
                        .foregroundColor(Color.black.opacity(0.8))
                    
                    Text("\(surname)")
                        .font(.title)
                        .foregroundColor(Color.black.opacity(0.8))
                        .padding(.top, -8)
                    
                    Text("\(email)")
                        .foregroundColor(Color.black.opacity(0.7))
                }
                .padding(.leading, 20)
                
                Spacer(minLength: 0)
            }
            .padding(.horizontal, 20)
            .padding(.top, 10)
            
        
            HStack(spacing: 20){
                
                VStack(spacing: 12){
                    
                    Image(systemName: "chart.bar.fill")
                    .resizable()
                    .frame(width: 80, height: 80)
                    
                    Text("Skills Bar")
                        .font(.title)
                        .padding(.top,10)
                    Button(action: {
                        self.isBar.toggle()
                    }){
                        
                        Text("Open").foregroundColor(.gray)
                    }.sheet(isPresented: $isBar){
                        Skills_Bar()
                    }
                }
                .padding(.vertical)
                // half screen - spacing - two side paddings = 60
                .frame(width: (UIScreen.main.bounds.width - 60) / 2)
                .background(Color("Color1"))
                .cornerRadius(15)
                .shadow(color: Color.black.opacity(0.1), radius: 5, x: 8, y: 8)
                .shadow(color: Color.white.opacity(0.5), radius: 5, x: -8, y: -8)
                // shadows...
                
                VStack(spacing: 12){
                    
                    Image(systemName: "pencil.circle.fill")
                    .resizable()
                    .frame(width: 80, height: 80)
                    
                    Text("Pro-Testing")
                        .font(.title)
                        .padding(.top,10)
                    
                    Button(action: {
                        self.isTest.toggle()
                    }){
                        Text("Open").foregroundColor(.gray)
                    }.sheet(isPresented: $isTest){
                        Questions()
                    }
                }
                .padding(.vertical)
                // half screen - spacing - two side paddings = 60
                .frame(width: (UIScreen.main.bounds.width - 60) / 2)
                .background(Color("Color1"))
                .cornerRadius(15)
                .shadow(color: Color.black.opacity(0.1), radius: 5, x: 8, y: 8)
                .shadow(color: Color.white.opacity(0.5), radius: 5, x: -8, y: -8)
                // shadows...
                
            }
            .padding(.top,20)
            
            HStack(spacing: 20){
                
                VStack(spacing: 12){
                    
                    Image(systemName: "mappin.circle.fill")
                    .resizable()
                    .frame(width: 80, height: 80)
                    
                    Text("Spot")
                        .font(.title)
                        .padding(.top,10)
                    
                    
                    Text("Comming soon")
                        .font(.caption)
                        .foregroundColor(.gray)
                }
                .padding(.vertical)
                // half screen - spacing - two side paddings = 60
                .frame(width: (UIScreen.main.bounds.width - 60) / 2)
                .background(Color("Color1"))
                .cornerRadius(15)
                .shadow(color: Color.black.opacity(0.1), radius: 5, x: 8, y: 8)
                .shadow(color: Color.white.opacity(0.5), radius: 5, x: -8, y: -8)
                // shadows...
                
            }
            .padding(.top,20)
            
            Spacer(minLength: 0)
        }
        .background(Color(.white).edgesIgnoringSafeArea(.all))
        
    }
}
struct type : Identifiable {
        var id : Int
        var percent : CGFloat
        var name : Image
}
var percents = [
    
    type(id: 0, percent: 14, name: Image("Adaptability")),
    type(id: 1, percent: 54, name: Image("Creativity")),
    type(id: 2, percent: 64, name: Image("Enforceability")),
    type(id: 3, percent: 70, name: Image("Healthiness")),
    type(id: 4, percent: 79, name: Image("Intelligence")),
    type(id: 5, percent: 90, name: Image("Leadership Skills")),
    type(id: 6, percent: 34, name: Image("Loyalty")),
    type(id: 7, percent: 69, name: Image("Organizational Skills")),
    type(id: 8, percent: 40, name: Image("Sociability")),
    type(id: 9, percent: 46, name: Image("Diligence"))
    
    ]

struct Bar : View {
    @State var percent : CGFloat = 0
    
    var body: some View {
        VStack{
            
            Text(String(format: "%.0f", Double(percent))).foregroundColor(Color.black.opacity(0.5))
            Rectangle().fill(Color.purple).frame(width: UIScreen.main.bounds.width / 10 - 9, height: getHeight())
        }
    }
    func getHeight()->CGFloat {
        return 200 / 100 * percent
    }
}
struct Info : View {
    var body: some View {
        ScrollView(.vertical, showsIndicators: false){
        VStack(alignment: .leading, spacing: 10){
            VStack(alignment: .leading, spacing: 20){
                Image("Adaptability")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 50, height: 50)
                Text("Адаптивность")
                    .foregroundColor(.gray)
                    .font(.callout)
                Text("Способность быстро подстраиваться под меняющиеся условия")
                    .font(.subheadline)
            }.padding(12)
            Divider()
            VStack(alignment: .leading, spacing: 20){
                Image("Creativity")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 50, height: 50)
                Text("Креативность")
                    .foregroundColor(.gray)
                    .font(.callout)
                Text("Способность к поиску новых решений")
                    .font(.subheadline)
            }.padding(12)
            Divider()
            VStack(alignment: .leading, spacing: 20){
                Image("Enforceability")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 50, height: 50)
                Text("Исполнительность")
                    .foregroundColor(.gray)
                    .font(.callout)
                Text("Способность четко следовать указаниям")
                    .font(.subheadline)
            }.padding(12)
            Divider()
            VStack(alignment: .leading, spacing: 20){
                Image("Enforceability")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 50, height: 50)
                Text("Исполнительность")
                    .foregroundColor(.gray)
                    .font(.callout)
                Text("Способность четко следовать указаниям")
                    .font(.subheadline)
            }.padding(12)
            Divider()
            VStack(alignment: .leading, spacing: 20){
                Image("Healthiness")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 50, height: 50)
                Text("Здоровье")
                    .foregroundColor(.gray)
                    .font(.callout)
                Text("Совокупность факторов здорового образа жизни")
                    .font(.subheadline)
            }.padding(12)
            Divider()
            }
        }
    }
}
struct Skills_Bar : View {
    @State private var isForm = false
    @State private var isInfo = false
    var body: some View {
        VStack{
            HStack {
                Button(action: {
                    self.isForm.toggle()
                }){
                    Text("Edit")
                    .foregroundColor(.white)
                    .fontWeight(.bold)
                    .padding(.vertical)
                    .frame(width: 150)
                    .background(Color.purple)
                    .clipShape(Capsule())
                    .padding(12)
                }
                    .padding(.top, -200)
                    .sheet(isPresented: $isForm){
                        setB()
                }
                Spacer()
                Button(action: {
                    self.isInfo.toggle()
                }){
                    Image(systemName: "info.circle.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 30, height: 30)
                    .padding(12)
                }.sheet(isPresented: $isInfo){
                    Info()
                }
                .padding(.top, -190)
            }
            VStack {
        HStack(alignment: .bottom, spacing: 8) {
            ForEach(percents){ i in
                Bar(percent: i.percent)
            }
        }.frame(height: 250)
        HStack(alignment: .bottom, spacing: 9){
            Image("Adaptability")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: 30, height: 30)
            Image("Creativity")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: 30, height: 30)
            Image("Enforceability")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: 30, height: 30)
            Image("Healthiness")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: 30, height: 30)
            Image("Intelligence")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: 30, height: 30)
            Image("Leadership Skills")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: 30, height: 30)
            Image("Loyalty")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: 30, height: 30)
            Image("Organizational Skills")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: 30, height: 30)
            Image("Sociability")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: 30, height: 30)
            Image("Diligence")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: 30, height: 30)
                }
            }
        }
    }
}
struct setB : View {
    @State var c1 : String = ""
    @State var c2 : String = ""
    @State var c3 : String = ""
    @State var c4 : String = ""
    @State var c5 : String = ""
    @State var c6 : String = ""
    @State var c7 : String = ""
    @State var c8 : String = ""
    @State var c9 : String = ""
    @State var c10 : String = ""
    @State var skill = false
    var managerBar = HttpSendBar()
    var user_id = 7
    @Environment(\.presentationMode) var Present
    //@State var user =
    var body: some View {
        VStack(alignment: .leading){
            Form {
                Section {
                    Text("Adaptability")
                        .fontWeight(.bold)
                        .font(.system(size: 20))
                    TextField("Enter percent", text: $c1).keyboardType(.decimalPad)
                }
                Section {
                    Text("Creativity")
                        .fontWeight(.bold)
                        .font(.system(size: 20))
                    TextField("Enter percent", text: $c2).keyboardType(.decimalPad)
                }
                Section {
                    Text("Enforceability")
                        .fontWeight(.bold)
                        .font(.system(size: 20))
                    TextField("Enter percent", text: $c3).keyboardType(.decimalPad)
                }
                Section {
                    Text("Healthiness")
                        .fontWeight(.bold)
                        .font(.system(size: 20))
                    TextField("Enter percent", text: $c4).keyboardType(.decimalPad)
                }
                Section {
                    Text("Intelligence")
                        .fontWeight(.bold)
                        .font(.system(size: 20))
                    TextField("Enter percent", text: $c5).keyboardType(.decimalPad)
                }
                Section {
                    Text("Leadership Skills")
                        .fontWeight(.bold)
                        .font(.system(size: 20))
                    TextField("Enter percent", text: $c6).keyboardType(.decimalPad)
                }
                Section {
                    Text("Loyalty")
                        .fontWeight(.bold)
                        .font(.system(size: 20))
                    TextField("Enter percent", text: $c7).keyboardType(.decimalPad)
                }
                Section {
                    Text("Organizational Skills")
                        .fontWeight(.bold)
                        .font(.system(size: 20))
                    TextField("Enter percent", text: $c8).keyboardType(.decimalPad)
                }
                Section {
                    Text("Sociability")
                        .fontWeight(.bold)
                        .font(.system(size: 20))
                    TextField("Enter percent", text: $c9).keyboardType(.decimalPad)
                }
                Section {
                    Text("Diligence")
                        .fontWeight(.bold)
                        .font(.system(size: 20))
                    TextField("Enter percent", text: $c10).keyboardType(.decimalPad)
                }
            }
            Button(action: {
                self.Present.wrappedValue.dismiss()
                self.managerBar.checkDet(adaptability: "\(self.c1)", creativity: "\(self.c2)", enforceability: "\(self.c3)", healthiness: "\(self.c4)", intelligence: "\(self.c5)", leadership_skills: "\(self.c6)", loyalty: "\(self.c7)", organizational_skills: "\(self.c8)", sociability: "\(self.c9)", diligence: "\(self.c10)", user_id: "\(self.user_id)")
            }) {
                Text("Submit")
                .foregroundColor(.white)
                .fontWeight(.bold)
                .padding(.vertical)
                .frame(width: 150)
                .background(Color.purple)
                .clipShape(Capsule())
                .padding(12)
            }
            
        }
    }
}
struct Testing: View {
    @Binding var percent : CGFloat
    var body: some View{
        ZStack(alignment: .leading){
            ZStack(alignment: .trailing){
                Capsule().fill(Color.black.opacity(0.08))
                    .frame(height: 22)
                Text(String(format: "%.0f", self.percent * 100) + "%").font(.caption).foregroundColor(Color.gray.opacity(0.75)).padding(.trailing)
            }
            Capsule().fill(LinearGradient(gradient: .init(colors: [Color.purple,Color.red]), startPoint: .leading, endPoint: .trailing))
                .frame(width: self.calPercent(), height: 22)
        }.padding(18)
            .background(Color.black.opacity(0.085))
            .cornerRadius(15)
    }
    func calPercent()->CGFloat {
        let width = UIScreen.main.bounds.width - 66
        return width * self.percent
    }
}
struct Questions : View {
    @State var CurrentText = 0
    @State var percent : CGFloat = 0
    @State var count : Int = 0
    @State var load = false
    var body: some View {
        var adapt : CGFloat = 0
        return ZStack {
            VStack(spacing: 20) {
            Button(action: {
                self.load.toggle()
                if self.CurrentText < 3 {
                    self.CurrentText += 1
                }
            }){
                Text("Next")
                .foregroundColor(.white)
                .fontWeight(.bold)
                .padding(.vertical)
                .frame(width: 90)
                .background(Color.purple)
                .clipShape(Capsule())
                .padding(12)
            }
                .animation(.spring())
            ZStack {
                if CurrentText == 0{
                    Text("У вас есть опыт работы по управлению командой?")
                    .fontWeight(.semibold)
                }
                else if CurrentText == 1 {
                    Text("Вы общаетесь со своими коллегами?")
                    .fontWeight(.semibold)
                }
                else {
                    Text("Вы присматриваетесь к новым способам решения задач?")
                    .fontWeight(.semibold)

                }
            }
            Button(action: {
                    adapt += 1.0
                    self.percent += 0.01
                    self.count += 1
                }){
                    Text("Да")
                    .foregroundColor(.white)
                    .fontWeight(.bold)
                    .padding(.vertical)
                    .frame(width: 150)
                    .background(Color.purple)
                    .cornerRadius(30)
                }
                Button(action: {
                    adapt += 0.5
                     self.percent += 0.01
                    self.count += 1
                }){
                    Text("Отчасти")
                    .foregroundColor(.white)
                    .fontWeight(.bold)
                    .padding(.vertical)
                    .frame(width: 150)
                    .background(Color.purple)
                    .cornerRadius(30)
                }
                Button(action: {
                    adapt += 0
                     self.percent += 0.01
                    self.count += 1
                }){
                    Text("Нет")
                    .foregroundColor(.white)
                    .fontWeight(.bold)
                    .padding(.vertical)
                    .frame(width: 150)
                    .background(Color.purple)
                    .cornerRadius(30)
                    }
            Spacer(minLength: 0)
            Button(action: {
            }){
                Text("Send")
                .foregroundColor(.white)
                .fontWeight(.bold)
                .padding(.vertical)
                .frame(width: 150)
                .background(Color.purple)
                .cornerRadius(30)
                }.opacity((self.count != 100) ? 0.35 : 1)
                .disabled((self.count != 100) ? true : false)
            
                Spacer(minLength: 0)
                Testing(percent: self.$percent).padding(.top, -50)
            }.padding()
        }
    }
}
struct Setting: View {
    var body: some View {
        VStack {
            Button(action: {
                UserDefaults.standard.set(false, forKey: "status")
                NotificationCenter.default.post(name: NSNotification.Name("statusChange"), object: nil)
            }){
                Text("LOG OUT")
            }
        }
    }
}
