import React, { useEffect, useState } from 'react'
import { Link } from "react-router-dom"
import mockLog from './mocklog.js'
import mockShipLog from './mockship.js'
import useUrbitStore from '../store'


// real time add

export const Log = () => {
    const { urbit, log, setLog, shipLog, setShipLog } = useUrbitStore()
    const [display, setDisplay] = useState('~zod')

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
              setDisplay(`~${urbit.ship}`)
        }

        urbit ? getLogs() : setLog(mockLog)
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
                            <th colSpan={6}>{
                            Object.keys(log).map((l,i) => {
                                // if (display !== l)
                                return (
                                    <span key={i}>
                                        <button className={display === l ? 'reverse' : ''}
                                                onClick={()=> setDisplay(l)}>{l} 
                                        </button>&nbsp;&nbsp;
                                    </span>

                                )
                            })}
                            </th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr>
                            <th>when</th>
                            <th>position</th>
                            <th>why</th>
                            <th>momentum</th>
                        </tr>
                        {log[display]?.map((s,i) => {
                            var when = new Date(s.when);
                            return (
                                <tr key={i}>  
                                    <td>
                                            {` ${when.toLocaleTimeString("en-US")}`}   <br></br>
                                            {`${when.toLocaleDateString("en-US")}` }   
                                    </td> 
                                    <td>
                                        {s.position}
                                    </td>    
                                
                                    <td>
                                        {s.intention}
                                    </td> 
                                    <td>
                                        {s.momentum}
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