import { fitAspectRatio, lerp, lerpAngle, lerpColor, lerpPosition, unlerp } from '../core/utils.js';
import { bell, ease, easeOut, easeIn, elastic } from '../core/transitions.js';
import { HEIGHT, WIDTH } from '../core/constants.js';
import { HEXAGON_RADIUS, HEXAGON_WIDTH, hexToScreen } from './hex.js';
import { TooltipManager } from './TooltipManager.js';
import { IDLE_FRAMES, SLEEP_FRAMES, SUN_DATA_LIST } from './assetConstants.js';
import { parseData, parseGlobalData } from './Deserializer.js';
const DIRT_PARTICLE_COUNT = 20;
const LIGHT_PARTICLE_COUNT = 15;
export var FrameType;
(function (FrameType) {
    FrameType[FrameType["GATHERING"] = 0] = "GATHERING";
    FrameType[FrameType["ACTIONS"] = 1] = "ACTIONS";
    FrameType[FrameType["SUN_MOVE"] = 2] = "SUN_MOVE";
    FrameType[FrameType["INIT"] = 3] = "INIT";
})(FrameType || (FrameType = {}));
const ALL = 2;
const ME = 1;
const NONE = 0;
const api = {
    options: {
        debugMode2: false,
        showSFX: true,
        messages: 2,
        shadows: new Map(),
        trees: new Map(),
        ratio: 0.65,
        updateTrees: () => { }
    },
    setDebug: () => {
        api.options.updateTrees();
        for (const [, shadow] of api.options.shadows) {
            updateDebugShadow(shadow);
        }
    },
    setMessage: () => { }
};
export { api };
export function updateDebugShadow(shadow) {
    shadow.sprite.texture = api.options.debugMode2
        ? PIXI.Texture.from('shadowDebug.png')
        : PIXI.Texture.from('Ombre.png');
}
export class ViewModule {
    constructor() {
        this.states = [];
        this.pool = {};
        this.sun = new Map();
        this.hexes = new Map();
        this.trees = new Map();
        this.dormants = new Map();
        this.shadows = new Map();
        this.debugData = new Map();
        this.debugHUD = new Map();
        window.debug = this;
        this.tooltipManager = new TooltipManager();
        api.options.updateTrees = () => {
            this.updateTrees(this.previousData, this.currentData, this.progress);
        };
    }
    static get moduleName() {
        return 'graphics';
    }
    // Effects
    getFromPool(type) {
        if (!this.pool[type]) {
            this.pool[type] = [];
        }
        for (const e of this.pool[type]) {
            if (!e.busy) {
                e.busy = true;
                return e;
            }
        }
        const e = this.createEffect(type);
        this.pool[type].push(e);
        e.busy = true;
        return e;
    }
    createEffect(type) {
        let display = null;
        if (type === 'sunPoint') {
            display = this.drawEntity('sunPoint.png');
            this.sfxLayer.addChild(display);
        }
        else if (type === 'seed') {
            display = this.drawEntity();
            this.sfxLayer.addChild(display);
        }
        else if (type === 'particle') {
            display = PIXI.Sprite.from('Particule.png');
            display.anchor.set(0.5);
            this.sfxLayer.addChild(display);
        }
        else if (type === 'light') {
            display = PIXI.Sprite.from('light.png');
            display.anchor.set(0.5);
            this.sfxLayer.addChild(display);
        }
        else if (type === 'outerMarkerA') {
            display = PIXI.Sprite.from('outer_ringA.png');
            display.anchor.set(0.5);
            this.markerLayer.addChild(display);
        }
        else if (type === 'outerMarkerB') {
            display = PIXI.Sprite.from('outer_ringB.png');
            display.anchor.set(0.5);
            this.markerLayer.addChild(display);
        }
        return { busy: false, display };
    }
    // Update
    updateScene(previousData, currentData, progress, playerSpeed) {
        this.previousData = previousData;
        this.currentData = currentData;
        this.progress = progress;
        this.playerSpeed = playerSpeed || 0;
        this.resetEffects();
        this.updateHud(previousData, currentData, progress);
        this.updateTotoros(previousData, currentData, progress);
        this.updateSpeechBubbles(currentData);
        // ACTIONS Frame
        this.updateTrees(previousData, currentData, progress);
        this.updateDormants(previousData, currentData, progress);
        this.updateSeeds(previousData, currentData, progress);
        this.updateSeedSplash(previousData, currentData, progress);
        this.updateDebugActions(previousData, currentData, progress);
        // SUNMOVE Frame
        this.updateShadows(previousData, currentData, progress);
        this.updateSun(previousData, currentData, progress);
        // GATHERING Frame
        const ratio = 3 / 4; // Generates a pause after the animation
        const sunProgress = unlerp(0, ratio, progress);
        this.updateSunPoints(currentData, sunProgress);
        this.updateTooltip(currentData);
        this.updateDebugHud(previousData, currentData);
    }
    getFrameTypeName(frameType) {
        switch (frameType) {
            case FrameType.ACTIONS:
                return 'Taking actions';
            case FrameType.GATHERING:
                return 'Gathering sun';
            case FrameType.INIT:
                return 'Gathering sun';
            case FrameType.SUN_MOVE:
                return 'Sun is moving';
        }
    }
    getSunReport(currentData, index) {
        const sunPointsMap = {
            1: [],
            2: [],
            3: []
        };
        Object.values(currentData.trees)
            .filter(t => t.owner === index && t.sunPoints > 0 && t.size > 0)
            .forEach(t => sunPointsMap[t.size].push(t.index));
        let report = '';
        for (let i = 1; i <= 3; ++i) {
            if (sunPointsMap[i].length > 0) {
                report += `\n${i}: ${sunPointsMap[i].join(', ')}`;
            }
        }
        return report.length > 0 ? report : '\nnone';
    }
    updateDebugHud(previousData, currentData) {
        for (const [index, text] of this.debugHUD) {
            if (index === -1) {
                const curRound = currentData.frameType === FrameType.SUN_MOVE ? previousData.round : currentData.round;
                text.text =
                    `Nutrients: ${currentData.nutrients}` +
                        `\nRound: ${curRound}/${this.globalData.totalRounds - 1}` +
                        `\n${this.getFrameTypeName(currentData.frameType)}`;
            }
            else {
                const player = currentData.players[index];
                text.text =
                    `Waiting: ${player.isWaiting}`;
                if (currentData.frameType === FrameType.GATHERING) {
                    const report = this.getSunReport(currentData, index);
                    text.text +=
                        '\nSun gathered' +
                            `${report}`;
                }
                else {
                    text.text +=
                        '\nDormant:\n' +
                            this.splitText(player.activated.join(', ')) +
                            'Message:\n' +
                            this.splitText(player.message);
                }
            }
        }
    }
    splitText(message) {
        if (message === null) {
            return '';
        }
        else {
            const lines = Math.floor(message.length / 20) + 1;
            let newMessage = '';
            for (let i = 0; i <= lines; i++) {
                newMessage += message.slice(20 * i, 20 * (i + 1)) + '\n';
            }
            return newMessage;
        }
    }
    updateHud(previousData, currentData, progress) {
        for (const player of this.globalData.players) {
            const data = progress < 3 / 4 ? previousData : currentData;
            this.HUD.sun[player.index].text = data.players[player.index].sun.toString();
            this.HUD.score[player.index].text = data.players[player.index].score.toString();
        }
    }
    updateTotoros(previousData, currentData, progress) {
        for (let idx = 0; idx < this.globalData.playerCount; ++idx) {
            const totoro = this.totoros[idx];
            const sleepBefore = previousData.players[idx].isWaiting;
            const sleepNow = currentData.players[idx].isWaiting;
            if (!sleepBefore && !sleepNow) {
                totoro.sleep.alpha = 0;
                totoro.idle.alpha = 1;
            }
            else if (sleepBefore && sleepNow) {
                totoro.sleep.alpha = 1;
                totoro.idle.alpha = 0;
            }
            else if (sleepNow) {
                // Going to sleep
                const p = unlerp(0.3, 0.7, progress);
                totoro.idle.alpha = 1 - p;
                totoro.sleep.alpha = p;
            }
            else {
                // Waking up
                const p = unlerp(0.4, 0.6, progress);
                totoro.idle.alpha = p;
                totoro.sleep.alpha = 1 - p;
            }
        }
    }
    updateSpeechBubbles(currentData) {
        for (let idx = 0; idx < this.globalData.playerCount; ++idx) {
            const { speech } = this.bubbles[idx];
            const SPEECH_WIDTH = 316;
            const SPEECH_HEIGHT = 198;
            const SPEECH_PAD_X = 60;
            const SPEECH_PAD_Y = 30;
            const message = currentData.players[idx].message;
            this.bubbles[idx].show = !!message;
            const textMaxWidth = SPEECH_WIDTH - SPEECH_PAD_X;
            const textMaxHeight = SPEECH_HEIGHT - SPEECH_PAD_Y;
            speech.scale.set(1);
            speech.maxWidth = textMaxWidth;
            if (message) {
                speech.text = message;
            }
            if (speech.height > textMaxHeight) {
                const scale = fitAspectRatio(speech.width, speech.height, textMaxWidth, textMaxHeight);
                speech.scale.set(scale);
                speech.maxWidth *= 1 / speech.scale.x;
            }
            else {
                const scale = fitAspectRatio(speech.width, speech.height, textMaxWidth, textMaxHeight);
                speech.scale.set(Math.min(1.6, scale));
            }
        }
    }
    updateTrees(previousData, currentData, progress) {
        var _a;
        for (const [index, tree] of this.trees) {
            const treeBefore = previousData.trees[index];
            const treeNow = currentData.trees[index];
            const ownerIdx = (_a = treeNow === null || treeNow === void 0 ? void 0 : treeNow.owner) !== null && _a !== void 0 ? _a : treeBefore === null || treeBefore === void 0 ? void 0 : treeBefore.owner;
            const colorName = ownerIdx === 0 ? 'Red' : 'Blue';
            const shadowBefore = previousData.shadows[index] && previousData.shadows[index].size;
            const shadowNow = currentData.shadows[index] && currentData.shadows[index].size;
            const color = lerpColor(0xFFFFFF, 0xAAAAAA, lerp(treeBefore && treeBefore.size <= shadowBefore ? 1 : 0, treeNow && treeNow.size <= shadowNow ? 1 : 0, progress));
            tree.transitionSprite.tint = color;
            tree.mainSprite.tint = color;
            tree.mainSprite.scale.set(1);
            tree.transitionSprite.scale.set(1);
            tree.transitionSprite.visible = false;
            if (treeBefore && !treeNow) {
                tree.mainSprite.texture = PIXI.Texture.from(`Arbre3_${colorName}.png`);
                tree.mainSprite.alpha = progress < 0.6 ? 1 : 0;
                tree.mainSprite.scale.set(lerp(1, 1.2, progress));
                tree.transitionSprite.texture = PIXI.Texture.from('Arbre3_White.png');
                tree.transitionSprite.visible = true;
                tree.transitionSprite.alpha = bell(progress);
                tree.transitionSprite.scale.set(lerp(1, 1.2, progress));
                this.updateTreeFlash(index, treeBefore.sfxData, lerp(0, 0.5, progress));
            }
            else if (!treeBefore && treeNow) {
                // Seed animation is playing
                tree.mainSprite.alpha = 0;
            }
            else if (treeBefore && treeNow) {
                tree.mainSprite.alpha = 1;
                tree.mainSprite.texture = PIXI.Texture.from(`Arbre${treeBefore.size}_${colorName}.png`);
                if (treeBefore.size !== treeNow.size) {
                    tree.transitionSprite.visible = true;
                    tree.transitionSprite.alpha = 1;
                    tree.transitionSprite.texture = PIXI.Texture.from(`Arbre${treeNow.size}_${colorName}.png`);
                    tree.mainSprite.scale.set(lerp(1, 0, easeOut(unlerp(0, 0.4, progress))));
                    tree.transitionSprite.scale.set(lerp(0, 1, elastic(progress)));
                }
                else {
                    const seedData = currentData.seeds.find(s => s.sourceIndex === index);
                    if (seedData != null) {
                        tree.mainSprite.scale.set(this.bounce(progress));
                    }
                }
            }
            else {
                tree.mainSprite.alpha = 0;
                if (previousData.previous.trees[index] && !previousData.trees[index]) {
                    this.updateTreeFlash(index, previousData.previous.trees[index].sfxData, lerp(0.5, 1, progress));
                }
            }
            for (const sprite of [tree.mainSprite, tree.transitionSprite]) {
                if (api.options.debugMode2) {
                    sprite.scale.x *= api.options.ratio;
                    sprite.scale.y *= api.options.ratio;
                    sprite.position.y = HEXAGON_RADIUS / 3;
                }
                else {
                    sprite.position.y = 0;
                }
            }
        }
    }
    updateTreeFlash(index, sfxData, progress) {
        const hex = this.hexes.get(index).data;
        const targetP = this.screenToBoard(hexToScreen(hex.q, hex.r));
        for (let i = 0; i < LIGHT_PARTICLE_COUNT; ++i) {
            const particle = this.getFromPool('light').display;
            const { angle, speed, size, position, duration } = sfxData[i];
            particle.visible = true;
            particle.angle = angle;
            particle.position.x = targetP.x + position.x + Math.cos(angle) * speed * easeOut(progress);
            particle.position.y = targetP.y + position.y + Math.sin(angle) * speed * easeOut(progress);
            particle.scale.set(size * lerp(0.5, 1, easeIn(progress)));
            particle.alpha = bell(unlerp(0.2, duration, progress));
        }
    }
    updateDormants(previousData, currentData, progress) {
        var _a, _b, _c, _d, _e;
        for (const [index, dormant] of this.dormants) {
            const dormantBefore = (_a = previousData.trees[index]) === null || _a === void 0 ? void 0 : _a.isDormant;
            const dormantNow = (_b = currentData.trees[index]) === null || _b === void 0 ? void 0 : _b.isDormant;
            const ownerIdx = (_d = (_c = currentData.trees[index]) === null || _c === void 0 ? void 0 : _c.owner) !== null && _d !== void 0 ? _d : (_e = previousData.trees[index]) === null || _e === void 0 ? void 0 : _e.owner;
            const colorName = ownerIdx === 0 ? 'Rouge' : 'Bleu';
            dormant.sprite.texture = PIXI.Texture.from(`Dormant_${colorName}.png`);
            if (dormantBefore && !dormantNow) {
                dormant.sprite.alpha = unlerp(1 / 6, 0, progress);
            }
            else if (!dormantBefore && dormantNow) {
                dormant.sprite.alpha = unlerp(1 / 2, 1, progress);
            }
            else if (dormantBefore && dormantNow) {
                dormant.sprite.alpha = 1;
            }
            else {
                dormant.sprite.alpha = 0;
            }
        }
    }
    updateDebugActions(previousData, currentData, progress) {
        for (let playerIdx = 0; playerIdx < this.globalData.playerCount; ++playerIdx) {
            const player = currentData.players[playerIdx];
            for (const cellIdx of player.affected) {
                const a = this.getFromPool('outerMarkerA');
                const b = this.getFromPool('outerMarkerB');
                if (playerIdx === 0) {
                    a.display.zIndex = 4;
                    b.display.zIndex = 1;
                }
                else {
                    a.display.zIndex = 2;
                    b.display.zIndex = 3;
                }
                for (const { display } of [a, b]) {
                    display.tint = this.globalData.players[playerIdx].color;
                    display.visible = true;
                    const cell = this.hexes.get(cellIdx);
                    const pos = this.screenToBoard(hexToScreen(cell.data.q, cell.data.r));
                    display.position.copyFrom(pos);
                }
            }
        }
    }
    updateSeedSplash(previousData, currentData, progress) {
        const animated = new Set();
        for (const seedData of previousData.seeds) {
            const targetCell = this.hexes.get(seedData.targetIndex);
            if (animated.has(targetCell)) {
                continue;
            }
            animated.add(targetCell);
            const targetP = this.screenToBoard(hexToScreen(targetCell.data.q, targetCell.data.r));
            for (let i = 0; i < DIRT_PARTICLE_COUNT; ++i) {
                const particle = this.getFromPool('particle').display;
                const { angle, speed, size } = seedData.sfxData[i];
                particle.visible = true;
                particle.angle = angle;
                particle.position.x = targetP.x + Math.cos(angle) * speed * easeOut(progress);
                particle.position.y = targetP.y + Math.sin(angle) * speed * easeOut(progress);
                particle.scale.set(size * lerp(1, 0, easeIn(progress)));
            }
        }
    }
    updateSeeds(previousData, currentData, progress) {
        for (const seedData of currentData.seeds) {
            const seed = this.getFromPool('seed').display;
            const colorName = seedData.owner === 0 ? 'Red' : 'Blue';
            seed.visible = true;
            seed.texture = PIXI.Texture.from(`Arbre0_${colorName}.png`);
            const sourceCell = this.hexes.get(seedData.sourceIndex);
            const targetCell = this.hexes.get(seedData.targetIndex);
            const sourceP = this.screenToBoard(hexToScreen(sourceCell.data.q, sourceCell.data.r));
            const targetP = this.screenToBoard(hexToScreen(targetCell.data.q, targetCell.data.r));
            const newPosition = lerpPosition(sourceP, targetP, ease(progress));
            seed.position.set(newPosition.x, newPosition.y);
            const belled = bell(progress);
            const scale = (belled + ease(progress));
            seed.scale.set(scale);
        }
    }
    updateShadows(previousData, currentData, progress) {
        for (const [index, shadow] of this.shadows) {
            const shadowBefore = previousData.shadows[index];
            const shadowNow = currentData.shadows[index];
            if (shadowBefore && !shadowNow) {
                shadow.sprite.alpha = 1 - progress;
            }
            else if (!shadowBefore && shadowNow) {
                shadow.sprite.alpha = progress;
            }
            else if (shadowBefore && shadowNow) {
                shadow.sprite.alpha = 1;
            }
            else {
                shadow.sprite.alpha = 0;
            }
            updateDebugShadow(shadow);
        }
    }
    updateSun(previousData, currentData, progress) {
        for (const sun of this.sun.values()) {
            const sunBefore = sun.data.activeOrientations.includes(previousData.sunOrientation);
            const sunNow = sun.data.activeOrientations.includes(currentData.sunOrientation);
            sun.container.rotation = lerpAngle(-previousData.sunOrientation * Math.PI / 3, -currentData.sunOrientation * Math.PI / 3, progress);
            if (sunBefore && !sunNow) {
                sun.sprite.alpha = 1 - progress;
            }
            else if (!sunBefore && sunNow) {
                sun.sprite.alpha = progress;
            }
            else if (sunBefore && sunNow) {
                sun.sprite.alpha = 1;
            }
            else {
                sun.sprite.alpha = 0;
            }
        }
    }
    updateSunPoints(currentData, progress) {
        for (const [index] of this.trees) {
            if (currentData.trees[index] && currentData.trees[index].sunPoints) {
                const sun = this.getFromPool('sunPoint');
                sun.display.visible = true;
                const initP = this.screenToBoard(hexToScreen(this.hexes.get(index).data.q, this.hexes.get(index).data.r));
                const targP = {
                    x: [280, WIDTH - 280][currentData.trees[index].owner],
                    y: 300
                };
                const initS = currentData.trees[index].sfxData[0].speed * 20;
                const initA = currentData.trees[index].sfxData[0].angle;
                const targS = currentData.trees[index].sfxData[1].speed * 20;
                const targA = currentData.trees[index].sfxData[1].angle;
                const x = ease(unlerp(0.5, 1, progress));
                const newPositionX = (initS * Math.cos(initA) + targS * Math.cos(targA) - 2 * targP.x + 2 * initP.x) * (Math.pow(x, 3)) +
                    (-2 * initS * Math.cos(initA) - targS * Math.cos(targA) + 3 * targP.x - 3 * initP.x) * (Math.pow(x, 2)) +
                    (initS * Math.cos(initA)) * x +
                    initP.x;
                const newPositionY = (initS * Math.sin(initA) + targS * Math.sin(targA) - 2 * targP.y + 2 * initP.y) * (Math.pow(x, 3)) +
                    (-2 * initS * Math.sin(initA) - targS * Math.sin(targA) + 3 * targP.y - 3 * initP.y) * (Math.pow(x, 2)) +
                    (initS * Math.sin(initA)) * x +
                    initP.y;
                sun.display.position.set(newPositionX, newPositionY);
                const belled = bell(ease(progress));
                const scale = (belled * 2 + ease(progress));
                sun.display.scale.x = scale * (currentData.trees[index].owner ? 1 : -1);
                sun.display.scale.y = scale;
            }
        }
    }
    updateTooltip(currentData) {
        var _a, _b;
        for (const [index, hex] of this.hexes) {
            const nutrients = hex.data.richness
                ? currentData.nutrients + this.globalData.nutrients[hex.data.richness - 1]
                : 0;
            const dormant = (_a = currentData.trees[index]) === null || _a === void 0 ? void 0 : _a.isDormant;
            const shadowSize = (_b = currentData.shadows[index]) === null || _b === void 0 ? void 0 : _b.size;
            const tree = currentData.trees[index];
            const spooky = tree != null && tree.size <= shadowSize;
            this.registerTooltip(hex.container, {
                richness: hex.data.richness,
                index: index,
                nutrients,
                dormant,
                shadowSize,
                spooky,
                tree
            });
            this.registerTooltip(this.debugData.get(index).container, {
                richness: hex.data.richness,
                index: index,
                nutrients,
                dormant,
                shadowSize,
                spooky,
                tree
            });
        }
    }
    // Update Functions
    resetEffects() {
        for (const type in this.pool) {
            for (const effect of this.pool[type]) {
                effect.display.visible = false;
                effect.busy = false;
            }
        }
    }
    setSize(sprite, size) {
        sprite.width = size;
        sprite.height = size;
    }
    bounce(t) {
        return 1 + (Math.sin(t * 10) * 0.5 * Math.cos(t * 3.14 / 2)) * (1 - t) * (1 - t);
    }
    // Init
    asLayer(func) {
        const layer = new PIXI.Container();
        func.bind(this)(layer);
        return layer;
    }
    reinitScene(container, canvasData) {
        this.oversampling = canvasData.oversampling;
        this.container = container;
        this.pool = {};
        const background = this.asLayer(this.initBackground);
        const totoLayer = this.asLayer(this.initTotoros);
        this.boardLayer = this.asLayer(this.initBoard);
        const shadowLayer = this.asLayer(this.initShadows);
        const treeLayer = this.asLayer(this.initTrees);
        const dormantLayer = this.asLayer(this.initDormants);
        const hudLayer = this.asLayer(this.initHud);
        const bubbleLayer = this.asLayer(this.initSpeechBubbles);
        const sunLayer = this.asLayer(this.initSuns);
        const devantLayer = this.asLayer(this.initDevant);
        this.markerLayer = new PIXI.Container();
        this.sfxLayer = new PIXI.Container();
        const tooltipLayer = this.tooltipManager.reinit();
        /* debug mode */
        const debugMask = this.asLayer(this.initDebugMask);
        const debugBoard = this.asLayer(this.initDebugBoard);
        const debugHUD = this.asLayer(this.initDebugHUD);
        /*            */
        this.markerLayer.sortableChildren = true;
        this.setVisibility(debugMask, 1);
        this.setVisibility(debugBoard, 1);
        this.setVisibility(debugHUD, 1);
        this.setVisibility(totoLayer, 0);
        this.setVisibility(this.boardLayer, 0);
        this.setVisibility(bubbleLayer, 0);
        Object.defineProperty(this.sfxLayer, 'visible', { get: () => api.options.showSFX });
        this.setVisibility(devantLayer, 0);
        background.interactiveChildren = false;
        bubbleLayer.interactiveChildren = false;
        hudLayer.interactiveChildren = false;
        tooltipLayer.interactiveChildren = false;
        totoLayer.interactiveChildren = false;
        shadowLayer.interactiveChildren = false;
        treeLayer.interactiveChildren = false;
        this.sfxLayer.interactiveChildren = false;
        sunLayer.interactiveChildren = false;
        dormantLayer.interactiveChildren = false;
        container.addChild(background);
        container.addChild(debugMask);
        container.addChild(totoLayer);
        container.addChild(this.boardLayer);
        container.addChild(debugBoard);
        container.addChild(shadowLayer);
        container.addChild(treeLayer);
        container.addChild(dormantLayer);
        container.addChild(this.markerLayer);
        container.addChild(bubbleLayer);
        container.addChild(hudLayer);
        container.addChild(sunLayer);
        container.addChild(this.sfxLayer);
        container.addChild(devantLayer);
        container.addChild(debugHUD);
        container.addChild(tooltipLayer);
    }
    setVisibility(layer, visibility) {
        if (visibility === 0) {
            Object.defineProperty(layer, 'visible', { get: () => !api.options.debugMode2 });
        }
        else if (visibility === 1) {
            Object.defineProperty(layer, 'visible', { get: () => api.options.debugMode2 });
        }
    }
    initTotoros(layer) {
        this.totoros = [];
        for (const player of this.globalData.players) {
            const totoro = new PIXI.Container();
            const idle = PIXI.AnimatedSprite.fromFrames(IDLE_FRAMES[player.index]);
            const sleep = PIXI.AnimatedSprite.fromFrames(SLEEP_FRAMES[player.index]);
            idle.animationSpeed = 1 / 3;
            sleep.animationSpeed = 1 / 4;
            for (const anim of [idle, sleep]) {
                anim.anchor.set(1, 1);
                anim.scale.set(1.6);
                anim.scale.x *= player.index === 0 ? -1 : 1;
                anim.gotoAndPlay(0);
                anim.loop = true;
                anim.y = -80;
                totoro.addChild(anim);
            }
            // const desiredFPS = 30
            // const actualFPS = 60
            totoro.x = player.index * WIDTH;
            totoro.y = HEIGHT;
            this.totoros.push({
                idle,
                sleep,
                container: totoro
            });
            layer.addChild(totoro);
        }
    }
    initBackground(layer) {
        const backdrop = PIXI.Sprite.from('background.jpg');
        layer.addChild(backdrop);
    }
    initBoard(layer) {
        for (const cell of this.globalData.cells) {
            const hex = this.initHex(cell);
            layer.addChild(hex);
        }
        layer.position.set(WIDTH / 2, HEIGHT / 2);
    }
    initHex(cell) {
        const drawnHex = this.drawTile(cell);
        const container = new PIXI.Container();
        container.addChild(drawnHex);
        const hexaP = hexToScreen(cell.q, cell.r);
        container.position.set(hexaP.x, hexaP.y);
        this.hexes.set(cell.index, {
            container: container,
            sprite: drawnHex,
            data: cell
        });
        return container;
    }
    initShadows(layer) {
        for (const cell of this.globalData.cells) {
            const shadow = this.initShadow(cell);
            layer.addChild(shadow);
        }
        api.options.shadows = this.shadows;
    }
    initShadow(cell) {
        const drawnShadow = this.drawEntity('Ombre.png');
        const container = new PIXI.Container();
        container.addChild(drawnShadow);
        const hexaP = this.screenToBoard(hexToScreen(cell.q, cell.r));
        container.position.set(hexaP.x, hexaP.y);
        this.shadows.set(cell.index, {
            sprite: drawnShadow
        });
        return container;
    }
    initTrees(layer) {
        for (const cell of this.globalData.cells) {
            const tree = this.initTree(cell);
            layer.addChild(tree);
        }
        api.options.trees = this.trees;
    }
    initTree(cell) {
        const mainSprite = this.drawEntity();
        const transitionSprite = this.drawEntity();
        const container = new PIXI.Container();
        container.addChild(mainSprite);
        container.addChild(transitionSprite);
        const hexaP = this.screenToBoard(hexToScreen(cell.q, cell.r));
        container.position.set(hexaP.x, hexaP.y);
        this.trees.set(cell.index, {
            mainSprite,
            transitionSprite
        });
        return container;
    }
    initDormants(layer) {
        for (const cell of this.globalData.cells) {
            const dormant = this.initDormant(cell);
            layer.addChild(dormant);
        }
    }
    initDormant(cell) {
        const dormant = this.drawEntity();
        const container = new PIXI.Container();
        container.addChild(dormant);
        const hexaP = this.screenToBoard(hexToScreen(cell.q, cell.r));
        container.position.set(hexaP.x, hexaP.y);
        this.dormants.set(cell.index, {
            sprite: dormant
        });
        return container;
    }
    initHud(layer) {
        this.HUD = {
            score: [],
            sun: [],
            message: []
        };
        const playerHUDs = new PIXI.Container();
        for (const player of this.globalData.players) {
            const frame = PIXI.Sprite.from('hud.png');
            frame.anchor.x = 1;
            frame.scale.x = player.index === 0 ? -1 : 1;
            frame.x = WIDTH * player.index;
            const avatar = new PIXI.Sprite(player.avatar);
            avatar.anchor.set(0.5);
            avatar.width = avatar.height = 128;
            avatar.position.set(player.index === 0 ? 69 : WIDTH - 69, 69);
            const mask = new PIXI.Graphics();
            mask.beginFill(0x000000, 1);
            mask.drawCircle(player.index === 0 ? 69 : WIDTH - 69, 69, 64);
            mask.endFill();
            avatar.mask = mask;
            const name = this.drawText(player.name, 0xFFFFFF, player.index === 0 ? 340 : WIDTH - 340, 38);
            const score = this.drawText('0', 0xFFFFFF, player.index === 0 ? 300 : WIDTH - 300, 145);
            this.HUD.score.push(score);
            const sun = this.drawText('0', 0xFFFFFF, player.index === 0 ? 180 : WIDTH - 180, 307);
            this.HUD.sun.push(sun);
            playerHUDs.addChild(frame);
            playerHUDs.addChild(avatar);
            playerHUDs.addChild(mask);
            playerHUDs.addChild(name);
            playerHUDs.addChild(score);
            playerHUDs.addChild(sun);
        }
        layer.addChild(playerHUDs);
    }
    initSpeechBubbles(layer) {
        this.bubbles = [];
        for (let idx = 0; idx < this.globalData.playerCount; ++idx) {
            const player = this.globalData.players[idx];
            const flip = idx === 0 ? 1 : -1;
            const container = new PIXI.Container();
            const bubble = PIXI.Sprite.from('bubble.png');
            bubble.alpha = 1;
            bubble.scale.x = flip;
            const actualBubbleHeight = 190;
            bubble.anchor.y = 0;
            const speech = this.drawText('', player.color, (idx === 0 ? bubble.width / 2 : -bubble.width / 2), actualBubbleHeight / 2);
            speech.fontSize = 40;
            speech.align = 'center';
            const SPEECH_OFFSET_X = 37;
            const SPEECH_Y = 488;
            container.position.set(WIDTH * idx + flip * SPEECH_OFFSET_X, SPEECH_Y);
            container.alpha = 0;
            container.addChild(bubble);
            container.addChild(speech);
            layer.addChild(container);
            this.bubbles.push({ container, bubble, speech, show: false });
        }
    }
    initSuns(layer) {
        for (const sunData of SUN_DATA_LIST) {
            const sun = this.initSun(sunData);
            layer.addChild(sun);
        }
        layer.scale = this.boardLayer.scale.clone();
    }
    initSun(sun) {
        const drawnSun = this.drawEntity('Fleche-Soleil.png');
        drawnSun.anchor.x = 1;
        drawnSun.x = HEXAGON_WIDTH / 2;
        const container = new PIXI.Container();
        container.addChild(drawnSun);
        const hexaP = this.screenToBoard(hexToScreen(sun.q, sun.r));
        container.position.set(hexaP.x, hexaP.y);
        this.sun.set(SUN_DATA_LIST.indexOf(sun) + 37, {
            container: container,
            sprite: drawnSun,
            data: sun
        });
        return container;
    }
    initDevant(layer) {
        const devantLayer = new PIXI.Container();
        for (const player of this.globalData.players) {
            const frame = PIXI.Sprite.from('Devant.png');
            frame.anchor.x = 0;
            frame.anchor.y = 1;
            frame.x = WIDTH * player.index;
            frame.y = HEIGHT;
            frame.scale.x = player.index ? -1 : 1;
            devantLayer.addChild(frame);
        }
        layer.addChild(devantLayer);
    }
    // Init debug
    initDebugMask(layer) {
        const mask = new PIXI.Graphics();
        // mask.lineStyle()
        mask.beginFill(0x000000);
        mask.drawRect(0, 0, WIDTH, HEIGHT);
        mask.endFill();
        mask.alpha = 0.7;
        layer.addChild(mask);
    }
    initDebugBoard(layer) {
        for (const cell of this.globalData.cells) {
            const hex = this.initDebugHex(cell);
            layer.addChild(hex);
        }
        layer.position.set(WIDTH / 2, HEIGHT / 2);
    }
    initDebugHex(cell) {
        const hex = new PIXI.Graphics();
        hex.beginFill([0x777777, 0xD0B039, 0xD3EC39, 0x43DD2D][cell.richness]);
        hex.drawPolygon([
            0, HEXAGON_RADIUS,
            HEXAGON_WIDTH / 2, HEXAGON_RADIUS / 2,
            HEXAGON_WIDTH / 2, -HEXAGON_RADIUS / 2,
            0, -HEXAGON_RADIUS,
            -HEXAGON_WIDTH / 2, -HEXAGON_RADIUS / 2,
            -HEXAGON_WIDTH / 2, HEXAGON_RADIUS / 2
        ]);
        hex.endFill();
        hex.scale.set(0.95);
        const container = new PIXI.Container();
        const textIndex = this.generateText(cell.index.toString(), 0x444444, 50);
        textIndex.position.set(0, -HEXAGON_RADIUS / 2);
        hex.addChild(textIndex);
        container.addChild(hex);
        const hexaP = hexToScreen(cell.q, cell.r);
        container.position.set(hexaP.x, hexaP.y);
        this.debugData.set(cell.index, { container });
        return container;
    }
    initDebugHUD(layer) {
        const container = new PIXI.Container();
        const hud = new PIXI.Graphics();
        hud.beginFill(0xFFFFFF);
        hud.lineStyle(10, 0x000000);
        hud.drawRect(-8, -8, 308, 158);
        hud.endFill();
        const text = new PIXI.Text('', {
            fontSize: 34,
            fontFamily: 'Lato',
            fill: 0x000000
        });
        text.x += 10;
        text.y += 10;
        container.position.set(28, 400);
        container.addChild(hud);
        container.addChild(text);
        layer.addChild(container);
        this.debugHUD.set(-1, text);
        for (const player of this.globalData.players) {
            const container = new PIXI.Container();
            const hud = new PIXI.Graphics();
            hud.beginFill(0xFFFFFF);
            hud.lineStyle(10, player.color);
            hud.drawRect(-8, -8, 308, 458);
            hud.endFill();
            const text = new PIXI.Text('', {
                fontSize: 34,
                fontFamily: 'Lato',
                fill: 0x000000,
                whiteSpace: 'pre-line'
            });
            text.x += 10;
            text.y += 10;
            container.position.set(player.index ? WIDTH - hud.width : 28, HEIGHT - hud.height);
            container.addChild(hud);
            container.addChild(text);
            layer.addChild(container);
            this.debugHUD.set(player.index, text);
        }
    }
    // Init functions
    generateText(text, color, size) {
        const drawnText = new PIXI.Text(text, {
            fontSize: Math.round(size) + 'px',
            fontFamily: 'Lato',
            fontWeight: 'bold',
            fill: color,
            lineHeight: Math.round(size)
        });
        drawnText.anchor.x = 0.5;
        drawnText.anchor.y = 0.5;
        return drawnText;
    }
    registerTooltip(container, data) {
        container.interactive = true;
        const text = `index: ${data.index}` +
            `\nrichness: ${data.richness}${data.richness > 0 ? ` (${data.nutrients} points)` : ''}` +
            (data.tree != null
                ? `\nsize: ${data.tree.size} (${data.tree.owner === 0 ? 'red' : 'blue'})`
                : '') +
            (data.dormant
                ? '\nisDormant'
                : '') +
            (data.shadowSize
                ? `\nshadowSize: ${data.shadowSize}${data.spooky ? ' (spooky)' : ''}`
                : '');
        container.mouseover = () => {
            this.tooltipManager.showTooltip(text);
            container.mousemove = (event) => {
                this.tooltipManager.moveTooltip(event);
            };
        };
        container.mouseout = () => {
            this.tooltipManager.hideTooltip();
            container.mousemove = null;
        };
    }
    screenToBoard(point) {
        return {
            x: point.x + this.boardLayer.x,
            y: point.y + this.boardLayer.y
        };
    }
    drawTile(cell) {
        const path = [
            'Sol_0.png',
            'Sol_1.png',
            'Sol_2.png',
            'Sol_3.png'
        ][cell.richness];
        const sprite = PIXI.Sprite.from(path);
        sprite.anchor.set(0.5);
        return sprite;
    }
    drawEntity(path) {
        const sprite = path ? PIXI.Sprite.from(path) : new PIXI.Sprite();
        sprite.anchor.set(0.5);
        return sprite;
    }
    drawText(content, color, x, y) {
        const text = new PIXI.BitmapText(content, {
            fontName: 'hynings_48',
            fontSize: 48
        });
        text.tint = color;
        text.position.set(x, y - 14);
        text.anchor = 0.5;
        return text;
    }
    animateScene(delta) {
        for (let idx = 0; idx < this.globalData.playerCount; ++idx) {
            const { show, container } = this.bubbles[idx];
            const stepFactor = Math.pow(0.993 + (0.007 * (this.playerSpeed || 1) / 10), delta);
            const toggled = api.options.messages === ALL ||
                (this.globalData.players[idx].isMe && api.options.messages === ME);
            const targetAlpha = show && toggled ? 1 : 0;
            if (targetAlpha === 1) {
                container.alpha = 1;
            }
            else {
                container.alpha = container.alpha * stepFactor + targetAlpha * (1 - stepFactor);
            }
        }
    }
    // Handle Data
    handleGlobalData(players, raw) {
        const globalData = parseGlobalData(raw);
        // const globalData = JSON.parse(raw)
        this.globalData = Object.assign(Object.assign({}, globalData), { players: players, playerCount: players.length });
    }
    createDirtParticleEffect(seedData) {
        seedData.sfxData = [];
        for (var p = 0; p < DIRT_PARTICLE_COUNT; ++p) {
            const angle = Math.random() * Math.PI * 2;
            const speed = Math.random() * 50 + 50;
            const size = lerp(1.3, 1.5, Math.random());
            seedData.sfxData.push({
                angle,
                speed,
                size
            });
        }
    }
    createLightParticleEffect(treeData) {
        treeData.sfxData = [];
        for (var p = 0; p < LIGHT_PARTICLE_COUNT; ++p) {
            const angle = Math.random() * Math.PI * 2;
            const speed = Math.random() * 50 + 20;
            const size = lerp(2, 3, Math.random());
            const zoneSize = 25;
            const position = {
                x: lerp(-zoneSize, zoneSize, Math.random()),
                y: lerp(-zoneSize, zoneSize, Math.random())
            };
            const duration = lerp(0.7, 1, Math.random());
            treeData.sfxData.push({
                angle,
                speed,
                size,
                position,
                duration
            });
        }
    }
    handleFrameData(frameInfo, raw) {
        const data = parseData(raw, this.globalData);
        // const data = JSON.parse(raw)
        const shadows = {};
        for (const shadow of data.shadows) {
            shadows[shadow.index] = shadow;
        }
        const trees = {};
        for (const treeData of data.trees) {
            this.createLightParticleEffect(treeData);
            trees[treeData.index] = treeData;
        }
        for (const seedData of data.seeds) {
            this.createDirtParticleEffect(seedData);
        }
        const previous = this.states[this.states.length - 1];
        const state = {
            shadows,
            trees,
            seeds: data.seeds,
            players: data.players,
            round: data.round,
            sunOrientation: data.sunOrientation,
            frameType: data.frameType,
            nutrients: data.nutrients
        };
        state.previous = previous || state;
        this.states.push(state);
        return state;
    }
}
