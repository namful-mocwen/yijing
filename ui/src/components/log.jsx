import React, { useEffect, useState } from 'react'
import { useWindowWidth } from '@react-hook/window-size'
import { Link } from "react-router-dom"
import { Oracle } from './oracle'
import useUrbitStore from '../store'
import '@urbit/sigil-js'


// real time add

export const Log = () => {
    const { urbit, log, hexagrams, oracle, setOracle, setLog } = useUrbitStore()
    const [feed, setFeed] = useState('~zod')
    const width = useWindowWidth()

    // const getShipLog = async () => {
    //     return urbit.scry({
    //     app: 'yijing',
    //     path: `/log/~${urbit.ship}`,
    //     })
    // };

    const getLog = async () => {
        return urbit.scry({
        app: 'yijing',
        path: `/log`,
        })
    };

    useEffect(() => {
        const getLogs = async () =>  {
            //   setShipLog((await getShipLog())[`~${urbit.ship}`])
              setLog(await getLog())
              setFeed(`~${urbit.ship}`)
        }
        urbit && getLogs()
        setOracle(null)
      }, [urbit]);
    
    // log.length > 0 && console.log('log', log)
      // urbit sigil moons missing
    return (
        <>
            <main>
                <br/>
                {!oracle ? <table>
                    <thead>
                        <tr>
                            <th colSpan={6}>
                                {/* <span>
                                    <button className={feed === `~${urbit?.ship}` ? 'reverse' : ''}
                                        onClick={()=> setFeed(`~${urbit?.ship}`)}>{`~${urbit?.ship}`} 
                                    </button>
                                  </span> */}
                                { Object.keys(log).map((l,i) => {
                                // if (feed !== l)
                                return (
                                    <span key={i}>
                                        <button className={feed === l ? 'reverse' : ''}
                                            onClick={()=> setFeed(l)}>{(l.length > 16) ? `~${l.slice(l.length-13, l.length)}` : l } 
                                        </button>&nbsp;&nbsp;
                                    </span>
                                )
                            })}
                            </th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr>
                            {width > 345 && <th>who</th>}
                            {width > 500 && <th>when</th>}
                            <th>position</th>
                            <th>intention</th>
                            <th>momentum</th>
                        </tr>
                        {log[feed]?.map((s,i) => {
                            var when = new Date(s.when);
                            return (
                                <tr className='hover' onClick={()=> setOracle(s)} tkey={i}>  
                                    {width > 345 && <td>
                                        <urbit-sigil {...{ point: (feed.length) > 16 
                                                        ? feed.slice(feed.length-13, feed.length) : feed, 
                                                       size: 28,
                                                       space:'none',
                                                    }}
                                     /> 
                                    </td>}
                                    {width > 500 && <td>
                                            {`${when.toLocaleTimeString("en-US")}`}   <br></br>
                                            {`${when.toLocaleDateString("en-US")}`}   
                                    </td> }
                                    <td style={{fontSize: '32px'}}>
                                        {hexagrams[s.position-1]?.hc || s.position}
                                    </td>    
                                
                                    <td style={{minWidth: '8vw', maxWidth:  '42vw'}}>
                                        {s.intention}
                                    </td> 
                                    <td style={{fontSize: '32px'}}>
                                        {hexagrams[s.momentum-1]?.hc || s.momentum}
                                    </td> 
                                </tr>
                        )})}
                    </tbody>
                </table>
                : <Oracle /> }
                <br/><br/>
            </main>
            <div className='bottom'>
              <Link className='nav' to="/apps/yijing/hexagrams">[hexagrams]</Link>&nbsp;&nbsp;
              <Link onClick={()=>setOracle(null)} className='nav'  to="/apps/yijing/">[cast]</Link>&nbsp;&nbsp;
              <Link className='nav' to="/apps/yijing/rumors">[rumors]</Link>
              {/* <Link onClick={()=>setOracle({})} className='nav'  to="/apps/yijing/random">[random]</Link> */}
            </div>
        </>
    )
}