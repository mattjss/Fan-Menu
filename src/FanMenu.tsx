import { AnimatePresence, motion } from "framer-motion";
import { useState } from "react";

/**
 * Figma P26-Projects node 2672:4035 (opened fan).
 * Menu items: spring enter (bubbly scale + pop + stagger). Exit: quick fade.
 * Icons: `public/icons/*.svg`
 */
const ARTBOARD = 600;

const TRIGGER_CENTER_Y = 450.3;

const iconBase = `${import.meta.env.BASE_URL}icons`;

/** Bottom → top along the fan (Settings nearest trigger, Dashboard furthest). */
const FIGMA_FAN = [
  {
    label: "Settings" as const,
    iconSrc: `${iconBase}/settings.svg`,
    dx: 0,
    dy: -50.3,
    rotate: 0,
  },
  {
    label: "Calendar" as const,
    iconSrc: `${iconBase}/calendar.svg`,
    dx: -1.79,
    dy: -104.09,
    rotate: -5,
  },
  {
    label: "Documents" as const,
    iconSrc: `${iconBase}/documents.svg`,
    dx: -7.07,
    dy: -154.82,
    rotate: -10,
  },
  {
    label: "Experiments" as const,
    iconSrc: `${iconBase}/experiments.svg`,
    dx: -30.09,
    dy: -208.09,
    rotate: -20,
  },
  {
    label: "Dashboard" as const,
    iconSrc: `${iconBase}/dashboards.svg`,
    dx: -62.8,
    dy: -254.19,
    rotate: -30,
  },
];

const PLUS_SRC = `${iconBase}/Plus.svg`;

/** Plus / × rotation — keep a soft spring here only. */
const SPRING = {
  type: "spring" as const,
  stiffness: 300,
  damping: 9,
  mass: 0.58,
};

const BUTTON_PRESS_SPRING = {
  type: "spring" as const,
  stiffness: 175,
  damping: 8,
  mass: 0.85,
};

/** Seconds between each pill’s spring starting (Settings → Dashboard). */
const MENU_STAGGER_S = 0.052;

/** Bubbly open: soft overshoot, playful settle (spring physics). */
const MENU_BUBBLE_SPRING = {
  type: "spring" as const,
  stiffness: 320,
  damping: 13,
  mass: 0.55,
};

export function FanMenu() {
  const [open, setOpen] = useState(false);

  return (
    <div
      className="relative bg-black"
      style={{ width: ARTBOARD, height: ARTBOARD }}
    >
      <AnimatePresence>
        {open &&
          FIGMA_FAN.map((item, i) => (
            <motion.div
              key={item.label}
              className="pointer-events-none absolute left-1/2 z-10"
              style={{ top: TRIGGER_CENTER_Y }}
              initial={{ opacity: 0, scale: 0.48, y: 28 }}
              animate={{ opacity: 1, scale: 1, y: 0 }}
              transition={{
                ...MENU_BUBBLE_SPRING,
                delay: i * MENU_STAGGER_S,
              }}
              exit={{
                opacity: 0,
                transition: { duration: 0.1, ease: "easeIn" },
              }}
            >
              <div
                style={{
                  transform: `translate(calc(-50% + ${item.dx}px), calc(-50% + ${item.dy}px)) rotate(${item.rotate}deg)`,
                }}
              >
                <button
                  type="button"
                  className="pointer-events-auto flex origin-center items-center gap-1.5 rounded-[32px] bg-white px-3 py-2 shadow-[0_4px_4px_rgba(146,146,146,0.35)]"
                >
                  <img
                    src={item.iconSrc}
                    alt=""
                    width={16}
                    height={16}
                    draggable={false}
                    className={
                      item.label === "Experiments"
                        ? "size-4 shrink-0 origin-center object-contain rotate-[20deg]"
                        : "size-4 shrink-0 object-contain"
                    }
                    aria-hidden
                  />
                  <span className="whitespace-nowrap text-xs font-medium tracking-[-0.096px] text-[#4f4f4f]">
                    {item.label}
                  </span>
                </button>
              </div>
            </motion.div>
          ))}
      </AnimatePresence>

      <div className="pointer-events-none absolute left-1/2 top-[450.3px] z-20 -translate-x-1/2 -translate-y-1/2">
        <motion.button
          type="button"
          aria-expanded={open}
          aria-label={open ? "Close menu" : "Open menu"}
          className="pointer-events-auto grid size-[42px] place-items-center rounded-[21px] border border-[#dfdfdf] bg-white p-0 shadow-[0_4px_4px_rgba(146,146,146,0.35)]"
          onClick={() => setOpen((v) => !v)}
          whileTap={{
            scale: 0.94,
            y: 2,
          }}
          transition={BUTTON_PRESS_SPRING}
        >
          <motion.span
            className="grid size-5 origin-center place-items-center"
            animate={{ rotate: open ? -45 : 0 }}
            transition={SPRING}
          >
            <img
              src={PLUS_SRC}
              alt=""
              width={20}
              height={20}
              draggable={false}
              className="pointer-events-none block h-5 w-5 shrink-0"
              aria-hidden
            />
          </motion.span>
        </motion.button>
      </div>
    </div>
  );
}

export default FanMenu;
