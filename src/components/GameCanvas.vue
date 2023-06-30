<template>
  <div ref="container"></div>
</template>

<script>
import { onMounted, ref } from 'vue';
import Konva from 'konva';

export default {
  setup() {
    const container = ref(null);
    let stage;

    onMounted(() => {
      stage = new Konva.Stage({
        container: container.value, // Container to render to
        width: window.innerWidth,
        height: window.innerHeight,
      });

      const layer = new Konva.Layer();
      stage.add(layer);

      const imageObj = new window.Image();
      imageObj.src = 'https://i.etsystatic.com/18388031/r/il/8b7a49/2796267092/il_fullxfull.2796267092_aezx.jpg'; // specify path to your image
      imageObj.onload = () => {
        const img = new Konva.Image({
          x: 0,
          y: 0,
          image: imageObj,
          width: stage.width(),
          height: stage.height(),
        });

        layer.add(img);
        layer.draw();
      };

      let isDrawing = false;
      let lastLine;
      let startPos;

      stage.on('mousedown', () => {
        isDrawing = true;
        startPos = stage.getPointerPosition();
        lastLine = new Konva.Rect({
          x: startPos.x,
          y: startPos.y,
          width: 0,
          height: 0,
          stroke: 'black',
          strokeWidth: 2,
          draggable: true,
        });
        layer.add(lastLine);
      });

      stage.on('mousemove', () => {
        if (!isDrawing) {
          return;
        }
        const pointerPos = stage.getPointerPosition();
        const dimension = Math.min(pointerPos.x - startPos.x, pointerPos.y - startPos.y);

        lastLine.width(dimension);
        lastLine.height(dimension);
        layer.batchDraw();
      });

      stage.on('mouseup', () => {
        isDrawing = false;

        // Create grid based on lastLine size
        const cellSize = lastLine.width(); // Assuming square cells
        const gridSize = {
          rows: Math.floor(Math.max(stage.width(), startPos.x + cellSize) / cellSize),
          cols: Math.floor(Math.max(stage.height(), startPos.y + cellSize) / cellSize),
        };

        for (let i = 0; i < gridSize.rows; i++) {
          for (let j = 0; j < gridSize.cols; j++) {
            const gridCell = new Konva.Rect({
              x: startPos.x + i * cellSize,
              y: startPos.y + j * cellSize,
              width: cellSize,
              height: cellSize,
              stroke: 'grey',
              strokeWidth: 1,
            });
            layer.add(gridCell);
          }
        }

        // Set new stage dimensions
        stage.width(gridSize.rows * cellSize);
        stage.height(gridSize.cols * cellSize);

        lastLine.moveToTop();
        layer.batchDraw();
      });
    });

    return { container };
  },
};
</script>
