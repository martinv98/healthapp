//
//  TaskEditView.swift
//  HealthAppTest
//
//  Created by Martin Varga on 23/02/2022.
//

import SwiftUI

let allGoals: [Goal] = [Goal(name: "Water"), Goal(name: "Steps"), Goal(name: "Heart Rate"), Goal(name: "Distance Running"), Goal(name: "Distance Swimming"), Goal(name: "Distance in wheelchair"), Goal(name: "Distance Cycling"), Goal(name: "Calories")]
//let goalNone: [Goal] = [Goal(name: "None")]

struct TaskEditView: View {
    
    @State var task = Task(name: "", servingGoals: SynData.shared.selectedGoals)
    
    /*init() {
        let previousSelectedTask = UserDefaults.standard.data(forKey: "selectedTask")
        var initialValue = Task(name: "", servingGoals: [goalNone[0]])
        if let exist = previousSelectedTask{
            initialValue = exist
        }
        _task = State<Task>(initialValue: initialValue)
    }*/

    var body: some View {
        Form {
            /*Section(header: Text("Name")) {
                TextField("e.g. Find a good Japanese textbook", text: $task.name)
            }*/

            Section(header: Text("Elements chosen to be synchronized")) {
                MultiSelector(
                    label: Text("Elements"),
                    options: allGoals,
                    optionToString: { $0.name },
                    selected: $task.servingGoals
                )
            }
        }
    }
}

struct TaskEditView_Previews: PreviewProvider {
    static var previews: some View {
        //NavigationView {
            TaskEditView()
        //}
    }
}
