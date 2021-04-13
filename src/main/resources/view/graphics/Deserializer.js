const MAIN_SEPARATOR = '\n';
export function parseData(raw, globalData) {
    const input = raw.split(MAIN_SEPARATOR)
        .map(hardSplit);
    const globalInfos = input.shift().map(x => +x);
    const data = {
        round: globalInfos[0],
        sunOrientation: globalInfos[1],
        nutrients: globalInfos[2],
        frameType: globalInfos[3],
        trees: [],
        seeds: [],
        shadows: [],
        players: []
    };
    let index = +input.shift()[0];
    for (let i = 1; i <= index; i++) {
        const tree = input.shift().map(x => +x);
        data.trees.push({
            index: tree[0],
            owner: tree[1],
            isDormant: tree[2] === 1,
            size: tree[3],
            sunPoints: tree[4]
        });
    }
    index = +input.shift()[0];
    for (let i = 1; i <= index; i++) {
        const seed = input.shift().map(x => +x);
        data.seeds.push({
            owner: seed[0],
            sourceIndex: seed[1],
            targetIndex: seed[2]
        });
    }
    index = +input.shift()[0];
    for (let i = 1; i <= index; i++) {
        const shadow = input.shift().map(x => +x);
        data.shadows.push({
            index: shadow[0],
            size: shadow[1]
        });
    }
    index = 2;
    for (let i = 1; i <= index; i++) {
        const player = input.shift().map(x => +x);
        const activated = input.shift().map(x => +x);
        const message = input.shift().join(' ');
        const affected = input.length ? input.shift().map(x => +x) : [];
        data.players.push({
            score: player[0],
            sun: player[1],
            activated,
            isWaiting: !!player[2],
            message: message !== '' ? message : null,
            affected
        });
    }
    return data;
}
export function parseGlobalData(raw) {
    const input = raw.split(MAIN_SEPARATOR).map(x => hardSplit(x).map(y => +y));
    const data = {
        totalRounds: input.shift()[0],
        nutrients: input.shift(),
        cells: []
    };
    while (input.length) {
        const cell = input.shift();
        data.cells.push({
            q: cell[0],
            r: cell[1],
            richness: cell[2],
            index: cell[3]
        });
    }
    return data;
}
function hardSplit(raw) {
    if (raw === '') {
        return [];
    }
    return raw.split(' ');
}
