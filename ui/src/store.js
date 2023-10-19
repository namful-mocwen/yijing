import { create } from 'zustand'

const useUrbitStore = create((set) => ({
    urbit: null,
    log: new Map(),
    shipLog: [],
    subEvent: null,
    intention: null,
    oracle: {},
    loading: false,
    error: null,
    setUrbit: (urbit) => set({ urbit }),
    setLog: log => set({ log }),
    setShipLog: shipLog => set({ shipLog }),
    setSubEvent: subEvent => set({ subEvent }),
    setIntention: intention => set({ intention }),
    setOracle: oracle => set({ oracle }),
    setLoading: loading => set({ loading }),
    setError: error => set({ error })

  }))

  export default useUrbitStore