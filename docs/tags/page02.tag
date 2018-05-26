<page02>
    <section class="hero">
        <div class="hero-body">
            <div class="container">
                <h1 class="title">
                    CLASSES
                </h1>
                <h2 class="subtitle">subtitle ........</h2>
            </div>
        </div>
    </section>

    <section class="section">
        <div class="container">
            <h1 class="title">Class List</h1>
            <h2 class="subtitle">クラスの一覧</h2>

            <div class="contents">
                <class-list data={this.classes()}></class-list>
            </div>
        </div>
    </section>

    <shin></shin>
    <ra></ra>
    <banshou></banshou>
    <naming></naming>
    <user></user>
    <force></force>

    <footer class="footer">
        <div class="container">
            <div class="content has-text-centered">
                Footer ........
            </div>
        </div>
    </footer>

    <script>
     this.classes = ()=>{
         return STORE.state().get('classes');
     };
    </script>
</page02>
