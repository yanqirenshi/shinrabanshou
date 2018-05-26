riot.tag2('app', '<page01 class="page"></page01> <page02 class="page"></page02> <page03 class="page"></page03>', 'app > .page { width: 100vw; height: 100vh; overflow: hidden; display: block; }', '', function(opts) {
     window.addEventListener('resize', (event) => {
         this.update();
     });

     this.on('mount', function () {
         Metronome.start();
     });
});

riot.tag2('page01', '', '', '', function(opts) {
});

riot.tag2('page02', '', '', '', function(opts) {
});

riot.tag2('page03', '', '', '', function(opts) {
});
