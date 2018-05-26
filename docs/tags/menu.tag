<menu>
    <div class="menu-item {active('page03')}" code="page03" onclick={click}>03</div>
    <div class="menu-item {active('page02')}" code="page02" onclick={click}>02</div>
    <div class="menu-item {active('page01')}" code="page01" onclick={click}>01</div>

    <style>
     menu {
         position: fixed;
         right: 11px;
         bottom: 11px;
     }
     menu > .menu-item {
         float: right;
         margin-left: 11px;
         border-radius: 55px;
         width: 55px;
         height: 55px;
         background: rgba(255, 255, 255, 0.9);
         z-index: 99999999;

         text-align: center;
         padding-top: 12px;

         border: 3px solid rgb(238, 238, 238);

         box-shadow: 0 0 8px gray;
     }
     menu > .menu-item.active {
         background: rgba(236, 109, 113, 0.9);
         color: #ffffff;
         border: 3px solid rgba(236, 109, 113);
     }
    </style>

    <script>
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
    </script>
</menu>
