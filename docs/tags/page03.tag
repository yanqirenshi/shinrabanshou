<page03>
    <section-header title="OPERATORS">
        <h2 class="subtitle">
            SHINRABANSHOU のオペレータのマニュアルです。
        </h2>
    </section-header>

    <section-3 title="Description">
        <h2 class="subtitle"></h2>

        <div class="contents">
            <p>
                シンプルで規則性のあるオペレータになっています。
            </p>
            <p>
                オペレータは大きく分類すると以下の四つになります。<br/>
            </p>
            <div style="margin-left: 33px;">
                <ol>
                    <li>CROUD</li>
                    <li>Paradicate</li>
                    <li>Accessor</li>
                    <li>Query (未実装)</li>
                </ol>
            </div>
        </div>
    </section-3>

    <section-3 title="List">
        <h2 class="subtitle">オペレータの一覧です。</h2>

        <div class="contents">
            格分類毎にマトリックスで整理されています。
        </div>

        <section-4 title="Read">
            <h2 class="subtitle"></h2>
            <div class="contents">
                <operators-matrix1></operators-matrix1>
            </div>
        </section-4>

        <section-4 title="Create/Update/Delete">
            <h2 class="subtitle"></h2>
            <div class="contents">
                <operators-matrix2></operators-matrix2>
            </div>
        </section-4>


        <section-4 title="Predicate">
            <h2 class="subtitle"></h2>
            <div class="contents">
                <operators-matrix3></operators-matrix3>
            </div>
        </section-4>

        <section-4 title="Accessors">
            <h2 class="subtitle"></h2>
            <div class="contents">
                <operators-matrix4></operators-matrix4>
            </div>
        </section-4>
    </section-3>

    <section-footer></section-footer>

    <script>
     this.operators = ()=>{
         let operators = STORE.state().get('operators');
         let targets = []
         for (var i in operators)
             if (operators[i].display)
                 targets.push(operators[i]);
         return targets;
     };
    </script>
</page03>
