<operator-list>
    <table class="table is-bordered is-striped is-narrow is-hoverable">
        <thead>
            <tr>
                <td>name</td>
                <td>description</td>
            </tr>
        </thead>
        <tbody>
            <tr each="{opts.data}">
                <td>{name}</td>
                <td>{description}</td>
            </tr>
        </tbody>
    </table>
</operator-list>
