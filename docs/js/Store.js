class Store extends Vanilla_Redux_Store {
    constructor(reducer) {
        super(reducer, Immutable.Map({}));
    }
    init () {
        this._contents = Immutable.Map({
            pages: {
                page01: {
                    name: 'Page 1',
                    active: false
                },
                page02: {
                    name: 'Page 2',
                    active: false
                },
                page03: {
                    name: 'Page 3',
                    active: false
                }
            }
        });
        return this;
    }
}
