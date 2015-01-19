part of drails_di;

class AopProxy {
  noSuchMethod(Invocation invocation) {
    var component = ApplicationContext.componentOfProxy[reflect(this).type.reflectedType];
    
    if(invocation.isGetter)
      return reflect(component).getField(invocation.memberName).reflectee;
    else if(invocation.isSetter) {
      var memberName = MirrorSystem.getName(invocation.memberName).replaceFirst('=', '');
      return reflect(component).setField(new Symbol(memberName), invocation.positionalArguments.first).reflectee;
    } else
      return reflect(component).invoke(invocation.memberName, invocation.positionalArguments, invocation.namedArguments).reflectee;
  }
}