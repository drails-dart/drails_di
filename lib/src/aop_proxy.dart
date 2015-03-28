part of drails_di;

/// Class that must be extended in order to make the methods of an object interceptable
/// 
///     Class MyService {
///       myMethod() => "inside myMethod";
///     }
///     
///     Class MyServiceImpl extends MyService {
///       myMethod() => super.myMethod() + "Impl";
///       
///       myMethodThrow() => throw new Exception("some message");
///     }
///     
///     Class MyServiceProxy extends AopProxy implements MyService {}
///     
/// then in other file or in the same file you can create top level functions that are
/// going to act as aspects/interceptors:
/// 
///     //Create the pointcut
///     bool myService_myMethod(instance, Invocation invo) =>
///       instance is MyService && invo.memberName == #myMethod;
/// 
///     //add the pointcut before
///     @Before(myService_myMethod)
///     printBeforeMyServiceMyMethod(Invocation invo) {
///       print("before MyService.myMethod");
///       //modify invo as needed
///       return invo;
///     }
///     
///     myService_myMethod_retVal(instance, Invocation invo, retVal) =>
///       retVal == "myMethodImpl" && myService_myMethod();
///     
///     //add pointcut after
///     @After(myService_myMethod_retVal)
///     printAfterMyServiceMyMethod(retVal) {
///       print(after MyService.myMethod");
///       //modify retVal as needed
///       return retVal;
///     }
///  
class AopProxy {
  noSuchMethod(Invocation invocation) {
    var component = ApplicationContext._componentOfProxy[reflect(this).type.reflectedType];
    
    var im = reflect(component);
    
    //Befor aspect begin
    ApplicationContext._aspectsBefore.keys.where((aspect) =>
        new GetValueOfAnnotation<Before>().fromDeclaration(aspect).isBefore(component, invocation)
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
      ApplicationContext._aspectsAfter.keys.where((aspect) =>
        new GetValueOfAnnotation<After>().fromDeclaration(aspect).isAfter(component, invocation, retVal)
      ).forEach((mm) {
        retVal = ApplicationContext._aspectsAfter[mm].invoke(mm.simpleName, [retVal]).reflectee;
      });
      //After aspect end
      
    } catch(ex, stack) {
      //AfterThrowing begin
      ApplicationContext._aspectsAfterThrowing.keys.where((aspect)  =>
          new GetValueOfAnnotation<AfterThrowing>().fromDeclaration(aspect).isAfterThrowing(component, invocation, ex)
      ).forEach((mm) {
          retVal = ApplicationContext._aspectsAfterThrowing[mm].invoke(mm.simpleName, [retVal, ex]).reflectee;
      });
      //AfterThrowing end
    } finally {
      //AfterFinally begin
      ApplicationContext._aspectsAfterFinally.keys.where((aspect) =>
        new GetValueOfAnnotation<AfterFinally>().fromDeclaration(aspect).pointCut(component, invocation)
      ).forEach((mm) {
        retVal = ApplicationContext._aspectsAfterFinally[mm].invoke(mm.simpleName, [retVal]).reflectee;
      });
      //AfterFinall end
    }
    
    return retVal;
  }
}