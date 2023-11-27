import { create } from 'zustand'

const useUrbitStore = create((set) => ({
    urbit: null,
    entropy: {},
    hexagrams: null,
    log: new Map(),
    shipLog: [],
    subEvent: null,
    intention: null,
    oracle: {},
    hOracle: { position: 2, momentum: 1, changing: [1,2,3,4,5,6] },
    loading: false,
    error: null,
    setUrbit: urbit => set({ urbit }),
    setEntropy: entropy => set({ entropy }),
    setHexagrams: hexagrams => set({ hexagrams }),
    setLog: log => set({ log }),
    setShipLog: shipLog => set({ shipLog }),
    setSubEvent: subEvent => set({ subEvent }),
    setIntention: intention => set({ intention }),
    setOracle: oracle => set({ oracle }),
    setHOracle: hOracle => set({ hOracle }),
    setLoading: loading => set({ loading }),
    setError: error => set({ error }),
    cast: (intention, urbit) => {
      urbit.poke({
        app: "yijing",
        mark: "yijing-action",
        json: { cast: { intention: intention } },
        onSuccess: () => console.log('successful cast. . .'),
        onError: () => setError("cast lost in dimensions. . ."),
      })
    }
  }))

  export default useUrbitStore