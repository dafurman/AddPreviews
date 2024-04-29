// Created 4/28/24

import AddPreviews
import SwiftUI

struct MyView: View {
    @State private var firstName: String
    @State private var lastName: String
    var isSubmitDisabled: Bool {
        firstName.isEmpty || lastName.isEmpty
    }

    init(firstName: String = "", lastName: String = "") {
        self.firstName = firstName
        self.lastName = lastName
    }

    var body: some View {
        Form {
            Text("Tell me about yourself!")

            TextField("First Name", text: $firstName)
            TextField("Last Name", text: $lastName)

            Button("Submit") {
                //
            }
            .disabled(isSubmitDisabled)
        }
    }
}

@AddPreviews
struct MyView_Previews: PreviewProvider {
    static var unfilled: some View {
        MyView()
    }

    static var firstNameFilled: some View {
        MyView(firstName: "Foo")
    }

    static var lastNameFilled: some View {
        MyView(lastName: "Bar")
    }

    static var everythingFilled: some View {
        MyView(firstName: "Foo", lastName: "Bar")
    }
}
