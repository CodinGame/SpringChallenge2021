import * as utils from '../core/utils.js';
export function setAnimationProgress(fx, progress) {
    let idx = Math.floor(progress * fx.totalFrames);
    idx = Math.min(fx.totalFrames - 1, idx);
    fx.gotoAndStop(idx);
}
export function fit(entity, maxWidth, maxHeight) {
    entity.scale.set(utils.fitAspectRatio(entity.texture.width, entity.texture.height, maxWidth, maxHeight));
}
