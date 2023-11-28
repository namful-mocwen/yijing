import React, { useEffect, useState } from 'react'
import { Link } from "react-router-dom"
import { Oracle } from './oracle'
import useUrbitStore from '../store'

import '@urbit/sigil-js'

export const Hexagrams = () => {
    const { hexagrams, oracle, setOracle } = useUrbitStore()
    const [hexa, setHexa] = useState(null)

    useEffect(() => {
      setOracle(null)
      }, []);

    if (!hexagrams) return (
        <>
            <p>"waiting for the book of changes..."</p>
            <div className='bottom'>
                <Link onClick={()=>setOracle(null)} className='nav'  to="/apps/yijing/">[cast]</Link>&nbsp;&nbsp;
                <Link className='nav' to="/apps/yijing/log">[log]</Link>&nbsp;&nbsp;
                <Link className='nav' to="/apps/yijing/rumors">[rumors]</Link>
            </div>
        </>
      )
    else return(
        <main>
            <br/>
            {!hexa && !oracle? <div style={{ width: '88vw',  textAlign:'center', wordWrap: 'break-word' }}>
                {hexagrams?.map((h,i) => {
                    return <span onClick={() => setHexa(h)} className='hexagram' key={i}>{h.hc}</span> 
                })
                }
            </div>
            : !oracle ?
            <div className='oracle'>
                <button className='hover' onClick={() => setHexa(null)}>[ X ] </button><br/><br/>
                <div style={{fontSize:'64px'}}>{hexa.hc}</div><p/>
                <div>{hexa.c} -  {hexa.nom}</div><p/>
                <div className='bold'>{hexa.num}</div><p/>
                <p>~</p>
                <div><p className='bold'>Judgement</p> {hexa.jud}</div><p/>
                <p>~</p>
                <div><p className='bold'>Image</p> {hexa.img}</div><p/>
                <p>~</p>
                {<div><div><span className='bold'>Changing Lines</span><p/>
                  {[1,2,3,4,5,6].map(l => {return <p><span className='bold'>Line {l}:</span> {hexa[`l${l}`]}</p>})} </div>
                  <p/><p>~</p>
                  </div>}
            </div>
            :  <Oracle /> }
            <div className='bottom'>
            {/* <Link onClick={()=>setOracle(null)} className='nav'  to="/apps/yijing/random">[random]</Link>&nbsp;&nbsp; */}
                <Link className='nav' to="/apps/yijing/log">[log]</Link>&nbsp;&nbsp;
                <Link onClick={()=>setOracle(null)} className='nav'  to="/apps/yijing/">[cast]</Link>&nbsp;&nbsp;
                <Link className='nav' to="/apps/yijing/rumors">[rumors]</Link>
            </div>
         </main>
    )
}