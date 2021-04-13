import { HEIGHT } from '../core/constants.js';
/* global PIXI */
const PADDING = 5;
const CURSOR_WIDTH = 20;
function generateText(text, size, color, align) {
    var textEl = new PIXI.Text(text, {
        fontSize: Math.round(size / 1.2) + 'px',
        fontFamily: 'Lato',
        fontWeight: 'bold',
        fill: color,
        lineHeight: Math.round(size / 1.2)
    });
    if (align === 'right') {
        textEl.anchor.x = 1;
    }
    else if (align === 'center') {
        textEl.anchor.x = 0.5;
    }
    return textEl;
}
;
export class TooltipManager {
    reinit() {
        const container = new PIXI.Container();
        const tooltip = new PIXI.Container();
        const background = new PIXI.Graphics();
        const label = generateText('DEFAULT', 36, 0xFFFFFF, 'left');
        label.position.x = PADDING;
        label.position.y = PADDING;
        tooltip.visible = false;
        tooltip.addChild(background);
        tooltip.addChild(label);
        this.tooltipBackground = background;
        this.tooltipLabel = label;
        this.tooltipContainer = container;
        this.tooltip = tooltip;
        container.addChild(this.tooltip);
        return container;
    }
    showTooltip(text) {
        this.initTooltip(this.tooltip, text);
    }
    initTooltip(tooltip, text) {
        this.tooltipLabel.text = text;
        const width = this.tooltipLabel.width + PADDING * 2;
        const height = this.tooltipLabel.height + PADDING * 2;
        this.tooltipOffset = -width;
        this.tooltipBackground.clear();
        this.tooltipBackground.beginFill(0x0, 0.8);
        this.tooltipBackground.drawRect(0, 0, width, height);
        this.tooltipBackground.endFill();
        tooltip.visible = true;
    }
    moveTooltip(event) {
        const newPosition = event.data.getLocalPosition(this.tooltipContainer);
        let xOffset = this.tooltipOffset - 10;
        let yOffset = -20;
        if (newPosition.x + xOffset < 0) {
            xOffset = CURSOR_WIDTH;
        }
        if (newPosition.y + this.tooltip.height > HEIGHT) {
            yOffset = HEIGHT - newPosition.y - this.tooltip.height;
        }
        this.tooltip.position.x = newPosition.x + xOffset;
        this.tooltip.position.y = newPosition.y + yOffset;
    }
    hideTooltip() {
        this.tooltip.visible = false;
    }
}
