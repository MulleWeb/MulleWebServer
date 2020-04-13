#
# cmake/reflect/_Headers.cmake is generated by `mulle-sde reflect`. Edits will be lost.
#
if( MULLE_TRACE_INCLUDE)
   MESSAGE( STATUS "# Include \"${CMAKE_CURRENT_LIST_FILE}\"" )
endif()

set( INCLUDE_DIRS
src
src/reflect
)

set( PRIVATE_GENERATED_HEADERS
src/reflect/_MulleWebServer-import-private.h
src/reflect/_MulleWebServer-include-private.h
)

set( PRIVATE_HEADERS
src/import-private.h
)

set( PUBLIC_GENERATED_HEADERS
src/reflect/_MulleWebServer-import.h
src/reflect/_MulleWebServer-include.h
)

set( PUBLIC_HEADERS
src/MulleCivetWebServer+OS.h
src/MulleObjCLoader+MulleWebServer.h
src/MulleWebHandler.h
src/MulleWebServer.h
src/import.h
)

