import React, { useEffect, useState } from 'react'
import { BrowserRouter, Route, Routes } from 'react-router-dom'
import { Landing } from './components/landing'
import { Log } from './components/log'
import useUrbitStore from './store'

import Urbit from '@urbit/http-api'
import './app.css'
// sigils
// context


export function App() {
  const { urbit, setUrbit, setHexagrams, setSubEvent } = useUrbitStore()

  useEffect(() => {
    const init = async () =>  {
      const newUrbit = new Urbit('', '')
      newUrbit.ship = window.ship

      setHexagrams(await newUrbit.scry({
        app: 'yijing',
        path: `/hexa`,
        }))

        
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


 console.log('ship', urbit?.ship)

  return (
      <div>
        <header>
          <span>䷁</span>
          <span>䷀</span>
        </header>
        <main>
        <div style={{height:'0px'}}>:::       yijing       :::</div><p />
            <BrowserRouter>
              <Routes>
                    <Route exact path='/apps/yijing' element={ <Landing /> } />
                    <Route exact path='/apps/yijing/log' element={ <Log subEvent/> } />
              </Routes> 
            </BrowserRouter>
        </main>
      </div>
  )
};
