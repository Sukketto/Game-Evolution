class_name EffectType extends Resource

var id : String
var categories : Array = []
var description : String 
var type : Attribute 
var operation : Operation
var value : String
var radius : int

enum Attribute {
	DROP_RATE,
	DROP_ID,
	DROP_COUNT,
	ID
}
enum Operation {
	ADD,
	MULTIPLY,
	SET,
	SELL
}
