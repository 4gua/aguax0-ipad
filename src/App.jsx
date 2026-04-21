import React, { useState, useEffect, useRef, useCallback } from 'react';
import '@google/model-viewer';
import {
  Play, Pause, SkipForward, SkipBack, Mic, Square,
  Navigation, Music, BookOpen, Edit3, Activity,
  MapPin, Wifi, WifiOff, Signal, Battery,
  Radio, Car, StopCircle, AlertTriangle,
  Fuel, Lock, Thermometer, CheckCircle, Flame,
  RefreshCw, Sun, CloudRain, Snowflake
} from 'lucide-react';
import hondaFitParked from './assets/honda-fit-parked.png';
import hondaFitMenuHome from './assets/honda-fit-menu-home.jpg';
import hondaFitMenuMaps from './assets/honda-fit-menu-maps.jpg';
import hondaFitMenuAudio from './assets/honda-fit-menu-audio.jpg';
import hondaFitMenuJournal from './assets/honda-fit-menu-journal.jpg';
import hondaFitMenuStudy from './assets/honda-fit-menu-study.jpg';

const HONDA_IMG = hondaFitParked;
const HONDA_MODEL = 'https://res.cloudinary.com/dvxg8rnxg/image/upload/v1776770670/2016_honda_fit_dba-gk3_m1pblf.glb';
const PARKED_SCENES = {
  home: {
    image: hondaFitMenuHome,
    imagePosition: '50% 56%',
    kicker: 'Desert Edition',
    title: 'Signature exterior view',
    detail: 'Low, bright, and clean against the open desert.',
  },
  maps: {
    image: hondaFitMenuMaps,
    imagePosition: '50% 50%',
    kicker: 'Journey',
    title: 'Roadside drive preview',
    detail: 'A route-forward scene with more atmosphere and motion.',
  },
  media: {
    image: hondaFitMenuAudio,
    imagePosition: '50% 48%',
    kicker: 'Audio',
    title: 'Rear three-quarter session',
    detail: 'A calmer backdrop for podcasts, mixes, and ambient listening.',
  },
  journal: {
    image: hondaFitMenuJournal,
    imagePosition: '50% 56%',
    kicker: 'Journal',
    title: 'Open desert perspective',
    detail: 'A quieter frame with more negative space for reflection.',
  },
  learn: {
    image: hondaFitMenuStudy,
    imagePosition: '50% 45%',
    kicker: 'Study',
    title: 'Reference garage mood',
    detail: 'A more editorial scene with multiple builds in view.',
  },
};

// --- PALETTE ---------------------------------------------------------------
const C = {
  gold: '#C9A961', goldLight: '#E8CF95',
  goldDim: 'rgba(201,169,97,0.12)', goldBorder: 'rgba(201,169,97,0.35)',
  cream: '#F0E6D2', bronze: '#8B6F3F',
  ink: '#0D0A07', danger: '#D85A3C',
  tGreen: '#6BAF7A', tYellow: '#E8B55A', tRed: '#D85A3C',
};
const serif = { fontFamily: '"Cormorant Garamond", serif' };
const narrow = { fontFamily: '"Archivo Narrow", sans-serif' };

export default function App() {
  const [netStatus, setNetStatus] = useState('checking');
  const [loadStep, setLoadStep] = useState(0);
  const [appReady, setAppReady] = useState(false);
  const fontsLoaded = useRef(false);

  useEffect(() => {
    if (fontsLoaded.current) return;
    fontsLoaded.current = true;
    const l = document.createElement('link');
    l.rel = 'stylesheet';
    l.href =
      'https://fonts.googleapis.com/css2?family=Cormorant+Garamond:ital,wght@0,300;0,400;0,500;0,600;1,400&family=Archivo:wght@300;400;500;600;700&family=Archivo+Narrow:wght@400;500;600;700&display=swap';
    document.head.appendChild(l);
  }, []);

  const checkNet = useCallback(() => {
    setNetStatus('checking');
    setLoadStep(0);
    setAppReady(false);

    setTimeout(() => {
      if (navigator.onLine) {
        setNetStatus('connected');
        [400, 800, 1200, 1600].forEach((ms, i) =>
          setTimeout(() => setLoadStep(i + 1), ms)
        );
        setTimeout(() => setAppReady(true), 2200);
      } else {
        setNetStatus('offline');
      }
    }, 600);
  }, []);

  useEffect(() => {
    const goOffline = () => setNetStatus('offline');
    const goOnline = () => checkNet();
    window.addEventListener('offline', goOffline);
    window.addEventListener('online', goOnline);
    return () => {
      window.removeEventListener('offline', goOffline);
      window.removeEventListener('online', goOnline);
    };
  }, [checkNet]);

  useEffect(() => {
    checkNet();
  }, [checkNet]);

  if (!appReady) return <LoadingScreen status={netStatus} step={loadStep} onRetry={checkNet} />;
  return <MainApp />;
}

// ============================================================================
// LOADING SCREEN
// ============================================================================
const BOOT_STEPS = [
  { label: 'GPS Signal', sub: 'CoreLocation acquiring satellites' },
  { label: 'Maps & Traffic', sub: 'MapKit · Google Roads handshake' },
  { label: 'Podcasts & Media', sub: 'RSS feeds · MusicKit auth' },
  { label: 'WeatherKit', sub: 'Current conditions loaded' },
];

