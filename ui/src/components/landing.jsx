import React, { useEffect, useState } from 'react'
import { Link } from "react-router-dom"
import useUrbitStore from '../store'
import '@urbit/sigil-js'

export const Landing = () => {
    const { urbit, oracle, hexagrams, setIntention, setOracle, subEvent, setError } = useUrbitStore()

    useEffect(() => {
      const updateFun = () => {
          setOracle(subEvent)
          }
      updateFun()
      }, [subEvent]);

console.log('hexa', hexagrams)
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
console.log('o',oracle)
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
                <div>position: {oracle.position-1}</div><p/>
                <div style={{fontSize:'64px'}}>{hexagrams[oracle.position-1].hc}</div><p/>
                <div>{hexagrams[oracle.position-1].c} -  {hexagrams[oracle.position-1].nom}</div><p/>
                <div>judgement: {hexagrams[oracle.position-1].jud}</div><p/>
                <div>image: {hexagrams[oracle.position-1].img}</div><p/>
                {oracle.changing.length > 0 && <div><div>changing lines: 
                  {oracle.changing?.map(o => {return <p>line {o}: {hexagrams[oracle.position-1][`l${o}`]}</p>})} </div>
                  <p/>
                  <div>momentum: {oracle.momentum-1}</div><p/>
                  <div style={{fontSize:'64px'}}>{hexagrams[oracle.momentum-1].hc}</div><p/>
                  <div>{hexagrams[oracle.momentum-1].c} - {hexagrams[oracle.momentum-1].nom}</div><p/>
                  <div>judgement: {hexagrams[oracle.momentum-1].jud}</div><p/>
                  </div>}
                <button onClick={() => setOracle({})}>X</button>
            </div>}
         </main>
    )
}