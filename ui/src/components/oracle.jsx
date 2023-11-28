import React from 'react'
import { useNavigate } from "react-router-dom"
import useUrbitStore from '../store'


export const Oracle = () => {
    const { oracle, hOracle, hexagrams, setOracle } = useUrbitStore()
    const navigate = useNavigate();
    console.log( oracle, hOracle) ;
    return (
        <div className='oracle'>
            <button className='hover' onClick={() => {oracle !== hOracle ? (setOracle(null) && navigate("/apps/yijing/log")) : setOracle(null)}}>[ X ] </button><br/><br/>
            {oracle !== hOracle && <div><p className='bold'>Intention</p> {oracle.intention} <p/><p>~</p></div>}
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
        </div>
    )
}