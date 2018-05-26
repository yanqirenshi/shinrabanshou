<page02>
    <section-header title="CLASSES">
        <h2 class="subtitle">
            SHINRABANSHOU のオペレータのクラスのマニュアルです。
        </h2>
    </section-header>

    <section-3 title="Class List" data={classes()}>
        <h2 class="subtitle">クラスの一覧</h2>

        <div class="contents">
            <class-list data={this.opts.data}></class-list>
        </div>
    </section-3>

    <section-3 title="クラス図">
        <h2 class="subtitle"></h2>
        <div class="contents">
            <class-diagram>
            </class-diagram>
        </div>
    </section-3>


    <shin></shin>
    <ra></ra>
    <banshou></banshou>
    <naming></naming>
    <user></user>
    <force></force>

    <section-footer></section-footer>

    <script>
     this.classes = ()=>{
         return STORE.state().get('classes');
     };
    </script>
</page02>
