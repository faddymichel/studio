import Music from '@faddymichel/studio/music/server';
import Tabla from '@faddymichel/studio/music/instrument/tabla';

await new class LDerebecca extends Music {

tempo = 105;

tabla = new Tabla ( this );

tuning = [

3,
2,
2,
3,
2,
2,
2

];

play () {

this .tabla .play ( { length: 1 }, {}, {}, {} );

return super .play ();

};

} () .play ();
