<app>
    <page01 class="page"></page01>
    <page02 class="page"></page02>
    <page03 class="page"></page03>

    <style>
     app > .page {
         width: 100vw;
         height: 100vh;
         overflow: hidden;
         display: block;
     }
    </style>

    <script>
     window.addEventListener('resize', (event) => {
         this.update();
     });

     this.on('mount', function () {
         Metronome.start();
     });
    </script>
</app>
