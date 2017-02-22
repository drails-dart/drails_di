part of drails_di;

/// indicates that the class could be injected into another class or the function
/// is an AOP proxy
const Serializable injectable = const Serializable();

/// indicates that the class could be injected into another class or the function
/// is an AOP proxy
const Serializable component = const Serializable();

/// Indicates that the variable is going to be injected
/// using the Type as reference
const inject = const _Inject(),
      autowired = inject;

class _Inject extends Annotation {
  const _Inject();
}

/// Defines the type of function that should be used for creating the
/// interception logic for [Before] and [AfterFinally] apects.
typedef bool PointCutFunc(component, Invocation invo);

/// Indicates that the annotated function should be executed before
/// the execution of [isBefore]
class Before extends Annotation {
  const Before(this.isBefore);
  
  final PointCutFunc isBefore;
}

/// Defines the type of function that should be used for creating the
/// interception logic for [After] aspects
typedef bool AfterFunc(component, Invocation invo, retVal);

/// Indicates that the annotated function should be executed after
/// the execution of the [isAfter]
class After extends Annotation  {
  const After(this.isAfter);

  final AfterFunc isAfter;
}

/// Defines the type of function that should be used for creating the
/// interception logic for [AfterThrowing] aspects
typedef bool AfterThrowingFunc(component, Invocation invo, Exception ex);

/// Indicates that the annotated function should be executed after
/// the execution of the [isAfterThrowing] that throws a exeption [exceptionType]
class AfterThrowing extends Annotation  {
  const AfterThrowing(this.isAfterThrowing);
  
  final AfterThrowingFunc isAfterThrowing;
}

/// Indicates that the annotated function should be executed after
/// the execution of the [isAfterFinally]
class AfterFinally extends Annotation  {
  const AfterFinally(this.isAfterFinally);
  
  final PointCutFunc isAfterFinally;
}
