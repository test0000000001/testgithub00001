//
//  mp4box.h
//  mp4box
//
//  Created by penggang xi on 3/22/13.
//  Copyright (c) 2013 penggang xi. All rights reserved.
//

#ifndef mp4box_mp4box_h
#define mp4box_mp4box_h

typedef struct GF_ISOFile isoFile;

typedef enum en_xif_ret{
    ISO_FILE_OK = 0,
    ISO_FILE_FAILT
}XIF_RET;

#ifdef __cplusplus
extern "C" {
#endif
    
int mp4boxPoss( int argc, char** argv, const char* outfile);

//cat.
extern isoFile* ifx_open(const char* outfile);
extern XIF_RET ifx_append(isoFile* file, const char* inputfile);
extern XIF_RET ifx_stop(isoFile* file);

//split.
extern XIF_RET ifx_split(const char* inputfile, const char* outfile, float start, float end);
    
#ifdef __cplusplus
}
#endif


#endif
