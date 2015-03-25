part of drails_di;

/**
 * Indicates that the variable is going to be injected 
 * using the Type as reference
 */
const inject = const _Inject(), 
      autowired = inject;

class _Inject {
  const _Inject();
}
