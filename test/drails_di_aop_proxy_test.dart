library drails_di_aop_proxy_test;

import 'package:drails_di/drails_di.dart';
import 'package:test/test.dart';

part 'drails_di_aop_proxy_test.g.dart';

main() {
  _initMirrors();
  group('AopProxy Test ->', () {

    setUp(() {
      ApplicationContext.bootstrap();
    });
  
    test('SomeService', () {
      SomeService someService = ApplicationContext.components[SomeService];
      expect(someService is SomeServiceAopProxy, true, reason: 'someService should be AopProxy');
      
      expect(someService.sayHello(), "hello impl");
      expect(beforeCounter, 1);
      expect(afterCounter, 1);
      expect(afterCounter2, 1);
      
      expect(() => someService.throwsError(), throwsException);
      expect(afterTrhowingCounter, 1);
      
      SomeController someController = ApplicationContext.components[SomeController];
      expect(someController.someService is SomeServiceAopProxy, true);
      
    });
    
    test('InjectedService', () {
      InjectedService injectedService = injectorGet(InjectedService);
      
      expect(injectedService is InjectedServiceImpl, true);
      expect(injectedService.someService is SomeServiceAopProxy, true);
      expect(injectedService.someService is SomeService, true);
      
      expect(injectedService.sayHi(), "hi hello impl");
      expect(beforeCounter, 2);
      expect(afterCounter, 2);
      expect(afterCounter2, 2);
    });
  });
}

@serializable
abstract class SomeService extends _$SomeServiceSerializable {
  String sayHello() => "hello";
  
  throwsError() => throw new Exception("message");
}

@reflectable
class SomeServiceImpl extends SomeService {
  String sayHello() => "${super.sayHello()} impl";
}

@reflectable
class SomeServiceAopProxy extends AopProxy implements SomeService { 
}

@serializable
class SomeController extends _$SomeControllerSerializable {
  @autowired SomeService someService;
  
  String sayHello() => someService.sayHello();
}

@serializable
abstract class InjectedService extends _$InjectedServiceSerializable {
  @inject SomeService someService;
  
  String sayHi() => "hi ";
}

@reflectable
class InjectedServiceImpl extends InjectedService {
  String sayHi() => super.sayHi() + someService.sayHello(); 
}

var beforeCounter = 0;

bool SomeService_sayHello(component, Invocation inv) =>
    component is SomeService
    && inv.memberName == #sayHello;

@reflectable
@Before(SomeService_sayHello)
increaseBeforeCounter(invocation) {
  beforeCounter++;
  print("before sayHello $beforeCounter");
  return invocation;
}

var afterCounter = 0;

someService_sayHello_noRetVal(component, Invocation inv, retVal) =>
    SomeService_sayHello(component, inv);

@reflectable
@After(someService_sayHello_noRetVal)
increaseAfterCounter(retVal) {
  afterCounter++;
  print("after sayHello $afterCounter");
  print(retVal);
  return retVal;
}

someService_sayHello_retValNull(component, Invocation inv, retVal) =>
    retVal == null && SomeService_sayHello(component, inv);

@reflectable
@After(someService_sayHello_retValNull)
noIncreaseAfterCounter(retVal) {
  //this should not happens
  afterCounter++;
  print("after sayHello $afterCounter");
  print(retVal);
  return retVal;
}

var afterCounter2 = 0;

someService_sayHello_retVal(component, Invocation inv, retVal) =>
    retVal == "hello impl" && SomeService_sayHello(component, inv);

@reflectable
@After(someService_sayHello_retVal)
increaseAfterCounter2(retVal) {
  afterCounter2++;
  print("after sayHello 2 $afterCounter2");
  print(retVal);
  return retVal;
}

var afterTrhowingCounter = 0;

SomeService_throwinError(component, Invocation inv, ex) =>
    ex is Exception
    && component is SomeService
    && inv.memberName == #throwsError;

@reflectable
@AfterThrowing(SomeService_throwinError)
increaseAfterThrowingCounter(retVal, Exception ex) {
  afterTrhowingCounter++;
  print("after throwing $afterTrhowingCounter");
  print(ex);
  throw ex;
}