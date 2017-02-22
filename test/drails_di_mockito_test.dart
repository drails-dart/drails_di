library drails_di_mockito_test;

import 'package:drails_di/drails_di.dart';
import 'package:test/test.dart';
import 'package:mockito/mockito.dart';

part 'drails_di_mockito_test.g.dart';

@serializable
abstract class SomeService extends _$SomeServiceSerializable {
  String sayHello() => "hello";
}

@reflectable
class SomeServiceImpl extends SomeService {
  String sayHello() => "${super.sayHello()} impl";
}

// we declare the Mock service
class SomeServiceMock extends Mock implements SomeService {
}

@serializable
class SomeController extends _$SomeControllerSerializable {
  // we inject SomeService instance to SomeController
  @autowired SomeService someService;

  // this method calls injected someService.sayHello method
  String sayHello() => someService.sayHello();
}

@serializable
abstract class InjectedService extends _$InjectedServiceSerializable {
  //
  @inject SomeService someService;

  String sayHi() => "hi ";
}

@reflectable
class InjectedServiceImpl extends InjectedService {
  String sayHi() => super.sayHi() + someService.sayHello();
}

main() {
  _initMirrors();
  group('Mockito Test ->', () {
    setUp(() {
      //We initialize the application
      ApplicationContext.bootstrap(bind: {
        //bind SomeService Manually, stopping autowiring
        SomeService: new SomeServiceMock()
      });

      //extract the Mock service from the ApplicationContext.components map
      SomeService someService = injectorGet(SomeService);
      //mock the sayHello Method so we can return a fake value
      when(someService.sayHello()).thenReturn('hello mock');
    });


    test('SomeService', () {
      //extract someService from the ApplicationContext.components map
      SomeService someService = injectorGet(SomeService);

      expect(someService is SomeServiceMock, true, reason: 'someService should be SomeServiceMock');

      expect(someService.sayHello(), "hello mock");

      SomeController someController = injectorGet(SomeController);
      expect(someController.someService is SomeServiceMock, true);
    });

    test('InjectedService', () {
      //extract injectedService from the ApplicationContext.components map
      InjectedService injectedService = injectorGet(InjectedService);
      expect(injectedService is InjectedServiceImpl, true);
      expect(injectedService.someService is SomeServiceMock, true);
      expect(injectedService.sayHi(), "hi hello mock");
    });
  });
}
