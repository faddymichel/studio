import Studio from '@faddymichel/studio/server';
import Tabla from '@faddymichel/studio/instrument/tabla';
import Electro from '@faddymichel/studio/instrument/electro';
import Horn from '@faddymichel/studio/instrument/horn';

export default await new class Example extends Studio {

title = 'theExampleBand';

tempo = 105;

tabla = new Tabla ( this );
electro = new Electro ( this );
horn = new Horn ( this );

};
