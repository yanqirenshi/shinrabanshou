route(function (a) {
    let len = arguments.length;
    let page = arguments[0];

    let new_pages = STORE.state().get('pages');

    STORE.dispatch(ACTIONS.movePage({
        pages: new_pages
    }));
});
