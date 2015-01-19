library drails_di_test;

import 'package:drails_di/drails_di.dart';
import 'package:unittest/unittest.dart';

main() {
  ApplicationContext.bootstrap([#drails_di_test]);
  
  test('SomeService', () {
    SomeService someService = ApplicationContext.components[SomeService];
    expect(someService is SomeServiceImpl, true);
    
    expect(someService.sayHello(), "hello impl");
    
    SomeController someController = ApplicationContext.components[SomeController];
    expect(someController.someService is SomeServiceImpl, true);
    
  });
  
  test('InjectedService', () {
    InjectedService injectedService = ApplicationContext.components[InjectedService];
    expect(injectedService is InjectedServiceImpl, true);
    expect(injectedService.someService is SomeServiceImpl, true);
    expect(injectedService.sayHi(), "hi hello impl");
  });
}

abstract class SomeService {
  String sayHello() => "hello";
}

class SomeServiceImpl extends SomeService {
  String sayHello() => "${super.sayHello()} impl";
}

class SomeController {
  @autowired
  SomeService someService;
  
  String sayHello() => someService.sayHello();
}

abstract class InjectedService {
  @autowired
  SomeService someService;
  
  String sayHi() => "hi ";
}

class InjectedServiceImpl extends InjectedService {
  String sayHi() => super.sayHi() + someService.sayHello(); 
}