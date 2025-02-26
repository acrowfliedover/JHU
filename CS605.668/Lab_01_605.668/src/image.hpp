/*
Developed for JHU 605.668: Computer Gaming Engines

This is free and unencumbered software released into the public domain.
For more information, please refer to <https://unlicense.org>
*/

#ifndef IMAGE_HPP
#define IMAGE_HPP

#include "info.hpp"
#include "sdl.h"

#include <optional>
#include <string>

namespace cge
{

void load_image_data(ImageData &im_data, const std::string &fname);

void free_image_data(ImageData &im_data);

SDLTextureInfo create_texture(const SDLInfo &sdl_info, const std::string &filepath);
void           destroy_texture(const SDLTextureInfo &texture_info);

void render_texture(const SDLInfo                   &sdl_info,
                    const SDLTextureInfo            &texture_info,
                    const SDL_FPoint                 pts[3],
                    std::optional<SDLTextureOptions> texture_mods = std::nullopt);

} // namespace cge

#endif // IMAGE_HPP
