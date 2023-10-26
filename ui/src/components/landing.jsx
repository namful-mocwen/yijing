import React, { useEffect } from 'react'
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

    useEffect(() => {
      setOracle({})
      }, []);
  
    
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
    console.log('hexa', hexagrams)
    return(
        <main>
            <br/>
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
                <button className='hover' onClick={() => setOracle({})}>[ X ] </button><br/><br/>
                <div>Intention: {oracle.intention}</div><p/>
                <div>Position: {oracle.position-1}</div><p/>
                <div style={{fontSize:'64px'}}>{hexagrams[oracle.position-1].hc}</div><p/>
                <div>{hexagrams[oracle.position-1].c} -  {hexagrams[oracle.position-1].nom}</div><p/>
                <div>Judgement: {hexagrams[oracle.position-1].jud}</div><p/>
                <div>Image: {hexagrams[oracle.position-1].img}</div><p/>
                {oracle.changing.length > 0 && <div><div>Changing Lines: 
                  {oracle.changing?.map(o => {return <p>Line {o}: {hexagrams[oracle.position-1][`l${o}`]}</p>})} </div>
                  <p/>
                  <div>Momentum: {oracle.momentum-1}</div><p/>
                  <div style={{fontSize:'64px'}}>{hexagrams[oracle.momentum-1].hc}</div><p/>
                  <div>{hexagrams[oracle.momentum-1].c} - {hexagrams[oracle.momentum-1].nom}</div><p/>
                  <div>Judgement: {hexagrams[oracle.momentum-1].jud}</div><p/>
                  </div>}
            </div>}
            <div style={{marginTop:'128px', marginRight: '16px'}}>
            {!oracle?.position && <urbit-sigil {...{ point: urbit?.ship, size: 256, space: 'none'}} />}
            </div>
            <Link  className='nav' to="/apps/yijing/log">[log]</Link>
         </main>
    )
}