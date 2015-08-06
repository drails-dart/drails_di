library drails_di_aop_proxy_test;

import 'package:drails_di/drails_di.dart';
import 'package:test/test.dart';

main() {
  group('AopProxy Test ->', () {

    setUp(() {
      ApplicationContext.bootstrap(['drails_di_aop_proxy_test']);
    });
  
    test('SomeService', () {
      SomeService someService = ApplicationContext.components[SomeService];
      expect(someService is SomeServiceAopProxy, true, reason: 'someService should be AopProxy');
      
      expect(someService.sayHello(), "hello impl");
      expect(beforeCounter, 1);
      expect(afterCounter, 1);
      expect(afterCounter2, 1);
      
      expect(() => someService.throwsError(), throws);
      expect(afterTrhowingCounter, 1);
      
      SomeController someController = ApplicationContext.components[SomeController];
      expect(someController.someService is SomeServiceAopProxy, true);
      
    });
    
    test('InjectedService', () {
      InjectedService injectedService = extract(InjectedService);
      
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

@component
abstract class SomeService {
  String sayHello() => "hello";
  
  throwsError() => throw new Exception("message");
}

@component
class SomeServiceImpl extends SomeService {
  String sayHello() => "${super.sayHello()} impl";
}

@component
class SomeServiceAopProxy extends AopProxy implements SomeService { 
  noSuchMethod(invocation) =>
    super.noSuchMethod(invocation);
}

@component
class SomeController {
  @autowired SomeService someService;
  
  String sayHello() => someService.sayHello();
}

@component
abstract class InjectedService {
  @inject SomeService someService;
  
  String sayHi() => "hi ";
}

@component
class InjectedServiceImpl extends InjectedService {
  String sayHi() => super.sayHi() + someService.sayHello(); 
}

var beforeCounter = 0;

bool SomeService_sayHello(component, Invocation inv) =>
    component is SomeService
    && inv.memberName == #sayHello;

@component
@Before(SomeService_sayHello)
increaseBeforeCounter(invocation) {
  beforeCounter++;
  print("before sayHello $beforeCounter");
  return invocation;
}

var afterCounter = 0;

someService_sayHello_noRetVal(component, Invocation inv, retVal) =>
    SomeService_sayHello(component, inv);

@component
@After(someService_sayHello_noRetVal)
increaseAfterCounter(retVal) {
  afterCounter++;
  print("after sayHello $afterCounter");
  print(retVal);
  return retVal;
}

someService_sayHello_retValNull(component, Invocation inv, retVal) =>
    retVal == null && SomeService_sayHello(component, inv);

@component
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

@component
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

@component
@AfterThrowing(SomeService_throwinError)
increaseAfterThrowingCounter(retVal, Exception ex) {
  afterTrhowingCounter++;
  print("after throwing $afterTrhowingCounter");
  print(ex);
  throw ex;
}