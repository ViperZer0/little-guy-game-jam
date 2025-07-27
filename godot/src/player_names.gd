class_name PlayerNames extends Node

const Art = Name.ART
const Mike = Name.MIKE

enum Name {
	ART,
	MIKE
}

static func invert_name(player_name: Name) -> Name:
	match player_name:
		Name.ART:
			return Name.MIKE
		Name.MIKE:
			return Name.ART
		_:
			push_error("PlayerName.Name was neither ART or MIKE")
			return Name.ART
