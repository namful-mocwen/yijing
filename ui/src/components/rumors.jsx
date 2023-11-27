import React, { useEffect, useState } from 'react'
import { Link, useNavigate } from "react-router-dom"
import { useWindowWidth } from '@react-hook/window-size'
import useUrbitStore from '../store'
import '@urbit/sigil-js'

export const Rumors = () => {
    const { urbit, cast, oracle, hexagrams, setOracle, setIntention } = useUrbitStore()
    const [rumors, setRumors] = useState([])
    const navigate = useNavigate();
    const width = useWindowWidth()

   const getRumors = async () => {
        return urbit.scry({
        app: 'yijing',
        path: '/rumors',
        })
    };

    useEffect(() => {
        setOracle({})
        }, []);

    useEffect(() => {
        const getEm = async () =>  {
            //   setShipLog((await getShipLog())[`~${urbit.ship}`])
              setRumors(await getRumors())
        }
        urbit && getEm()
      }, [urbit]);
    
    console.log('rumors', rumors)
    console.log('oracle', oracle)
      // urbit sigil moons missing
      if (rumors.length < 1) return (
        <>
            <p>"it's been strangely quiet..."</p>
            <div className='bottom'>
                <Link onClick={()=>setOracle({})} className='nav'  to="/apps/yijing/">[cast]</Link>&nbsp;&nbsp;
                <Link className='nav' to="/apps/yijing/log">[log]</Link>
            </div>
        </>
      )

      return (
        <>
            <main>
                <br/>
                {!oracle?.position ? <table>
                    <thead>
                        <tr>
                            <th colSpan={3}>
                                rumors
                            </th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr>
                            <th colSpan={3} />
                            {/* <th>when</th>
                            <th>what</th> */}
                        </tr>
                        {rumors?.map((s,i) => {
                            var when = new Date(s.when);
                            return (
                                <tr onClick={()=> setIntention(s.what)} tkey={i}>  
                                    {width > 420 && <td>
                                            {`${when.toLocaleTimeString("en-US")}`}   <br></br>
                                            {`${when.toLocaleDateString("en-US")}`}   
                                    </td>}
                                    <td style={{minWidth: '8vw', maxWidth: width > 420 ? '64vw' : '81vw'}}>
                                        {s.what}
                                    </td> 
                                    <td>
                                        <button  onClick={()=> cast(`%rumors ~ ${s.what}`, urbit)} className='reverse'>
                                            cast 
                                        </button>
                                    </td> 
                                </tr>
                        )})}
                    </tbody>
                </table>
                : <div className='oracle'>
                    <button className='hover' onClick={() => {setOracle({}); navigate("/apps/yijing/log")}}>[ X ]</button><br/><br/>
                    <div><p className='bold'>Intention</p> {oracle.intention}</div><p/><p>~</p>
                    <div><p className='bold'>Position</p> {oracle.position}</div><p/>
                    <div style={{fontSize:'64px'}}>{hexagrams[oracle.position-1].hc}</div><p/><p/>
                    <div>{hexagrams[oracle.position-1].c} -  {hexagrams[oracle.position-1].nom}</div><p/>
                    <div><p className='bold'>Judgement</p> {hexagrams[oracle.position-1].jud}</div><p/>
                    <div><p className='bold'>Image</p> {hexagrams[oracle.position-1].img}</div><p/>
                    {oracle.changing.length > 0 && <div><div><span className='bold'>Changing Lines</span>
                    {oracle.changing?.map(o => {return <p><span className='bold'>Line {o}:</span> {hexagrams[oracle.position-1][`l${o}`]}</p>})} </div>
                    <p/><p>~</p>
                    <div><p className='bold'>Momentum</p> {oracle.momentum}</div><p/>
                    <div style={{fontSize:'64px'}}>{hexagrams[oracle.momentum-1].hc}</div><p/>
                    <div>{hexagrams[oracle.momentum-1].c} - {hexagrams[oracle.momentum-1].nom}</div><p/>
                    <div><p className='bold'>Judgement</p> {hexagrams[oracle.momentum-1].jud}</div><p/>
                    </div>}
                    <p>~</p>
                </div>}
                <br/><br/>
            </main>
            <div className='bottom'>
              <Link onClick={()=>setOracle({})} className='nav'  to="/apps/yijing/">[cast]</Link>&nbsp;&nbsp;
              <Link className='nav' to="/apps/yijing/log">[log]</Link>
              {/* <Link onClick={()=>setOracle({})} className='nav'  to="/apps/yijing/random">[random]</Link> */}
            </div>
        </>
    )
}