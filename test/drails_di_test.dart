library drails_di_test;

import 'package:drails_di/drails_di.dart';
import 'package:test/test.dart';

main() {
  group('Simple Test ->', () {
    setUp(() {
      ApplicationContext.bootstrap(['drails_di_test']);
    });
    
    test('SomeService', () {
      SomeService someService = extract(SomeService);
      expect(someService is SomeService, true, reason: 'someService should be SomeService');
      
      expect(someService.sayHello(), "hello impl");
      
      SomeController someController = extract(SomeController);
      expect(someController.someService is SomeService, true);
      
    });
    
    test('InjectedService', () {
      InjectedService injectedService = extract(InjectedService);
      expect(injectedService is InjectedServiceImpl, true);
      expect(injectedService.someService is SomeServiceImpl, true);
      expect(injectedService.sayHi(), "hi hello impl");
    });
  });
}

@component
abstract class SomeService {
  String sayHello() => "hello";
}

@component
class SomeServiceImpl extends SomeService {
  String sayHello() => "${super.sayHello()} impl";
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