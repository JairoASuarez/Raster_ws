# Taller raster

## Propósito

Comprender algunos aspectos fundamentales del paradigma de rasterización.

## Tareas

Emplee coordenadas baricéntricas para:

1. Rasterizar un triángulo;
2. Implementar un algoritmo de anti-aliasing para sus aristas; y,
3. Hacer shading sobre su superficie.

Implemente la función ```triangleRaster()``` del sketch adjunto para tal efecto, requiere la librería [frames](https://github.com/VisualComputing/framesjs/releases).

## Integrantes

Máximo 3.
os como entrada y la capacidad 
Complete la tabla:

| Integrante | github nick |
|------------|-------------|
| Jonathan Granados | www.github.com/joagranadosme |
| Jairo Suarez | www.github.com/JairoASuarez |

## Discusión

Para realizar el anti-aliasing identificamos los puntos que hacian parte de las aristas del triangulo, es decir los bordes, a estos puntos los coloreamos con el color promedio resultante de el color del triangulo y el fondo de la pantalla.
Para el shading lo realizamos con coordenadas baricentricas hacia un vertice del triangulo.
Implementamos los eventos de teclas para activar/desactivar cada tarea:
1. Tecla 'd' para debug.
2. Tecla 'a' para anti-aliasing.
3. Tecla 's' para shading.

## Entrega

* Modo de entrega: [Fork](https://help.github.com/articles/fork-a-repo/) la plantilla en las cuentas de los integrantes (de las que se tomará una al azar).
* Plazo: 1/4/18 a las 24h.
