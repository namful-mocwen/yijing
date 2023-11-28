import React, { useEffect, useState } from 'react'
import { Link } from "react-router-dom"
import { useWindowWidth } from '@react-hook/window-size'
import { Oracle } from './oracle'
import useUrbitStore from '../store'
import '@urbit/sigil-js'

export const Rumors = () => {
    const { urbit, cast, oracle, setOracle, hexagrams, hOracle, setIntention } = useUrbitStore()
    const [rumors, setRumors] = useState([])
    const width = useWindowWidth()

   const getRumors = async () => {
        return urbit.scry({
        app: 'yijing',
        path: '/rumors',
        })
    };

    useEffect(() => {
        setOracle(null)
        }, []);

    useEffect(() => {
        const getEm = async () =>  {
            //   setShipLog((await getShipLog())[`~${urbit.ship}`])
              setRumors(await getRumors())
        }
        urbit && getEm()
      }, [urbit]);
    
    // console.log('rumors', rumors)
    // console.log('oracle', oracle)
      // urbit sigil moons missing
      if (rumors.length < 1) return (
        <>
            <p>"it's been strangely quiet..."</p>
            <div className='bottom'>
                <Link onClick={()=>setOracle(null)} className='nav'  to="/apps/yijing/">[cast]</Link>&nbsp;&nbsp;
                <Link className='nav' to="/apps/yijing/log">[log]</Link>
            </div>
        </>
      )

      return (
        <>
            <main>
                <br/>
                {!oracle ? <table>
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
                : <Oracle />}
                <br/><br/>
            </main>
            <div className='bottom'>
              <Link className='nav' to="/apps/yijing/hexagrams">[hexagrams]</Link>&nbsp;&nbsp; 
              <Link className='nav' to="/apps/yijing/log">[log]</Link>&nbsp;&nbsp;
              <Link onClick={()=>setOracle(null)} className='nav'  to="/apps/yijing/">[cast]</Link>
              {/* <Link onClick={()=>setOracle({})} className='nav'  to="/apps/yijing/random">[random]</Link> */}
            </div>
        </>
    )
}