CONFIG += object_parallel_to_source no_batch

TEMPLATE = lib
TARGET = webp

INCLUDEPATH += \
    $$PWD/ \
    $$PWD/src \
    $$PWD/src/dec \
    $$PWD/src/enc \
    $$PWD/src/dsp \
    $$PWD/src/mux \
    $$PWD/src/utils \
    $$PWD/src/webp

SOURCES += \
    $$PWD/src/dec/alpha.c \
    $$PWD/src/dec/buffer.c \
    $$PWD/src/dec/frame.c \
    $$PWD/src/dec/idec.c \
    $$PWD/src/dec/io.c \
    $$PWD/src/dec/quant.c \
    $$PWD/src/dec/tree.c \
    $$PWD/src/dec/vp8.c \
    $$PWD/src/dec/vp8l.c \
    $$PWD/src/dec/webp.c \
    $$PWD/src/demux/demux.c \
    $$PWD/src/dsp/cpu.c \
    $$PWD/src/dsp/dec.c \
    $$PWD/src/dsp/dec_sse2.c \
    $$PWD/src/dsp/enc.c \
    $$PWD/src/dsp/enc_sse2.c \
    $$PWD/src/dsp/lossless.c \
    $$PWD/src/dsp/upsampling.c \
    $$PWD/src/dsp/upsampling_sse2.c \
    $$PWD/src/dsp/yuv.c \
    $$PWD/src/dsp/alpha_processing.c \
    $$PWD/src/dsp/alpha_processing_sse2.c \
    $$PWD/src/dsp/dec_clip_tables.c \
    $$PWD/src/dsp/dec_mips32.c \
    $$PWD/src/dsp/enc_avx2.c \
    $$PWD/src/dsp/enc_mips32.c \
    $$PWD/src/dsp/lossless_mips32.c \
    $$PWD/src/dsp/lossless_sse2.c \
    $$PWD/src/dsp/yuv_mips32.c \
    $$PWD/src/dsp/yuv_sse2.c \
    $$PWD/src/enc/alpha.c \
    $$PWD/src/enc/analysis.c \
    $$PWD/src/enc/backward_references.c \
    $$PWD/src/enc/config.c \
    $$PWD/src/enc/cost.c \
    $$PWD/src/enc/filter.c \
    $$PWD/src/enc/frame.c \
    $$PWD/src/enc/histogram.c \
    $$PWD/src/enc/iterator.c \
    $$PWD/src/enc/picture.c \
    $$PWD/src/enc/quant.c \
    $$PWD/src/enc/syntax.c \
    $$PWD/src/enc/token.c \
    $$PWD/src/enc/tree.c \
    $$PWD/src/enc/vp8l.c \
    $$PWD/src/enc/webpenc.c \
    $$PWD/src/enc/picture_csp.c \
    $$PWD/src/enc/picture_psnr.c \
    $$PWD/src/enc/picture_rescale.c \
    $$PWD/src/enc/picture_tools.c \
    $$PWD/src/mux/muxedit.c \
    $$PWD/src/mux/muxinternal.c \
    $$PWD/src/mux/muxread.c \
    $$PWD/src/utils/bit_reader.c \
    $$PWD/src/utils/bit_writer.c \
    $$PWD/src/utils/color_cache.c \
    $$PWD/src/utils/filters.c \
    $$PWD/src/utils/huffman.c \
    $$PWD/src/utils/huffman_encode.c \
    $$PWD/src/utils/quant_levels.c \
    $$PWD/src/utils/quant_levels_dec.c \
    $$PWD/src/utils/random.c \
    $$PWD/src/utils/rescaler.c \
    $$PWD/src/utils/thread.c \
    $$PWD/src/utils/utils.c

android {
    SOURCES += $$NDK_ROOT/sources/android/cpufeatures/cpu-features.c
    INCLUDEPATH += $$NDK_ROOT/sources/android/cpufeatures
}

equals(QT_ARCH, arm)|equals(QT_ARCH, arm64) {
    SOURCES_FOR_NEON += \
        $$PWD/src/dsp/dec_neon.c \
        $$PWD/src/dsp/enc_neon.c \
        $$PWD/src/dsp/upsampling_neon.c \
        $$PWD/src/dsp/lossless_neon.c

    contains(QT_CPU_FEATURES.$$QT_ARCH, neon) {
        # Default compiler settings include this feature, so just add to SOURCES
        SOURCES += $$SOURCES_FOR_NEON
    } else {
        neon_comp.commands = $$QMAKE_CC -c $(CFLAGS)
        !contains(QT_ARCH, arm64) {
            neon_comp.commands += $$QMAKE_CFLAGS_NEON
        }
        neon_comp.commands += $(INCPATH) ${QMAKE_FILE_IN}
        msvc: neon_comp.commands += -Fo${QMAKE_FILE_OUT}
        else: neon_comp.commands += -o ${QMAKE_FILE_OUT}
        neon_comp.dependency_type = TYPE_C
        neon_comp.output = ${QMAKE_VAR_OBJECTS_DIR}${QMAKE_FILE_BASE}$${first(QMAKE_EXT_OBJ)}
        neon_comp.input = SOURCES_FOR_NEON
        neon_comp.variable_out = OBJECTS
        neon_comp.name = compiling[neon] ${QMAKE_FILE_IN}
        silent: neon_comp.commands = @echo compiling[neon] ${QMAKE_FILE_IN} && $$neon_comp.commands
        QMAKE_EXTRA_COMPILERS += neon_comp
    }
}

target.path = /usr/share/ru.neochapay.maximus/lib
INSTALLS += target
