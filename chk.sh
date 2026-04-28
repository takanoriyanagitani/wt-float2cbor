#!/bin/zsh

wsm="./float2cbor.wasm"

pad=$(( 0xf6 )) # null

single2cbor(){
  local single
  single=$1
  readonly single

  wasmer \
    run \
    --invoke \
    single2cbor \
    "${wsm}" \
    "${pad}" \
    $single
}

echo '1.5 in cbor(f32) with pads'
single2cbor 1.5 | xargs printf '%08x' | xxd -r -ps | xxd
echo

echo 'parse the cbor using cbor2.tool'
single2cbor 1.5 |
  xargs printf '%08x' |
  xxd -r -ps |
  python3 -m cbor2.tool --pretty --sequence
echo

echo 'cbor to float (ignore pads)'
node \
  ./cbor2float.mjs \
  $( single2cbor 1.5 | xargs printf '%08x' | xxd -r -ps | xxd -ps )
