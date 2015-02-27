# 森羅万象(shinrabanshou)

Common Lisp On-Memory Objective Graph Database.

Common Lisp ネイティブでポータブルかつシンプルな GraphDatabase を目指しています。

外部のDBを利用すれば良いのでしょうが、セットアップや利用方法などに悩まされます。
- とりあえず使えること。
- シンプルであること。
- AICD(?) とか難しいことは考えないこと。
- セットアップにストレスを覚えないこと。
- 利用するこにストレスを覚えないこと。

永続化ライブラリは [upanishad](https://github.com/yanqirenshi/upanishad) を利用します。


# Usage
なんかまだ使いかた出来とらんけぇ、作りながら整理しとるところじゃけぇ。

``` lisp
(ql:quickload :shinrabanshou)
(in-package :shinrabanshou)
(defvar *pool* nil)
(setf *pool* (make-banshou 'banshou pool-stor))

(shinra-test::run!)
```

## Dependencies
| library    | description                            |
|------------|----------------------------------------|
| alexandria | ユーティリティ                         |
| cl-ppcre   | 正規表現ライブラリ                     |
| cl+        | ユーティリティ                         |
| upanishad  | オブジェクトDB(cl-prevalence クローン) |

# Installation
``` lisp
(ql:quickload :shinrabanshou)
(ql:quickload :shinrabanshou-test)
```

# Author

+ Satoshi Iwasaki (yanqirenshi@gmail.com)

# Copyright

Copyright (c) 2014 Satoshi Iwasaki (yanqirenshi@gmail.com)

# License

Licensed under the LLGPL License.
