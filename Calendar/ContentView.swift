import SwiftUI

struct ContentView: View {
    @State private var currentDate = Date()
    @State private var daysInMonth = [String]()
    @State private var monthAndYear = ""
    
    let calendar = Calendar.current
    
    var body: some View {
        VStack {
            Text("Simple Calendar")
                .font(.largeTitle)
                .bold()
                .padding(.bottom, 10)
            
            Text(monthAndYear)
                .font(.title)
                .padding(.bottom, 10)
            
            HStack(spacing: 10) {
                ForEach(["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"], id: \.self) { day in
                    Text(day)
                        .frame(maxWidth: .infinity)
                        .font(.subheadline)
                }
            }
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 10), count: 7), spacing: 10) {
                ForEach(daysInMonth.indices, id: \.self) { index in
                    let day = daysInMonth[index]
                    let weekday = (index % 7) + 1
                    let today = calendar.component(.day, from: Date())
                    
                    Text(day)
                        .frame(width: 40, height: 40)
                        .background(
                            day == "\(today)" && calendar.isDate(currentDate, equalTo: Date(), toGranularity: .month)
                                ? Color.red.opacity(0.7)
                                : (weekday == 1 || weekday == 7
                                   ? Color.green.opacity(0.3)
                                   : Color.blue.opacity(0.2))
                        )
                        .cornerRadius(5)
                        .foregroundColor(day == "" ? .clear : .black)
                }
            }
            
            Spacer()
            
            HStack {
                Button(action: previousMonth) {
                    Text("Previous")
                        .padding()
                        .background(Color.blue.opacity(0.7))
                        .cornerRadius(10)
                        .foregroundColor(.white)
                }
                
                Spacer()
                
                Button(action: nextMonth) {
                    Text("Next")
                        .padding()
                        .background(Color.blue.opacity(0.7))
                        .cornerRadius(10)
                        .foregroundColor(.white)
                }
            }
            .padding(.horizontal)
        }
        .padding()
        .onAppear {
            updateCalendar()
        }
        .onChange(of: currentDate) {
            updateCalendar()
        }
    }
    
    func updateCalendar() {
        let components = calendar.dateComponents([.year, .month], from: currentDate)
        let year = components.year!
        let month = components.month!
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM yyyy"
        monthAndYear = dateFormatter.string(from: currentDate)
        
        let range = calendar.range(of: .day, in: .month, for: currentDate)!
        let days = Array(range)
        
        let firstDay = calendar.date(from: DateComponents(year: year, month: month, day: 1))!
        let firstWeekday = calendar.component(.weekday, from: firstDay)
        
        daysInMonth = Array(repeating: "", count: firstWeekday - 1) + days.map { "\($0)" }
    }
    
    func previousMonth() {
        if let newDate = calendar.date(byAdding: .month, value: -1, to: currentDate) {
            currentDate = newDate
        }
    }
    
    func nextMonth() {
        if let newDate = calendar.date(byAdding: .month, value: 1, to: currentDate) {
            currentDate = newDate
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
