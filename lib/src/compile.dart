// Copyright 2018 Google Inc. Use of this source code is governed by an
// MIT-style license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

// DO NOT EDIT. This file was generated from async_compile.dart.
// See tool/synchronize.dart for details.
//
// Checksum: 5ce549b3c33e03ea84c9caf4933d88be9c993ba1
//
// ignore_for_file: unused_import

import 'async_compile.dart';
export 'async_compile.dart';

import 'package:path/path.dart' as p;
import 'package:source_maps/source_maps.dart';
import 'package:source_span/source_span.dart';

import 'ast/sass.dart';
import 'import_cache.dart';
import 'callable.dart';
import 'importer.dart';
import 'importer/node.dart';
import 'io.dart';
import 'logger.dart';
import 'sync_package_resolver.dart';
import 'syntax.dart';
import 'visitor/evaluate.dart';
import 'visitor/serialize.dart';

/// Like [compile] in `lib/sass.dart`, but provides more options to support
/// the node-sass compatible API.
CompileResult compile(String path,
        {Syntax syntax,
        Logger logger,
        Iterable<Importer> importers,
        NodeImporter nodeImporter,
        SyncPackageResolver packageResolver,
        Iterable<String> loadPaths,
        Iterable<Callable> functions,
        OutputStyle style,
        bool useSpaces = true,
        int indentWidth,
        LineFeed lineFeed,
        bool sourceMap = false}) =>
    compileString(readFile(path),
        syntax: syntax ?? Syntax.forPath(path),
        logger: logger,
        importers: importers,
        nodeImporter: nodeImporter,
        packageResolver: packageResolver,
        loadPaths: loadPaths,
        importer: FilesystemImporter('.'),
        functions: functions,
        style: style,
        useSpaces: useSpaces,
        indentWidth: indentWidth,
        lineFeed: lineFeed,
        url: p.toUri(path),
        sourceMap: sourceMap);

/// Like [compileString] in `lib/sass.dart`, but provides more options to
/// support the node-sass compatible API.
CompileResult compileString(String source,
    {Syntax syntax,
    Logger logger,
    Iterable<Importer> importers,
    NodeImporter nodeImporter,
    SyncPackageResolver packageResolver,
    Iterable<String> loadPaths,
    Importer importer,
    Iterable<Callable> functions,
    OutputStyle style,
    bool useSpaces = true,
    int indentWidth,
    LineFeed lineFeed,
    url,
    bool sourceMap = false}) {
  var stylesheet =
      Stylesheet.parse(source, syntax ?? Syntax.scss, url: url, logger: logger);

  var evaluateResult = evaluate(stylesheet,
      importCache: ImportCache(importers,
          loadPaths: loadPaths,
          packageResolver: packageResolver,
          logger: logger),
      nodeImporter: nodeImporter,
      importer: importer,
      functions: functions,
      logger: logger,
      sourceMap: sourceMap);

  var serializeResult = serialize(evaluateResult.stylesheet,
      style: style,
      useSpaces: useSpaces,
      indentWidth: indentWidth,
      lineFeed: lineFeed,
      sourceMap: sourceMap);

  return CompileResult(evaluateResult, serializeResult);
}
