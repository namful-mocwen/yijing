import React, { useEffect, useState } from 'react'
import { Link } from "react-router-dom"
import useUrbitStore from '../store'
import '@urbit/sigil-js'

export const Landing = () => {
    const { urbit, oracle, hexagrams, setIntention, setOracle, subEvent, setError } = useUrbitStore()
    const [privacy, setPrivacy] = useState('public');

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
          json: { 
              cast: {
                  intention: intention,
                  public: privacy === 'public'
              }
            },
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
            <div style={{display: 'flex', flexDirection: 'column'}}>
              <input
                  type='text' 
                  name='intention' 
                  placeholder='*?*' 
                  onChange={e => setIntention(e.target.value)}
                  onKeyDown={e => onKeyDown(e)}
              />
              <div>
                  <input
                      type="radio"
                      name="privacy"
                      value="public"
                      checked={privacy === 'public'}
                      onChange={() => setPrivacy('public')}
                  /> Public
                  <input
                      type="radio"
                      name="privacy"
                      value="private"
                      checked={privacy === 'private'}
                      onChange={() => setPrivacy('private')}
                  /> Private
            </div>
              <p style={{color: '#f8f8f8', textAlign: 'center'}}><span style={{color: 'gray'}}>• </span> shared with %pals <span style={{color: 'gray'}}> •</span></p>
            </div>
            :
            <div className='oracle'>
                <button className='hover' onClick={() => setOracle({})}>[ X ] </button><br/><br/>
                <div><p className='bold'>Intention</p> {oracle.intention}</div><p/><p>~</p>
                <div><p className='bold'>Position</p> {oracle.position}</div><p/>
                <div style={{fontSize:'64px'}}>{hexagrams[oracle.position-1].hc}</div><p/>
                <div>{hexagrams[oracle.position-1].c} -  {hexagrams[oracle.position-1].nom}</div><p/>
                <div><p className='bold'>Judgement</p> {hexagrams[oracle.position-1].jud}</div><p/>
                <div><p className='bold'>Image</p> {hexagrams[oracle.position-1].img}</div><p/>
                {oracle.changing.length > 0 && <div><div><span className='bold'>Changing Lines</span><p/>
                  {oracle.changing?.map(o => {return <p><span className='bold'>Line {o}:</span> {hexagrams[oracle.position-1][`l${o}`]}</p>})} </div>
                  <p/><p>~</p>
                  <div><p className='bold'>Momentum</p> {oracle.momentum}</div><p/>
                  <div style={{fontSize:'64px'}}>{hexagrams[oracle.momentum-1].hc}</div><p/>
                  <div>{hexagrams[oracle.momentum-1].c} - {hexagrams[oracle.momentum-1].nom}</div><p/>
                  <div><p className='bold'>Judgement</p> {hexagrams[oracle.momentum-1].jud}</div><p/>
                  </div>}
                  <p>~</p>
            </div>}
            <div style={{marginTop:'138px', marginRight: '8px'}}>
            {!oracle?.position && <urbit-sigil {...{ point: (urbit?.ship.length > 16) 
                ? urbit?.ship.slice(urbit?.ship.length-13, urbit?.ship.length) 
                : urbit?.ship , size: 208, space: 'none'}} />}
            </div>
            <Link className='nav' to="/apps/yijing/log">[log]</Link>
         </main>
    )
}
