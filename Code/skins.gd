class_name Skins
extends Node


enum Type { 
	DEFAULT, 
	WHITE,
	NINJA, 
	PUMPKIN, 
	BlOODY
	}
enum TypeCost { COIN, SCORE, DONAT }

const TypeToBit = {
	Type.DEFAULT: 1,
	Type.WHITE: 2,
	Type.NINJA: 4,
	Type.PUMPKIN: 8,
	Type.BlOODY: 16
}

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
		"cost": 50,
		"type_cost": TypeCost.COIN
	},
	Type.PUMPKIN: {
		"description": "Тыквенная голова",
		"cost": 5000000,
		"type_cost": TypeCost.SCORE
	},
	Type.BlOODY: {
		"description": "Тыквенная голова",
		"cost": 10000000,
		"type_cost": TypeCost.SCORE
	},
	
}
