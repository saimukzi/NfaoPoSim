class_name NodeCacheBuilder

class Obj:

	var subject_cache:Obj
	var subject:Object
	var property:String
	var result_node:Node
	var result_done = false

	func get_node() -> Node:
		if not result_done:
			if subject == null:
				if subject_cache != null:
					subject = subject_cache.get_node()
			if subject != null:
				var node_path = subject.get(property)
				if node_path != null:
					result_node = subject.get_node(node_path)
			result_done = true
		return result_node

var subject_cache:Obj
var subject:Object
var property:String

func subject_cache(subject_cache:Obj) -> NodeCacheBuilder:
	self.subject_cache = subject_cache
	return self

func subject(subject:Object) -> NodeCacheBuilder:
	self.subject = subject
	return self

func property(property:String) -> NodeCacheBuilder:
	self.property = property
	return self

func build() -> Obj:
	var ret = Obj.new()
	ret.subject_cache = subject_cache
	ret.subject = subject
	ret.property = property
	return ret