function LoadingScreen({ status, step, onRetry }) {
  const [dots, setDots] = useState('');
  useEffect(() => {
    const i = setInterval(() => setDots((d) => (d.length >= 3 ? '' : d + '.')), 400);
    return () => clearInterval(i);
  }, []);

  return (
    <div
      className="w-full min-h-screen flex items-center justify-center"
      style={{
        background: 'radial-gradient(ellipse at center, #1a120a 0%, #0a0603 50%, #000 100%)',
        fontFamily: 'Archivo, sans-serif',
      }}
    >
      <style>{`
        @keyframes spinRing { to { stroke-dashoffset: -251; } }
        @keyframes fadeInUp { from { opacity:0; transform:translateY(12px); } to { opacity:1; transform:translateY(0); } }
        @keyframes pulse { 0%,100%{opacity:.5;} 50%{opacity:1;} }
        @keyframes blink  { 0%,100%{opacity:1;} 50%{opacity:0;} }
        .spin-ring { animation: spinRing 1.4s linear infinite; }
        .fade-in-up { animation: fadeInUp 0.5s ease both; }
        .pulse { animation: pulse 2s ease infinite; }
        .blink { animation: blink 1s step-end infinite; }
      `}</style>

      <div className="flex flex-col items-center gap-8" style={{ minWidth: 320 }}>
        <div className="text-center fade-in-up">
          <div
            style={{
              ...serif,
              color: C.cream,
              fontSize: 52,
              fontWeight: 400,
              fontStyle: 'italic',
              lineHeight: 1,
              letterSpacing: '0.04em',
            }}
          >
            Agua
            <span
              style={{
                ...narrow,
                fontSize: 28,
                fontStyle: 'normal',
                color: C.gold,
                fontWeight: 700,
                letterSpacing: '0.1em',
                marginLeft: 4,
              }}
            >
              X0
            </span>
          </div>
          <div className="mt-2 text-[10px] uppercase tracking-[0.55em]" style={{ ...narrow, color: C.bronze }}>
            In-Vehicle Companion
          </div>
        </div>

        <div className="relative flex items-center justify-center" style={{ width: 160, height: 160 }}>
          <svg width="160" height="160" viewBox="0 0 160 160" className="absolute inset-0">
            <circle cx="80" cy="80" r="70" fill="none" stroke={C.bronze} strokeWidth="1" opacity="0.25" />
            {status === 'checking' && (
              <circle
                cx="80"
                cy="80"
                r="70"
                fill="none"
                stroke={C.gold}
                strokeWidth="2"
                strokeDasharray="80 251"
                strokeLinecap="round"
                style={{ transformOrigin: '80px 80px', rotate: '-90deg' }}
                className="spin-ring"
              />
            )}
            {status === 'connected' && (
              <circle
                cx="80"
                cy="80"
                r="70"
                fill="none"
                stroke={C.gold}
                strokeWidth="2"
                strokeDasharray="251 251"
                strokeLinecap="round"
                style={{ transformOrigin: '80px 80px', rotate: '-90deg' }}
              />
            )}
            {status === 'offline' && (
              <circle
                cx="80"
                cy="80"
                r="70"
                fill="none"
                stroke={C.danger}
                strokeWidth="2"
                strokeDasharray="251 251"
                strokeLinecap="round"
                style={{ transformOrigin: '80px 80px', rotate: '-90deg' }}
              />
            )}
            {[0, 60, 120, 180, 240, 300].map((deg, i) => {
              const r = 70;
              const a = ((deg - 90) * Math.PI) / 180;
              return (
                <circle
                  key={i}
                  cx={80 + r * Math.cos(a)}
                  cy={80 + r * Math.sin(a)}
                  r="2.5"
                  fill={C.gold}
                  opacity="0.6"
                />
              );
            })}
          </svg>
          <div
            style={{
              background: '#000',
              borderRadius: 8,
              overflow: 'hidden',
              display: 'flex',
              alignItems: 'center',
              justifyContent: 'center',
            }}
          >
            <img
              src={HONDA_IMG}
              alt="Honda Fit"
              style={{
                width: 130,
                height: 90,
                objectFit: 'contain',
                objectPosition: 'center',
                opacity: status === 'offline' ? 0.3 : 0.95,
                transition: 'opacity 0.5s',
                filter: 'brightness(1.05) contrast(1.02)',
              }}
            />
          </div>
        </div>

        {status === 'checking' && (
          <div className="flex flex-col items-center gap-4 w-full" style={{ maxWidth: 280 }}>
            <div className="text-[11px] uppercase tracking-[0.5em]" style={{ ...narrow, color: C.gold }}>
              Connecting{dots}
            </div>
            <div className="w-full flex flex-col gap-2">
              {BOOT_STEPS.map((s, i) => (
                <div
                  key={i}
                  className="flex items-center gap-3 fade-in-up"
                  style={{ animationDelay: `${i * 0.15}s`, opacity: step > i ? 1 : 0.25, transition: 'opacity 0.4s' }}
                >
                  <div
                    className="w-4 h-4 rounded-full flex items-center justify-center flex-shrink-0"
                    style={{ background: step > i ? C.goldDim : 'transparent', border: `1px solid ${step > i ? C.gold : C.bronze}` }}
                  >
                    {step > i && <div className="w-1.5 h-1.5 rounded-full" style={{ background: C.gold }} />}
                  </div>
                  <div className="flex-1">
                    <div className="text-[10px] font-semibold" style={{ ...narrow, color: step > i ? C.cream : C.bronze, letterSpacing: '0.1em' }}>
                      {s.label}
                    </div>
                    {step > i && <div className="text-[9px] mt-0.5" style={{ ...narrow, color: C.bronze }}>{s.sub}</div>}
                  </div>
                  {step > i && <CheckCircle className="w-3 h-3 flex-shrink-0" style={{ color: C.gold }} />}
                </div>
              ))}
            </div>
          </div>
        )}

        {status === 'offline' && (
          <div className="flex flex-col items-center gap-4 text-center">
            <div className="flex items-center gap-2">
              <WifiOff className="w-4 h-4" style={{ color: C.danger }} />
              <span className="text-[11px] uppercase tracking-[0.4em]" style={{ ...narrow, color: C.danger }}>
                No Connection
              </span>
            </div>
            <p className="text-[11px] leading-relaxed" style={{ ...narrow, color: C.bronze, maxWidth: 240 }}>
              AguaX0 requires an active internet connection to load maps, traffic data, and media services.
            </p>
            <button
              onClick={onRetry}
              className="flex items-center gap-2 px-5 py-2.5 rounded-full transition-all"
              style={{ background: C.goldDim, border: `1px solid ${C.goldBorder}`, color: C.gold, ...narrow, fontSize: 11, letterSpacing: '0.35em', textTransform: 'uppercase', fontWeight: 600 }}
            >
              <RefreshCw className="w-3 h-3" />
              Retry
            </button>
          </div>
        )}

        <div className="flex items-center gap-2" style={{ width: 280 }}>
          <div className="h-px flex-1" style={{ background: `linear-gradient(to right, transparent, ${C.bronze})` }} />
          <div className="w-1 h-1 rotate-45" style={{ background: C.gold }} />
          <div className="h-px flex-1" style={{ background: `linear-gradient(to left, transparent, ${C.bronze})` }} />
        </div>
        <div className="text-[9px] uppercase tracking-[0.5em]" style={{ ...narrow, color: C.bronze }}>
          Honda Fit Sport · 2021
        </div>
      </div>
    </div>
  );
}

