## 0.1.0









feature: export ObjC dependency provider for MulleWebServer

* add public MulleObjCDeps+MulleWebServer header/implementation exposing a dependencies() selector so dependent libraries can declare load-time deps
* reflection imports updated to use the new MulleObjCDeps header; generated objc-deps.inc added and old objc-loader.inc removed
* silence unused-parameter warnings and cleanup minor handler code in MulleWebHandler
