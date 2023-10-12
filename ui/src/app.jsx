import React, { useEffect, useState } from 'react';
import Urbit from '@urbit/http-api';
import './app.css'

const api = new Urbit('', '', window.desk);
api.ship = window.ship;

export function App() {
  const [log, setLog] = useState(new Map())
  const [shipLog, setShipLog] = useState(new Map())
  const [oracle, setOracle] = useState({})
  const [intention, setIntention] = useState(null)
  const [subEvent, setSubEvent] = useState({})
  const [status, setStatus] = useState(null) 
  const [error, setError]  = useState(null)

  useEffect(() => {
    const init = async () =>  {
          subscribe()
          setShipLog(await getShipLog())
          setLog(await getLog())

    }
    window.urbit = new Urbit("")
    window.urbit.ship = window.ship

    window.urbit.onOpen = () => setStatus("con")
    window.urbit.onRetry = () => setStatus("try")
    window.urbit.onError = () => setStatus("err")

    init()
  }, []);

  useEffect(() => {
    const updateFun = () => {
      setOracle(subEvent)
      console.log('test', subEvent)
      }
    updateFun()
  }, [subEvent]);

  const getShipLog = async () => {
    return window.urbit.scry({
      app: 'yijing',
      path: `/log/~${window.ship}`,
    })
  };

  const getLog = async () => {
    return window.urbit.scry({
      app: 'yijing',
      path: `/log`,
    })
  };


  const subscribe = () => {
    try {
      window.urbit.subscribe({
        app: "yijing",
        path: "/updates",
        event: setSubEvent,
        err: () => console.log("Subscription rejected"),
        quit: () => console.log("Kicked from subscription"),
      })
    } catch {
      console.log("Subscription failed");
    }
  };

  const cast = (intention) => {
    window.urbit.poke({
      app: "yijing",
      mark: "yijing-action",
      json: { cast: { intention: intention } },
      onSuccess: () => console.log('successful cast. . .'),
      onError: () => setError("cast lost in dimensions. . ."),
    })
  };


const onKeyDown = e => {
  if (e.key === 'Enter' && !e.shiftKey) {
    e.preventDefault()
    e.target.value && cast(e.target.value)
    e.target.value=''
    setIntention('')
  }
};

console.log('log', log)
console.log('ship', window.ship)
console.log('shiplog', shipLog)

  return (
      <div>
        <header>
          <span>䷁</span>
          {/* <span>~</span> */}
          <span>䷀</span>
        </header>
        <main>

          <div>:::       yijing       :::</div><p />
          {/* <div>:::            :::</div><p /> */}
 
          {!oracle.position 
            ? 
            <input
              type='text' 
              name='intention' 
              placeholder='intention' 
              onChange={e => setIntention(e.target.value)}
              onKeyDown={e => onKeyDown(e)}
            />
           :
          <div className='oracle'>
            <div>intention: {oracle.intention}</div><p/>
            <div>position: {oracle.position}</div>
            <div>momentum: {oracle.momentum}</div><p/>
            <button onClick={() => setOracle({})}>X</button>
          </div>}
        </main>
      </div>
  )
};
