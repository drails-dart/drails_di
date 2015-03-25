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

  /**
   * Get the controllers from the application Context
   */
  static Iterable<Object> get controllers {
    return components.values.where((component) => CONTROLLER_NAMES.any((name) => 
      MirrorSystem.getName(reflect(component).type.simpleName).endsWith(name))
    );
  }

  /// Initialize the application Context. Search into all the libraries [includedLibs] and then
  /// create an instance of every class that ends with Service, Controller or Repository. Then Inject
  /// the respectives values to every created class.
  static void bootstrap(List<Symbol> includedLibs, {Map<Type, Object> bind}) {
    // clear components for multiple initialization when unit testing
    components.clear();
    
    if(bind != null) {
      components.addAll(bind);
    }
    
    CONTROLLER_NAMES.addAll(_CONTROLLER_NAMES);
    COMPONENT_NAMES..addAll(_COMPONENT_NAMES)..addAll(CONTROLLER_NAMES);
    List<DeclarationMirror> dms = [];
    includedLibs.forEach((incLibrary) {
      var libs = currentMirrorSystem().findLibrary(incLibrary).declarations.values.where((dm) => dm is ClassMirror);
      dms.addAll(libs);
    });
    
    var proxyOfComponent = {};

    /// Contains the proxies of the components
    Map<Type, Object> proxies = {};

    dms.where((dm) =>
      MirrorSystem.getName(dm.simpleName).endsWith('AopProxy')
    ).forEach((ClassMirror injectableProxyCm) {
        var componentType = injectableProxyCm.superinterfaces.first.reflectedType;
        proxies[componentType] = injectableProxyCm.newInstance(const Symbol(''), []).reflectee;
        proxyOfComponent[componentType] = injectableProxyCm.reflectedType;
    });
    
    //Get Components' instances
    dms.where((dm) => 
      COMPONENT_NAMES.any((name) => MirrorSystem.getName(dm.simpleName).endsWith(name))
    ).forEach((ClassMirror injectableCm) {
      var componentType = injectableCm.reflectedType;
      
      if(components[componentType] == null) {
        if(proxies[componentType] != null) {
          
          components[componentType] = proxies[injectableCm.reflectedType];
          _componentOfProxy[proxyOfComponent[componentType]] = injectableCm.isAbstract 
              ? getObjectThatExtend(injectableCm, dms)
              : injectableCm.newInstance(const Symbol(''), []).reflectee;
        } else {
          components[componentType] = injectableCm.isAbstract 
                ? getObjectThatExtend(injectableCm, dms)
                : injectableCm.newInstance(const Symbol(''), []).reflectee;
        }
      }
    });
    
    _appContextlog.fine('components: $components');
    
    _injectComponents();
  }
  
  static void _injectComponents() {
    components.values.forEach((component) {
      var im = reflect(component);
      
      new GetVariablesAnnotatedWith<_Inject>().from(im).forEach((vm) {
        _appContextlog.fine(vm.type);
        var injectable = components[vm.type.reflectedType];
        im.setField(vm.simpleName, injectable);
      });
    });
  }
}
