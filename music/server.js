import Music from '@faddymichel/studio/music';
import { resolve } from 'node:path';
import { writeFile } from 'node:fs/promises';
import { spawn } from 'node:child_process';

export default class MusicServer extends Music {

stdio = 'ignore';

get path () { return resolve ( process .cwd (), this .title + '.csd' ) };

write ( path = this .path ) { return writeFile ( path, this .document, 'utf8' ) };

async play ( path = this .path ) {

await this .write ( path );

return new Promise ( done => spawn ( 'csound', [ `--logfile=${ path }.log`, path ], { stdio: this .stdio } )
.on ( 'exit', ( ... status ) => done ( status ) ) );

};

};
