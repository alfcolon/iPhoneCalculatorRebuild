iPhone Calculator Rebuild
======
A reverse engineered first to ~~market~~ GitHub (🎉) near replica of the iPhone Calculator built entirely from scratch by moi! The Calculator App features a standard calculator accessible in portrait and a scientific calculator accessible in landscape.
<div align="center">
  <div style="display: flex; align-items: flex-start;">
    <img src="https://i.ibb.co/YjLqqLv/Screen-Shot-2020-10-15-at-4-58-41-PM.png" alt="Screen-Shot-2020-10-15-at-4-58-41-PM" height="400" width="700">
    <img src="https://i.ibb.co/YjKWtBb/Screen-Shot-2020-10-15-at-4-59-46-PM.png" alt="Screen-Shot-2020-10-15-at-4-59-46-PM" height="700" width="400">
  </div>
</div>

Demo 💃🏾
======
Erring on the side of caution, I won't even attempt to submit this to the App Store. Instead, a TestFlight beta testing app is on its way pending my escaping Apple's Developer Support limbo. In the mean time, I invite you to download this repositiory and open it with Xcode, Apple's Development software used to build Apple applications. In Xcode, you can simply press the play button on the upper-left corner of the screen to run the application simulator. You'll feel like a Developer doing it, it'll be fierce, I promise you!

<a href="https://apps.apple.com/us/app/xcode/id497799835?mt=12"><img src="https://upload.wikimedia.org/wikipedia/commons/thumb/1/1e/Xcode_Icon.png/1200px-Xcode_Icon.png" width="100" vertical-align="middle"></a>

Feature Overview
======
- [x] Add Displayed Number as Right Term
- [x] Continue Last Operation
- [x] Copy and Paste
- [x] Logic Autocorrect
- [x] Parenthetical and Precedence Total Displaying
- [x] Swipe to Delete

Feature Examples
======
### Add Displayed Number as Right Term
In the case where the last calculator entry was an operator and the "=" or ")" symbols are tapped, the number displayed will be added to the calculation to close the parenthetical stack or evaluate all expressions. Below are examples of this in action for an "=" and ")".
<img src="https://media.giphy.com/media/7LpkbWtP6TkbMkVPp4/giphy.gif" width="700" height="350"/>
<img src="https://media.giphy.com/media/SPuhY0TiLl7IvHj5ZD/giphy.gif" width="700" height="350"/>

### Continue Last Operation
To continue the last operation, simply continue tapping the "=" symbol.
My logic purposely differs from Apple's here. 
| Apple's Arithmetic Logic | My Arithmetic Logic
|------------------------|------------------------|
|1 + 2 + ( 3 × 4 xy 2 = =|1 + 2 + ( 3 × 4 xy 2 = =|
|1 + 2 + ( 3 × 16 = =|1 + 2 + ( 3 × 16 = =|
|1 + 2 + ( 48 = =|1 + 2 + ( 48 = =|
|3 + 48 = =|3 + 48 = =|
|51 = = |51 = =|
|(51xy2) =|(51 + 48) = |
|(2601) =|(99) = |
|(2601xy2)|(99 + 48)|
|6,765,201|147|
- __Apple's iPhone Calculator's Continued Arithmetic__
  The iPhone Calculator will set __xy__ as the final operation pressing "=" continues it
  - its input1 will be the evaluated total (51 first and 2601 second)
  - its input2 will remain 2
- __My iPhone Calculator Rebuild's Continued Arithmetic__
  Technically, since any parenthetical expression after the first parenthetical expression condences down to one term, I create a __final operation__ that takes an operator, left term and right term.
  - the operator is the last operator in the first parenthetical expression (+)
  - the left term is evaluated total of the first parenthetical expression (51)
  - the right term is the evaluated total of anything after the first parenthetical expression (48)

<img src="https://media.giphy.com/media/qpEunCShAigY9tkSFD/giphy.gif" width="700" height="350"/>

### Copy and Paste
Displayed numbers can be copied, pasted and used in calculations.
<img src="https://media.giphy.com/media/qki5V72m1qZ8Q8UCGK/giphy.gif" width="700" height="350"/>

### Logic Autocorrect
+ #### FunctionWithTwoInputs Added After an Operator
  With no input1 for the functionWithTwoInputs, the Calculator will correct this deleting the last operator, adding the last term as its input1 and replacing the last term
  ```bash
   1 + 2 + ( xy 3 =
   1 + ( 2xy3 =
   1 + 8 =
   9
  ```
  <img src="https://media.giphy.com/media/SpwoCKZj6RaOff5lJP/giphy.gif" width="700" height="300"/>

+ #### FunctionWithTwoInputs Added to an Empty Parenthetical Expression
  With no input1 for the functionWithTwoInputs, the Calculator will correct this deleting the last operator, moving the last term to the new parenthetical expression, adding the term as its input1 and acting as the first term in the new parenthetical expression.
  ```bash
   2 + xy 4 =
   2xy4 =
   16
  ```
  <img src="https://media.giphy.com/media/dLvjQcV7aSpUJRuSL9/giphy.gif" width="700" height="300"/>

+ #### Operator Following Operator
  Entering an operator following an operator will replace the previous operator with the new operator and display the appropiate parenthetical or precedence total.
  
  ```bash
   1 + - 3 =
   1 - 3 =
   -2
  ```
  <img src="https://media.giphy.com/media/5tTOvrT5z3sinHRPX6/giphy.gif" width="700" height="300"/>
  
+ #### Operator Added to an Empty Parenthetical Expression
  With no left term for the operator to operate on, the Calculator will correct this by retrieving the last term added and deleting the previous operator.
  ```bash
   1 × 2 × 3 + ( ( ) - 4 =
   1 × 2 × 3 + ( - 4 =
   1 × 2 × (3 - 4 =
   1 × 2 × (-1 =
   2 × ( -1 =
   2 × -1 =
   -2
  ```
  <img src="https://media.giphy.com/media/jRoNMpcq3AwAokCa3m/giphy.gif" width="700" height="300"/>

### Parenthetical and Precedence Total Displaying
A parenthetical or precedence total will be displayed when an operator is tapped. Actually, after a stroke of genius I realized that the left term is really what is being displayed but I'll save that explanation for another time. For now, an easy way to remember what is displayed is to remember that a precedence total is displayed when dividing or multiplying and a parenthetical total is displayed when adding or subtracting.
| Calculator Entries | Precedence Total Display | Parenthical Total Displayed | Calculator Entry Displayed
| ---------------    | :-------------: | :-------------: | :-------------: |
| 1                |                 |                 |               1|
| 1 +              |                 |                1|                |
| 1 + 2            |                 |                 |               2|
| 1 + 2 +          |                 |                3|                |
| 1 + 2 + 3        |                 |                 |               3|
| 1 + 2 + 3 +      |                 |                6|                |
| 1 + 2 + 3 + ×    |                3|                 |                |
| 1 + 2 + 3 + × +  |                 |                6|                |
| 1 + 2 + 3 + × + ×|                3|                 |                |
<img src="https://media.giphy.com/media/6Avtz8eU2e5kgBPHSp/giphy.gif" width="700" height="350"/>

### Swipe to Delete
Users can also delete numbers that they've entered in via left swiping. Once each number is deleted, a zero will replace the number. A negative sign can also be removed once all digits have been removed by swiping left on the negative symbol.

<img src="https://media.giphy.com/media/95etPFbzHGSAC8gPTi/giphy.gif" width="700" height="350"/>
