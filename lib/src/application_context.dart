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

class ApplicationContext {
  static Map<Type, Object> components = {};
  static Map<Type, Object> proxyOfComponent = {};
  static Map<Type, Object> componentOfProxy = {};

  /**
   * Get the controllers from the application Context
   */
  static Iterable<Object> get controllers {
    return components.values.where((component) => CONTROLLER_NAMES.any((name) => 
        MirrorSystem.getName(reflect(component).type.simpleName).endsWith(name))
       );
  }

  /**
   * Initialize the application Context
   */
  static void bootstrap(List<Symbol> includedLibs) {
    CONTROLLER_NAMES.addAll(_CONTROLLER_NAMES);
    COMPONENT_NAMES..addAll(_COMPONENT_NAMES)..addAll(CONTROLLER_NAMES);
    var dms = [];
    includedLibs.forEach((inclibrary) {
      var libs = currentMirrorSystem().findLibrary(inclibrary).declarations.values.where((dm) => dm is ClassMirror);
      dms.addAll(libs);
    });
    
    //Get Components' instances
    dms.where((dm) => 
      COMPONENT_NAMES.any((name) => MirrorSystem.getName(dm.simpleName).endsWith(name))
    ).forEach((ClassMirror injectableCm) =>
      components[injectableCm.reflectedType] =injectableCm.isAbstract 
          ? getObjectThatExtend(injectableCm, dms)
          : injectableCm.newInstance(const Symbol(''), []).reflectee );
    
    _appContextlog.fine('components: $components');
    
    _injectComponents();
  }
  
  static void _injectComponents() {
    components.values.forEach((component) {
      var im = reflect(component);
      
      new GetVariablesAnnotatedWith<_Autowired>().from(im).forEach((vm) {
        _appContextlog.fine(vm.type);
        var injectable = components[vm.type.reflectedType];
        im.setField(vm.simpleName, injectable);
      });
    });
  }
  
}
