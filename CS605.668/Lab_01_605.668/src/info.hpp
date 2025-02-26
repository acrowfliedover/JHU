/*
Developed for JHU 605.668: Computer Gaming Engines

This is free and unencumbered software released into the public domain.
For more information, please refer to <https://unlicense.org>
*/

#ifndef INFO_HPP
#define INFO_HPP

#include "sdl.h"

namespace cge
{

struct SDLInfo
{
    SDL_Window   *window;
    SDL_Renderer *renderer;
};

enum class EventType
{
    PLAY_SOUND,
    TOGGLE_MUSIC,
    QUIT
};

struct SDLEventInfo
{
    static constexpr size_t MAX_EVENTS = 10;
    uint8_t                 num_events;
    EventType               events[MAX_EVENTS];
};

struct SDLTextureInfo
{
    SDL_Texture *texture;
    int          width;
    int          height;
    SDL_Rect     dimensions;
};

struct SDLTextureOptions
{
    int           width = -1;  // if negative, render texture's original size
    int           height = -1; // if negative, render texture's original size
    SDL_BlendMode blend_mode = SDL_BLENDMODE_NONE;
    uint8_t       blend_alpha = 255;
    uint8_t       color_mod[3] = {255, 255, 255};
};

struct ImageData
{
    int            w = 0;
    int            h = 0;
    int            channels = 0;
    int            bytes_per_row;
    unsigned char *data = nullptr;
};

} // namespace cge

#endif // INFO_HPP
