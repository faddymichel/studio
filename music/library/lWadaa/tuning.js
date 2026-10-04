export default class Tuning {

$ = this .#engine .bind ( this );

#key = 'a' .charCodeAt ( 0 );
#scale = {};

constructor ( ... tones ) { this .#construct ( ... tones ) };

#construct ( ... tones ) {

if ( ! tones .length ) return;

this .#scale [ String .fromCharCode ( this .#key++ ) ] = tones .shift ();

return this .#construct ( ... tones );

};

#engine ( ... argv ) {

if ( ! argv .length )
return { ... this .#scale };

};

};

const { $ } = new Tuning (

-5,
-1,
0,
3,
4,
7,
10,

);

console .log ($ (



) );
