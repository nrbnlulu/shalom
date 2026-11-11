## 0.1.0

* `ShalomDebugPanel` (cache inspector) is now built only on `package:flutter/widgets.dart`.
  It no longer depends on Material or Cupertino, so it renders the same in any app and
  does not need the host app to bundle the MaterialIcons font.
* Inspector controls expose stable `Semantics` identifiers (`shalom-inspector-*`).
* Keyboard navigation (Tab / Enter / Space) for inspector tabs, list items and links.
* Filter field supports text selection and a copy/paste context menu.
* Copy raw JSON and copy variables buttons.

## 0.0.1

* Initial version.
