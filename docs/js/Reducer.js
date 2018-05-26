class Reducer extends Vanilla_Redux_Reducer {
    put (state, action) {
        return state.mergeDeep(Immutable.Map(action.data));
    }
}
