import React, { useEffect } from 'react'
import { Link, useNavigate } from "react-router-dom"
import useUrbitStore from '../store'
import '@urbit/sigil-js'

export const Random = () => {
    const { urbit, oracle, hexagrams, setOracle } = useUrbitStore()

    useEffect( () => {
        const getOracle = async () => {
            setOracle(await urbit.scry({
            app: 'yijing',
            path: '/cast',
            }))
        };  
      setOracle({})
      if (urbit) {
        getOracle()
        }
      }, [urbit]);


    console.log(oracle)
    if (!oracle?.position) return <div><br/>entropy pending. . .</div>
    else return(
        <main>
            <br/>
            <div className='oracle'>
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
            </div>
            <div className='bottom'>
            <Link onClick={()=>setOracle({})} className='nav'  to="/apps/yijing/">[cast]</Link>&nbsp;&nbsp;
              <Link className='nav' to="/apps/yijing/log">[log]</Link>&nbsp;&nbsp;
              <Link className='nav' to="/apps/yijing/rumors">[rumors]</Link>
            </div>
         </main>
    )
}