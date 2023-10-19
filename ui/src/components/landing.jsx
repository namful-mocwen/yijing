import React, { useEffect, useState } from 'react'
import { Link } from "react-router-dom"
import useUrbitStore from '../store'

export const Landing = () => {
    const { urbit, oracle, setIntention, setOracle, subEvent, setError } = useUrbitStore()
    
    useEffect(() => {
    const updateFun = () => {
        setOracle(subEvent)
        }
    updateFun()
    }, [subEvent]);

    const cast = (intention) => {
        urbit.poke({
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

    return(
        <main>
            <Link className='nav' to="/apps/yijing/log">[log]</Link>
            {!oracle?.position 
            ? 
            <input
                type='text' 
                name='intention' 
                placeholder='*?*' 
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
    )
}