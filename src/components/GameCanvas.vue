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
    // let lastDist = ref(0);
    // let isPanning = ref(false);
    // let lastPointerPos = ref({ x: 0, y: 0 });

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

      const canvasElement = document.createElement('canvas');
      canvasElement.width = gridSize.rows * cellSize;
      canvasElement.height = gridSize.cols * cellSize;

      const context = canvasElement.getContext('2d');

      for (let i = 0; i < gridSize.rows; i++) {
        for (let j = 0; j < gridSize.cols; j++) {
          context.strokeRect(gridStartPos.value.x + i * cellSize, gridStartPos.value.y + j * cellSize, cellSize, cellSize);
        }
      }

      const imageObj = new Image();
      imageObj.onload = function() {
        const img = new Konva.Image({
          x: 0,
          y: 0,
          image: imageObj,
          width: gridSize.rows * cellSize,
          height: gridSize.cols * cellSize,
        });

        layer.value.add(img);
        layer.value.draw();
      }
      imageObj.src = canvasElement.toDataURL();

      // Set new stage dimensions
      stage.value.width(gridSize.rows * cellSize);
      stage.value.height(gridSize.cols * cellSize);

      // Remove lastLine Rect when no longer needed
      lastLine.value.remove();

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
      stage.value.on('wheel', (e) => {
        e.evt.preventDefault();

        const oldScale = stage.value.scaleX();

        const pointerPos = stage.value.getPointerPosition();

        const mousePointTo = {
          x: (pointerPos.x - stage.value.x()) / oldScale,
          y: (pointerPos.y - stage.value.y()) / oldScale,
        };

        const newScale = e.evt.deltaY > 0 ? oldScale * 1.1 : oldScale * 0.9;

        stage.value.scale({ x: newScale, y: newScale });

        const newPos = {
          x: pointerPos.x - mousePointTo.x * newScale,
          y: pointerPos.y - mousePointTo.y * newScale,
        };

        stage.value.position(newPos);
        stage.value.batchDraw();
      });
    });

    return { container };
  },
};
</script>
