# C\# Convention and Style Guide
## General
* Methods and control statements should use the [Allman/BSD](https://en.wikipedia.org/wiki/Indentation_style#Allman_style) bracing style, which dictates the opening brace should be on the following line at the same indentation level as the control statement.
* "Hard Tabs" should be used for indentation, which means actual tab characters are recorded into the source file. Standard tab width should be two spaces, but can be configured by individual developers in their editor of choice.
* There should be **no** space between a method name and its parentheses in a method definition or call.
* There **should** be a single space between control statements and their parentheses
* A closing brace for a method call or control statement should immediately be followed by a new line.
	* This means `else` and `else if` statements are to be made on the next line after the preceding `if/else/elseif`'s closing brace
* Separating new lines within an indented class body, method body, et al should be completely empty; i.e. there should be no indentation whitespace.
* There are no restrictions/suggestions on visually separating lines within a control or method body, or between control or method statements. Use new lines at your own discretion to visually group and separate code logic.

### Example: General
```csharp
// Method declaration: no space between method name and parentheses
public void Greet(string name, int excitementLevel)
{
	// Method call, no space between method name and parentheses
	Console.Write($"Hello, {name}");
	// Below newline is completely empty; no indentation characters present

	// Control statement, space between statement and parentheses
	if (excitementLevel > 0)
	{
		for (var i = 0; i < excitementLevel; i++)
		{
			Console.Write("!");
		}
	} // else if is placed on next line, not this one
	else if (excitementLevel < 0)
	{
		for (var i = excitementLevel; i > 0; i++)
		{
			Console.Write(":(");	
		}
	}
	else
	{
		Console.Write(".");
	}

	Console.WriteLine();
}
```
## Methods
* Methods use PascalCase capitalization
* Method calls and definitions have no space between the method name and the parentheses
* Method parameters use camelCase capitalization
* Event handler methods should begin with "On", e.g. `OnEventHappens()`
* See `Greet()` above which follows these conventions
## Variables
* Variable naming conventions depend on their access level and data type
	* Enumerators use PascalCase capitalization
	* Properties use PascalCase capitalization
	* Variables use camelCase capitalization
	* Private member properties and variables are prepended by an underscore, but otherwise use their standard naming convention
		* A Property uses its `get` access modifier to determine whether it is private or public for naming convention purposes
	* Private variables which exist as an underlying variable for a Property have their names prepended by a lowercase 'm' and an underscore, e.g. `m_maxVelocity`
		* The 'm' comes from a similar convention for private variables in C and C++, and stands for "member variable"
		* These should **never** be referenced directly. Always reference these through their associated Property, both within their defining class and externally.
	* Constant variables are named in all-uppercase with underscore separators.

### Example: Variables
```csharp
// public variables
public uint currentAge;

// private variables
private string _bloodType;

// publicly-accessible Properties
public string FirstName { get; private set; }
public string LastName { get; private set; }
public string FullName { get => FirstName + " " + LastName; }

// private property
private string _SSN 
{
	get => m_ssn ;
	set
	{
		m_ssn = value;
	}
}

// private backing variable for a property
private string m_ssn;
```
## Classes
### Using Directives
* `using` directives are grouped by top-level namespace
* `using` directives are ordered by top-level namespace following this schema:
	* `System` namespace
	* External library namespaces, alphabetically
	* `Godot` namespace
	* Local library namespaces, alphabetically
* `using` directive sub-namespaces are ordered alphabetically
* A blank line should separate each top-level namespace group
### Naming Classes
* Class names use PascalCase
* A space lies on either side of the colon when a class inherits from a base class
* There should be only one class declaration per file (excluding internal classes)
### Naming Interfaces
* Interface names are always prepended with a capital 'I'
* Interface names use PascalCase
* There should only be one interface declaration per file

### Example: Class Definition
```csharp
using System;
using System.Collections.Generic;

using JsonLibrary.JSON;

using YAMLLibrary.YAML;

using Godot;
using Godot.Collections;

using Game;

public class Level : Game.Level
{
	// ...
}
```

### Class Members
* So long as it does not come at the cost of clarity, class members should be defined within the class in the following order:
	* `delegate`* and `enum` definitions
		* * does not include Godot signal delegates
	* Static members (all types)
		* Static members are themselves ordered in the same way as the rest of this list.
	* Events
	* Godot Exported Properties
	* Godot Signal Delegates
	* Variables
		* Excludes backing variables for properties, which are grouped with the properties they back
		* Ordered by:
			* `public`
			* `protected`
			* `internal`
			* `private`
	* Constructors
	* Destructors
	* Properties
		* Property backing variables should be declared immediately after the backing property.
		* Ordered by:
			* `sealed public`
			* `override public`
			* `virtual public`
			* `public`
			* `sealed protected`
			* `override protected`
			* `virtual protected`
			* `protected`
			* `internal`
			* `private`
	* Methods
		* Ordered by:
			* `sealed public`
			* `override public`
			* `virtual public`
			* `public`
			* `sealed protected`
			* `override protected`
			* `virtual protected`
			* `protected`
			* `internal`
			* `private`
			* Event Handlers (should be `private`)
	* Subclasses
* Using blank lines to group and separate related members is highly encouraged, but specifics are not prescribed by this guide.
### Example: Class Members
```csharp
public class ConventionalClass : BaseClass
{
	// Pure C# Delegates and Enums
	public enum ClassStatus { Active, Inactive, Pending, Unknown }

	public delegate bool ClassDelegate(ConventionalClass classInstance)

	// Static Members
	public static int instanceCount;

	// Events
	public event EventHandler StatusUpdated;

	// Godot Exported Properites
	[Export]
	public string NodeName { get; set; } = "Class";

	// Godot Signal Delegates
	[Signal]
	public delegate void NameUpdatedEventHandler();

	// Variables

	// - public variables
	public const int MAX_INSTANCES = 99;
	public string instanceName;
	public int instanceID;

	// - protected variables
	protected ConventionalClass parentClass;

	// - private variables
	private int _internalID;

	// Constructors and Destructors
	public ClassStatus()
	{
		Status = ClassStatus.Unknown;
	}

	// Properties
	public Status
	{
		get => m_status;
		private set m_status = value;
	}
	// - backing private variable for Status declared immediately afterward
	private ClassStatus m_status;

	// Methods
	public void SetStatus(ClassStatus newStatus)
	{
		// We set our Status value through the Status property, and not
		// directly through the m_status variable even though we "could".
		Status = newStatus;
		StatusUpdated?.Invoke(this, EventArgs.Empty);
	}
}
```