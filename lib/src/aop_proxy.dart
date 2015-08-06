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
    var component_ = ApplicationContext._componentOfProxy[component.reflect(this).type.reflectedType];
    
    var im = component.reflect(component_);
    
    //Befor aspect begin
    ApplicationContext.aspectsBefore.keys.where((aspect) =>
        new GetValueOfAnnotation<Before>().fromDeclaration(aspect).isBefore(component_, invocation)
    ).forEach((mm) {
      invocation = ApplicationContext.aspectsBefore[mm].invoke(mm.simpleName, [invocation]);
    });
    //Befor aspect 
    var retVal;
    
    try {
      var memberName = dart_mirrors.MirrorSystem.getName(invocation.memberName);

      //Invoque method begin
      if(invocation.isGetter)
        retVal = im.invokeGetter(memberName);
      else if(invocation.isSetter) {
        memberName = memberName.replaceFirst('=', '');
        retVal = im.invokeSetter(memberName, invocation.positionalArguments.first);
      } else
        retVal = im.invoke(memberName, invocation.positionalArguments, invocation.namedArguments);
      //Invoque method end
      
      //After aspect begin
      ApplicationContext._aspectsAfter.keys.where((aspect) =>
        new GetValueOfAnnotation<After>().fromDeclaration(aspect).isAfter(component_, invocation, retVal)
      ).forEach((mm) {
        retVal = ApplicationContext._aspectsAfter[mm].invoke(mm.simpleName, [retVal]);
      });
      //After aspect end
      
    } catch(ex) {
      //AfterThrowing begin
      ApplicationContext._aspectsAfterThrowing.keys.where((aspect)  =>
          new GetValueOfAnnotation<AfterThrowing>().fromDeclaration(aspect).isAfterThrowing(component_, invocation, ex)
      ).forEach((mm) {
          retVal = ApplicationContext._aspectsAfterThrowing[mm].invoke(mm.simpleName, [retVal, ex]);
      });
      //AfterThrowing end
    } finally {
      //AfterFinally begin
      ApplicationContext._aspectsAfterFinally.keys.where((aspect) =>
        new GetValueOfAnnotation<AfterFinally>().fromDeclaration(aspect).isAfterFinally(component_, invocation)
      ).forEach((mm) {
        retVal = ApplicationContext._aspectsAfterFinally[mm].invoke(mm.simpleName, [retVal]);
      });
      //AfterFinall end
    }
    
    return retVal;
  }
}