// ============================================================================
// MAIN APP
// ============================================================================
function MainApp() {
  const [mode, setMode] = useState('parked');
  const [tab, setTab] = useState('home');
  const [playing, setPlaying] = useState(true);
  const [recording, setRecording] = useState(false);
  const [recTime, setRecTime] = useState(0);
  const [now, setNow] = useState(new Date());
  const [speed, setSpeed] = useState(0);
  const [transitioning, setTrans] = useState(false);
  const [detecting, setDetecting] = useState(null);
  const [detectPct, setDetectPct] = useState(0);
  const [trafficOn, setTrafficOn] = useState(true);
  const [weather, setWeather] = useState('clear');

  const driveTimer = useRef(null);
  const parkTimer = useRef(null);
  const simRef = useRef(null);
  const progRef = useRef(null);

  const SPEED_LIMIT = 35;
  const isOver = speed > SPEED_LIMIT;
  const overBy = Math.round(speed - SPEED_LIMIT);

  useEffect(() => {
    const i = setInterval(() => setNow(new Date()), 1000);
    return () => clearInterval(i);
  }, []);

  useEffect(() => {
    if (!recording) {
      setRecTime(0);
      return;
    }
    const i = setInterval(() => setRecTime((t) => t + 1), 1000);
    return () => clearInterval(i);
  }, [recording]);

  const doTransition = useCallback((m) => {
    setTrans(true);
    setDetecting(null);
    setDetectPct(0);
    setTimeout(() => setMode(m), 700);
    setTimeout(() => setTrans(false), 1600);
  }, []);

  useEffect(() => {
    if (transitioning) return;
    if (mode === 'parked' && speed > 10) {
      if (!driveTimer.current) {
        setDetecting('drive');
        const s = Date.now();
        progRef.current = setInterval(() => setDetectPct(Math.min(1, (Date.now() - s) / 2000)), 50);
        driveTimer.current = setTimeout(() => {
          clearInterval(progRef.current);
          doTransition('driving');
          driveTimer.current = null;
        }, 2000);
      }
    } else if (speed <= 10 && driveTimer.current) {
      clearTimeout(driveTimer.current);
      clearInterval(progRef.current);
      driveTimer.current = null;
      setDetecting(null);
      setDetectPct(0);
    }
    if (mode === 'driving' && speed < 2) {
      if (!parkTimer.current) {
        setDetecting('park');
        const s = Date.now();
        progRef.current = setInterval(() => setDetectPct(Math.min(1, (Date.now() - s) / 3000)), 50);
        parkTimer.current = setTimeout(() => {
          clearInterval(progRef.current);
          doTransition('parked');
          parkTimer.current = null;
        }, 3000);
      }
    } else if (speed >= 2 && parkTimer.current) {
      clearTimeout(parkTimer.current);
      clearInterval(progRef.current);
      parkTimer.current = null;
      setDetecting(null);
      setDetectPct(0);
    }
  }, [speed, mode, transitioning, doTransition]);

  const clearSim = () => {
    if (simRef.current) {
      clearInterval(simRef.current);
      simRef.current = null;
    }
  };
  const tripStart = () => {
    clearSim();
    simRef.current = setInterval(() => setSpeed((s) => {
      if (s >= 32) {
        clearSim();
        return 32;
      }
      return s + 1;
    }), 90);
  };
  const tripEnd = () => {
    clearSim();
    simRef.current = setInterval(() => setSpeed((s) => {
      if (s <= 0) {
        clearSim();
        return 0;
      }
      return Math.max(0, s - 1);
    }), 90);
  };

  useEffect(() => {
    if (mode !== 'driving' || simRef.current) return;
    const i = setInterval(() => setSpeed((s) => (s < 5 ? s : Math.max(0, Math.min(88, s + (Math.random() - 0.5) * 2)))), 1500);
    return () => clearInterval(i);
  }, [mode]);

  const hh12 = (now.getHours() + 11) % 12 + 1;
  const mm = now.getMinutes().toString().padStart(2, '0');
  const ampm = now.getHours() >= 12 ? 'PM' : 'AM';
  const recM = Math.floor(recTime / 60).toString().padStart(2, '0');
  const recS = (recTime % 60).toString().padStart(2, '0');
  const needle = -135 + Math.min(1, speed / 100) * 270;

  return (
    <div
      className="w-full min-h-screen flex items-center justify-center p-4"
      style={{ background: 'radial-gradient(ellipse at center,#1a120a 0%,#0a0603 50%,#000 100%)', fontFamily: 'Archivo, sans-serif' }}
    >
      <style>{`
        @keyframes bloom { 0%,100%{opacity:.4;transform:scale(1);} 50%{opacity:1;transform:scale(1.6);} }
        @keyframes sweep { 0%{transform:translateX(-120%) skewX(-20deg);opacity:0;} 30%{opacity:1;} 100%{transform:translateX(220%) skewX(-20deg);opacity:0;} }
        @keyframes wm    { 0%{opacity:0;letter-spacing:.05em;transform:scale(.9);} 30%{opacity:1;letter-spacing:.45em;transform:scale(1);} 80%{opacity:1;} 100%{opacity:0;letter-spacing:.5em;transform:scale(1.02);} }
        @keyframes up    { from{opacity:0;transform:translateY(14px);filter:blur(5px);} to{opacity:1;transform:none;filter:none;} }
        @keyframes ppulse{ 0%,100%{r:5;opacity:1;} 50%{r:7;opacity:.7;} }
        @keyframes pring { 0%{r:5;opacity:.6;} 100%{r:20;opacity:0;} }
        @keyframes alert { 0%,100%{opacity:.75;} 50%{opacity:1;} }
        @keyframes float { 0%,100%{transform:translateY(0);} 50%{transform:translateY(-5px);} }
        @keyframes rainFall {
          0% { transform: translateY(-20px) translateX(0) rotate(15deg); opacity: 0; }
          10% { opacity: 1; }
          80% { opacity: 1; }
          100% { transform: translateY(140px) translateX(-35px) rotate(15deg); opacity: 0; }
        }
        @keyframes snowFall {
          0% { transform: translateY(-20px) translateX(0); opacity: 0; }
          20% { opacity: 1; }
          80% { opacity: 0.8; }
          100% { transform: translateY(140px) translateX(30px); opacity: 0; }
        }
        @keyframes beamSweep {
          0% { transform: translateX(-28%) rotate(25deg); opacity: 0; }
          18% { opacity: 0.35; }
          52% { opacity: 0.16; }
          100% { transform: translateX(34%) rotate(25deg); opacity: 0; }
        }
        @keyframes sceneGlow {
          0%, 100% { opacity: 0.24; transform: scaleX(0.95); }
          50% { opacity: 0.42; transform: scaleX(1.04); }
        }
        .rain-drop {
          position: absolute;
          width: 1.5px;
          height: 25px;
          background: linear-gradient(to bottom, transparent, rgba(200,220,255,0.8));
          animation: rainFall 0.6s linear infinite;
        }
        .snow-flake {
          position: absolute;
          background: rgba(255,255,255,0.8);
          border-radius: 50%;
          animation: snowFall 2.5s ease-in-out infinite;
          filter: blur(0.5px);
        }
        .flare-beam {
          position: absolute;
          top: -50%;
          height: 200%;
          background: linear-gradient(90deg, transparent, rgba(201,169,97,0.08), transparent);
          transform: rotate(25deg);
          animation: beamSweep 8s ease-in-out infinite;
        }
        .scene-glow { animation: sceneGlow 4.5s ease-in-out infinite; }
        .dot-bloom { animation:bloom 1.6s ease-in-out; }
        .sweep     { animation:sweep 1.6s cubic-bezier(.4,0,.2,1); }
        .wordmark  { animation:wm    1.6s cubic-bezier(.4,0,.2,1); }
        .enter     { animation:up    .6s  cubic-bezier(.2,.8,.2,1) .7s both; }
        .ppulse    { animation:ppulse 2s ease-in-out infinite; }
        .pring     { animation:pring  2s ease-out    infinite; }
        .alert     { animation:alert  2s ease-in-out infinite; }
        .float     { animation:float  4s ease-in-out infinite; }
        input[type=range]{-webkit-appearance:none;height:4px;border-radius:2px;background:rgba(201,169,97,.2);outline:none;}
        input[type=range]::-webkit-slider-thumb{-webkit-appearance:none;width:14px;height:14px;border-radius:50%;background:${C.gold};cursor:pointer;box-shadow:0 0 8px ${C.gold};}
      `}</style>

      <div className="w-full max-w-6xl">
        <div className="mb-4 rounded-2xl p-4" style={{ background: 'rgba(0,0,0,.45)', border: `1px solid ${C.bronze}30` }}>
          <div className="flex items-center gap-4 flex-wrap">
            <div>
              <div className="text-[9px] uppercase tracking-[.4em]" style={{ ...narrow, color: C.bronze }}>GPS Speed</div>
              <div className="flex items-baseline gap-1.5">
                <span style={{ ...serif, fontSize: 32, fontWeight: 400, lineHeight: 1, color: isOver ? C.danger : C.gold, transition: 'color .3s' }}>
                  {Math.round(speed)}
                </span>
                <span className="text-[10px]" style={{ ...narrow, color: C.bronze }}>mph</span>
              </div>
            </div>
            <div className="h-8 w-px" style={{ background: C.bronze, opacity: 0.4 }} />
            <div>
              <div className="text-[9px] uppercase tracking-[.4em]" style={{ ...narrow, color: C.bronze }}>Mode</div>
              <div className="flex items-center gap-1.5 mt-0.5">
                {mode === 'driving' ? <Car className="w-3.5 h-3.5" style={{ color: C.gold }} /> : <StopCircle className="w-3.5 h-3.5" style={{ color: C.gold }} />}
                <span style={{ ...serif, color: C.cream, fontSize: 15, fontStyle: 'italic' }}>{mode === 'driving' ? 'Underway' : 'Sanctuary'}</span>
              </div>
            </div>
            <div className="h-8 w-px" style={{ background: C.bronze, opacity: 0.4 }} />
            <div style={{ minWidth: 150 }}>
              <div className="text-[9px] uppercase tracking-[.4em]" style={{ ...narrow, color: C.bronze }}>Detection</div>
              {detecting ? (
                <div className="mt-1">
                  <div className="text-[10px]" style={{ ...narrow, color: C.gold }}>{detecting === 'drive' ? 'Confirming motion…' : 'Confirming rest…'}</div>
                  <div className="mt-1 h-[2px] w-32 rounded-full overflow-hidden" style={{ background: `${C.bronze}40` }}>
                    <div className="h-full rounded-full" style={{ width: `${detectPct * 100}%`, background: C.gold, transition: 'width .1s' }} />
                  </div>
                </div>
              ) : transitioning ? (
                <div className="text-[10px] mt-1" style={{ ...serif, color: C.goldLight, fontStyle: 'italic' }}>Transitioning…</div>
              ) : (
                <div className="text-[10px] mt-1" style={{ ...narrow, color: C.bronze }}>Idle · monitoring</div>
              )}
            </div>
            <div className="ml-auto flex gap-2 flex-wrap">
              <button onClick={tripStart} disabled={transitioning} className="px-3 py-1.5 rounded-lg text-[10px] uppercase tracking-[.25em] disabled:opacity-40" style={{ ...narrow, background: C.goldDim, color: C.gold, border: `1px solid ${C.goldBorder}`, fontWeight: 600 }}>▶ Trip</button>
              <button onClick={tripEnd} disabled={transitioning} className="px-3 py-1.5 rounded-lg text-[10px] uppercase tracking-[.25em] disabled:opacity-40" style={{ ...narrow, background: 'rgba(0,0,0,.3)', color: C.cream, border: `1px solid ${C.bronze}60`, fontWeight: 600 }}>■ Arrive</button>
              <button onClick={() => setTrafficOn((t) => !t)} className="px-3 py-1.5 rounded-lg text-[10px] uppercase tracking-[.25em]" style={{ ...narrow, background: trafficOn ? `${C.tRed}25` : 'rgba(0,0,0,.3)', color: trafficOn ? C.tRed : C.cream, border: `1px solid ${trafficOn ? C.tRed : C.bronze + '60'}`, fontWeight: 600 }}>⚠ Traffic</button>
            </div>
          </div>
          <div className="flex items-center gap-3 mt-3">
            <span className="text-[9px] uppercase tracking-[.4em] w-16" style={{ ...narrow, color: C.bronze }}>Manual</span>
            <input type="range" min="0" max="80" value={speed} onChange={(e) => { clearSim(); setSpeed(+e.target.value); }} className="flex-1" />
            <span className="text-[9px] w-12 text-right" style={{ ...narrow, color: C.bronze }}>0 – 80</span>
          </div>
        </div>

        <div className="relative rounded-[28px] overflow-hidden" style={{ aspectRatio: '3/2', background: 'radial-gradient(ellipse at 50% 50%,#1a120a 0%,#0a0603 70%,#050302 100%)', border: `1px solid ${C.bronze}30`, boxShadow: `0 50px 100px -20px rgba(0,0,0,.9),inset 0 0 120px rgba(201,169,97,.04)` }}>
          <div className="absolute inset-0 pointer-events-none z-[5]">
            {[{x:8,y:12,s:1},{x:92,y:18,s:1.5},{x:15,y:88,s:1},{x:88,y:92,s:1},{x:50,y:5,s:.8},{x:5,y:50,s:.8},{x:95,y:55,s:1.2},{x:22,y:95,s:.8},{x:78,y:8,s:.8},{x:35,y:22,s:.6},{x:65,y:78,s:.6}].map((d, i) => (
              <div key={i} className={transitioning ? 'dot-bloom' : ''} style={{ position: 'absolute', left: `${d.x}%`, top: `${d.y}%`, width: `${d.s * 2}px`, height: `${d.s * 2}px`, borderRadius: '50%', background: C.gold, boxShadow: `0 0 ${d.s * 6}px ${C.gold}`, opacity: .4, animationDelay: `${i * .04}s` }} />
            ))}
          </div>
          <div className="absolute bottom-0 left-0 right-0 h-1/3 pointer-events-none" style={{ background: `radial-gradient(ellipse at 50% 100%,${C.goldDim} 0%,transparent 70%)` }} />

          <div className="absolute top-0 left-0 right-0 flex items-center justify-between px-5 pt-3.5 z-20">
            <div className="flex items-center gap-2.5">
              <span style={{ ...serif, color: C.cream, fontSize: 17, fontWeight: 500, fontStyle: 'italic', letterSpacing: '.04em' }}>
                Agua<span style={{ ...narrow, fontSize: 11, fontStyle: 'normal', color: C.gold, fontWeight: 700, letterSpacing: '.1em', marginLeft: 2 }}>X0</span>
              </span>
              <div className="h-3 w-px" style={{ background: C.bronze }} />
              <span className="text-[9px] uppercase tracking-[.4em]" style={{ ...narrow, color: C.bronze }}>{mode === 'driving' ? 'Underway' : 'Sanctuary'}</span>
            </div>
            <div className="flex items-center gap-3">
              <div className="flex items-center gap-1.5">
                <MapPin className="w-2.5 h-2.5" style={{ color: C.gold }} />
                <span className="text-[10px] tracking-wider" style={{ ...narrow, color: C.cream }}>Santa Monica</span>
              </div>
              <div className="h-3 w-px" style={{ background: C.bronze }} />
              <span className="text-[10px] tracking-[.2em]" style={{ ...narrow, color: C.cream }}>{hh12}:{mm} {ampm}</span>
              <div className="flex gap-1 opacity-50">
                <Signal className="w-2.5 h-2.5" style={{ color: C.cream }} />
                <Wifi className="w-2.5 h-2.5" style={{ color: C.cream }} />
                <Battery className="w-3 h-3" style={{ color: C.cream }} />
              </div>
            </div>
          </div>
          <div className="absolute top-[48px] left-5 right-5 h-px z-10" style={{ background: `linear-gradient(to right,transparent,${C.bronze}80,transparent)` }} />

          <div
            key={mode}
            className={`absolute inset-0 z-10 ${transitioning ? '' : 'enter'}`}
            style={{ opacity: transitioning ? 0.1 : 1, filter: transitioning ? 'blur(8px)' : 'none', transition: 'opacity .4s,filter .4s' }}
          >
            {mode === 'driving'
              ? <DrivingView {...{ speed, needle, playing, setPlaying, recording, setRecording, recM, recS, SPEED_LIMIT, isOver, overBy, trafficOn }} />
              : <ParkedView {...{ tab, setTab, now, playing, setPlaying, weather, setWeather }} />}
          </div>

          {transitioning && (
            <div className="absolute inset-0 z-30 flex items-center justify-center pointer-events-none overflow-hidden">
              <div className="sweep absolute top-0 bottom-0 w-1/3" style={{ background: `linear-gradient(90deg,transparent,rgba(201,169,97,.12),rgba(232,207,149,.18),rgba(201,169,97,.12),transparent)`, filter: 'blur(8px)' }} />
              <div className="wordmark text-center">
                <div style={{ ...serif, color: C.cream, fontSize: 'clamp(38px,5.5vw,68px)', fontWeight: 400, fontStyle: 'italic', lineHeight: 1 }}>
                  Agua<span style={{ ...narrow, fontSize: '0.48em', fontStyle: 'normal', color: C.gold, fontWeight: 700, letterSpacing: '.1em', marginLeft: 3 }}>X0</span>
                </div>
                <div className="mt-2 text-[9px] uppercase tracking-[.65em]" style={{ ...narrow, color: C.gold }}>
                  {mode === 'parked' ? 'Entering Motion' : 'Entering Sanctuary'}
                </div>
              </div>
            </div>
          )}
        </div>
      </div>
    </div>
  );
}

