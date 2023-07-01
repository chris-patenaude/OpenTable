<template>
  <div ref="container"></div>
</template>

<script>
import { onMounted, ref } from 'vue';
import Konva from 'konva';

export default {
  setup() {
    let isDrawing = ref(false);
    let gridDrawn = ref(false)
    const container = ref(null);
    let lastLine = ref(null);
    let startPos = ref(null);
    let gridStartPos = ref(null);
    let stage = ref(null);
    let layer = ref(null);

    async function drawGameGrid() {
      console.log("GameCanvas: Drawing Grid...")
      isDrawing.value = false;

      const cellSize = lastLine.value.width(); // Assuming square cells
      const offset = {
        x: -Math.floor(stage.value.width() / cellSize),
        y: -Math.floor(stage.value.height() / cellSize),
      }

      gridStartPos.value = {
        x: startPos.value.x + offset.x * cellSize,
        y: startPos.value.y + offset.y * cellSize,
      };

      const gridSize = {
        rows: Math.floor(Math.max(stage.value.width() * 2, gridStartPos.value.x + cellSize) / cellSize),
        cols: Math.floor(Math.max(stage.value.height() * 2, gridStartPos.value.y + cellSize) / cellSize),
      };

      // Store all cells first, instead of adding to layer immediately
      let cells = [];

      for (let i = 0; i < gridSize.rows; i++) {
        for (let j = 0; j < gridSize.cols; j++) {
          const gridCell = new Konva.Rect({
            x: gridStartPos.value.x + i * cellSize,
            y: gridStartPos.value.y + j * cellSize,
            width: cellSize,
            height: cellSize,
            stroke: 'grey',
            strokeWidth: 1,
          });
          cells.push(gridCell);
        }
      }

      // Add all cells to layer at once
      cells.forEach(cell => layer.value.add(cell));

      // Set new stage dimensions
      stage.value.width(gridSize.rows * cellSize);
      stage.value.height(gridSize.cols * cellSize);

      // Remove lastLine Rect when no longer needed
      lastLine.value.remove();

      // Draw or batchDraw once after all elements have been added
      layer.value.batchDraw();

      gridDrawn.value = true;
      console.log("GameCanvas: Grid drawn.")
    }


    function drawUserSquare() {
      if (!isDrawing.value) {
        return;
      }
      const pointerPos = stage.value.getPointerPosition();
      const dimension = Math.min(pointerPos.x - startPos.value.x, pointerPos.y - startPos.value.y);
      lastLine.value.width(dimension);
      lastLine.value.height(dimension);
      layer.value.batchDraw();
    }

    function setStartPos() {
      isDrawing.value = true;
      startPos.value = stage.value.getPointerPosition();

      lastLine.value = new Konva.Rect({
        x: startPos.value.x,
        y: startPos.value.y,
        width: 0,
        height: 0,
        stroke: 'black',
        strokeWidth: 2,
        draggable: true,
      });
      layer.value.add(lastLine.value);
    }

    function initGameBoard() {
      stage.value = new Konva.Stage({
        container: container.value, // Container to render to
        width: window.innerWidth,
        height: window.innerHeight,
      });

      layer.value = new Konva.Layer();
      stage.value.add(layer.value);

      const imageObj = new window.Image();
      imageObj.src = 'https://i.etsystatic.com/18388031/r/il/8b7a49/2796267092/il_fullxfull.2796267092_aezx.jpg'; // specify path to your image
      imageObj.onload = () => {
        const img = new Konva.Image({
          x: 0,
          y: 0,
          image: imageObj,
          width: stage.value.width(),
          height: stage.value.height(),
        });

        layer.value.add(img);
        layer.value.draw();
      };

    }


    onMounted(() => {
      initGameBoard();

      stage.value.on('mousedown', () => {
        if (gridDrawn.value) {
          return;
        }
        setStartPos();
      });

      stage.value.on('mousemove', () => {
        if (gridDrawn.value) {
          return
        }
        drawUserSquare();
      });

      stage.value.on('mouseup', () => {
        if (gridDrawn.value) {
          return
        }
        drawGameGrid()
      });
    });

    return { container };
  },
};
</script>
