class_name PackType extends Resource

var id : String
var description : String
var items : Array[PackItem]
var cost : int
var pack_size : int = 5

class PackItem extends Resource:
	var id : String
	var weight : int

func get_random_item_id() -> String:
	var total_weight = 0
	for item in items:
		total_weight += item.weight
	var random_weight = randi() % total_weight
	var current_weight = 0
	for item in items:
		current_weight += item.weight
		if current_weight >= random_weight:
			return item.id
	return items[items.size() - 1].id
