extends Node

const TILE_TYPE_BITMASK = 256

enum TileType {
	FLOOR = 1,
	WALL = 2,
	CEILING = 4,
	DROP = 8,
	LADDER = 16,
}

enum ItemType {
	FOOD,
	MEDICINE,
	FOOD_MEDICINE,
	KNIFE,
	UMBRELLA,
	LOCK_PICK,
	KEY,
}

enum PlayerMode {
	NONE,
	NORMAL,
	LADDER,
}

enum PlayerMovement {
	IDLE,
	WALKING,
	RUNNING,
	CLIMBING,
	JUMPING,
}

var game: Game
var player: CharacterBody2D
var camera: Camera2D
var music: AudioStreamPlayer2D
var level: Level
var hud: Control
var audio: Audio
var help: Help
