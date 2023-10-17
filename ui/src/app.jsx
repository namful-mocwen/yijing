import React, { useRef, useEffect, useState } from 'react';
import Urbit from '@urbit/http-api';
import * as THREE from 'three';
import './app.css'

const api = new Urbit('', '', window.desk);
api.ship = window.ship;

export function App() {
  const [log, setLog] = useState(new Map())
  const [shipLog, setShipLog] = useState(new Map())
  const [oracle, setOracle] = useState({})
  const [intention, setIntention] = useState(null)
  const [subEvent, setSubEvent] = useState({})
  const [status, setStatus] = useState(null)
  const [error, setError] = useState(null)
  const canvasRef = useRef(null);

  useEffect(() => {
    const init = async () => {
      subscribe()
      setShipLog(await getShipLog())
      setLog(await getLog())

    }
    window.urbit = new Urbit("")
    window.urbit.ship = window.ship

    window.urbit.onOpen = () => setStatus("con")
    window.urbit.onRetry = () => setStatus("try")
    window.urbit.onError = () => setStatus("err")

    init()
  }, []);

  useEffect(() => {
    const updateFun = () => {
      setOracle(subEvent)
      console.log('test', subEvent)
    }
    updateFun()
  }, [subEvent]);

  const getShipLog = async () => {
    return window.urbit.scry({
      app: 'yijing',
      path: `/log/~${window.ship}`,
    })
  };

  const getLog = async () => {
    return window.urbit.scry({
      app: 'yijing',
      path: `/log`,
    })
  };


  const subscribe = () => {
    try {
      window.urbit.subscribe({
        app: "yijing",
        path: "/updates",
        event: setSubEvent,
        err: () => console.log("Subscription rejected"),
        quit: () => console.log("Kicked from subscription"),
      })
    } catch {
      console.log("Subscription failed");
    }
  };

  const cast = (intention) => {
    window.urbit.poke({
      app: "yijing",
      mark: "yijing-action",
      json: { cast: { intention: intention } },
      onSuccess: () => console.log('successful cast. . .'),
      onError: () => setError("cast lost in dimensions. . ."),
    })
  };


  const onKeyDown = e => {
    if (e.key === 'Enter' && !e.shiftKey) {
      e.preventDefault()
      e.target.value && cast(e.target.value)
      e.target.value = ''
      setIntention('')
    }
  };

  console.log('log', log)
  console.log('ship', window.ship)
  console.log('shiplog', shipLog)

  useEffect(() => {
    const scene = new THREE.Scene();
    const camera = new THREE.PerspectiveCamera(75, window.innerWidth / window.innerHeight, 0.1, 1000);
    const renderer = new THREE.WebGLRenderer({ canvas: canvasRef.current, alpha: true });

    // Update renderer size while maintaining aspect ratio
    const setRendererSize = () => {
      const newWidth = window.innerWidth;
      const newHeight = window.innerHeight;

      renderer.setSize(newWidth, newHeight);
      camera.aspect = newWidth / newHeight;
      camera.updateProjectionMatrix();
    };
    setRendererSize();

    renderer.domElement.classList.add('renderer');
    document.body.appendChild(renderer.domElement);

    window.addEventListener('resize', setRendererSize);

    const plane = new THREE.PlaneGeometry(window.innerWidth, window.innerHeight);
    const material = new THREE.ShaderMaterial({
      uniforms: {
        u_resolution: new THREE.Uniform(new THREE.Vector2()),
        u_mouse: new THREE.Uniform(new THREE.Vector2())
      },
      fragmentShader: `
        void main() {
          gl_FragColor = vec4(0.0, 0.0, 0.0, 1.0);
        }
      `,
    });
    const bg = new THREE.Mesh(plane, material);
    scene.add(bg);


    camera.position.z = 5;
    const render = () => {
      const object = scene.children[0];
      object.material.uniforms.u_resolution.value.x = window.innerWidth;
      object.material.uniforms.u_resolution.value.y = window.innerHeight;
      renderer.render(scene, camera);
    }

    const animate = () => {
      requestAnimationFrame(animate);
      render();
    };
    animate();
    return () => {
      window.removeEventListener('resize', setRendererSize);
      document.body.removeChild(renderer.domElement);
    };
  }, []);

  return (
    <div>
      <canvas ref={canvasRef}></canvas>
      <main className='main'>
        {!oracle.position
          ?
          <input
            type='text'
            name='intention'
            placeholder='Type your intentions here. . .'
            onChange={e => setIntention(e.target.value)}
            onKeyDown={e => onKeyDown(e)}
          />
          :
          <div className='oracle'>
            <div>intention: {oracle.intention}</div><p />
            <div>position: {oracle.position}</div>
            <div>momentum: {oracle.momentum}</div><p />
            <button onClick={() => setOracle({})}>X</button>
          </div>}
      </main>
    </div>
  )
};