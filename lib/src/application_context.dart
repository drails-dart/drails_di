part of drails_di;

final _appContextlog = new Logger('application_context');

///Default controller names
const _CONTROLLER_NAMES = const ['Controller'];

///Default Component names
const _COMPONENT_NAMES = const ['Service', 'Repository'];

/**
 * This are global variable that allows users to add their custom name for controllers, Services, and Repositories,
 * for example users could add 'Srvc' for services, 'Ctrlr' for controllers, 'repo' for repositories.
 */
List<String> CONTROLLER_NAMES = [],
    COMPONENT_NAMES = [];

/// Extract the singleton from the [ApplicationContext]. This is useful for global functions or Instances that cannot be
/// treated as Injectables
T injectorGet<T extends SerializableMap>(Type t) => ApplicationContext.components[t];

class ApplicationContext {
  /// Contains the Objects with its respectives injected objects. This is useful for global functions or Instances that cannot be
  /// treated as Injectables
  static Map<Type, SerializableMap> components = {};
  static Map<FunctionMirror, Function> proxyFunctions = {};

  /// Contains a map that link every component to its respective proxy
  static Map<Type, Object> _componentOfProxy = {};

  static Map<FunctionMirror, Function> _aspectsBefore = {};
  static Map<FunctionMirror, Function> _aspectsAfter = {};
  static Map<FunctionMirror, Function> _aspectsAfterFinally = {};
  static Map<FunctionMirror, Function> _aspectsAfterThrowing = {};

  /// Get the controllers from the application Context
  static Iterable<SerializableMap> get controllers =>
      components.values.where((component_) =>
          CONTROLLER_NAMES.any((name) => reflect(component_).name.endsWith(name)));

  /// Initialize the application Context. Search into all the mirrors and then
  /// create an instance of every class that ends with Service, Controller or Repository. Then Inject
  /// the respective values to every created class.
  static void bootstrap({Map<Type, Object> bind}) {
    // clear components for multiple initialization when unit testing
    components.clear();

    if (bind != null) {
      components.addAll(bind);
    }

    CONTROLLER_NAMES.addAll(_CONTROLLER_NAMES);
    COMPONENT_NAMES..addAll(_COMPONENT_NAMES)..addAll(CONTROLLER_NAMES);

    functionMirrors.forEach((function, fm) {
      for (var a in fm.annotations) {
        if (a is Before) {
          _aspectsBefore[fm] = function;
          return;
        } else if (a is After) {
          _aspectsAfter[fm] = function;
          return;
        } else if (a is AfterFinally) {
          _aspectsAfterFinally[fm] = function;
          return;
        } else if (a is AfterThrowing) {
          _aspectsAfterThrowing[fm] = function;
          return;
        } else {
          proxyFunctions[fm] = function;
        }
      }
    });

    var proxyOfComponent = {};

    /// Contains the proxies of the components
    Map<Type, Object> proxies = {};

    classMirrors.forEach((type, cm) {
      if (cm.name.endsWith('AopProxy')) {
        var componentType = cm.superinterfaces.first;
        proxies[componentType] = cm.constructors['']();
        proxyOfComponent[componentType] = type;
      }
    });

    classMirrors.forEach((type, cm) {
      //Get Components' instances
      if (COMPONENT_NAMES.any((name) => cm.name.endsWith(name))) {
        if (components[type] == null) {
          if (proxies[type] != null) {
            components[type] = proxies[type];
            _componentOfProxy[proxyOfComponent[type]] = cm.isAbstract
                ? getObjectThatExtend(cm)
                : cm.constructors['']();
          } else {
            components[type] = cm.isAbstract
                ? getObjectThatExtend(cm)
                : cm.constructors['']();
          }
        }
      }
    });

    _appContextlog.fine('components: $components');

    _injectComponents();
  }

  static void _injectComponents() {
    components.forEach((type, component_) {
      ClassMirror cm = reflectType(type);

      cm.fields?.forEach((name, fieldMirror) {
        if (fieldMirror.annotations?.any(new Is<_Inject>()) == true) {
          _appContextlog.fine(fieldMirror.type);
          var injectable = components[fieldMirror.type];
          component_[name] = injectable;
        }
      });
    });
  }
}
