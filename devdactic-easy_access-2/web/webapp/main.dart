library devdactic;

import "package:stream/stream.dart";

part "index.rsp.dart";

//URI mapping
var _mapping = {
  "/": index
};

void main() {
  new StreamServer(uriMapping: _mapping).start();
}
