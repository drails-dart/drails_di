# Drails DI

This library maintains the dependency injection of drails. It also can be used on client side projects.

## Dependency Injection

The framework  wires classes with postfix: `Controller`, `Service`, and `Repository`. For example, we can create an abstract class named 'SomeService':

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
  // we inject the service SomeService from the ApplicationContext.components map
  // you can use @autowire as well
  @inject SomeService someService;
  
  //simply calls the someService.someMethod()
  String callSomeMethod() => someService.someMethod();
}
```

in that way whenever a controller has a variable of Type SomeService and is annotated with `@autowired` or `@inject` the framework is going to inject SomeServiceImpl into the controller.

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
  // initialize the application
  ApplicationContext.bootstrap([#drails_di_test]);
  
  // we use function extract to get SomeServiceImpl
  SomeService someService = extract(SomeService);
  expect(someService is SomeService, true, reason: 'someService should be SomeService');
  someService.sayHello(); // prints "hello impl"
  
  SomeController someController = extract(SomeController);
  someController.someService.sayHello(); //prints "Hello impl"
  someController.sayHi(); // prints "Hi Hello impl"
}
```

As you can see in the previous example the first parameter passed to `ApplicationContext.bootstrap` is the symbol of the library where we are going to scan for components. However you can also pass a second parameter call `bind`. This parameter is a map that contains the manual wiring (You are going to see this in action in next section).

## Mocking Components using Dart Mockito library

>Although you can use any Mock library, I recomend the use of Mockito since its power and versatility.

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

## Aspect Oriented Programing

> In computing, aspect-oriented programming (AOP) is a programming paradigm that aims to increase modularity by allowing the separation of cross-cutting concerns.

> http://en.wikipedia.org/wiki/Aspect-oriented_programming

To be able to use AOP with Drails_DI you need to extend the `AopProxy` class and implement the proxied method. For example, let say you have next class:

```dart

abstract class SomeService {
  String sayHello() => "hello";
  
  throwsError() => throw new Exception("message");
}
```

and you have an implementation:

```dart
class SomeServiceImpl extends SomeService {
  String sayHello() => "${super.sayHello()} impl";
}
```

then to make that component interceptable you need to create an `AopProxy` class:
```dart
class SomeServiceAopProxy extends AopProxy implements SomeService { 
  noSuchMethod(invocation) =>
    super.noSuchMethod(invocation);
}
```

finally you only need to create the aspects/interceptors. To do this you need to create two things: the pointCut and the execution method. In Drails_DI this is doing by mean of top level functions. 

### Before

Before Aspects should be executed before to the pointCut. For example if I want to intercept the method `SomeService.sayHello` before it occurs, I could do:

```dart
var beforeCounter = 0;

// PointCut
bool SomeService_sayHello(component, Invocation inv) =>
    component is SomeService
    && inv.memberName == #sayHello;

// Aspect
@Before(SomeService_sayHello)
// execution method
increaseBeforeCounter() {
  beforeCounter++;
  print("before sayHello $beforeCounter");
}
```

In the previous example I'm telling that the method `increaseBeforeCounter` is going to be executed always that the result of the method `SomeService_sayHello` is true. Since this method is true whenever the `component` (in this case `SomeService` singleton object created by Drails_DI) is `SomeService` type and the invoked member name is `sayHello`.

As you can see the execution method `increaseBeforeCounter` should have as parameter `invocation` which could be modified before executing the intercepted method.

### After

After Aspects should be executed after to the pointCut. For example if I want to intercept the method `SomeService.sayHello` after it occurs, I could do:

```dart
var afterCounter = 0;

someService_sayHello_noRetVal(component, Invocation inv, retVal) =>
    SomeService_sayHello(component, inv);

@After(someService_sayHello_noRetVal)
increaseAfterCounter(retVal) {
  afterCounter++;
  print("after sayHello $afterCounter");
  print(retVal);
  return retVal;
}
```

In the previous example I'm telling that the method `increaseAfterCounter` is going to be executed always the result of the method `SomeService_sayHello_noRetVal` is true. This method is true whenever the function `SomeService_sayHello` is true.

As you can see the execution method `increaseAfterCounter` should have as parameter `retVal` which could be modified before executing the intercepted method and should be returned to continue with the process.

You can also check if the returned Value `retVal` accomplish certain criteria:

```dart
var afterCounter2 = 0;

someService_sayHello_retVal(component, Invocation inv, retVal) =>
    retVal == "hello impl" && SomeService_sayHello(component, inv);

@After(someService_sayHello_retVal)
increaseAfterCounter2(retVal) {
  afterCounter2++;
  print("after sayHello 2 $afterCounter2");
  print(retVal);
  return retVal;
}
```
In the previous example I'm telling that the method `increaseAfterCounter` is going to be executed always the result of the method `SomeService_sayHello_noRetVal` is true. This method is true whenever `retVal` is equal to `"hello impl"` and the function `SomeService_sayHello` is true.

### AfterThrowing

AfterThrowing Aspects should be executed after the pointCut has throwed an exception. For example if I want to intercept the method `SomeService.sayHello` after it throws an exception, I could do:

```dart
var afterTrhowingCounter = 0;

SomeService_throwinError(component, Invocation inv, ex) =>
    ex is Exception
    && component is SomeService
    && inv.memberName == #throwsError;

@AfterThrowing(SomeService_throwinError)
increaseAfterThrowingCounter(retVal, Exception ex) {
  afterTrhowingCounter++;
  print("after throwing $afterTrhowingCounter");
  print(ex);
  throw ex;
}
```

In the previous example I'm telling that the method `increaseAfterThrowingCounter` is going to be executed always that the result of the method `SomeService_throwinError` is true. Since this method is true whenever the exception throwed `ex` is `Exception`, the `component` is `SomeService`, and the invoked member name is `sayHello`.

As you can see the execution method `increaseAfterThrowingCounter` should have as parameter the returned value `retVal` and the exception `ex` which could be modified before executing the intercepted method.


### AfterFinally

AfterFinally Aspects should be executed after the pointCut has throwed an exception. For example if I want to intercept the method `SomeService.sayHello` after it throws an exception, I could do:

```dart
var afterFinallyCounter = 0;

@AfterFinally(SomeService_sayHello)
increaseAfterFinallyCounter(retVal) {
  afterFinallyCounter++;
  print("after sayHello finally $afterFinallyCounter");
  print(retVal);
  return retVal;
}
```

In the previous example I'm telling that the method `increaseAfterFinallyCounter` is going to be executed always that the result of the method `SomeService_sayHello` is true. Since this method is true whenever the `component` is `SomeService`, and the invoked member name is `sayHello`.

As you can see the execution method `increaseAfterFinallyCounter` should have as parameter the returned value `retVal` which could be modified before executing the intercepted method.

