/// A macro that adds a `previews` property to a struct, derived from static, nonprivate view properties, contained by the struct.
/// source code that generated the value. 
///
/// For example,
/// ```swift
/// @AddPreviews
/// struct MyView_Previews: PreviewProvider {
///     static var stateOne: some View { MyView(state: .one) }
///     static var stateTwo: some View { MyView(state: .two) }
/// }
/// ```
///
/// produces
/// ```swift
/// @AddPreviews
/// struct MyView_Previews: PreviewProvider {
///     static var stateOne: some View { MyView(state: .one) }
///     static var stateTwo: some View { MyView(state: .two) }
///
///     static var previews: some View {
///         stateOne
///         stateTwo
///     }
/// }
/// ```
@attached(member, names: named(previews))
public macro AddPreviews() = #externalMacro(module: "AddPreviewsMacros", type: "AddPreviews")
