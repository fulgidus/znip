"use client";
import { useEffect, useRef } from "react";

export default function MouseAura() {
    const bgRef = useRef<HTMLDivElement>(null);

    useEffect(() => {
        const handleMouseMove = (e: MouseEvent) => {
            if (bgRef.current) {
                const x = e.clientX;
                const y = e.clientY;
                bgRef.current.style.background = `radial-gradient(circle 200px at ${x}px ${y}px, rgba(255,255,0,0.15) 0%, rgba(255,255,0,0.08) 40%, rgba(255,255,0,0) 100%)`;
            }
        };
        window.addEventListener("mousemove", handleMouseMove);
        return () => window.removeEventListener("mousemove", handleMouseMove);
    }, []);

    return (
        <div
            ref={bgRef}
            style={{
                position: "fixed",
                inset: 0,
                width: "100vw",
                height: "100vh",
                zIndex: 0,
                pointerEvents: "none",
                mixBlendMode: "lighten",
                transition: "background 0.2s",
            }}
            aria-hidden
        />
    );
}
