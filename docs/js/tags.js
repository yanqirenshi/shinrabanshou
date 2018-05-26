riot.tag2('app', '<page01 class="page {this.hide(\'page01\')}"></page01> <page02 class="page {this.hide(\'page02\')}"></page02> <page03 class="page {this.hide(\'page03\')}"></page03> <menu></menu>', 'app > .page { width: 100vw; height: 100vh; overflow: hidden; display: block; } app > .page.hide { display: none; }', '', function(opts) {
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

riot.tag2('page01', '<section class="hero"> <div class="hero-body"> <div class="container"> <h1 class="title"> Page01 </h1> <h2 class="subtitle">subtitle ........</h2> </div> </div> </section> <section class="section"> <div class="container"> <h1 class="title">Section</h1> <h2 class="subtitle">subtitle ........</h2> </div> </section> <footer class="footer"> <div class="container"> <div class="content has-text-centered"> Footer ........ </div> </div> </footer>', '', '', function(opts) {
});

riot.tag2('page02', '<section class="hero"> <div class="hero-body"> <div class="container"> <h1 class="title"> Page02 </h1> <h2 class="subtitle">subtitle ........</h2> </div> </div> </section> <section class="section"> <div class="container"> <h1 class="title">Section</h1> <h2 class="subtitle">subtitle ........</h2> </div> </section> <footer class="footer"> <div class="container"> <div class="content has-text-centered"> Footer ........ </div> </div> </footer>', '', '', function(opts) {
});

riot.tag2('page03', '<section class="hero"> <div class="hero-body"> <div class="container"> <h1 class="title"> Page03 </h1> <h2 class="subtitle">subtitle ........</h2> </div> </div> </section> <section class="section"> <div class="container"> <h1 class="title">Section</h1> <h2 class="subtitle">subtitle ........</h2> </div> </section> <footer class="footer"> <div class="container"> <div class="content has-text-centered"> Footer ........ </div> </div> </footer>', '', '', function(opts) {
});
