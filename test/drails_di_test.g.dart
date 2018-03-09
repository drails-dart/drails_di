// GENERATED CODE - DO NOT MODIFY BY HAND

part of drails_di_test;

// **************************************************************************
// Generator: DsonGenerator
// **************************************************************************

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
      )
    },
    isAbstract: true);
_SomeServiceImpl__Constructor([positionalParams, namedParams]) =>
    new SomeServiceImpl();

const SomeServiceImplClassMirror = const ClassMirror(
    name: 'SomeServiceImpl',
    constructors: const {
      '': const FunctionMirror(name: '', $call: _SomeServiceImpl__Constructor)
    },
    methods: const {
      'sayHello': const FunctionMirror(
        name: 'sayHello',
        returnType: String,
      )
    },
    superclass: SomeService);
_SomeController__Constructor([positionalParams, namedParams]) =>
    new SomeController();

const $$SomeController_fields_someService = const DeclarationMirror(
    name: 'someService', type: SomeService, annotations: const [autowired]);

const SomeControllerClassMirror =
    const ClassMirror(name: 'SomeController', constructors: const {
  '': const FunctionMirror(name: '', $call: _SomeController__Constructor)
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

const $$InjectedService_fields_someService = const DeclarationMirror(
    name: 'someService', type: SomeService, annotations: const [inject]);

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
      '': const FunctionMirror(
          name: '', $call: _InjectedServiceImpl__Constructor)
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
// Generator: InitMirrorsGenerator
// **************************************************************************

_initMirrors() {
  initClassMirrors({
    SomeService: SomeServiceClassMirror,
    SomeServiceImpl: SomeServiceImplClassMirror,
    SomeController: SomeControllerClassMirror,
    InjectedService: InjectedServiceClassMirror,
    InjectedServiceImpl: InjectedServiceImplClassMirror
  });
}
