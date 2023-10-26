import React, { useEffect, useRef, useState } from 'react'
import { Link } from "react-router-dom"
import useUrbitStore from '../store'
import '@urbit/sigil-js'
import * as THREE from 'three';
import hexcolors from './hexcolors.json';


// This is the shader code - ignore this
const defaultShader = `
  #ifdef GL_ES
  precision mediump float;
  #endif

  uniform vec2 u_resolution;
  uniform float u_time;
  uniform vec3 u_fireColor;


  float snoise(vec3 uv, float res)
  {
      const vec3 s = vec3(1e0, 1e2, 1e3);
      
      uv *= res;
      
      vec3 uv0 = floor(mod(uv, res)) * s;
      vec3 uv1 = floor(mod(uv + vec3(1.), res)) * s;
      
      vec3 f = fract(uv);
      f = f * f * (3.0 - 2.0 * f);

      vec4 v = vec4(uv0.x + uv0.y + uv0.z, uv1.x + uv0.y + uv0.z,
                    uv0.x + uv1.y + uv0.z, uv1.x + uv1.y + uv0.z);

      vec4 r = fract(sin(v * 1e-1) * 1e3);
      float r0 = mix(mix(r.x, r.y, f.x), mix(r.z, r.w, f.x), f.y);
      
      r = fract(sin((v + uv1.z - uv0.z) * 1e-1) * 1e3);
      float r1 = mix(mix(r.x, r.y, f.x), mix(r.z, r.w, f.x), f.y);
      
      return mix(r0, r1, f.z) * 2.0 - 1.0;
  }

  void main() {
      vec2 p = -1.0 + 2.0 * gl_FragCoord.xy / u_resolution.xy;
      p.x *= u_resolution.x / u_resolution.y;
      
      float fire = 0.0;
      vec3 coord = vec3(atan(p.x, p.y) / 6.2832 + 0.5, length(p) * 0.9, 11);
      float oscillatingValue = sin(u_time * 0.4);
      float timeFactor = abs(oscillatingValue);
      timeFactor = mix(-5.9, 1.0, timeFactor);
      float shaderColor = 3.2 - (3.0 * length(2.0 * p)) + timeFactor;

      for (int i = 1; i <= 7; i++) {
          float power = pow(2.0, float(i));
          shaderColor += (1.5 / power) * snoise(coord + vec3(0.0, -u_time * 0.1, u_time * 0.01), power * 3.0);
      }
                  
      // Use u_fireColor instead of hardcoded fireColor
      vec3 finalColor = mix(u_fireColor, u_fireColor * vec3(shaderColor), 0.3);
      
      gl_FragColor = vec4(finalColor, 1.0);
  }
`;



