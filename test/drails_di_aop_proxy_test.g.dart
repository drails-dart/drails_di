// GENERATED CODE - DO NOT MODIFY BY HAND

part of drails_di_aop_proxy_test;

// **************************************************************************
// Generator: DsonGenerator
// **************************************************************************

abstract class _$SomeServiceSerializable extends SerializableMap {
  String sayHello();
  dynamic throwsError();

  operator [](Object __key) {
    switch (__key) {
      case 'sayHello':
        return sayHello;
      case 'throwsError':
        return throwsError;
    }
    throwFieldNotFoundException(__key, 'SomeService');
  }

  operator []=(Object __key, __value) {
    switch (__key) {
    }
    throwFieldNotFoundException(__key, 'SomeService');
  }

  Iterable<String> get keys => SomeServiceClassMirror.fields.keys;
}

abstract class _$SomeControllerSerializable extends SerializableMap {
  SomeService get someService;
  void set someService(SomeService v);
  String sayHello();

  operator [](Object __key) {
    switch (__key) {
      case 'someService':
        return someService;
      case 'sayHello':
        return sayHello;
    }
    throwFieldNotFoundException(__key, 'SomeController');
  }

  operator []=(Object __key, __value) {
    switch (__key) {
      case 'someService':
        someService = __value;
        return;
    }
    throwFieldNotFoundException(__key, 'SomeController');
  }

  Iterable<String> get keys => SomeControllerClassMirror.fields.keys;
}

abstract class _$InjectedServiceSerializable extends SerializableMap {
  SomeService get someService;
  void set someService(SomeService v);
  String sayHi();

  operator [](Object __key) {
    switch (__key) {
      case 'someService':
        return someService;
      case 'sayHi':
        return sayHi;
    }
    throwFieldNotFoundException(__key, 'InjectedService');
  }

  operator []=(Object __key, __value) {
    switch (__key) {
      case 'someService':
        someService = __value;
        return;
    }
    throwFieldNotFoundException(__key, 'InjectedService');
  }

  Iterable<String> get keys => InjectedServiceClassMirror.fields.keys;
}

// **************************************************************************
// Generator: MirrorsGenerator
// **************************************************************************

const SomeServiceClassMirror = const ClassMirror(
    name: 'SomeService',
    methods: const {
      'sayHello': const FunctionMirror(
        name: 'sayHello',
        returnType: String,
      ),
      'throwsError': const FunctionMirror(
        name: 'throwsError',
        returnType: dynamic,
      )
    },
    isAbstract: true);
_SomeServiceImpl__Constructor([positionalParams, namedParams]) =>
    new SomeServiceImpl();

const SomeServiceImplClassMirror = const ClassMirror(
    name: 'SomeServiceImpl',
    constructors: const {
      '': const FunctionMirror($call: _SomeServiceImpl__Constructor)
    },
    methods: const {
      'sayHello': const FunctionMirror(
        name: 'sayHello',
        returnType: String,
      ),
      'throwsError': const FunctionMirror(
        name: 'throwsError',
        returnType: dynamic,
      )
    },
    superclass: SomeService);
_SomeServiceAopProxy__Constructor([positionalParams, namedParams]) =>
    new SomeServiceAopProxy();

const SomeServiceAopProxyClassMirror = const ClassMirror(
    name: 'SomeServiceAopProxy',
    constructors: const {
      '': const FunctionMirror($call: _SomeServiceAopProxy__Constructor)
    },
    methods: const {
      'noSuchMethod': const FunctionMirror(
        positionalParameters: const [
          const DeclarationMirror(
              name: 'invocation', type: Invocation, isRequired: true)
        ],
        name: 'noSuchMethod',
        returnType: dynamic,
      ),
      'sayHello': const FunctionMirror(
        name: 'sayHello',
        returnType: String,
      ),
      'throwsError': const FunctionMirror(
        name: 'throwsError',
        returnType: dynamic,
      )
    },
    superclass: AopProxy,
    superinterfaces: const [SomeService]);
_SomeController__Constructor([positionalParams, namedParams]) =>
    new SomeController();

const $$SomeController_fields_someService =
    const DeclarationMirror(type: SomeService, annotations: const [autowired]);

