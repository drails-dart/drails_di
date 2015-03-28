part of drails_di;

class AopProxy {
  noSuchMethod(Invocation invocation) {
    var component = ApplicationContext._componentOfProxy[reflect(this).type.reflectedType];
    
    var im = reflect(component);
    
    //Befor aspect begin
    ApplicationContext._aspectsBefore.keys.where((aspect) =>
        new GetValueOfAnnotation<Before>().fromDeclaration(aspect).isBefore(im, invocation)
    ).forEach((mm) {
      ApplicationContext._aspectsBefore[mm].invoke(mm.simpleName, []);
    });
    //Befor aspect 
    var retVal;
    
    try {
      //Invoque method begin
      if(invocation.isGetter)
        retVal = im.getField(invocation.memberName).reflectee;
      else if(invocation.isSetter) {
        var memberName = MirrorSystem.getName(invocation.memberName).replaceFirst('=', '');
        retVal = im.setField(new Symbol(memberName), invocation.positionalArguments.first).reflectee;
      } else
        retVal = im.invoke(invocation.memberName, invocation.positionalArguments, invocation.namedArguments).reflectee;
      //Invoque method end
      
      //After aspect begin
      ApplicationContext._aspectsAfter.keys.where((aspect) {
        var afterAnn = new GetValueOfAnnotation<After>().fromDeclaration(aspect);
        
        if(!afterAnn.retValNull && afterAnn.retVal == retVal
            || afterAnn.retValNull == (retVal == null))
          return afterAnn.isAfter(im, invocation);
        
        return false;
      }).forEach((mm) {
        retVal = ApplicationContext._aspectsAfter[mm].invoke(mm.simpleName, [retVal]).reflectee;
      });
      //After aspect end
      
    } catch(ex, stack) {
      //AfterThrowing begin
      ApplicationContext._aspectsAfterThrowing.keys.where((aspect)  =>
          new GetValueOfAnnotation<AfterThrowing>().fromDeclaration(aspect).isAfterThrowing(im, invocation, ex)
      ).forEach((mm) {
          retVal = ApplicationContext._aspectsAfterThrowing[mm].invoke(mm.simpleName, [ex]).reflectee;
      });
      //AfterThrowing end
    } finally {
      //AfterFinally begin
      ApplicationContext._aspectsAfterFinally.keys.where((aspect) =>
        new GetValueOfAnnotation<AfterFinally>().fromDeclaration(aspect).pointCut(im, invocation)
      ).forEach((mm) {
        retVal = ApplicationContext._aspectsAfterFinally[mm].invoke(mm.simpleName, [retVal]).reflectee;
      });
      //AfterFinall end
    }
    
    return retVal;
  }
}