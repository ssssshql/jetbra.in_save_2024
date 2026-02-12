import { readFileSync } from 'fs';
const data = JSON.parse(readFileSync('keys.json', 'utf-8'));
console.log(JSON.stringify(Object.keys(data), null, 2));
