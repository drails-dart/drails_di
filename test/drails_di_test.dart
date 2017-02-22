library drails_di_test;

import 'package:drails_di/drails_di.dart';
import 'package:dson/dson.dart';
import 'package:test/test.dart';

part 'drails_di_test.g.dart';

@reflectable
abstract class SomeService {
  String sayHello() => "hello";
}

@reflectable
class SomeServiceImpl extends SomeService {
  String sayHello() => "${super.sayHello()} impl";
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

main() {
  _initMirrors();
  group('Simple Test ->', () {
    setUp(() {
      ApplicationContext.bootstrap();
    });
    
    test('SomeService', () {
      SomeService someService = injectorGet(SomeService);
      expect(someService is SomeService, true, reason: 'someService should be SomeService');
      
      expect(someService.sayHello(), "hello impl");
      
      SomeController someController = injectorGet(SomeController);
      expect(someController.someService is SomeService, true);
      
    });
    
    test('InjectedService', () {
      InjectedService injectedService = injectorGet(InjectedService);
      expect(injectedService is InjectedServiceImpl, true);
      expect(injectedService.someService is SomeServiceImpl, true);
      expect(injectedService.sayHi(), "hi hello impl");
    });
  });
}