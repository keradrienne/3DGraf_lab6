# 3D Grafikus rendszerek - 6. Labor
## Kiinduló projekt
A kiinduló projekt egy Gradle segítségével buildelhető WebGL alapú 3D grafikus alkalmazás, amely GLSL shadereket és Kotlin nyelvű logikát használ a rendereléshez.
Némely matematikai alapművelet és geomtria előre meg van írva. Ezeket kell a feladatnak megfelelően kiegészíteni vagy befejezni. A program fordítása során a Kotlin/JS transzpiláció a Kotlin kódot JavaScript kódra fordítja, amit a böngésző képes futtatni.

Kamera irányítása az A,W,S,D,Q,E billentyűk segítségével történik.

## Megvalósított feladatok
A terep 3D implicit zajfüggvénnyel lett generálva, majd raycast segítségével bináris kereséssel a terep magassága szerint árnyalva lett.
Színes köd is került a terep fölé, ami kitakarja a hátteret.