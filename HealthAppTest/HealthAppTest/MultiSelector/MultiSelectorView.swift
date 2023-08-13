//
//  MultiSelectorView.swift
//  HealthAppTest
//
//  Created by Martin Varga on 23/02/2022.
//

import SwiftUI

struct MultiSelectionView<Selectable: Identifiable & Hashable>: View {
    let options: [Selectable]
    let optionToString: (Selectable) -> String

    @Binding var selected: Set<Selectable>

    var body: some View {
        List {
            ForEach(options) { selectable in
                Button(action: { toggleSelection(selectable: selectable) }) {
                    HStack {
                        Text(optionToString(selectable)).foregroundColor(.accentColor)
                        Spacer()
                        if selected.contains { $0.id == selectable.id } {
                            Image(systemName: "checkmark").foregroundColor(.accentColor)
                        }
                    }
                }.tag(selectable.id)
                    //.background(.black)
            }
        }.listStyle(GroupedListStyle())
    }

    private func toggleSelection(selectable: Selectable) {
        //print(SynData.shared.goalNone[0].id)
        if let existingIndex = selected.firstIndex(where: { $0.id == selectable.id }) {
            selected.remove(at: existingIndex)
            if selected.isEmpty == true{
                selected.insert(SynData.shared.goalNone[0] as! Selectable)
            }
        } else {
            selected.insert(selectable)
            if let indexOfNone = selected.firstIndex(where: { $0.id as! String == SynData.shared.goalNone[0].id }) {
                selected.remove(at: indexOfNone)
            }
        }
        SynData.shared.selectedGoals = selected as! Set<Goal>
        print(SynData.shared.selectedGoals)
        //print(selected)
        //SynData.shared.printVars()
    }
}

struct MultiSelectionView_Previews: PreviewProvider {
    struct IdentifiableString: Identifiable, Hashable {
        let string: String
        var id: String { string }
    }

    @State static var selected: Set<IdentifiableString> = Set(["A", "C"].map { IdentifiableString(string: $0) })

    static var previews: some View {
        NavigationView {
            MultiSelectionView(
                options: ["A", "B", "C", "D"].map { IdentifiableString(string: $0) },
                optionToString: { $0.string },
                selected: $selected
            )
        }
    }
}
