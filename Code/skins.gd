class_name Skins
extends Node


enum Type { DEFAULT, NINJA, PUMPKIN, WHITE }
enum TypeCost { COIN, SCORE, DONAT }

const List: Dictionary[Type, Dictionary] = {
	Type.DEFAULT: {
		"description": "zalupa",
		"cost": 10,
		"type_cost": TypeCost.COIN
	},
	Type.NINJA: {
		"description": "ниндзя",
		"cost": 500,
		"type_cost": TypeCost.COIN
	},
	Type.PUMPKIN: {
		"description": "Тыквенная голова",
		"cost": 5000000,
		"type_cost": TypeCost.SCORE
	},
	Type.WHITE: {
		"description": "белый катается с фломом",
		"cost": 15000000,
		"type_cost": TypeCost.SCORE
	}
}
