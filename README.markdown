# 森羅万象(shinrabanshou)

Common Lisp On-Memory Objective Graph Database.  
Common Lisp ネイティブでポータブルかつシンプルな GraphDatabase を目指しています。  
外部のDBを利用すれば良いのでしょうが、セットアップや利用方法などに悩まされます。(特にWindowsでは)
- とりあえず使えること。
- シンプルであること。
- AICD(?) とか難しいことは考えないこと。
- セットアップにストレスを覚えないこと。
- 利用するこにストレスを覚えないこと。

永続化ライブラリは [upanishad](https://github.com/yanqirenshi/upanishad) を利用します。

詳細な情報は [Wiki](https://github.com/yanqirenshi/shinrabanshou/wiki) を参照してください。

# Usage
``` lisp
;; ロード
(qlot:quickload :shinrabanshou)
(in-package :shinrabanshou)

;; Poolの作成
(defvar *pool* nil)
(setf *pool* (make-banshou 'banshou pool-stor))

;; Vertex の作成
    ：
   ※執筆待ち
    ：
;; Edge の作成
    ：
   ※執筆待ち
    ：
;; Vertex / Edge の取得
    ：
   ※執筆待ち
    ：
```

# Installation
飾りっけなし。 Thank you [qlot](https://github.com/fukamachi/qlot).
``` lisp
(qlot:install :shinrabanshou)
```

必要であれば .sbcl とかに以下を追加。
``` lisp
(qlot:quickload :shinrabanshou)
```

動くかどうかはテストすれば良し。
``` lisp
(qlot:quickload :shinrabanshou-test)
```

# Author

+ Satoshi Iwasaki (yanqirenshi@gmail.com)

# Copyright

Copyright (c) 2014 Satoshi Iwasaki (yanqirenshi@gmail.com)

# License

Licensed under the LLGPL License.
