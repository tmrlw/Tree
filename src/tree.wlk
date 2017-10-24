class Vertex {
	var children = []
	
	method add(n) {
		n.times({t => children.add(new Vertex())})
	}
	
	method add(label, n) {
		if (label == 0) {
			self.add(n)
		} else {
			if (children.isEmpty().negate()) {
				var order = 1
				var child
				children.size().times({t =>
					child = children.get(t - 1)
					child.add(label - order, n)
					order += child.order()
				})
			}
		}
	}
	
	/**
	method apply(label, closure) {
		if (label == 0) {
			closure.apply(self)
		} else {
			if (children.isEmpty().negate()) {
				var order = 1
				var child
				children.size().times({t =>
					child = children.get(t - 1)
					child.apply(label - order, closure)
					order += child.order()
				})
			}
		}
	}
	*/
	
	// root.order() returns the amount of vertices in the tree.
	
	method order() {
		if (children.isEmpty()) {
			return 1
		} else {
			return 1 + children.map({c => c.order()}).sum()
		}
	}
	
	// root.leaves() returns the number of vertices that don't have any children.
	
	method leaves() {
		if (children.isEmpty()) {
			return 1
		} else {
			return children.map({c => c.leaves()}).sum()
		}
	}
	
	// root.height() returns the highest level of the tree.
	
	method height() {
		return self.height(0)
	}
	
	method height(l) {
		if (children.isEmpty()) {
			return l
		} else {
			return children.map({c => c.height(l + 1)}).max()
		}
	}
	
	// root.of(x) returns the number of vertices of the level x.
	
	method of(l) {
		if (l == 0) {
			return 1
		} else {
			return children.map({c => c.of(l - 1)}).sum()
		}
	}
	
	// root.of() returns the number of vertices of each level.
	
	method of() {
		var acc = [1]
		self.height(0).times({t => acc.add(self.of(t))})
		return acc
	}
	
	// root.level() recursively maps the tree by the level of each vertex.
	
	method level() {
		if (children.isEmpty()) {
			return [0]
		} else {
			return self.level(0)
		}
	}
	
	method level(l) {
		if (children.isEmpty()) {
			return l
		} else {
			return [l, children.map({c => c.level(l + 1)})]
		}
	}
	
	// root.degree() recursively maps the tree by the number of incident edges of each vertex.
	
	method degree() {
		if (children.isEmpty()) {
			return [0]
		} else {
			return [children.size(), children.map({c => c.degree(1)})]
		}
	}
	
	method degree(n) {
		if (children.isEmpty()) {
			return n
		} else {
			return [children.size() + n, children.map({c => c.degree(n)})]
		}
	}
	
	// root.label() recursively maps the tree by assigning each vertex a unique label.
	
	method label() {
		if (children.isEmpty()) {
			return [0]
		} else {
			return self.label((0..(self.order() - 1)).asList())
		}
	}
	
	method label(flat) {
		if (children.isEmpty()) {
			return flat.head()
		} else {
			var levelled = []
			var order = 1
			var child
			children.size().times({t =>
				child = children.get(t - 1)
				levelled.add(child.label(flat.drop(order)))
				order += child.order()
			})
			return [flat.head(), levelled]
		}
	}
}

object root inherits Vertex { }