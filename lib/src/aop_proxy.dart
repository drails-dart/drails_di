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
    var component_ = ApplicationContext._componentOfProxy[this.runtimeType];
    
    //Befor aspect begin
    ApplicationContext._aspectsBefore.forEach((am, aspect) {
        if((am.annotations.singleWhere(new Is<Before>()) as Before).isBefore(component_, invocation))
          invocation = ApplicationContext._aspectsBefore[am](invocation);
    });
    //Before aspect end

    var retVal;
    
    try {
      var memberName = MirrorSystem.getName(invocation.memberName);

      //Invoque method begin
      if(invocation.isGetter)
        retVal = component_[memberName];
      else if(invocation.isSetter) {
        memberName = memberName.replaceFirst('=', '');
        retVal = component_[memberName] = invocation.positionalArguments.first;
      } else
        retVal = Function.apply(component_[memberName], invocation.positionalArguments, invocation.namedArguments);
      //Invoque method end
      
      //After aspect begin
      ApplicationContext._aspectsAfter.forEach((am, aspect) {
        After after = am.annotations.singleWhere(new Is<After>());
        if(after.isAfter(component_, invocation, retVal))
          retVal = ApplicationContext._aspectsAfter[am](retVal);
      });
      //After aspect end
      
    } catch(ex) {
      //AfterThrowing begin
      ApplicationContext._aspectsAfterThrowing.forEach((am, aspect)  {
        AfterThrowing afterThrowing = am.annotations.singleWhere(new Is<AfterThrowing>());
        if(afterThrowing.isAfterThrowing(component_, invocation, ex))
          retVal = ApplicationContext._aspectsAfterThrowing[am](retVal, ex);
      });
      //AfterThrowing end
    } finally {
      //AfterFinally begin
      ApplicationContext._aspectsAfterFinally.forEach((am, aspect) {
        AfterFinally afterFinally = am.annotations.singleWhere(new Is<AfterFinally>());
        if(afterFinally.isAfterFinally(component_, invocation))
          retVal = ApplicationContext._aspectsAfterFinally[am](retVal);
      });
      //AfterFinall end
    }
    
    return retVal;
  }
}