riot.tag2('app', '<page01 class="page {this.hide(\'page01\')}"></page01> <page02 class="page {this.hide(\'page02\')}"></page02> <page03 class="page {this.hide(\'page03\')}"></page03> <menu></menu>', 'app > .page.hide { display: none; }', '', function(opts) {
     this.hide = (code)=>{
         let pages = STORE.state().get('pages');
         return pages[code].active ? '' : 'hide'
     };

     STORE.subscribe((action)=>{
         if(action.type=='MOVE-PAGE')
             this.update();
     });

     this.on('mount', function () {
         Metronome.start();

         if (location.hash=='')
             location.hash='#page01'
     });

     window.addEventListener('resize', (event) => {
         this.update();
     });
});

riot.tag2('banshou', '<section class="section"> <div class="container"> <h1 class="title">Class: BANSHOU</h1> <h2 class="subtitle"> </h2> </div> </section>', '', '', function(opts) {
});

riot.tag2('class-list', '<table class="table is-bordered is-striped is-narrow is-hoverable"> <thead> <tr> <td>package</td> <td>name</td> <td>description</td> </tr> </thead> <tbody> <tr each="{opts.data}"> <td>{package}</td> <td>{name}</td> <td>{description}</td> </tr> </tbody> </table>', '', '', function(opts) {
});

riot.tag2('force', '<section class="section"> <div class="container"> <h1 class="title">Class: FORCE</h1> <h2 class="subtitle"> </h2> </div> </section>', '', '', function(opts) {
});

riot.tag2('naming', '<section class="section"> <div class="container"> <h1 class="title">Class: NAMING</h1> <h2 class="subtitle"> </h2> </div> </section>', '', '', function(opts) {
});

riot.tag2('ra', '<section class="section"> <div class="container"> <h1 class="title">Class: RA</h1> <h2 class="subtitle"> </h2> </div> </section>', '', '', function(opts) {
});

riot.tag2('shin', '<section class="section"> <div class="container"> <h1 class="title">Class: SHIN</h1> <h2 class="subtitle"> </h2> </div> </section>', '', '', function(opts) {
});

riot.tag2('user', '<section class="section"> <div class="container"> <h1 class="title">Class: USER</h1> <h2 class="subtitle"> </h2> </div> </section>', '', '', function(opts) {
});

riot.tag2('menu', '<div class="menu-item {active(\'page03\')}" code="page03" onclick="{click}">03</div> <div class="menu-item {active(\'page02\')}" code="page02" onclick="{click}">02</div> <div class="menu-item {active(\'page01\')}" code="page01" onclick="{click}">01</div>', 'menu { position: fixed; right: 11px; bottom: 11px; } menu > .menu-item { float: right; margin-left: 11px; border-radius: 55px; width: 55px; height: 55px; background: rgba(255, 255, 255, 0.9); z-index: 99999999; text-align: center; padding-top: 12px; border: 3px solid rgb(238, 238, 238); box-shadow: 0 0 8px gray; } menu > .menu-item.active { background: rgba(236, 109, 113, 0.9); color: #ffffff; border: 3px solid rgba(236, 109, 113); }', '', function(opts) {
     this.active = (code) => {
         let page = STORE.state().get('pages')[code];
         return page.active ? 'active' : '';
     };
     this.click = (e) => {
         let target = e.target;
         let hash = '#' + target.getAttribute('CODE');

         if (hash!=location.hash)
             location.hash = hash;
     };
});

riot.tag2('class-diagram', '<pre>作成中。</pre>', '', '', function(opts) {
});

riot.tag2('find-r', '<section class="section"> <div class="container"> <h1 class="title">Function: FIND-R</h1> <h2 class="subtitle"> </h2> </div> </section>', '', '', function(opts) {
});

riot.tag2('operator-list', '<table class="table is-bordered is-striped is-narrow is-hoverable"> <thead> <tr> <td>name</td> <td>description</td> </tr> </thead> <tbody> <tr each="{opts.data}"> <td>{name}</td> <td>{description}</td> </tr> </tbody> </table>', '', '', function(opts) {
});

