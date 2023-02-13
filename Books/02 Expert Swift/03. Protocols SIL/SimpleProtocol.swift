protocol SimpleProtocol {
  func simpleMethod()
}

func executeSimpleMethod(on protocolInstance: SimpleProtocol) {
  protocolInstance.simpleMethod()
}

func executeSimpleMethodWithGeneric<T: SimpleProtocol>(on protocolInstance: T) {
  protocolInstance.simpleMethod()
}
