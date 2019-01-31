# XcodeSourceEditTemplate

This project aims to demonstrate the use of Source Edit Extensions provided by Xcode to automate certain day to day coding practices we need as part of our development process. In this case we have an automatic initialiser created by just selecting the variables in the swift file. All of this is done by taking String inputs from the file and then utilising the selected text to retrieve the information we need. In this case we have to select the variables in the swift file and the selected text will create an automatic initialiser for you - Simple and easy.


Consider the following example.

# Any Swift file or Playground.
```
var name: String
var age: Double
```
- Select the above two variables
- Go to Editor
- You will see the name of the class.
- The initialiser will be created just below the variables.
```
init(name: String, age: Double) {
  self.name = name
  self.age = age
}
```
