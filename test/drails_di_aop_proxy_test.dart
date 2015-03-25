library drails_di_aop_proxy_test;

import 'package:drails_di/drails_di.dart';
import 'package:unittest/unittest.dart';

main() {
  group('AopProxy Test ->', () {

    setUp(() {
      ApplicationContext.bootstrap([#drails_di_aop_proxy_test]);
    });
  
    test('SomeService', () {
      SomeService someService = ApplicationContext.components[SomeService];
      expect(someService is SomeServiceAopProxy, true, reason: 'someService should be AopProxy');
      
      expect(someService.sayHello(), "hello impl");
      
      SomeController someController = ApplicationContext.components[SomeController];
      expect(someController.someService is SomeServiceAopProxy, true);
      
    });
    
    test('InjectedService', () {
      InjectedService injectedService = ApplicationContext.components[InjectedService];
      expect(injectedService is InjectedServiceImpl, true);
      expect(injectedService.someService is SomeServiceAopProxy, true);
      expect(injectedService.sayHi(), "hi hello impl");
    });
  });
}

abstract class SomeService {
  String sayHello() => "hello";
}

class SomeServiceImpl extends SomeService {
  String sayHello() => "${super.sayHello()} impl";
}

class SomeServiceAopProxy extends AopProxy implements SomeService { 
  noSuchMethod(invocation) =>
    super.noSuchMethod(invocation);
}

class SomeController {
  @autowired SomeService someService;
  
  String sayHello() => someService.sayHello();
}

abstract class InjectedService {
  @inject SomeService someService;
  
  String sayHi() => "hi ";
}

class InjectedServiceImpl extends InjectedService {
  String sayHi() => super.sayHi() + someService.sayHello(); 
}