// ============================================================================
// DRIVING VIEW
// ============================================================================
function DrivingView({ speed, needle, playing, setPlaying, recording, setRecording, recM, recS, SPEED_LIMIT, isOver, overBy, trafficOn }) {
  return (
    <div className="absolute inset-0 pt-[54px] pb-4 px-5 flex flex-col gap-3">
      <div className="rounded-xl px-5 py-3 flex items-center gap-5 flex-shrink-0" style={{ background: `linear-gradient(90deg,rgba(201,169,97,.1),rgba(0,0,0,.25))`, border: `1px solid ${C.goldBorder}` }}>
        <svg width="26" height="26" viewBox="0 0 40 40" fill="none" className="flex-shrink-0">
          <path d="M8 28L8 18Q8 12 14 12L26 12M26 12L20 6M26 12L20 18" stroke={C.gold} strokeWidth="2" strokeLinecap="round" strokeLinejoin="round" />
        </svg>
        <div className="flex-1 min-w-0">
          <div className="text-[8px] uppercase tracking-[.45em]" style={{ ...narrow, color: C.bronze }}>Next · Right Turn</div>
          <div style={{ ...serif, color: C.cream, fontSize: 21, fontWeight: 500, lineHeight: 1.05 }}>Ocean Avenue</div>
        </div>
        <div className="text-right flex-shrink-0">
          <div style={{ ...serif, color: C.gold, fontSize: 28, fontWeight: 300, lineHeight: 1 }}>0.4</div>
          <div className="text-[8px] uppercase tracking-[.35em]" style={{ ...narrow, color: C.bronze }}>miles ahead</div>
        </div>
      </div>

      <div className="flex-1 grid grid-cols-12 gap-3 min-h-0">
        <div className="col-span-4 flex flex-col items-center justify-center gap-3">
          <div className="w-full" style={{ maxWidth: 220, aspectRatio: '1' }}>
            <svg viewBox="0 0 300 300" className="w-full h-full">
              <defs>
                <radialGradient id="dg"><stop offset="0%" stopColor={isOver ? C.danger : C.gold} stopOpacity=".15" /><stop offset="70%" stopColor={isOver ? C.danger : C.gold} stopOpacity="0" /></radialGradient>
                <linearGradient id="ag" x1="0" y1="0" x2="1" y2="1"><stop offset="0%" stopColor={isOver ? C.danger : C.goldLight} /><stop offset="100%" stopColor={isOver ? '#8B2F1F' : C.bronze} /></linearGradient>
              </defs>
              <circle cx="150" cy="150" r="140" fill="url(#dg)" />
              <circle cx="150" cy="150" r="135" fill="none" stroke={C.bronze} strokeWidth=".6" opacity=".6" />
              <circle cx="150" cy="150" r="128" fill="none" stroke={C.bronze} strokeWidth=".3" opacity=".4" />
              {(() => { const la = (-135 + (SPEED_LIMIT / 100) * 270) * Math.PI / 180; return <line x1={150 + Math.cos(la) * 128} y1={150 + Math.sin(la) * 128} x2={150 + Math.cos(la) * 100} y2={150 + Math.sin(la) * 100} stroke={C.cream} strokeWidth="2" opacity=".6" />; })()}
              {[...Array(11)].map((_, i) => {
                const a = (-135 + i * 27) * Math.PI / 180;
                const x1 = 150 + Math.cos(a) * 118, y1 = 150 + Math.sin(a) * 118;
                const x2 = 150 + Math.cos(a) * 105, y2 = 150 + Math.sin(a) * 105;
                const lx = 150 + Math.cos(a) * 90, ly = 150 + Math.sin(a) * 90;
                const maj = i % 2 === 0;
                return (<g key={i}><line x1={x1} y1={y1} x2={x2} y2={y2} stroke={maj ? C.cream : C.bronze} strokeWidth={maj ? 1.5 : .8} opacity={maj ? .9 : .5} />{maj && <text x={lx} y={ly + 4} textAnchor="middle" fill={C.cream} fontSize="11" style={narrow} opacity=".7">{i * 10}</text>}</g>);
              })}
              <path d={(() => { const r = 122, s = -135 * Math.PI / 180, e = needle * Math.PI / 180; const sx = 150 + Math.cos(s) * r, sy = 150 + Math.sin(s) * r, ex = 150 + Math.cos(e) * r, ey = 150 + Math.sin(e) * r, lg = (needle - (-135)) > 180 ? 1 : 0; return `M${sx} ${sy} A${r} ${r} 0 ${lg} 1 ${ex} ${ey}`; })()} fill="none" stroke="url(#ag)" strokeWidth="3" strokeLinecap="round" />
              <g transform={`rotate(${needle} 150 150)`} style={{ transition: 'transform .6s cubic-bezier(.34,1.56,.64,1)' }}>
                <line x1="150" y1="150" x2="262" y2="150" stroke={isOver ? C.danger : C.goldLight} strokeWidth="2" strokeLinecap="round" />
                <line x1="150" y1="150" x2="135" y2="150" stroke={isOver ? C.danger : C.goldLight} strokeWidth="2" strokeLinecap="round" opacity=".5" />
              </g>
              <circle cx="150" cy="150" r="10" fill={C.ink} stroke={isOver ? C.danger : C.gold} strokeWidth="1" />
              <circle cx="150" cy="150" r="3" fill={isOver ? C.danger : C.gold} />
              <text x="150" y="205" textAnchor="middle" fill={isOver ? C.danger : C.cream} fontSize="52" style={serif} fontWeight="500">{Math.round(speed)}</text>
              <text x="150" y="224" textAnchor="middle" fill={C.bronze} fontSize="10" style={narrow} letterSpacing="4">MPH</text>
            </svg>
          </div>

          <div className="flex items-center gap-3">
            <div style={{ width: 46, height: 57, background: '#fafafa', borderRadius: 4, border: `3px solid ${isOver ? C.danger : '#0a0a0a'}`, boxShadow: isOver ? `0 0 14px ${C.danger}` : '0 2px 6px rgba(0,0,0,.5)', transition: 'all .3s', position: 'relative', flexShrink: 0 }}>
              <div className="absolute inset-0 flex flex-col items-center justify-center">
                <div style={{ fontFamily: '"Archivo Narrow",sans-serif', fontSize: 6, fontWeight: 900, color: '#0a0a0a', letterSpacing: '.5px', lineHeight: 1 }}>SPEED</div>
                <div style={{ fontFamily: '"Archivo Narrow",sans-serif', fontSize: 6, fontWeight: 900, color: '#0a0a0a', letterSpacing: '.5px', lineHeight: 1, marginTop: 1 }}>LIMIT</div>
                <div style={{ fontFamily: '"Archivo Narrow",sans-serif', fontSize: 22, fontWeight: 800, color: '#0a0a0a', lineHeight: 1, marginTop: 2 }}>{SPEED_LIMIT}</div>
              </div>
            </div>
            {isOver && (
              <div className="alert flex flex-col gap-0.5">
                <div className="flex items-center gap-1">
                  <AlertTriangle className="w-3 h-3" style={{ color: C.danger }} />
                  <span className="text-[8px] uppercase tracking-[.25em]" style={{ ...narrow, color: C.danger, fontWeight: 700 }}>Over by</span>
                </div>
                <span style={{ ...serif, color: C.danger, fontSize: 20, fontWeight: 500, lineHeight: 1 }}>+{overBy}</span>
              </div>
            )}
          </div>
        </div>

        <div className="col-span-5 relative rounded-2xl overflow-hidden" style={{ background: 'linear-gradient(180deg,rgba(10,6,3,.9) 0%,rgba(5,3,2,.95) 100%)', border: `1px solid ${C.bronze}40` }}>
          <svg viewBox="0 0 400 320" preserveAspectRatio="xMidYMid slice" className="w-full h-full absolute inset-0">
            <defs>
              <radialGradient id="mg" cx="50%" cy="60%" r="60%"><stop offset="0%" stopColor={C.gold} stopOpacity=".06" /><stop offset="100%" stopColor={C.gold} stopOpacity="0" /></radialGradient>
              <pattern id="gr" x="0" y="0" width="24" height="24" patternUnits="userSpaceOnUse"><path d="M24 0L0 0 0 24" fill="none" stroke={C.bronze} strokeWidth=".3" opacity=".12" /></pattern>
            </defs>
            <rect width="400" height="320" fill="url(#gr)" />
            <rect width="400" height="320" fill="url(#mg)" />
            <path d="M0 0Q30 90 20 160Q10 230 30 320L0 320Z" fill={C.bronze} opacity=".08" />
            {[[280,50,30,28],[315,55,25,32],[285,90,35,22],[325,95,30,28]].map(([x, y, w, h], i) => <rect key={i} x={x} y={y} width={w} height={h} fill={C.bronze} opacity=".12" rx="2" />)}
            <path d="M180 320Q170 260 160 200" stroke={C.tGreen} strokeWidth="5" fill="none" strokeLinecap="round" opacity=".85" />
            <path d="M160 200Q155 180 165 160" stroke={C.tYellow} strokeWidth="5" fill="none" strokeLinecap="round" opacity=".9" />
            <path d="M165 160Q185 125 220 100" stroke={trafficOn ? C.tRed : C.tYellow} strokeWidth="5" fill="none" strokeLinecap="round" opacity=".9" />
            <path d="M220 100Q260 80 300 70" stroke={C.tGreen} strokeWidth="5" fill="none" strokeLinecap="round" opacity=".5" strokeDasharray="4 4" />
            <path d="M180 320Q170 260 160 200Q155 180 165 160Q185 125 220 100" stroke={C.gold} strokeWidth="1" fill="none" opacity=".4" />
            <circle cx="220" cy="100" r="9" fill={C.ink} stroke={C.gold} strokeWidth="1.5" />
            <path d="M216 102L220 97L224 102M220 97L220 104" stroke={C.gold} strokeWidth="1.5" fill="none" strokeLinecap="round" strokeLinejoin="round" />
            <circle cx="160" cy="200" r="12" fill={C.gold} opacity=".15" className="pring" />
            <circle cx="160" cy="200" r="5" fill={C.gold} className="ppulse" style={{ filter: `drop-shadow(0 0 6px ${C.gold})` }} />
            <path d="M160 190L156 198L160 196L164 198Z" fill={C.cream} />
          </svg>
          {trafficOn && (
            <div className="absolute bottom-2.5 left-2.5 right-2.5 rounded-lg px-3 py-1.5 flex items-center gap-2 backdrop-blur-sm alert" style={{ background: `linear-gradient(90deg,rgba(216,90,60,.18),rgba(10,6,3,.65))`, border: `1px solid ${C.tRed}55` }}>
              <AlertTriangle className="w-3 h-3 flex-shrink-0" style={{ color: C.tRed }} />
              <span className="text-[8px] uppercase tracking-[.35em] font-bold" style={{ ...narrow, color: C.tRed }}>Congestion</span>
              <span className="text-[9px]" style={{ ...narrow, color: C.cream }}>Ocean Ave · <span style={{ color: C.tRed, fontWeight: 600 }}>+4 min</span></span>
            </div>
          )}
        </div>

        <div className="col-span-3 flex flex-col gap-2.5 min-h-0">
          <div className="rounded-xl p-3 flex-1" style={{ background: 'linear-gradient(180deg,rgba(201,169,97,.06) 0%,rgba(0,0,0,.3) 100%)', border: `1px solid ${C.bronze}40` }}>
            <div className="text-[8px] uppercase tracking-[.45em] mb-1.5" style={{ ...narrow, color: C.gold }}>Now Playing</div>
            <div style={{ ...serif, color: C.cream, fontSize: 14, lineHeight: 1.2, fontWeight: 500 }}>The Huberman Lab</div>
            <div className="text-[9px] mt-0.5 truncate" style={{ ...narrow, color: C.bronze }}>Ep. 184 · Focus & Flow</div>
            <div className="flex items-center justify-center gap-3 mt-2.5">
              <button style={{ color: C.cream, opacity: .6 }}><SkipBack className="w-3.5 h-3.5" /></button>
              <button onClick={() => setPlaying((p) => !p)} className="w-9 h-9 rounded-full flex items-center justify-center" style={{ background: C.gold, color: C.ink, boxShadow: `0 0 18px ${C.gold}50` }}>
                {playing ? <Pause className="w-3.5 h-3.5" /> : <Play className="w-3.5 h-3.5 ml-0.5" />}
              </button>
              <button style={{ color: C.cream, opacity: .6 }}><SkipForward className="w-3.5 h-3.5" /></button>
            </div>
          </div>
          <div className="rounded-xl px-3 py-2 flex justify-between items-center" style={{ background: 'rgba(0,0,0,.3)', border: `1px solid ${C.bronze}30` }}>
            <div>
              <div className="text-[8px] uppercase tracking-[.4em]" style={{ ...narrow, color: C.bronze }}>ETA</div>
              <div style={{ ...serif, color: C.cream, fontSize: 17, fontWeight: 500, lineHeight: 1 }}>6:42<span className="text-[9px] ml-0.5" style={{ color: C.bronze }}>PM</span></div>
            </div>
            <div className="h-5 w-px" style={{ background: C.bronze, opacity: .5 }} />
            <div className="text-right">
              <div className="text-[8px] uppercase tracking-[.4em]" style={{ ...narrow, color: C.bronze }}>Remaining</div>
              <div style={{ ...serif, color: C.cream, fontSize: 17, fontWeight: 500, lineHeight: 1 }}>18<span className="text-[9px] ml-0.5" style={{ color: C.bronze }}>min</span></div>
            </div>
          </div>
          <button onClick={() => setRecording((r) => !r)} className="rounded-xl py-2.5 flex items-center justify-center gap-2 transition-all" style={{ background: recording ? 'linear-gradient(180deg,#8B2F1F 0%,#4A1810 100%)' : 'transparent', border: `1px solid ${recording ? '#B54A34' : C.bronze + '60'}`, color: recording ? C.cream : C.gold }}>
            {recording ? <Square className="w-3 h-3 fill-current" /> : <Mic className="w-3 h-3" />}
            <span className="text-[9px] uppercase tracking-[.35em]" style={narrow}>{recording ? `Rec · ${recM}:${recS}` : 'Voice Memo'}</span>
          </button>
        </div>
      </div>
    </div>
  );
}