export const Landing = () => {
    const { urbit, oracle, hexagrams, setIntention, setOracle, subEvent, setError } = useUrbitStore()
    const [inputPos, setInputPos] = useState({ x: 0, y: 0 });
    const [isActive, setIsActive] = useState(false);
    const inputRef = useRef(null);
    
    useEffect(() => {
        const handleMouseMove = (e) => {
            setInputPos({
                x: e.clientX,
                y: e.clientY
            });
        };
    
        const handleKeyDown = (e) => {
            if (e.target.tagName !== 'INPUT' && e.target.tagName !== 'TEXTAREA') {
                setIsActive(true);
                inputRef.current.focus();
            }
        };
    
        document.addEventListener('mousemove', handleMouseMove);
        document.addEventListener('keydown', handleKeyDown);
    
        return () => {
            document.removeEventListener('mousemove', handleMouseMove);
            document.removeEventListener('keydown', handleKeyDown);
        };
    }, []);
    
    const handleBlur = () => {
        setIsActive(false);
    };
        // This is the THREE.js material ref to change the shader color depending on cast results
    const materialRef = useRef(null);    
    // This is the THREE.js canvasRef
    const canvasRef = useRef(null);

    const fadeToBlack = () => {
        if (materialRef.current) {
            materialRef.current.fragmentShader = defaultShader;
            materialRef.current.needsUpdate = true;
            
            // Clear any existing timeouts and animation frames
            if (timeoutRef.current) {
                clearTimeout(timeoutRef.current);
                timeoutRef.current = null;
            }
            if (animationFrameRef.current) {
                cancelAnimationFrame(animationFrameRef.current);
                animationFrameRef.current = null;
            }
    
            // Initial flame color
            let fireColor = { ...currentFireColor };
            
            // Call target flame color from hexcolors.json
            const hexagramIndex = oracle.position ? oracle.position - 1 : null;
            const colorData = hexagramIndex !== null ? hexcolors.colors.find(color => color.num === hexagramIndex) : null;
            const rgbValues = colorData ? colorData.color.slice(1, -1).split(',').map(Number) : null;
            const targetColor = rgbValues ? { r: rgbValues[0], g: rgbValues[1], b: rgbValues[2] } : null;
                
            const decrement = 0.005;
            const frameDelay = 30;
    
            const animate = () => {
                animationFrameRef.current = requestAnimationFrame(animate);
    
                fireColor.r = THREE.MathUtils.lerp(fireColor.r, targetColor.r, decrement);
                fireColor.g = THREE.MathUtils.lerp(fireColor.g, targetColor.g, decrement);
                fireColor.b = THREE.MathUtils.lerp(fireColor.b, targetColor.b, decrement);
    
                // Update the shader uniform with the new fireColor
                materialRef.current.uniforms.u_fireColor.value = new THREE.Vector3(fireColor.r, fireColor.g, fireColor.b);
                materialRef.current.needsUpdate = true;
    
                if (Math.abs(fireColor.r - targetColor.r) > 0.01 || 
                    Math.abs(fireColor.g - targetColor.g) > 0.01 || 
                    Math.abs(fireColor.b - targetColor.b) > 0.01) {
                    timeoutRef.current = setTimeout(() => {
                        requestAnimationFrame(animate);
                    }, frameDelay);
                }
            };
    
            animate();
        }
    };

    useEffect(() => {
      const updateFun = () => {
          setOracle(subEvent)
          }
      updateFun()
      }, [subEvent]);

      useEffect(() => {
        // Set up basic scene
        const scene = new THREE.Scene();
        const camera = new THREE.PerspectiveCamera(75, window.innerWidth / window.innerHeight, 0.1, 1000);
        const renderer = new THREE.WebGLRenderer({ canvas: canvasRef.current, alpha: true });

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

        // Set up shader background
        const plane = new THREE.PlaneGeometry(window.innerWidth, window.innerHeight);

        // Set up uniforms for material
        const material = new THREE.ShaderMaterial({
            uniforms: {
                u_resolution: new THREE.Uniform(new THREE.Vector2()),
                u_time: { value: 0.0 },
                u_shaderColor: { value: 0.0 },
                u_fireColor: { value: new THREE.Vector3(0.349, 0.416, 0.416) },
                u_fadeFactor: { value: 0.0 }
            },
            fragmentShader: defaultShader
        });

        materialRef.current = material;

        const bg = new THREE.Mesh(plane, material);
        scene.add(bg);

        // Add pointers
        // const mouse = new THREE.Vector2();
        // const raycaster = new THREE.Raycaster();
        // const cursorTarget = new THREE.Vector3();

        // // Add shadow
        // const orb = new THREE.SphereGeometry(0.087, 32, 32);
        // const orbMaterial = new THREE.MeshBasicMaterial({ color: 0xefefef });
        // const shadow = new THREE.Mesh(orb, orbMaterial);
        // scene.add(shadow);

        // function onMouseMove(event) {
        //     mouse.x = (event.clientX / window.innerWidth) * 2 - 1;
        //     mouse.y = -(event.clientY / window.innerHeight) * 2 + 1;

        //     raycaster.setFromCamera(mouse, camera);
        //     const intersects = raycaster.intersectObjects(scene.children);

        //     if (intersects.length > 0) {
        //         const intersection = intersects[0];
        //         cursorTarget.copy(intersection.point); // Store the target position
        //         const dampingFactor = 0.1; // Adjust the damping factor as needed
        //         shadow.position.lerp(cursorTarget, dampingFactor);
        //     }
        // }

        // window.addEventListener('mousemove', onMouseMove, false);

        camera.position.z = 5;

        // Render and animate scene
        const render = () => {
            const object = scene.children[0];
            object.material.uniforms.u_resolution.value.x = window.innerWidth;
            object.material.uniforms.u_resolution.value.y = window.innerHeight;
            renderer.render(scene, camera);
        }

        const animate = () => {
            requestAnimationFrame(animate);
            material.uniforms.u_time.value += 0.01;
            render();
        };

        animate();
        
        return () => {
            window.removeEventListener('resize', setRendererSize);
            document.body.removeChild(renderer.domElement);
        };
    }, []);


console.log('hexa', hexagrams)
    const cast = (intention) => {
        urbit.poke({
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
        e.target.value=''
        setIntention('')
      }
    };
    
console.log('o',oracle)
    return(
      
        <main>
            <canvas ref={canvasRef} style={{
                position: "absolute",
                top: 0,
                left: 0,
                width: "100%",
                height: "100%",
                zIndex: -1
            }}></canvas>
            <Link className='nav' to="/apps/yijing/log">[log]</Link>
            {!oracle?.position 
            ? 
            <input
                ref={inputRef}
                style={{
                    position: 'absolute',
                    top: `${inputPos.y}px`,
                    left: `${inputPos.x}px`,
                    pointerEvents: isActive ? 'auto' : 'none'
                }}
                type='text' 
                name='intention' 
                placeholder='Type your intentions here . . .' 
                onChange={e => setIntention(e.target.value)}
                onKeyDown={e => onKeyDown(e)}
                onBlur={handleBlur}
            />
                :
            <div className='oracle'>
                <div>intention: {oracle.intention}</div><p/>
                <div>position: {oracle.position-1}</div><p/>
                <div style={{fontSize:'64px'}}>{hexagrams[oracle.position-1].hc}</div><p/>
                <div>{hexagrams[oracle.position-1].c} -  {hexagrams[oracle.position-1].nom}</div><p/>
                <div>judgement: {hexagrams[oracle.position-1].jud}</div><p/>
                <div>image: {hexagrams[oracle.position-1].img}</div><p/>
                {oracle.changing.length > 0 && <div><div>changing lines: 
                  {oracle.changing?.map(o => {return <p>line {o}: {hexagrams[oracle.position-1][`l${o}`]}</p>})} </div>
                  <p/>
                  <div>momentum: {oracle.momentum-1}</div><p/>
                  <div style={{fontSize:'64px'}}>{hexagrams[oracle.momentum-1].hc}</div><p/>
                  <div>{hexagrams[oracle.momentum-1].c} - {hexagrams[oracle.momentum-1].nom}</div><p/>
                  <div>judgement: {hexagrams[oracle.momentum-1].jud}</div><p/>
                  </div>}
                <button onClick={() => setOracle({})}>X</button>
            </div>}
         </main>
    )
}