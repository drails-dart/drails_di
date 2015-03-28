# Drails DI

This library maintains the dependency injection of drails. It also can be used on client side projects.

## Dependency Injection

The framework  wires classes with postfix: `Controller`, `Service`, and `Repository`. For example, you can create a abstract class named 'SomeService':

```dart
abstract class SomeService {
  String someMethod();
}
```

and then we can create next implementation class:

```dart
class SomeServiceImpl implements SomeService {
  String someMethod() => 'someMethod';
}
```

finally to inject a component we use the annotation `@autowire` or the annotation `@inject`.

```dart
class SomeController {
  // we inject the service SomeService from the ApplicationContest.components map
  // you can use @autowire as well
  @inject SomeService someService;
  
  //simply calls the someService.someMethod()
  String callSomeMethod() => someService.someMethod();
}
```

in that way whenever a controller has a variable of Type SomeService and is annotated with @autowired the framework is going to inject SomeServiceImpl into the controller.

If you have a third level class that implements or extends SomeService this class is going to be used doubt to the level.

## Boostrapping

To start the wiring/injection of the components you should call `Application.bootstrap()`. This method search for every class that ends with `Controller`, `Service`, or `Repository`, then look for the super classes that implements or extends the abstracts or base classes, and finally injects the necessary components to every instantiated class. For example:

```dart
library drails_di_test;

import 'package:drails_di/drails_di.dart';
import 'package:unittest/unittest.dart';

abstract class SomeService {
  String sayHello() => "hello";
}

class SomeServiceImpl extends SomeService {
  String sayHello() => "${super.sayHello()} impl";
}

class SomeController {
  @autowired SomeService someService;
  
  String sayHi() => someService.sayHello();
}

main() {
  // initialize the 
  ApplicationContext.bootstrap([#drails_di_test]);
  
  SomeService someService = extract(SomeService);
  expect(someService is SomeService, true, reason: 'someService should be SomeService');
  someService.sayHello(); // prints "hello impl"
  
  SomeController someController = extract(SomeController);
  someController.someService.sayHello(); //prints "Hello impl"
  someController.sayHi(); // prints "Hi Hello impl"
}
```

As you can see in the previous example the first parameter passed to `ApplicationContest.bootstrap` is the symbol of the library where we are going to scan for components. However you can also pass a second parameter call `bind`. This parameter is a map that contains the manual wiring. You are going to see this in action in next section.

## Mocking Components using Dart Mockito library

Although you can use any Mock library, I recomend the use of Mockito since its power and versatility.

During unit testing one important feature is mocking components (Create fakes components that acts as the reals components). In that way we can decouple every stage of the application, and be sure that we are only testing one module at a time. This is specially useful when we call remote web-service or endpoints. In this way our test doesn't depends on third party data that could change during the time making our test invalid. For example:

```dart
library drails_di_mockito_test;

import 'package:drails_di/drails_di.dart';
import 'package:unittest/unittest.dart';
import 'package:mockito/mockito.dart';

main() {
  group('Mockito Test ->', () {

    setUp(() {
      //We initialize the application
      ApplicationContext.bootstrap([#drails_di_mockito_test],
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

abstract class SomeService {
  String sayHello() => "hello";
}

class SomeServiceImpl extends SomeService {
  String sayHello() => "${super.sayHello()} impl";
}

// we declare the Mock service
class SomeServiceMock extends Mock implements SomeService { 
  //this method could be ommited, but I don't like to see the warning.
  noSuchMethod(invocation) =>
    super.noSuchMethod(invocation);
}

class SomeController {
  // we inject SomeService instance to SomeController
  @autowired SomeService someService;
  
  // this method calls injected someService.sayHello method
  String sayHello() => someService.sayHello();
}

abstract class InjectedService {

  @inject SomeService someService;
  
  String sayHi() => "hi ";
}

class InjectedServiceImpl extends InjectedService {
  String sayHi() => super.sayHi() + someService.sayHello(); 
}
```