// ============================================================================
// PARKED VIEW
// ============================================================================
function ParkedView({ tab, setTab, now, playing, setPlaying, weather, setWeather }) {
  const dayName = now.toLocaleDateString('en-US', { weekday: 'long' });
  const dateLong = now.toLocaleDateString('en-US', { month: 'long', day: 'numeric', year: 'numeric' });
  const greeting = now.getHours() < 12 ? 'Good Morning' : now.getHours() < 18 ? 'Good Afternoon' : 'Good Evening';
  const TABS = [{id:'home',icon:Activity,lbl:'Home'},{id:'maps',icon:Navigation,lbl:'Journey'},{id:'media',icon:Music,lbl:'Audio'},{id:'journal',icon:Edit3,lbl:'Journal'},{id:'learn',icon:BookOpen,lbl:'Study'}];
  const activeScene = PARKED_SCENES[tab] ?? PARKED_SCENES.home;

  return (
    <div className="absolute inset-0 overflow-hidden">
      <div className="absolute top-[56px] bottom-4 right-0 w-[58%] pointer-events-none">
        <div className="absolute inset-0 overflow-hidden">
          <img
            src={activeScene.image}
            alt={activeScene.title}
            className="absolute inset-0 h-full w-full"
            style={{ objectFit: 'cover', objectPosition: activeScene.imagePosition, filter: 'brightness(0.78) saturate(0.94) contrast(1.02)' }}
          />
          <div
            className="absolute inset-0"
            style={{ background: 'linear-gradient(90deg, rgba(5,3,2,0.98) 0%, rgba(5,3,2,0.88) 14%, rgba(5,3,2,0.42) 34%, rgba(5,3,2,0.16) 58%, rgba(5,3,2,0.10) 100%)' }}
          />
          <div
            className="absolute inset-0"
            style={{ background: 'radial-gradient(circle at 75% 18%, rgba(255,255,255,0.10), transparent 18%), radial-gradient(circle at 62% 72%, rgba(201,169,97,0.12), transparent 24%), linear-gradient(180deg, rgba(255,255,255,0.03), transparent 22%, rgba(0,0,0,0.10) 100%)' }}
          />
        </div>
      </div>

      <div className="absolute inset-0 pt-[52px] pb-4 px-5 flex flex-col z-10">
        <div className="flex items-start justify-between gap-6 mb-2">
          <div className="pt-1">
            <div className="text-[9px] uppercase tracking-[.5em] mb-0.5" style={{ ...narrow, color: C.gold }}>{greeting}</div>
            <div style={{ ...serif, color: C.cream, fontSize: 'clamp(18px,2.6vw,30px)', fontWeight: 300, lineHeight: 1, fontStyle: 'italic' }}>{dayName},</div>
            <div style={{ ...serif, color: C.cream, fontSize: 'clamp(12px,1.6vw,18px)', fontWeight: 300, opacity: .65, lineHeight: 1.15 }}>{dateLong}</div>
          </div>
          <ParkedUtilityRail weather={weather} setWeather={setWeather} />
        </div>

        <div className="flex items-center gap-1.5 mb-3">
          <div className="h-px flex-1" style={{ background: `linear-gradient(to right,transparent,${C.bronze})` }} />
          <div className="w-1.5 h-1.5 rotate-45" style={{ background: C.gold }} />
          <div className="h-px w-5" style={{ background: C.bronze }} />
          <div className="w-1 h-1 rotate-45" style={{ background: C.gold, opacity: .5 }} />
          <div className="h-px flex-1" style={{ background: `linear-gradient(to left,transparent,${C.bronze})` }} />
        </div>

        <div className="flex-1 min-h-0">
          {tab === 'home' && <ParkedHome playing={playing} setPlaying={setPlaying} weather={weather} />}
          {tab !== 'home' && <ParkedScenePanel tab={tab} />}
        </div>

        <div className="mt-3 flex justify-center">
          <div className="flex items-center gap-1.5 rounded-full px-2 py-1.5" style={{ background: 'rgba(7,5,4,0.44)', border: `1px solid ${C.bronze}35`, backdropFilter: 'blur(10px)' }}>
            {TABS.map(({ id, icon: Icon, lbl }) => (
              <button key={id} onClick={() => setTab(id)} className="flex items-center gap-1.5 rounded-full px-3 py-1.5 transition-all" style={{ background: tab === id ? C.goldDim : 'transparent', color: tab === id ? C.gold : C.bronze, border: `1px solid ${tab === id ? C.gold + '50' : 'transparent'}` }}>
                <Icon className="w-3.5 h-3.5" />
                <span className="text-[8px] uppercase tracking-[.28em]" style={narrow}>{lbl}</span>
              </button>
            ))}
          </div>
        </div>
      </div>
    </div>
  );
}

