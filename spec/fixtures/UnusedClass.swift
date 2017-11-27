class UnusedClass { }

class UnusedClassWithParent: UnusedParent { }

class UnusedGenericClass<T> { }

class UnusedClassWithGenericParent: UnusedGenericParent<Void> { }

class UnusedGenericClassWithConstraint<T: AnyObject> { }
