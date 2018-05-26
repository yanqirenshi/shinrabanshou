route(function (a) {
    let len = arguments.length;
    let page = arguments[0];
    let hash = location.hash;

    if (hash.trim=='')
        return location.hash = 'page01';

    let new_pages = STORE.state().get('pages');
    let hash_code = hash.substring(1);

    if (hash_code.trim=='')
        return location.hash = 'page01';

    for (var k in new_pages)
        new_pages[k].active=(k==hash_code);

    STORE.dispatch(ACTIONS.movePage({
        pages: new_pages
    }));

    return null;
});