function ParkedScenePanel({ tab }) {
  const scene = PARKED_SCENES[tab] ?? PARKED_SCENES.home;

  return (
    <div className="flex-1 flex items-end">
      <div className="max-w-[420px] px-2 py-2">
        <div className="inline-flex items-center rounded-full px-3 py-1" style={{ background: 'rgba(7,5,4,0.38)', backdropFilter: 'blur(8px)' }}>
          <div className="text-[9px] uppercase tracking-[0.45em]" style={{ ...narrow, color: C.gold }}>
            {scene.kicker}
          </div>
        </div>
        <div style={{ ...serif, color: C.cream, fontSize: 34, fontWeight: 300, fontStyle: 'italic', lineHeight: 1.02, marginTop: 14 }}>
          {scene.title}
        </div>
        <div className="mt-3 text-[11px] leading-relaxed" style={{ ...narrow, color: 'rgba(240,230,210,0.78)', maxWidth: 340 }}>
          {scene.detail}
        </div>
      </div>
    </div>
  );
}

function ParkedUtilityRail({ weather, setWeather }) {
  const weatherCards = {
    clear: { temp: '68°', desc: 'Clear', loc: 'Santa Monica', icon: Sun, color: C.gold },
    rain: { temp: '55°', desc: 'Heavy Rain', loc: 'Seattle', icon: CloudRain, color: '#8A9BB4' },
    snow: { temp: '28°', desc: 'Snow Showers', loc: 'Aspen', icon: Snowflake, color: '#D8E2F0' },
  };
  const currentWeather = weatherCards[weather];
  const WeatherIcon = currentWeather.icon;

  const cycleWeather = () => {
    setWeather((value) => (value === 'clear' ? 'rain' : value === 'rain' ? 'snow' : 'clear'));
  };

  return (
    <div className="grid grid-cols-3 gap-2.5 w-[540px] max-w-[60%]">
      <button onClick={cycleWeather} className="rounded-xl p-3 flex flex-col justify-between text-left transition-colors duration-500 hover:bg-white/5 active:scale-95" style={{ background: 'rgba(7,5,4,0.36)', border: `1px solid ${C.bronze}30`, backdropFilter: 'blur(10px)' }}>
        <div className="flex items-center justify-between gap-2">
          <span className="text-[8px] uppercase tracking-[.4em]" style={{ ...narrow, color: C.bronze }}>Outside</span>
          <WeatherIcon className="w-3.5 h-3.5" style={{ color: currentWeather.color }} />
        </div>
        <div className="mt-3">
          <div style={{ ...serif, color: C.cream, fontSize: 27, fontWeight: 300, lineHeight: 1 }}>{currentWeather.temp}</div>
          <div className="text-[8px] mt-1 truncate" style={{ ...narrow, color: C.cream, opacity: .72 }}>{currentWeather.desc} · {currentWeather.loc}</div>
        </div>
      </button>

      <div className="rounded-xl p-3 flex flex-col justify-between overflow-hidden" style={{ background: 'rgba(7,5,4,0.36)', border: `1px solid ${C.bronze}30`, backdropFilter: 'blur(10px)' }}>
        <div className="flex items-center gap-1.5 flex-shrink-0">
          <Mic className="w-3 h-3" style={{ color: C.gold }} />
          <span className="text-[8px] uppercase tracking-[.38em]" style={{ ...narrow, color: C.bronze }}>Latest Memo</span>
        </div>
        <div style={{ ...serif, color: C.cream, fontSize: 12.5, lineHeight: 1.25, fontStyle: 'italic', margin: '8px 0 6px' }} className="line-clamp-2">
          "Idea for Q3 launch — onboarding friction first…"
        </div>
        <div className="text-[8px] flex-shrink-0" style={{ ...narrow, color: C.bronze }}>2:14 PM · Coast Hwy</div>
      </div>

      <div className="rounded-xl p-3 flex flex-col justify-between" style={{ background: 'rgba(7,5,4,0.36)', border: `1px solid ${C.bronze}30`, backdropFilter: 'blur(10px)' }}>
        <div className="flex items-center gap-1.5">
          <Flame className="w-3 h-3" style={{ color: C.gold }} />
          <span className="text-[8px] uppercase tracking-[.4em]" style={{ ...narrow, color: C.bronze }}>Streak</span>
        </div>
        <div className="flex items-baseline gap-1 mt-2">
          <span style={{ ...serif, color: C.gold, fontSize: 28, fontWeight: 300, lineHeight: 1 }}>14</span>
          <span className="text-[9px]" style={{ ...narrow, color: C.cream, opacity: .7 }}>days</span>
        </div>
        <div className="flex gap-0.5 items-end h-4 mt-2">
          {[40, 70, 55, 85, 60, 90, 45].map((h, i) => <div key={i} className="flex-1 rounded-sm" style={{ height: `${h}%`, background: i >= 5 ? C.gold : `${C.bronze}50` }} />)}
        </div>
      </div>
    </div>
  );
}

