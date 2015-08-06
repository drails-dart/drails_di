library drails_di_mockito_test;

import 'package:drails_di/drails_di.dart';
import 'package:test/test.dart';
import 'package:mockito/mockito.dart';

main() {
  group('Mockito Test ->', () {

    setUp(() {
      //We initialize the application
      ApplicationContext.bootstrap(['drails_di_mockito_test'],
          bind: {
            //bind SomeService Manually, stopping autowiring
            SomeService: new SomeServiceMock()
          });

      //extract the Mock service from the ApplicationContext.components map
      SomeService someService = extract(SomeService);
      //mock the sayHello Method so we can return a fake value
      when(someService.sayHello()).thenReturn('hello mock');
    });
    
    
    test('SomeService', () {
      //extract someService from the ApplicationContext.components map
      SomeService someService = extract(SomeService);
      
      expect(someService is SomeServiceMock, true, reason: 'someService should be SomeServiceMock');
      
      expect(someService.sayHello(), "hello mock");
      
      SomeController someController = extract(SomeController);
      expect(someController.someService is SomeServiceMock, true);
      
    });
    
    test('InjectedService', () {
      //extract injectedService from the ApplicationContext.components map
      InjectedService injectedService = extract(InjectedService);
      expect(injectedService is InjectedServiceImpl, true);
      expect(injectedService.someService is SomeServiceMock, true);
      expect(injectedService.sayHi(), "hi hello mock");
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

// we declare the Mock service
@component
class SomeServiceMock extends Mock implements SomeService { 
  //this method could be ommited, but I don't like to see the warning.
  noSuchMethod(invocation) =>
    super.noSuchMethod(invocation);
}

@component
class SomeController {
  // we inject SomeService instance to SomeController
  @autowired SomeService someService;
  
  // this method calls injected someService.sayHello method
  String sayHello() => someService.sayHello();
}

@component
abstract class InjectedService {
  //
  @inject SomeService someService;
  
  String sayHi() => "hi ";
}

@component
class InjectedServiceImpl extends InjectedService {
  String sayHi() => super.sayHi() + someService.sayHello(); 
}