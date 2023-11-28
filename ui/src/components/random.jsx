import React, { useEffect } from 'react'
import { Link } from "react-router-dom"
import { Oracle } from './oracle'
import useUrbitStore from '../store'
import '@urbit/sigil-js'

export const Random = () => {
    const { urbit, oracle, setOracle, hexagrams  } = useUrbitStore()

    useEffect( () => {
        const getOracle = async () => {
            setOracle(await urbit.scry({
            app: 'yijing',
            path: '/cast',
            }))
        };  
      setOracle(null)

      if (urbit) {
        getOracle()
        }
      }, [urbit]);


    if (!oracle) return <div><br/>entropy pending. . .</div>
    else return(
        <main>
            <br/>
            <Oracle />
            <div className='bottom'>
            <Link onClick={()=>setOracle(null)} className='nav'  to="/apps/yijing/">[cast]</Link>&nbsp;&nbsp;
              <Link className='nav' to="/apps/yijing/log">[log]</Link>&nbsp;&nbsp;
              <Link className='nav' to="/apps/yijing/rumors">[rumors]</Link>
            </div>
         </main>
    )
}