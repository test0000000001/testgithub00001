//
//  effects.h
//  effectslib
//
//  Created by xi penggang on 5/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#ifndef effectslib_effects_h
#define effectslib_effects_h

#include <sys/time.h>

extern "C" {
#include "../../ffmpeg/include/libavformat/avformat.h"
#include "../../ffmpeg/include/libavcodec/avcodec.h"
#include "../../ffmpeg/include/libswscale/swscale.h"
#include "../../ffmpeg/include/libavutil/avutil.h"
    

    
#include "../../ffmpeg/include/libavutil/avassert.h"
#include "../../ffmpeg/include/libavutil/opt.h"
#include "../../ffmpeg/include/libavutil/dict.h"
#include "../../ffmpeg/include/libavutil/pixdesc.h"	
#include "../../ffmpeg/include/libavutil/avstring.h"
#include "../../ffmpeg/include/libavutil/mathematics.h"
#include "../../ffmpeg/include/libavutil/parseutils.h"  
    
#include <sys/time.h>
#include <time.h>
#include <stdarg.h>
    
    
}

#include "effects_define.h"

/**
 * name：        detect_mp4_format
 * desc:         parse input media file first frame, if file's audio codec is aac and 
 video codec is h264, return 1, or 0.
 * @param：       fileName: the full media file's full path
 * @return:      if h264 & aac  value is 1, or  0;
 **/
extern int get_file_duration(char *filename);




/**
 * Return a name for the specified enum AVMeidaType
 * @param   AVMediaType enum value
 * @return  A name for the mediaType if found, NULL otherwise.
 */

extern const char *av_get_media_type_string(enum AVMediaType media_type);

extern void save_frame(AVFrame *pFrame, int width, int height, char *output_filename);
extern int generate_screencut(char *filename, int start_seconds,  char *output_filename);
extern int write_jpg (AVCodecContext *pCodecCtx, AVFrame *pFrame, char *filename);

extern void write_audio_frame(AVFormatContext *oc, AVStream *st);
extern void write_video_frame(AVFormatContext *oc, AVStream *st);
extern void write_audio_frame_by_packet(AVFormatContext *oc, AVStream *st, AVPacket *pkt);
extern void write_video_frame_by_packet(AVFormatContext *oc, AVStream *st, AVPacket *pkt);

extern void get_audio_frame(int16_t *samples, int frame_size, int nb_channels);
extern AVFrame *alloc_picture(enum PixelFormat pix_fmt, int width, int height);
extern void fill_yuv_image(AVFrame *pict, int frame_index, int width, int height);
extern void close_audio(AVFormatContext *oc, AVStream *st);
extern void close_video(AVFormatContext *oc, AVStream *st);


extern AVStream *add_video_stream(AVFormatContext *oc, AVFormatContext *pFormatContext,enum CodecID codec_id, int streamIndex);
extern AVStream *add_audio_stream(AVFormatContext *oc, AVFormatContext *pFormatContext,enum CodecID codec_id, int streamIndex);
extern AVStream *add_video_stream(AVFormatContext *oc, enum CodecID codec_id);
extern AVStream *add_audio_stream(AVFormatContext *oc, enum CodecID codec_id);
extern void open_video(AVFormatContext *oc, AVStream *st, AVStream *srcStream);
extern void open_audio(AVFormatContext *oc, AVStream *st, AVStream *srcStream);


extern void open_video(AVFormatContext *oc, AVStream *st);
extern void open_audio(AVFormatContext *oc, AVStream *st);

#endif
