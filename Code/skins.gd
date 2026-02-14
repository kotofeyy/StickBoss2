class_name Skins
extends Node


enum Type { DEFAULT, NINJA, PUMPKIN, WHITE }
enum TypeCost { COIN, SCORE, DONAT }

const List: Dictionary[Type, Dictionary] = {
	Type.DEFAULT: {
		"description": "default",
		"cost": 0,
		"type_cost": TypeCost.COIN
	},
	Type.WHITE: {
		"description": "белый катается с фломом",
		"cost": 5,
		"type_cost": TypeCost.COIN
	},
	Type.NINJA: {
		"description": "ниндзя",
		"cost": 15000000,
		"type_cost": TypeCost.SCORE
	},
	Type.PUMPKIN: {
		"description": "Тыквенная голова",
		"cost": 5000000,
		"type_cost": TypeCost.SCORE
	},
	
}
