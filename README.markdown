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

;;; グラフを生成
SHINRA> (defvar *graph* (make-banshou 'banshou "/input/your/path/"))

*GRAPH*

;;; vertex と edge クラスを定義。
SHINRA> (defclass vertex (shin naming) ()) 
#<STANDARD-CLASS VERTEX>

SHINRA> (defclass edge (ra naming) ()) 
#<STANDARD-CLASS EDGE>


;;; ロボットの制作/組み立て。
SHINRA> 
(let ((head       (make-vertex *graph* 'vertex '((name "head"))))
      (breast     (make-vertex *graph* 'vertex '((name "breast"))))
      (waist      (make-vertex *graph* 'vertex '((name "waist"))))
      (left-arm   (make-vertex *graph* 'vertex '((name "left-arm"))))
      (right-arm  (make-vertex *graph* 'vertex '((name "right-arm"))))
      (left-foot  (make-vertex *graph* 'vertex '((name "left-foot"))))
      (right-foot (make-vertex *graph* 'vertex '((name "right-foot")))))
  (make-edge *graph* 'edge head   breast     :docking)
  (make-edge *graph* 'edge breast waist      :docking)
  (make-edge *graph* 'edge breast left-arm   :docking)
  (make-edge *graph* 'edge breast right-arm  :docking)
  (make-edge *graph* 'edge waist  left-foot  :docking)
  (make-edge *graph* 'edge waist  right-foot :docking))


#<EDGE {1006D78EE3}>
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
