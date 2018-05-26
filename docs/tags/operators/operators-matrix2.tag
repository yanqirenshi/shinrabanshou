<operators-matrix2>
    <table class="table is-bordered is-striped is-narrow is-hoverable">
        <thead>
            <tr>
                <th rowspan="2">Target</th>
                <th colspan="3">Transaction</th>
                <th colspan="3">Not Transaction</th>
            </tr>
            <tr>
                <th>Create</th>
                <th>Update</th>
                <th>Delete</th>
                <th>Create</th>
                <th>Update</th>
                <th>Delete</th>
            </tr>
        </thead>
        <tbody>
            <tr>
                <th>BANSHOU</th>
                <td>---</td>
                <td>---</td>
                <td>---</td>
                <td><a href="#operators/make-banshou">make-banshou</a></td>
                <td>---</td>
                <td>---</td>
            </tr>
            <tr>
                <th>VERTEX</th>
                <td><a href="#operators/tx-make-vertex">tx-make-vertex</a></td>
                <td><a href="#operators/tx-change-vertex">tx-change-vertex</a></td>
                <td><a href="#operators/tx-delete-vertex">tx-delete-vertex</a></td>
                <td><a href="#operators/make-vertex">make-vertex</a></td>
                <td><a href="#operators/change-vertex">change-vertex</a> (未実装)</td>
                <td><a href="#operators/delete-vertex">delete-vertex</a></td>
            </tr>
            <tr>
                <th>EDGE</th>
                <td><a href="#operators/tx-make-edge">tx-make-edge</a></td>
                <td>
                    <a href="#operators/tx-change-edge">tx-change-edge</a> (未実装)<br/>
                    <a href="#operators/tx-change-type">tx-change-type</a>
                </td>
                <td><a href="#operators/tx-delete-edge">tx-delete-edge</a></td>
                <td><a href="#operators/make-edge">make-edge</a></td>
                <td><a href="#operators/change-edge">change-edge</a> (未実装)</td>
                <td><a href="#operators/delete-edge">delete-edge</a></td>
            </tr>
        </tbody>
    </table>
</operators-matrix2>