riot.tag2('operators-matrix1', '<table class="table is-bordered is-striped is-narrow is-hoverable"> <thead> <tr> <th rowspan="2">Target</th> <th colspan="3">Find</th> <th colspan="5">Get</th> </tr> <tr> <th>both</th> <th>vertex</th> <th>edge</th> <th>both</th> <th>vertex</th> <th>edge</th> <th>from-vertex?</th> <th>to-vertex?</th> </tr> </thead> <tbody> <tr> <th>Relationship</th> <td><a href="#operators/find-r">find-r</a></td> <td><a href="#operators/find-r-vertex">find-r-vertex</a></td> <td><a href="#operators/find-r-edge">find-r-edge</a></td> <td><a href="#operators/get-r">get-r</a></td> <td><a href="#operators/get-r-vertex">get-r-vertex</a></td> <td><a href="#operators/get-r-edge">get-r-edge</a></td> <td><a href="#operators/get-from-vertex">get-from-vertex</a></td> <td><a href="#operators/get-to-vertex">get-to-vertex</a></td> </tr> <tr> <th>VERTEX</th> <td>---</td> <td><a href="#operators/find-vertex">find-vertex</a></td> <td>---</td> <td>---</td> <td> <a href="#operators/get-vertex">get-vertex</a> (未実装)<br> <a href="#operators/get-vertex-at">get-vertex-at</a> (廃棄予定) </td> <td>---</td> <td>---</td> <td>---</td> </tr> <tr> <th>EDGE</th> <td>---</td> <td><a href="#operators/find-edge">find-edge</a> (未実装)</td> <td>---</td> <td>---</td> <td><a href="#operators/get-edge">get-edge</a> (未実装)</td> <td>---</td> <td>---</td> <td>---</td> </tr> </tbody> </table>', '', '', function(opts) {
});

riot.tag2('operators-matrix2', '<table class="table is-bordered is-striped is-narrow is-hoverable"> <thead> <tr> <th rowspan="2">Target</th> <th colspan="3">Transaction</th> <th colspan="3">Not Transaction</th> </tr> <tr> <th>Create</th> <th>Update</th> <th>Delete</th> <th>Create</th> <th>Update</th> <th>Delete</th> </tr> </thead> <tbody> <tr> <th>BANSHOU</th> <td>---</td> <td>---</td> <td>---</td> <td><a href="#operators/make-banshou">make-banshou</a></td> <td>---</td> <td>---</td> </tr> <tr> <th>VERTEX</th> <td><a href="#operators/tx-make-vertex">tx-make-vertex</a></td> <td><a href="#operators/tx-change-vertex">tx-change-vertex</a></td> <td><a href="#operators/tx-delete-vertex">tx-delete-vertex</a></td> <td><a href="#operators/make-vertex">make-vertex</a></td> <td><a href="#operators/change-vertex">change-vertex</a> (未実装)</td> <td><a href="#operators/delete-vertex">delete-vertex</a></td> </tr> <tr> <th>EDGE</th> <td><a href="#operators/tx-make-edge">tx-make-edge</a></td> <td> <a href="#operators/tx-change-edge">tx-change-edge</a> (未実装)<br> <a href="#operators/tx-change-type">tx-change-type</a> </td> <td><a href="#operators/tx-delete-edge">tx-delete-edge</a></td> <td><a href="#operators/make-edge">make-edge</a></td> <td><a href="#operators/change-edge">change-edge</a> (未実装)</td> <td><a href="#operators/delete-edge">delete-edge</a></td> </tr> </tbody> </table>', '', '', function(opts) {
});

riot.tag2('operators-matrix3', '<table class="table is-bordered is-striped is-narrow is-hoverable"> <thead> <tr> <th>Target</th> <th>type?</th> <th>exist?</th> </tr> </thead> <tbody> <tr> <th>VERTEX</th> <td><a href="#operators/vertexp">vertexp</a></td> <td rowspan="2"><a href="#operators/existp">existp</a></td> </tr> <tr> <th>EDGE</th> <td><a href="#operators/edgep">edgep</a></td> </tr> <tr> <th>BANSHOU</th> <td><a href="#operators/banshoup">banshoup</a> (未実装)</td> <td>---</td> </tr> </tbody> </table>', '', '', function(opts) {
});

