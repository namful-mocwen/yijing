import React, { useEffect } from 'react'
import { Link } from "react-router-dom"
import mockLog from './mock.js'
import useUrbitStore from '../store'

export const Log = () => {
    const { urbit, log, setLog, shipLog, setShipLog } = useUrbitStore()
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
        }
        urbit ? getLogs() : setShipLog(mockLog)
      }, [urbit]);
    
      console.log(shipLog)
   return (
        <>
            <main>
                <br/>
                <table>
                    <thead>
                        <tr>
                            <th colSpan={6}>{`~${urbit?.ship}`}</th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr>
                            <th>when</th>
                            <th>position</th>
                            <th>why</th>
                            <th>momentum</th>
                        </tr>
                        {shipLog && shipLog.map((e,i) => {
                            var when = new Date(e.when);
                            return (
                                <tr key={i}>  
                                    <td>
                                            {` ${when.toLocaleTimeString("en-US")}`}   <br></br>
                                            {`${when.toLocaleDateString("en-US")}` }   
                                    </td> 
                                    <td>
                                        {e.position}
                                    </td>    
                                
                                    <td>
                                        {e.intention}
                                    </td> 
                                    <td>
                                        {e.momentum}
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