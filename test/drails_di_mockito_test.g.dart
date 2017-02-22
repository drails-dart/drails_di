// GENERATED CODE - DO NOT MODIFY BY HAND

part of drails_di_mockito_test;

// **************************************************************************
// Generator: InitMirrorsGenerator
// Target: library drails_di_mockito_test
// **************************************************************************

_initMirrors() {
  initClassMirrors({
    SomeService: SomeServiceClassMirror,
    SomeServiceImpl: SomeServiceImplClassMirror,
    SomeController: SomeControllerClassMirror,
    InjectedService: InjectedServiceClassMirror,
    InjectedServiceImpl: InjectedServiceImplClassMirror
  });
  initFunctionMirrors({});
}

// **************************************************************************
// Generator: DsonGenerator
// Target: abstract class SomeService
// **************************************************************************

abstract class _$SomeServiceSerializable extends SerializableMap {
  String sayHello();

  operator [](Object key) {
    switch (key) {
      case 'sayHello':
        return sayHello;
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
      )
    },
    superclass: SomeService);

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