riot.tag2('operators-matrix4', '<table class="table is-bordered is-striped is-narrow is-hoverable"> <thead> <tr> <th>Target</th> <th>%id</th> <th>from-id</th> <th>from-class</th> <th>to-id</th> <th>to-class</th> <th>edge-type</th> </tr> </thead> <tbody> <tr> <th>VERTEX</th> <th><a href="#operators/%id">%id</a></th> <th>---</th> <th>---</th> <th>---</th> <th>---</th> <th>---</th> </tr> <tr> <th>EDGE</th> <td><a href="#operators/%id">%id</a></td> <td><a href="#operators/from-id">from-id</a></td> <td><a href="#operators/from-class">from-class</a></td> <td><a href="#operators/to-id">to-id</a></td> <td><a href="#operators/to-class">to-class</a></td> <td><a href="#operators/edge-type">edge-type</a></td> </tr> </tbody> </table>', '', '', function(opts) {
});

riot.tag2('section-3', '<section class="section"> <div class="container"> <h1 class="title is-3">{opts.title}</h1> <yield></yield> </div> </section>', '', '', function(opts) {
});

riot.tag2('section-4', '<section class="section"> <div class="container"> <h1 class="title is-4">{opts.title}</h1> <yield></yield> </div> </section>', 'section-4 section4 > section.section,[data-is="section-4"] section4 > section.section{ padding: 1rem 1.5rem; }', '', function(opts) {
});

riot.tag2('section-footer', '<footer class="footer"> <div class="container"> <div class="content has-text-centered"> Footer ........ </div> </div> </footer>', '', '', function(opts) {
});

riot.tag2('section-header', '<section class="section"> <div class="container"> <h1 class="title is-2">{opts.title}</h1> <yield></yield> </div> </section>', 'section-header > section.section{ background: #eeeeee; }', '', function(opts) {
});

riot.tag2('page01', '<section class="hero"> <div class="hero-body"> <div class="container"> <h1 class="title"> 森羅万象 (SHINRABANSHOU) </h1> <h2 class="subtitle">subtitle ........</h2> </div> </div> </section> <section class="section"> <div class="container"> <h1 class="title">Section</h1> <h2 class="subtitle">subtitle ........</h2> </div> </section> <section-footer></section-footer>', '', '', function(opts) {
});

riot.tag2('page02', '<section-header title="CLASSES"> <h2 class="subtitle"> SHINRABANSHOU のオペレータのクラスのマニュアルです。 </h2> </section-header> <section-3 title="Class List" data="{classes()}"> <h2 class="subtitle">クラスの一覧</h2> <div class="contents"> <class-list data="{this.opts.data}"></class-list> </div> </section-3> <section-3 title="クラス図"> <h2 class="subtitle"></h2> <div class="contents"> <class-diagram> </class-diagram> </div> </section-3> <shin></shin> <ra></ra> <banshou></banshou> <naming></naming> <user></user> <force></force> <section-footer></section-footer>', '', '', function(opts) {
     this.classes = ()=>{
         return STORE.state().get('classes');
     };
});

riot.tag2('page03', '<section-header title="OPERATORS"> <h2 class="subtitle"> SHINRABANSHOU のオペレータのマニュアルです。 </h2> </section-header> <section-3 title="Description"> <h2 class="subtitle"></h2> <div class="contents"> <p> シンプルで規則性のあるオペレータになっています。 </p> <p> オペレータは大きく分類すると以下の四つになります。<br> </p> <div style="margin-left: 33px;"> <ol> <li>CROUD</li> <li>Paradicate</li> <li>Accessor</li> <li>Query (未実装)</li> </ol> </div> </div> </section-3> <section-3 title="List"> <h2 class="subtitle">オペレータの一覧です。</h2> <div class="contents"> 格分類毎にマトリックスで整理されています。 </div> <section-4 title="Read"> <h2 class="subtitle"></h2> <div class="contents"> <operators-matrix1></operators-matrix1> </div> </section-4> <section-4 title="Create/Update/Delete"> <h2 class="subtitle"></h2> <div class="contents"> <operators-matrix2></operators-matrix2> </div> </section-4> <section-4 title="Predicate"> <h2 class="subtitle"></h2> <div class="contents"> <operators-matrix3></operators-matrix3> </div> </section-4> <section-4 title="Accessors"> <h2 class="subtitle"></h2> <div class="contents"> <operators-matrix4></operators-matrix4> </div> </section-4> </section-3> <section-footer></section-footer>', '', '', function(opts) {
     this.operators = ()=>{
         let operators = STORE.state().get('operators');
         let targets = []
         for (var i in operators)
             if (operators[i].display)
                 targets.push(operators[i]);
         return targets;
     };
});
