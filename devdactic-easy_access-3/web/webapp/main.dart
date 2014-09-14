library devdactic;

import "dart:async";
import "dart:io";
import "package:stream/stream.dart";
import "package:rikulo_security/security.dart";
import "package:rikulo_security/plugin.dart";

part "home.rsp.dart";
part "private-area/index.rsp.dart";

void main() {
  final authenticator = new DummyAuthenticator()
      ..addUser("beginner", "1337", ["user"])
      ..addUser("admin", "1337", ["user"]);
  
  final accessControl = new SimpleAccessControl({
    "/private-area(|.*)": ["user"]
  });
  
  final myCustomRedirector = new _Redirector();
  
  final security = new Security(authenticator, accessControl, redirector : myCustomRedirector);
  
  new StreamServer(uriMapping: {
      "/": home,
      "/private-area": index,
      "/s_login": security.login,
      "/s_logout": security.logout
    }, filterMapping: {
      "/.*": security.filter
    }, errorMapping: {
      "404": "/404.html"
    }).start();

}

class _Redirector extends Redirector {
  @override
  String getLogin(HttpConnect connect) => "/";
  
  @override
  String getLoginFailed(HttpConnect connect, String username, bool rememberMe) => "?error=1";
  
  @override
  String getLoginTarget(HttpConnect connect, String originalUri)
  => originalUri != null ? originalUri: "/private-area";
}