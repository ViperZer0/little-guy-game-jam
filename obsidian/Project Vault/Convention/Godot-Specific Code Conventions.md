Godot is extremely flexible and provides numerous ways to accomplish something. For certain common operations such as connecting signals and referencing children, this is how we recommend doing things, though as always exceptions may require alternative setups.
## Rule of Thumb
In general, if Godot provides a way to do things in the editor, use the editor. The editor will handle changes to underlying references such as renaming and moving. 
## Signals
Firstly, use signals whenever possible, not C# events.
Unless signals need to be connected dynamically and/or at run time, use the editor to link signals. 
This helps reduce boilerplate and in many circumstances means that attaching a script to a scene can be avoided entirely. Consider a setup, where a level contains a door and a button that opens it. 

**Door**
```cs
public class Door : Node2D
{
	public void Open()
	{
		//...
	}
}
```
**Button**
```cs
public class Button : Node2D
{
	[Signal]
	public delegate void ButtonPressedEventHandler()
}
```

Neither one of these components should be directly responsible for connecting the `ButtonPressed` signal to the `Open` method of the door. We could attach a script to the level scene and connect the two nodes that way, but instead we could use the editor to connect the nodes, avoiding an extra script entirely.
## Referencing Children
Parent nodes will quite often need to reference their children nodes. For immediate children, especially children that are responsible for what we might call "aesthetic" or "additional" functionality, prefer using `GetNode()` in the parent's `_Ready()` function. Use the fully typed function: i.e `GetNode<Node2D>("Child")`, not `GetNode("Child")`. Do not call `GetNode` multiple times for the same child node: instead assign the node to a private member variable.

If there is a significant chance that a reference to a child node may change or be swapped out, instead use an exported property to assign the proper reference in the editor. 

Examples of common node types that should be referenced via `GetNode()`:
- Sprites
- AudioStreamPlayers
- Areas

Examples of node types that should be referenced via exported properties:
- UI components
	- Since the UI layout is determined by the order of its children, changes to the UI layout will likely move the order and hierarchy of children, breaking `GetNode` references
- Packed Scenes/Resources
- Timers

Alternatively, consider "lifting" properties of child nodes so that they can be set through the parent node, instead of having the entire child set as an exported property.

**Example**
```cs
public class Player: Node2D
{
	// "Lifts" the Timer's WaitTime property.
	[Export]
	public float HurtCooldown { get; set; }
	
	private AnimatedSprite2D sprite;
	private AudioStreamPlayer2D audioPlayer;
	private Timer hurtCooldownTimer;

	public override void _Ready(){
		sprite = GetNode<AnimatedSprite2D>("AnimatedSprite2D");
		audioPlayer = GetNode<AudioStreamPlayer2D>("AudioStreamPlayer2D");
		// We could either export a Timer property,
		// allowing scenes that instantiate a player to configure the hurt 
		// cooldown timer anyway they want. 
		// However we might not want this: 
		// We might not want it to be set to loop or autostart,
		// for example. In that case we may only want to expose
		// the duration of the timer to scenes that instantiate the player
		// Use your discretion either way.
		hurtCooldownTimer = GetNode<Timer>("HurtCooldownTimer");
		hurtCooldownTimer.WaitTime = HurtCooldown;
	}
}
```

## Naming Children
For nodes that have a specific, obvious purpose and will almost never have more than one instance of that type of node, feel free to leave the node name as its default.

Examples include:
	- Sprites
	- UI containers
	- Collision shapes

For nodes that can be used in a variety of ways or may have multiple instances of that type of node, rename the node in a way that clarifies its purpose.

Examples include:
	- Timers
	- Areas
	- Buttons

A player scene, for example, might look like this
```
Player (CharacterBody2D)
|-- Sprite2D
|-- CollisionShape2D
|-- AttackCooldown (Timer)
|-- Hitbox (Area2D)
	|-- CollisionShape2D
```
Sprite2D doesn't need a name since most scenes only have one sprite. In this case the CollisionShape2D doesn't need a name, since it is a required child of a CharacterBody2D. The timer is given a name since timers can be used in a variety of ways and we will likely add more timers to the player for other actions. The name here specifies that this controls the cooldown of the player's attacks. Finally the Area2D is given a name that clarifies that it defines the player's hitbox, distinct from the CharacterBody2D's physics shape.