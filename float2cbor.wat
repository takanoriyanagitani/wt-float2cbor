(module

  (func $single2cbor (export "single2cbor")
    (param $pad i32)
    (param $single f32)
    (result i64)

    ;; input: f32
    ;; output: padded cbor

    local.get $single
    i32.reinterpret_f32
    i64.extend_i32_u
    i64.const 24
    i64.shl

    ;; copy the pad bytes using mul
    local.get $pad
    i32.const 0x0000_00ff
    i32.and
    i64.extend_i32_u
    i64.const 0x0000_0000_0001_0101
    i64.mul

    ;; or with the type 0xfa(32-bit float)
    i64.const 0xfa00_0000_0000_0000
    i64.or

    ;; or with the input f32
    i64.or
  )

  (func $single2i32 (export "single2i32") (param $s f32) (result i32)
    local.get $s
    i32.reinterpret_f32
  )

  (func $int2single (export "int2single") (param $i i32) (result f32)
    local.get $i
    f32.reinterpret_i32
  )

  (func $cbor2single (export "cbor2single") (param $c i64) (result f32)
    ;; input: cbor f32 with padding(ignored)

    ;; ignore the padded bytes and the type(0xfa)
    local.get $c
    i64.const 0x00ff_ffff_ff00_0000
    i64.and

    ;; shift to fit in i32
    i64.const 24
    i64.shr_u

    i32.wrap_i64
    f32.reinterpret_i32
  )

)
