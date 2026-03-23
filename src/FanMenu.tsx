import { AnimatePresence, motion } from "framer-motion";
import {
  CalendarRange,
  FileCode2,
  FlaskConical,
  LayoutDashboard,
  Plus,
  SlidersHorizontal,
} from "lucide-react";
import { useState } from "react";

/**
 * Figma P26-Projects node 2672:4035 (opened fan).
 * Artboard 600×600 #000000; trigger center ≈ (300, 450.3).
 * (dx, dy) offsets from that center (down = +y).
 */
const ARTBOARD = 600;

const TRIGGER_CENTER_Y = 450.3; // px from top of artboard

/** Bottom → top along the fan (Settings nearest trigger, Dashboard furthest). */
const FIGMA_FAN = [
  { label: "Settings" as const, icon: SlidersHorizontal, dx: 0, dy: -50.3, rotate: 0 },
  { label: "Calendar" as const, icon: CalendarRange, dx: -1.79, dy: -104.09, rotate: -5 },
  { label: "Documents" as const, icon: FileCode2, dx: -7.07, dy: -154.82, rotate: -10 },
  { label: "Experiments" as const, icon: FlaskConical, dx: -30.09, dy: -208.09, rotate: -20 },
  { label: "Dashboard" as const, icon: LayoutDashboard, dx: -62.8, dy: -254.19, rotate: -30 },
];

const SPRING = { type: "spring" as const, stiffness: 300, damping: 20 };

const STAGGER_S = 0.06;

export function FanMenu() {
  const [open, setOpen] = useState(false);
  const n = FIGMA_FAN.length;

  return (
    <div
      className="relative bg-black"
      style={{ width: ARTBOARD, height: ARTBOARD }}
    >
      <AnimatePresence>
        {open &&
          FIGMA_FAN.map((item, i) => {
            const Icon = item.icon;
            return (
              <div
                key={item.label}
                className="pointer-events-none absolute left-1/2 z-10"
                style={{
                  top: TRIGGER_CENTER_Y,
                  transform: `translate(calc(-50% + ${item.dx}px), calc(-50% + ${item.dy}px)) rotate(${item.rotate}deg)`,
                }}
              >
                <motion.button
                  type="button"
                  className="pointer-events-auto flex origin-center items-center gap-1.5 rounded-[32px] bg-white px-3 py-2 shadow-[0_4px_4px_rgba(146,146,146,0.35)]"
                  initial={{ opacity: 0, scale: 0.6, y: 20 }}
                  animate={{ opacity: 1, scale: 1, y: 0 }}
                  exit={{
                    opacity: 0,
                    scale: 0.6,
                    y: 20,
                    transition: {
                      ...SPRING,
                      delay: (n - 1 - i) * STAGGER_S,
                    },
                  }}
                  transition={{ ...SPRING, delay: i * STAGGER_S }}
                >
                  <Icon
                    className="size-4 shrink-0 text-[#4f4f4f]"
                    strokeWidth={2}
                  />
                  <span className="whitespace-nowrap text-xs font-medium tracking-[-0.096px] text-[#4f4f4f]">
                    {item.label}
                  </span>
                </motion.button>
              </div>
            );
          })}
      </AnimatePresence>

      <motion.button
        type="button"
        aria-expanded={open}
        aria-label={open ? "Close menu" : "Open menu"}
        className="absolute left-1/2 z-20 flex size-[42px] -translate-x-1/2 -translate-y-1/2 items-center justify-center rounded-[21px] border border-[#dfdfdf] bg-white shadow-[0_4px_4px_rgba(146,146,146,0.35)]"
        style={{ top: TRIGGER_CENTER_Y, padding: 11 }}
        onClick={() => setOpen((v) => !v)}
        whileTap={{ scale: 0.96 }}
      >
        <motion.span
          className="flex size-5 items-center justify-center text-[#4f4f4f]"
          animate={{ rotate: open ? -45 : 0 }}
          transition={SPRING}
        >
          <Plus className="size-5" strokeWidth={2.25} />
        </motion.span>
      </motion.button>
    </div>
  );
}

export default FanMenu;
