class Store extends Vanilla_Redux_Store {
    constructor(reducer) {
        super(reducer, {
            pages: {
                page01: {},
                page02: {},
                page03: {}
            }
        });
    }
    init () {
        this._contents = Immutable.Map({});
        return this;
    }
}