// ============================================================================
// WEATHER OVERLAYS
// ============================================================================
function WeatherOverlay({ weather }) {
  if (weather === 'clear') {
    return (
      <div className="absolute inset-0 pointer-events-none flex justify-center">
        <div className="flare-beam w-16 left-1/4" />
        <div className="flare-beam w-24 right-1/4 opacity-60" style={{ animationDelay: '2.1s' }} />
      </div>
    );
  }
  if (weather === 'rain') {
    return (
      <div className="absolute inset-0 pointer-events-none overflow-hidden">
        {[...Array(25)].map((_, i) => (
          <div
            key={i}
            className="rain-drop"
            style={{
              left: `${Math.random() * 120}%`,
              animationDelay: `${Math.random() * 0.6}s`,
              animationDuration: `${0.4 + Math.random() * 0.3}s`,
            }}
          />
        ))}
      </div>
    );
  }
  if (weather === 'snow') {
    return (
      <div className="absolute inset-0 pointer-events-none overflow-hidden">
        {[...Array(35)].map((_, i) => (
          <div
            key={i}
            className="snow-flake"
            style={{
              left: `${-10 + Math.random() * 120}%`,
              animationDelay: `${Math.random() * 2.5}s`,
              animationDuration: `${2 + Math.random() * 2}s`,
              width: `${2 + Math.random() * 3}px`,
              height: `${2 + Math.random() * 3}px`,
              opacity: 0.3 + Math.random() * 0.7,
            }}
          />
        ))}
      </div>
    );
  }
  return null;
}

