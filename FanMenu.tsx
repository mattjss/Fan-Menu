import { AnimatePresence, motion } from "framer-motion";
import {
  BookMarked,
  CalendarRange,
  FolderKanban,
  LayoutDashboard,
  Plus,
  SlidersHorizontal,
} from "lucide-react";
import { useState } from "react";

const MENU_ITEMS = [
  { label: "Dashboard", icon: LayoutDashboard },
  { label: "Projects", icon: FolderKanban },
  { label: "Timeline", icon: CalendarRange },
  { label: "Library", icon: BookMarked },
  { label: "Settings", icon: SlidersHorizontal },
] as const;

/** Angle from vertical (up) toward top-left, in degrees — arc ~30°–80°. */
const ANGLE_MIN_DEG = 30;
const ANGLE_MAX_DEG = 80;

const FAN_RADIUS_BASE = 72;
const FAN_RADIUS_STEP = 32;

const SPRING = { type: "spring" as const, stiffness: 300, damping: 20 };

const STAGGER_S = 0.06;

function angleRad(index: number, count: number): number {
  const t = count > 1 ? index / (count - 1) : 0;
  const deg = ANGLE_MIN_DEG + t * (ANGLE_MAX_DEG - ANGLE_MIN_DEG);
  return (deg * Math.PI) / 180;
}

/** Fan offset from trigger center: toward top-left (negative x, negative y in translate). */
function fanOffset(index: number, count: number): { x: number; y: number } {
  const θ = angleRad(index, count);
  const r = FAN_RADIUS_BASE + index * FAN_RADIUS_STEP;
  return {
    x: -Math.sin(θ) * r,
    y: -Math.cos(θ) * r,
  };
}

/** Top items ~-20°, bottom ~-5°. */
function pillRotationDeg(index: number, count: number): number {
  const t = count > 1 ? index / (count - 1) : 0;
  return -5 + t * -15;
}

export function FanMenu() {
  const [open, setOpen] = useState(false);
  const n = MENU_ITEMS.length;

  return (
    <div className="relative flex min-h-[420px] w-full max-w-md items-end justify-center bg-gray-100 pb-6">
      <div className="relative size-14 shrink-0">
        <AnimatePresence>
          {open &&
            MENU_ITEMS.map((item, i) => {
              const { x, y } = fanOffset(i, n);
              const Icon = item.icon;
              const depthScale = 1 + i * 0.035;
              const rot = pillRotationDeg(i, n);

              return (
                <div
                  key={item.label}
                  className="pointer-events-none absolute left-1/2 top-1/2 z-10"
                  style={{
                    transform: `translate(calc(-50% + ${x}px), calc(-50% + ${y}px))`,
                  }}
                >
                  <motion.button
                    type="button"
                    className="pointer-events-auto flex h-11 items-center gap-2 rounded-full border border-gray-100 bg-white px-4 shadow-md"
                    initial={{ opacity: 0, scale: 0.6 * depthScale, y: 20, rotate: rot }}
                    animate={{ opacity: 1, scale: depthScale, y: 0, rotate: rot }}
                    exit={{
                      opacity: 0,
                      scale: 0.6 * depthScale,
                      y: 20,
                      rotate: rot,
                      transition: {
                        ...SPRING,
                        delay: (n - 1 - i) * STAGGER_S,
                      },
                    }}
                    transition={{ ...SPRING, delay: i * STAGGER_S }}
                  >
                    <Icon
                      className="size-[18px] shrink-0 text-gray-500"
                      strokeWidth={2 + i * 0.2}
                    />
                    <span
                      className={`whitespace-nowrap font-semibold text-gray-800 ${
                        i >= 3 ? "text-[15px]" : "text-sm"
                      }`}
                    >
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
          className="absolute inset-0 z-20 m-auto flex size-14 shrink-0 items-center justify-center rounded-full bg-white shadow-md"
          onClick={() => setOpen((v) => !v)}
          whileTap={{ scale: 0.96 }}
        >
          <motion.span
            className="flex size-7 items-center justify-center text-gray-800"
            animate={{ rotate: open ? 45 : 0 }}
            transition={SPRING}
          >
            <Plus className="size-7" strokeWidth={2.25} />
          </motion.span>
        </motion.button>
      </div>
    </div>
  );
}

export default FanMenu;
