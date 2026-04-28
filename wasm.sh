#!/bin/sh

iname=./float2cbor.wat
oname=./float2cbor.wasm

wat2wasm \
	"${iname}" \
	-o "${oname}" \
	--enable-relaxed-simd \
	--enable-tail-call || exec sh -c '
		echo unable to compile.
		exit 1
	'

ls -l "${oname}"
