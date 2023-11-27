import React, { useEffect, useState } from 'react'
import { BrowserRouter, Route, Routes } from 'react-router-dom'
import { Landing } from './components/landing'
import { Rumors } from './components/rumors'
// import { Random } from './components/random'
import { Log } from './components/log'
import useUrbitStore from './store'

import Urbit from '@urbit/http-api'
import './app.css'

export function App() {
  const { urbit, setUrbit, hexagrams, setHexagrams, hOracle, setHOracle, subEvent, setOracle, setSubEvent } = useUrbitStore()

  useEffect(() => {
    const init = async () =>  {
      const newUrbit = new Urbit('', '')
      newUrbit.ship = window.ship
      const hx = await newUrbit.scry({
        app: 'yijing',
        path: `/hexa`,
        })
      setHexagrams(hx?.sort((a, b) => a.num - b.num))
      await newUrbit.subscribe({
        app: "yijing",
        path: "/updates",
        event: setSubEvent,
        err: () => console.log("Subscription rejected"),
        quit: () => console.log("Kicked from subscription"),
      })

      setUrbit(newUrbit)
    }
    init()
  }, []);


  useEffect(() => {
    const updateFun = () => {
        setOracle(subEvent)
        }
    updateFun()
  }, [subEvent]);

  const getHOracle = async () => {
    const result = await urbit.scry({
    app: 'yijing',
    path: '/cast',
    })
    // console.log(result)
    setHOracle(result)
    setOracle(result)
  };  

 urbit?.ship && console.log('ship', urbit.ship)
  return (
      <div>
        <header>  
          <span onClick={() => getHOracle()} className='hover'>{hexagrams ? hexagrams[hOracle?.position - 1].hc : '䷁'}</span>
          <span onClick={() => setOracle(hOracle)} className='hover'>{hexagrams ? hexagrams[hOracle?.momentum - 1].hc : '䷀'}</span>
        </header>
        <div className='yijing'>:::       yijing       :::</div>
        <main>
            <BrowserRouter>
              <Routes>
                    <Route exact path='/apps/yijing' element={ <Landing /> } />
                    <Route exact path='/apps/yijing/log' element={ <Log subEvent/> } />
                    <Route exact path='/apps/yijing/rumors' element={ <Rumors subEvent/> } />
                    {/* <Route exact path='/apps/yijing/random' element={ <Random subEvent/> } /> */}
              </Routes> 
            </BrowserRouter>
        </main>
      </div>
  )
};
