import { TILE_HEIGHT } from './assetConstants.js';
const TILE_SEPERATION = 2;
export const HEXAGON_HEIGHT = TILE_HEIGHT + TILE_SEPERATION;
export const HEXAGON_RADIUS = HEXAGON_HEIGHT / 2;
export const HEXAGON_WIDTH = HEXAGON_RADIUS * Math.sqrt(3);
export const HEXAGON_Y_SEP = HEXAGON_RADIUS * 3 / 2;
export function hexToScreen(q, r) {
    const x = HEXAGON_RADIUS * (Math.sqrt(3) * q + Math.sqrt(3) / 2 * r);
    const y = HEXAGON_RADIUS * 3 / 2 * r;
    return { x, y };
}
