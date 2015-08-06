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
List<String> CONTROLLER_NAMES = [], COMPONENT_NAMES = [];

/// Extract the singleton from the [ApplicationContext]. This is useful for global functions or Instances that cannot be 
/// treated as Injectables
Object extract(Type t) => ApplicationContext.components[t];

class ApplicationContext {
  /// Contains the Objects with its respectives injected objects. This is useful for global functions or Instances that cannot be 
  /// treated as Injectables
  static Map<Type, Object> components = {};
  
  /// Contains a map that link every component to its respective proxy
  static Map<Type, Object> _componentOfProxy = {};
  
  static Map<MethodMirror, LibraryMirror> aspectsBefore = {};
  static Map<MethodMirror, LibraryMirror> _aspectsAfter = {};
  static Map<MethodMirror, LibraryMirror> _aspectsAfterFinally = {};
  static Map<MethodMirror, LibraryMirror> _aspectsAfterThrowing = {};

  /// Get the controllers from the application Context
  static Iterable<Object> get controllers {
    return components.values.where((component_) => CONTROLLER_NAMES.any((name) =>
      component.reflect(component_).type.simpleName.endsWith(name))
    );
  }

  /// Initialize the application Context. Search into all the libraries [includedLibs] and then
  /// create an instance of every class that ends with Service, Controller or Repository. Then Inject
  /// the respectives values to every created class.
  static void bootstrap(List<String> includedLibs, {Map<Type, Object> bind}) {
    // clear components for multiple initialization when unit testing
    components.clear();
    
    if(bind != null) {
      components.addAll(bind);
    }
    
    CONTROLLER_NAMES.addAll(_CONTROLLER_NAMES);
    COMPONENT_NAMES..addAll(_COMPONENT_NAMES)..addAll(CONTROLLER_NAMES);
    
    List<ClassMirror> cms = [];
    
    includedLibs.forEach((incLibraryName) {
      LibraryMirror incLibrary = component.findLibrary(incLibraryName);
      var dms = incLibrary.declarations.values;
      dms.forEach((dm) {
        if(dm is ClassMirror) {
          cms.add(dm);
          return;
        }
        if(dm is MethodMirror) {
          if(new IsAnnotation<Before>().onDeclaration(dm)) {
            aspectsBefore[dm] = incLibrary;
            return;
          }
          if(new IsAnnotation<After>().onDeclaration(dm)) {
            _aspectsAfter[dm] = incLibrary;
            return;
          }
          if(new IsAnnotation<AfterFinally>().onDeclaration(dm)) {
            _aspectsAfterFinally[dm] = incLibrary;
            return;
          }
          if(new IsAnnotation<AfterThrowing>().onDeclaration(dm)) {
            _aspectsAfterThrowing[dm] = incLibrary;
            return;
          }
        }
      });
    });
    
    var proxyOfComponent = {};

    /// Contains the proxies of the components
    Map<Type, Object> proxies = {};

    cms.where((dm) =>
      dm.simpleName.endsWith('AopProxy')
    ).forEach((ClassMirror injectableProxyCm) {
        var componentType = injectableProxyCm.superinterfaces.first.reflectedType;
        proxies[componentType] = injectableProxyCm.newInstance('', []);
        proxyOfComponent[componentType] = injectableProxyCm.reflectedType;
    });
    
    //Get Components' instances
    cms.where((dm) => 
      COMPONENT_NAMES.any((name) => dm.simpleName.endsWith(name))
    ).forEach((ClassMirror injectableCm) {
      var componentType = injectableCm.reflectedType;
      
      if(components[componentType] == null) {
        if(proxies[componentType] != null) {
          
          components[componentType] = proxies[injectableCm.reflectedType];
          _componentOfProxy[proxyOfComponent[componentType]] = injectableCm.isAbstract 
              ? getObjectThatExtend(injectableCm, cms)
              : injectableCm.newInstance('', []);
        } else {
          components[componentType] = injectableCm.isAbstract 
                ? getObjectThatExtend(injectableCm, cms)
                : injectableCm.newInstance('', []);
        }
      }
    });
    
    _appContextlog.fine('components: $components');
    
    _injectComponents();
  }
  
  static void _injectComponents() {
    components.values.forEach((component_) {
      InstanceMirror im = component.reflect(component_);
      
      new GetVariablesAnnotatedWith<_Inject>().from(im, component).forEach((vm) {
        _appContextlog.fine(vm.type);
        var injectable = components[vm.type.reflectedType];
        im.invokeSetter(vm.simpleName, injectable);
      });
    });
  }
}
