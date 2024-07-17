//
//  Generated file. Do not edit.
//

// clang-format off

#include "generated_plugin_registrant.h"

#include <readability/readability_plugin.h>

void fl_register_plugins(FlPluginRegistry* registry) {
  g_autoptr(FlPluginRegistrar) readability_registrar =
      fl_plugin_registry_get_registrar_for_plugin(registry, "ReadabilityPlugin");
  readability_plugin_register_with_registrar(readability_registrar);
}
