const ornaments = length => {

const { floor, log2 } = Math;
const power = log2 ( length );
const division = 2**floor ( power )
const remainder = length - division;

console .log ( 'length', length );
console .log ( 'power', power );
console .log ( 'division', division );
console .log ( 'remainder', remainder );

};

ornaments ( 7/8 );
