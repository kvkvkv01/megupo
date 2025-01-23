#pragma once
#include <libavcodec/avcodec.h>
#include <libavformat/avformat.h>
#include <pthread.h>

extern int readCallBack(void*, uint8_t*, int);
extern int64_t seekCallBack(void*, int64_t, int);

void init(void);
int create_context(AVFormatContext** ctx, const char* input_format);
int codec_context(const AVCodec** codec, AVCodecContext** avcc, int* stream, AVFormatContext* avfc, const enum AVMediaType type);