function ParkedHome({ playing, setPlaying, weather }) {
  const wConfig = {
    clear: { glow: 'rgba(201,169,97,0.14)', rim: 'rgba(255,255,255,0.08)' },
    rain: { glow: 'rgba(138,155,180,0.18)', rim: 'rgba(180,198,216,0.08)' },
    snow: { glow: 'rgba(216,226,240,0.18)', rim: 'rgba(255,255,255,0.12)' },
  };
  const c = wConfig[weather];
  const modelViewerRef = useRef(null);
  const [viewerStatus, setViewerStatus] = useState('loading');
  const [cameraOrbit, setCameraOrbit] = useState('18deg 78deg 126%');
  const [fieldOfView, setFieldOfView] = useState('19deg');
  const cameraPresets = [
    { orbit: '18deg 78deg 126%', fov: '19deg' },
    { orbit: '94deg 81deg 132%', fov: '17deg' },
    { orbit: '156deg 76deg 128%', fov: '18deg' },
    { orbit: '-10deg 69deg 112%', fov: '15deg' },
  ];

  useEffect(() => {
    const modelViewer = modelViewerRef.current;
    if (!modelViewer) return undefined;

    const handleLoad = () => setViewerStatus('ready');
    const handleError = () => setViewerStatus('error');

    setViewerStatus('loading');
    modelViewer.addEventListener('load', handleLoad);
    modelViewer.addEventListener('error', handleError);

    return () => {
      modelViewer.removeEventListener('load', handleLoad);
      modelViewer.removeEventListener('error', handleError);
    };
  }, []);

  useEffect(() => {
    if (viewerStatus !== 'ready') return undefined;

    let presetIndex = 0;
    const intervalId = setInterval(() => {
      presetIndex = (presetIndex + 1) % cameraPresets.length;
      setCameraOrbit(cameraPresets[presetIndex].orbit);
      setFieldOfView(cameraPresets[presetIndex].fov);
    }, 4200);

    return () => clearInterval(intervalId);
  }, [viewerStatus]);

  return (
    <div className="flex-1 flex flex-col gap-3 min-h-0">
      <div
        className="rounded-2xl overflow-hidden flex flex-col justify-center transition-colors duration-1000"
        style={{ background: `linear-gradient(135deg,rgba(201,169,97,.08) 0%,rgba(0,0,0,.5) 60%)`, border: `1px solid ${C.goldBorder}`, flex: '1.2', minHeight: 0 }}
      >
        <div className="grid grid-cols-12 gap-0 items-center">
          <div className="col-span-7 flex flex-col justify-center px-4 py-2">
            <div className="flex items-baseline gap-2 mb-1 flex-shrink-0">
              <span style={{ ...serif, color: C.cream, fontSize: 20, fontWeight: 400, fontStyle: 'italic' }}>Honda Fit</span>
              <span className="text-[9px] uppercase tracking-[.3em]" style={{ ...narrow, color: C.bronze }}>Sport · 2021</span>
            </div>

            <div
              className="relative flex items-center justify-center overflow-hidden transition-colors duration-1000"
              style={{ height: 'clamp(190px, 27vh, 260px)', background: '#090605', borderRadius: 10, margin: '4px 0' }}
            >
              <WeatherOverlay weather={weather} />
              <svg viewBox="0 0 300 60" className="absolute bottom-0 left-0 right-0 w-full" style={{ height: 36, opacity: .18, pointerEvents: 'none' }}>
                {[0, .25, .5, .75, 1].map((t, i) => {
                  const y = 60 - t * 55;
                  const xOff = t * 90;
                  return <line key={i} x1={xOff} y1={y} x2={300 - xOff} y2={y} stroke={C.gold} strokeWidth=".7" className="transition-colors duration-1000" />;
                })}
                {[.1, .25, .4, .5, .6, .75, .9].map((t, i) => {
                  const xC = 300 * t;
                  return <line key={i} x1={xC} y1={0} x2={150 + (xC - 150) * 1.8} y2={60} stroke={C.gold} strokeWidth=".5" className="transition-colors duration-1000" />;
                })}
              </svg>
              <div className="scene-glow absolute bottom-0 left-6 right-6 h-8 rounded-full blur-xl transition-all duration-1000" style={{ background: `radial-gradient(ellipse at center, ${c.glow}, transparent 72%)` }} />
              <div className="absolute bottom-0 left-0 right-0 h-6 transition-all duration-1000" style={{ background: `linear-gradient(to top, ${c.glow}, transparent)` }} />

              <model-viewer
                ref={modelViewerRef}
                src={HONDA_MODEL}
                alt="Honda Fit Sport 2021 3D model"
                camera-controls
                disable-pan
                interaction-prompt="none"
                shadow-intensity="1"
                exposure="1.05"
                interpolation-decay="120"
                camera-orbit={cameraOrbit}
                camera-target="auto auto auto"
                field-of-view={fieldOfView}
                min-camera-orbit="auto auto 85%"
                max-camera-orbit="auto auto 165%"
                style={{
                  width: '100%',
                  height: '100%',
                  position: 'relative',
                  zIndex: 1,
                  backgroundColor: 'transparent',
                  ['--poster-color']: 'transparent',
                }}
              />

              {viewerStatus !== 'ready' && (
                <div className="absolute inset-0 flex items-center justify-center px-4 text-center pointer-events-none" style={{ zIndex: 2 }}>
                  <span className="text-[8px] uppercase tracking-[.28em]" style={{ ...narrow, color: C.cream, opacity: 0.72 }}>
                    {viewerStatus === 'error' ? '3D model unavailable' : 'Loading 3D model'}
                  </span>
                </div>
              )}
            </div>

            <div className="flex items-center gap-3 mt-1 flex-shrink-0 pb-0.5">
              <div className="flex items-center gap-1">
                <CheckCircle className="w-2.5 h-2.5" style={{ color: '#6BAF7A' }} />
                <span className="text-[8px] uppercase tracking-[.25em]" style={{ ...narrow, color: C.cream }}>Locked</span>
              </div>
              <div className="h-2 w-px" style={{ background: C.bronze, opacity: .5 }} />
              <div className="flex items-center gap-1">
                <Thermometer className="w-2.5 h-2.5" style={{ color: C.gold }} />
                <span className="text-[8px] uppercase tracking-[.25em]" style={{ ...narrow, color: C.cream }}>Cabin 72°</span>
              </div>
              <div className="h-2 w-px" style={{ background: C.bronze, opacity: .5 }} />
              <div className="flex items-center gap-1">
                <Lock className="w-2.5 h-2.5" style={{ color: C.gold }} />
                <span className="text-[8px] uppercase tracking-[.25em]" style={{ ...narrow, color: C.cream }}>Armed</span>
              </div>
            </div>
          </div>

          <div className="col-span-5 flex flex-col justify-center gap-3 py-2 px-5" style={{ borderLeft: `1px solid ${C.bronze}35` }}>
            <div>
              <div className="text-[8px] uppercase tracking-[.4em]" style={{ ...narrow, color: C.bronze }}>Estimated Range</div>
              <div className="flex items-baseline gap-1.5 mt-0.5">
                <span style={{ ...serif, color: C.cream, fontSize: 32, fontWeight: 300, lineHeight: 1 }}>287</span>
                <span className="text-[10px]" style={{ ...narrow, color: C.bronze }}>miles</span>
              </div>
            </div>
            <div>
              <div className="text-[8px] uppercase tracking-[.4em] mb-1" style={{ ...narrow, color: C.bronze }}>Fuel Level</div>
              <div className="flex items-center gap-2">
                <Fuel className="w-3 h-3 flex-shrink-0" style={{ color: C.gold }} />
                <div className="flex-1 h-1.5 rounded-full" style={{ background: `${C.bronze}30` }}>
                  <div className="h-full rounded-full" style={{ width: '62%', background: `linear-gradient(90deg,${C.gold},${C.goldLight})` }} />
                </div>
                <span className="text-[10px] font-semibold" style={{ ...narrow, color: C.cream }}>62%</span>
              </div>
            </div>
            <div>
              <div className="text-[8px] uppercase tracking-[.4em]" style={{ ...narrow, color: C.bronze }}>Odometer</div>
              <div style={{ ...serif, color: C.cream, fontSize: 17, fontWeight: 400, lineHeight: 1.1 }}>42,156 <span className="text-[9px]" style={{ ...narrow, color: C.bronze }}>mi</span></div>
            </div>
            <div>
              <div className="text-[8px] uppercase tracking-[.4em]" style={{ ...narrow, color: C.bronze }}>Last Trip</div>
              <div style={{ ...serif, color: C.cream, fontSize: 14, fontStyle: 'italic', lineHeight: 1.2 }}>24.6 mi · 48 min</div>
            </div>
          </div>
        </div>
      </div>

      <div className="rounded-xl px-4 py-2.5 flex items-center gap-4 flex-shrink-0" style={{ background: 'rgba(0,0,0,.3)', border: `1px solid ${C.bronze}30` }}>
        <div className="w-10 h-10 rounded-lg flex items-center justify-center flex-shrink-0" style={{ background: `linear-gradient(135deg,${C.gold},${C.bronze})` }}>
          <Radio className="w-4 h-4" style={{ color: C.ink }} />
        </div>
        <div className="flex-1 min-w-0">
          <div className="text-[8px] uppercase tracking-[.4em]" style={{ ...narrow, color: C.gold }}>Continue Listening</div>
          <div style={{ ...serif, color: C.cream, fontSize: 15, fontWeight: 500, lineHeight: 1.1 }}>The Huberman Lab · Ep 184</div>
          <div className="flex items-center gap-2 mt-1.5">
            <div className="flex-1 h-[2px] rounded-full" style={{ background: `${C.bronze}40` }}>
              <div className="h-full rounded-full" style={{ width: '38%', background: C.gold }} />
            </div>
            <span className="text-[8px]" style={{ ...narrow, color: C.bronze }}>38 min left</span>
          </div>
        </div>
        <button onClick={() => setPlaying((p) => !p)} className="w-9 h-9 rounded-full flex items-center justify-center flex-shrink-0" style={{ background: C.gold, color: C.ink, boxShadow: `0 0 18px ${C.gold}40` }}>
          {playing ? <Pause className="w-3.5 h-3.5" /> : <Play className="w-3.5 h-3.5 ml-0.5" />}
        </button>
      </div>

    </div>
  );
}
