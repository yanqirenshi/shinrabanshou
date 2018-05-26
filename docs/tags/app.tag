<app>
    <page01 class="page {this.hide('page01')}"></page01>
    <page02 class="page {this.hide('page02')}"></page02>
    <page03 class="page {this.hide('page03')}"></page03>

    <menu></menu>

    <style>
     app > .page {
         width: 100vw;
         height: 100vh;
         overflow: hidden;
         display: block;
     }
     app > .page.hide { display: none; }
    </style>

    <script>
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
    </script>
</app>
