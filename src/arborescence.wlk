object root inherits Vertex { }

class Vertex {
	var children = []
	
	/**
	TODO: use apply on every label-based method

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
	
	// root.order() returns the total amount of vertices.
	
	method order() {
		if (children.isEmpty()) {
			return 1
		} else {
			return 1 + children.map({c => c.order()}).sum()
		}
	}
	
	// root.bylabel() recursively maps the arborescence by assigning each vertex a unique label.
	
	method bylabel() {
		if (children.isEmpty()) {
			return ["R"]
		} else {
			return self.bylabel((0..(self.order() - 1)).asList())
		}
	}
	
	method bylabel(flat) {
		var _flat = flat
		if (flat.head() == 0) {
			_flat = ["R"] + flat.drop(1)
		}
		if (children.isEmpty()) {
			return _flat.head()
		} else {
			var levelled = []
			var order = 1
			var child
			children.size().times({t =>
				child = children.get(t - 1)
				levelled.add(child.bylabel(_flat.drop(order)))
				order += child.order()
			})
			return [_flat.head(), levelled]
		}
	}
	
	// root.add(n) adds n children to the root.
	// TODO: missing exceptions
	
	method add(n) {
		n.times({t => children.add(new Vertex())})
	}
	
	// root.add(x, n) adds n children to the vertex x.
	// TODO: missing exceptions
	
	method add(label, n) {
		if (label == 0 or label == "R") {
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
	
	// root.detach(x) detaches the vertex x.
	// TODO: missing exceptions; make better break
	
	method detach(label) {
		if (label == 0 or label == "R") {
			throw new Exception()
		}
		if (children.isEmpty().negate()) {
			var order = 1
			var child
			try {
				children.size().times({t =>
					child = children.get(t - 1)
					if (label - order  == 0) {
						children.remove(child)
						throw new Exception()
					} else {
						child.detach(label - order)
						order += child.order()
					}
				})
			}
			catch e: Exception { }
		}
	}
	
	// root.reset() deletes all the vertices except root.
	
	method reset() {
		children = []
	}
	
	// root.leaves() returns the number of vertices that don't have any children.
	
	method leaves() {
		if (children.isEmpty()) {
			return 1
		} else {
			return children.map({c => c.leaves()}).sum()
		}
	}
	
	// root.height() returns the highest level.
	
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
	
	// root.level(x) returns the number of vertices of the level x.
	// TODO: missing exceptions
	
	method level(l) {
		if (l == 0) {
			return 1
		} else {
			return children.map({c => c.level(l - 1)}).sum()
		}
	}
	
	// root.levels() returns the number of vertices of each level.
	
	method levels() {
		var acc = [1]
		self.height(0).times({t => acc.add(self.level(t))})
		return acc
	}
	
	// root.bylevel() recursively maps the arborescence by the level of each vertex.
	
	method bylevel() {
		if (children.isEmpty()) {
			return [0]
		} else {
			return self.bylevel(0)
		}
	}
	
	method bylevel(l) {
		if (children.isEmpty()) {
			return l
		} else {
			return [l, children.map({c => c.bylevel(l + 1)})]
		}
	}
	
	// root.bydegree() recursively maps the arborescence by the number of incident edges of each vertex.
	
	method bydegree() {
		if (children.isEmpty()) {
			return [0]
		} else {
			return [children.size(), children.map({c => c.bydegree(1)})]
		}
	}
	
	method bydegree(n) {
		if (children.isEmpty()) {
			return n
		} else {
			return [children.size() + n, children.map({c => c.bydegree(n)})]
		}
	}
}