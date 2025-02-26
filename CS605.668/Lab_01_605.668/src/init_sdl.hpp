/*
Developed for JHU 605.668: Computer Gaming Engines

This is free and unencumbered software released into the public domain.
For more information, please refer to <https://unlicense.org>
*/

#ifndef INIT_SDL_HPP
#define INIT_SDL_HPP

#include "info.hpp"

namespace cge
{

void init_sdl();
void create_sdl_components(SDLInfo &sdl_info, int window_width, int window_height);
void destroy_sdl_components(SDLInfo &sdl_info);

} // namespace cge

#endif // INIT_SDL_HPP
