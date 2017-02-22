// GENERATED CODE - DO NOT MODIFY BY HAND

part of drails_di_aop_proxy_test;

// **************************************************************************
// Generator: InitMirrorsGenerator
// Target: library drails_di_aop_proxy_test
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

// **************************************************************************
// Generator: DsonGenerator
// Target: abstract class SomeService
// **************************************************************************

abstract class _$SomeServiceSerializable extends SerializableMap {
  String sayHello();
  dynamic throwsError();

  operator [](Object key) {
    switch (key) {
      case 'sayHello':
        return sayHello;
      case 'throwsError':
        return throwsError;
    }
    throwFieldNotFoundException(key, 'SomeService');
  }

  operator []=(Object key, value) {
    switch (key) {
    }
    throwFieldNotFoundException(key, 'SomeService');
  }

  get keys => SomeServiceClassMirror.fields.keys;
}

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

// **************************************************************************
// Generator: MirrorsGenerator
// Target: class SomeServiceImpl
// **************************************************************************

_SomeServiceImpl__Constructor(params) => new SomeServiceImpl();

const SomeServiceImplClassMirror = const ClassMirror(
    name: 'SomeServiceImpl',
    constructors: const {
      '': const FunctionMirror(
          parameters: const {}, call: _SomeServiceImpl__Constructor)
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

// **************************************************************************
// Generator: MirrorsGenerator
// Target: class SomeServiceAopProxy
// **************************************************************************

_SomeServiceAopProxy__Constructor(params) => new SomeServiceAopProxy();

const SomeServiceAopProxyClassMirror = const ClassMirror(
    name: 'SomeServiceAopProxy',
    constructors: const {
      '': const FunctionMirror(
          parameters: const {}, call: _SomeServiceAopProxy__Constructor)
    },
    methods: const {
      'noSuchMethod': const FunctionMirror(
        name: 'noSuchMethod',
        returnType: dynamic,
        parameters: const {
          'invocation': const DeclarationMirror(type: Invocation)
        },
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

// **************************************************************************
// Generator: DsonGenerator
// Target: class SomeController
// **************************************************************************

abstract class _$SomeControllerSerializable extends SerializableMap {
  SomeService get someService;
  void set someService(SomeService v);
  String sayHello();

  operator [](Object key) {
    switch (key) {
      case 'someService':
        return someService;
      case 'sayHello':
        return sayHello;
    }
    throwFieldNotFoundException(key, 'SomeController');
  }

  operator []=(Object key, value) {
    switch (key) {
      case 'someService':
        someService = value;
        return;
    }
    throwFieldNotFoundException(key, 'SomeController');
  }

  get keys => SomeControllerClassMirror.fields.keys;
}

_SomeController__Constructor(params) => new SomeController();

const $$SomeController_fields_someService =
    const DeclarationMirror(type: SomeService, annotations: const [autowired]);

const SomeControllerClassMirror =
    const ClassMirror(name: 'SomeController', constructors: const {
  '': const FunctionMirror(
      parameters: const {}, call: _SomeController__Constructor)
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

// **************************************************************************
// Generator: DsonGenerator
// Target: abstract class InjectedService
// **************************************************************************

abstract class _$InjectedServiceSerializable extends SerializableMap {
  SomeService get someService;
  void set someService(SomeService v);
  String sayHi();

  operator [](Object key) {
    switch (key) {
      case 'someService':
        return someService;
      case 'sayHi':
        return sayHi;
    }
    throwFieldNotFoundException(key, 'InjectedService');
  }

  operator []=(Object key, value) {
    switch (key) {
      case 'someService':
        someService = value;
        return;
    }
    throwFieldNotFoundException(key, 'InjectedService');
  }

  get keys => InjectedServiceClassMirror.fields.keys;
}

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

// **************************************************************************
// Generator: MirrorsGenerator
// Target: class InjectedServiceImpl
// **************************************************************************

_InjectedServiceImpl__Constructor(params) => new InjectedServiceImpl();

const InjectedServiceImplClassMirror = const ClassMirror(
    name: 'InjectedServiceImpl',
    constructors: const {
      '': const FunctionMirror(
          parameters: const {}, call: _InjectedServiceImpl__Constructor)
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

// **************************************************************************
// Generator: MirrorsGenerator
// Target: increaseBeforeCounter
// **************************************************************************

const increaseBeforeCounterFunctionMirror = const FunctionMirror(
    name: 'increaseBeforeCounter',
    returnType: dynamic,
    parameters: const {'invocation': const DeclarationMirror(type: dynamic)},
    annotations: const [const Before(SomeService_sayHello)]);

// **************************************************************************
// Generator: MirrorsGenerator
// Target: increaseAfterCounter
// **************************************************************************

const increaseAfterCounterFunctionMirror = const FunctionMirror(
    name: 'increaseAfterCounter',
    returnType: dynamic,
    parameters: const {'retVal': const DeclarationMirror(type: dynamic)},
    annotations: const [const After(someService_sayHello_noRetVal)]);

// **************************************************************************
// Generator: MirrorsGenerator
// Target: noIncreaseAfterCounter
// **************************************************************************

const noIncreaseAfterCounterFunctionMirror = const FunctionMirror(
    name: 'noIncreaseAfterCounter',
    returnType: dynamic,
    parameters: const {'retVal': const DeclarationMirror(type: dynamic)},
    annotations: const [const After(someService_sayHello_retValNull)]);

// **************************************************************************
// Generator: MirrorsGenerator
// Target: increaseAfterCounter2
// **************************************************************************

const increaseAfterCounter2FunctionMirror = const FunctionMirror(
    name: 'increaseAfterCounter2',
    returnType: dynamic,
    parameters: const {'retVal': const DeclarationMirror(type: dynamic)},
    annotations: const [const After(someService_sayHello_retVal)]);

// **************************************************************************
// Generator: MirrorsGenerator
// Target: increaseAfterThrowingCounter
// **************************************************************************

const increaseAfterThrowingCounterFunctionMirror = const FunctionMirror(
    name: 'increaseAfterThrowingCounter',
    returnType: dynamic,
    parameters: const {
      'retVal': const DeclarationMirror(type: dynamic),
      'ex': const DeclarationMirror(type: Exception)
    },
    annotations: const [
      const AfterThrowing(SomeService_throwinError)
    ]);
