import test from 'node:test';
import assert from 'node:assert/strict';
import {decodePacket} from './amf.mjs';
test('AMF0 ECMA array keeps numeric indices, named keys and object references',()=>{
 // Hand-authored AMF0 envelope: body is an ECMA array with two numeric entries,
 // an associative label and a reference back to the array itself.
 const packet=Buffer.from('00000000000100015800022f31ffffffff08000000020001300200036f6e6500013107000000056c6162656c02000474657374000009','hex');
 const a=decodePacket(packet).bodies[0].data;
 assert.ok(Array.isArray(a));assert.equal(a[0],'one');assert.equal(a[1],a);assert.equal(a.label,'test');
});
