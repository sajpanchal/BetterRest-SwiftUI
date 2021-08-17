//
//  ContentView.swift
//  BetterRest
//
//  Created by saj panchal on 2021-06-04.
//

import SwiftUI

struct ContentView: View {
    @State var sleepAmount = 8.0
    @State var coffeeAmount = 1
    @State var alertTitle = ""
    @State var alertMessage = ""
    @State var showingAlert = false
    @State var stepperFlag = 0
    static var defaultWakeTime: Date {
        var components = DateComponents()
        components.hour = 7
        components.minute = 0
        return Calendar.current.date(from: components) ?? Date()
    }
    @State var wakeUp = defaultWakeTime
    var calculateBedTime: String {
        let components = Calendar.current.dateComponents([.hour,.minute], from: wakeUp)
         let hour = (components.hour ?? 0) * 60 * 60
         let minute = (components.minute ?? 0) * 60
         //this will instantiate our core ML model object.
         let model = BetterRest1()
         do {
         //create an instance from model.prediction method. this method takes 3 input parameters and returns the output prediction that is BedTime.
         let prediction = try model.prediction(wake: Double(hour + minute), estimatedSleep: sleepAmount, coffee: Double(coffeeAmount))
         let sleepTime = wakeUp - prediction.actualSleep
         let formatter = DateFormatter()
         formatter.timeStyle = .short
            return formatter.string(from: sleepTime)
        // alertTitle = "Your ideal bedtime is..."
        // alertMessage = formatter.string(from: sleepTime)
         }
         catch{
         //alertTitle = "Error"
         //alertMessage = "Something went wrong!"
            return "Something went wrong!"
         }
         //showingAlert = true
       
    }

    var body: some View {
        // stepper can be used to step up/down Int or Double values. they can have a value, range and step increment value.
        NavigationView {
            
            Form {
                Section(header: Text("When do you want to wake up?").font(.headline)) {
                    DatePicker("Select Date:", selection: $wakeUp, displayedComponents: .hourAndMinute).labelsHidden()
                }
                Section {
                    Section(header: Text("Desired amount of sleep:").font(.headline)) {
                        /*Stepper(value: $sleepAmount, in: 4...12 , step: 0.25) {
                            Text("\(sleepAmount, specifier: "%g") hrs")
                        }*/
                        Stepper(
                            onIncrement: {
                                sleepAmount += 0.25
                                stepperFlag = 1
                            },
                            onDecrement: {
                                sleepAmount -= 0.25
                                stepperFlag = -1
                            },
                            label: {
                                Text("\(sleepAmount, specifier: "%g") hrs").accessibility(hidden: true)
                            })
                            .accessibility(label: Text("Sleep Stepper"))
                            .accessibility(value: Text("\(stepperFlag == 1 ? "increase sleep time by 0.25 hours. Now set to \(sleepAmount) hours" : "decrease sleep time by 0.25 hours. Now set to \(sleepAmount) hours")"))
                       
                    }
                }
                Section {
                  
                        Picker("Number of coffee", selection: $coffeeAmount, content: {
                            ForEach(0..<21) {
                                Text("\($0) cups")
                            }
                        }).labelsHidden()
                        
                        
                       /* Stepper (value: $coffeeAmount, in: 1...20, step: 1) {
                            if coffeeAmount == 1 {
                                Text("\(coffeeAmount) cup")
                            }
                            else {
                                Text("\(coffeeAmount) cups")
                            }
                        }*/
                    
                }
                Section(header:Text("Calculated bedtime: ")) {
                   //Text(\(calculateBedTime))
                    Text(calculateBedTime)
                  //  Text("hello")
                }
               
            }/*.alert(isPresented: $showingAlert, content: {
                Alert(title: Text(alertTitle), message: Text(alertMessage), dismissButton: .default(Text("OK")))
            })*/
            .navigationBarTitle("BetterRest")
            //navigationBarItems
            //.navigationBarItems(trailing: Button("Calculate", action: calculateBedTime))
        }
    }
    /*func calculateBedTime() {
        let components = Calendar.current.dateComponents([.hour,.minute], from: wakeUp)
        let hour = (components.hour ?? 0) * 60 * 60
        let minute = (components.minute ?? 0) * 60
        //this will instantiate our core ML model object.
        let model = BetterRest1()
        do {
            //create an instance from model.prediction method. this method takes 3 input parameters and returns the output prediction that is BedTime.
            let prediction = try model.prediction(wake: Double(hour + minute), estimatedSleep: sleepAmount, coffee: Double(coffeeAmount))
            let sleepTime = wakeUp - prediction.actualSleep
            let formatter = DateFormatter()
            formatter.timeStyle = .short
            alertTitle = "Your ideal bedtime is..."
            alertMessage = formatter.string(from: sleepTime)
        }
        catch{
            alertTitle = "Error"
            alertMessage = "Something went wrong!"
          
        }
        showingAlert = true
    }*/
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
