<class-list>
    <table class="table is-bordered is-striped is-narrow is-hoverable">
        <thead>
            <tr>
                <td>package</td>
                <td>name</td>
                <td>description</td>
            </tr>
        </thead>
        <tbody>
            <tr each="{opts.data}">
                <td>{package}</td>
                <td>{name}</td>
                <td>{description}</td>
            </tr>
        </tbody>
    </table>
</class-list>
