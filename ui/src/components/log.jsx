import React, { useEffect, useState } from 'react'
import { Link } from "react-router-dom"
import useUrbitStore from '../store'
import '@urbit/sigil-js'


// real time add

export const Log = () => {
    const { urbit, log, hexagrams, setLog, shipLog, setShipLog } = useUrbitStore()
    const [feed, setFeed] = useState('~zod')

    const getShipLog = async () => {
        return urbit.scry({
        app: 'yijing',
        path: `/log/~${urbit.ship}`,
        })
    };

    const getLog = async () => {
        return urbit.scry({
        app: 'yijing',
        path: `/log`,
        })
    };

    useEffect(() => {
        const getLogs = async () =>  {
              setShipLog((await getShipLog())[`~${urbit.ship}`])
              setLog(await getLog())
              setFeed(`~${urbit.ship}`)
        }

        urbit && getLogs()
      }, [urbit]);
    
    console.log('ship', urbit?.ship)
    log && console.log('log', log)

    return (
        <>
            <main>
                <br/>
                <table>
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
                                            onClick={()=> setFeed(l)}>{l} 
                                        </button>&nbsp;&nbsp;
                                    </span>

                                )
                            })}
                            </th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr>
                            <th>who</th>
                            <th>when</th>
                            <th>position</th>
                            <th>intention</th>
                            <th>momentum</th>
                        </tr>
                        {log[feed]?.map((s,i) => {
                            var when = new Date(s.when);
                            return (
                                <tr key={i}>  
                                    <td>
                                    <urbit-sigil {...{ point: feed, 
                                                       size: 28,
                                                       space:'none',
                                                    }}
                                     />
                                    </td>
                                    <td>
                                            {`${when.toLocaleTimeString("en-US")}`}   <br></br>
                                            {`${when.toLocaleDateString("en-US")}`}   
                                    </td> 
                                    <td>
                                        {hexagrams[s.position-1]?.hc ||  s.position}
                                    </td>    
                                
                                    <td>
                                        {s.intention}
                                    </td> 
                                    <td>
                                        {hexagrams[s.momentum]?.hc || s.momentum}
                                    </td> 
                                </tr>
                        )})}
                    </tbody>
                </table><br/><br/>
            </main>
            <Link className='nav'  to="/apps/yijing/">[cast]</Link>
        </>
    )
}