const SomeControllerClassMirror =
    const ClassMirror(name: 'SomeController', constructors: const {
  '': const FunctionMirror($call: _SomeController__Constructor)
}, fields: const {
  'someService': $$SomeController_fields_someService
}, getters: const [
  'someService'
], setters: const [
  'someService'
], methods: const {
  'sayHello': const FunctionMirror(
    name: 'sayHello',
    returnType: String,
  )
});

const $$InjectedService_fields_someService =
    const DeclarationMirror(type: SomeService, annotations: const [inject]);

const InjectedServiceClassMirror = const ClassMirror(
    name: 'InjectedService',
    fields: const {'someService': $$InjectedService_fields_someService},
    getters: const ['someService'],
    setters: const ['someService'],
    methods: const {
      'sayHi': const FunctionMirror(
        name: 'sayHi',
        returnType: String,
      )
    },
    isAbstract: true);
_InjectedServiceImpl__Constructor([positionalParams, namedParams]) =>
    new InjectedServiceImpl();

const InjectedServiceImplClassMirror = const ClassMirror(
    name: 'InjectedServiceImpl',
    constructors: const {
      '': const FunctionMirror($call: _InjectedServiceImpl__Constructor)
    },
    fields: const {'someService': $$InjectedService_fields_someService},
    getters: const ['someService'],
    setters: const ['someService'],
    methods: const {
      'sayHi': const FunctionMirror(
        name: 'sayHi',
        returnType: String,
      )
    },
    superclass: InjectedService);
const increaseBeforeCounterFunctionMirror = const FunctionMirror(
    positionalParameters: const [
      const DeclarationMirror(
          name: 'invocation', type: dynamic, isRequired: true)
    ],
    name: 'increaseBeforeCounter',
    returnType: dynamic,
    annotations: const [const Before(SomeService_sayHello)]);
const increaseAfterCounterFunctionMirror = const FunctionMirror(
    positionalParameters: const [
      const DeclarationMirror(name: 'retVal', type: dynamic, isRequired: true)
    ],
    name: 'increaseAfterCounter',
    returnType: dynamic,
    annotations: const [const After(someService_sayHello_noRetVal)]);
const noIncreaseAfterCounterFunctionMirror = const FunctionMirror(
    positionalParameters: const [
      const DeclarationMirror(name: 'retVal', type: dynamic, isRequired: true)
    ],
    name: 'noIncreaseAfterCounter',
    returnType: dynamic,
    annotations: const [const After(someService_sayHello_retValNull)]);
const increaseAfterCounter2FunctionMirror = const FunctionMirror(
    positionalParameters: const [
      const DeclarationMirror(name: 'retVal', type: dynamic, isRequired: true)
    ],
    name: 'increaseAfterCounter2',
    returnType: dynamic,
    annotations: const [const After(someService_sayHello_retVal)]);
const increaseAfterThrowingCounterFunctionMirror = const FunctionMirror(
    positionalParameters: const [
      const DeclarationMirror(name: 'retVal', type: dynamic, isRequired: true),
      const DeclarationMirror(name: 'ex', type: Exception, isRequired: true)
    ],
    name: 'increaseAfterThrowingCounter',
    returnType: dynamic,
    annotations: const [const AfterThrowing(SomeService_throwinError)]);

// **************************************************************************
// Generator: InitMirrorsGenerator
// **************************************************************************

_initMirrors() {
  initClassMirrors({
    SomeService: SomeServiceClassMirror,
    SomeServiceImpl: SomeServiceImplClassMirror,
    SomeServiceAopProxy: SomeServiceAopProxyClassMirror,
    SomeController: SomeControllerClassMirror,
    InjectedService: InjectedServiceClassMirror,
    InjectedServiceImpl: InjectedServiceImplClassMirror
  });
  initFunctionMirrors({
    increaseBeforeCounter: increaseBeforeCounterFunctionMirror,
    increaseAfterCounter: increaseAfterCounterFunctionMirror,
    noIncreaseAfterCounter: noIncreaseAfterCounterFunctionMirror,
    increaseAfterCounter2: increaseAfterCounter2FunctionMirror,
    increaseAfterThrowingCounter: increaseAfterThrowingCounterFunctionMirror
  });
}
