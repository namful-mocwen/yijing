import React, { useEffect } from 'react'
import { Link } from "react-router-dom"
import { Oracle } from './oracle'
import useUrbitStore from '../store'
import '@urbit/sigil-js'

export const Landing = () => {
    const { urbit, cast, oracle, hOracle, hexagrams, setIntention, setOracle, setError } = useUrbitStore()

    useEffect(() => {
      setOracle(null)
      }, []);

    const onKeyDown = e => {
      if (e.key === 'Enter' && !e.shiftKey) {
        e.preventDefault()
        e.target.value && cast(e.target.value, urbit)
        e.target.value=''
        setIntention('')
      }
    };

    // oracle && console.log('o', oracle)
    // hOracle && console.log('hO', hOracle)
    // console.log('hexa', hexagrams)
    return(
        <main>
            <br/>
            {!oracle 
            ? 
            <div style={{display: 'flex', flexDirection: 'column'}}>
              <input
                  type='text' 
                  name='intention' 
                  placeholder='*?*' 
                  onChange={e => setIntention(e.target.value)}
                  onKeyDown={e => onKeyDown(e)}
              />
              <p style={{color: '#f8f8f8', textAlign: 'center'}}><span style={{color: 'gray'}}>• </span> shared with %pals <span style={{color: 'gray'}}> •</span></p>
            </div>
            : <Oracle />}
            <div style={{marginTop:'138px', marginRight: '8px'}}>
            {!oracle?.position && <urbit-sigil {...{ point: (urbit?.ship.length > 16) 
                ? urbit?.ship.slice(urbit?.ship.length-13, urbit?.ship.length) 
                : urbit?.ship , size: 208, space: 'none'}} />}
            </div>
            <div className='bottom'>
            {/* <Link onClick={()=>setOracle(null)} className='nav'  to="/apps/yijing/random">[random]</Link>&nbsp;&nbsp; */}
            <Link className='nav' to="/apps/yijing/hexagrams">[hexagrams]</Link>&nbsp;&nbsp;
              <Link className='nav' to="/apps/yijing/log">[log]</Link>&nbsp;&nbsp;
              <Link className='nav' to="/apps/yijing/rumors">[rumors]</Link>
            
            </div>
         </main>
    )
}