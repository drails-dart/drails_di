part of drails_di;

/**
 * Indicates that the variable is going to be injected 
 * using the Type as reference
 */
const inject = const _Inject(), 
      autowired = inject;

class _Inject {
  const _Inject();
}

/// Defines the type of function that should be used for creating the
/// interception logic.
typedef bool PointCutFunc(InstanceMirror im, Invocation invo);

/// Indicates that the annotated function should be executed before
/// the execution of [isBefore]
class Before {
  const Before(this.isBefore);
  
  final PointCutFunc isBefore;
}

/// Indicates that the annotated function should be executed after
/// the execution of the [isAfter]
class After {
  const After(this.isAfter, {this.retVal, this.retValNull: false});

  final PointCutFunc isAfter;
  final retVal;
  final bool retValNull;
}

typedef bool AfterThrowingFunc(InstanceMirror im, Invocation invo, Exception ex);

/// Indicates that the annotated function should be executed after
/// the execution of the [isAfterThrowing] that throws a exeption [exceptionType]
class AfterThrowing {
  const AfterThrowing(this.isAfterThrowing, [this.exceptionType = #Exception]);
  
  final AfterThrowingFunc isAfterThrowing;
  final Symbol exceptionType;
}

/// Indicates that the annotated function should be executed after
/// the execution of the [pointCut] with [retVal]
class AfterFinally {
  const AfterFinally(this.pointCut, this.retVal);
  
  final PointCutFunc pointCut;
  final retVal;
}
