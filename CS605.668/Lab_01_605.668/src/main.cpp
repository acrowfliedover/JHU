/*
Developed for JHU 605.668: Computer Gaming Engines

This is free and unencumbered software released into the public domain.
For more information, please refer to <https://unlicense.org>
*/

#include "image.hpp"
#include "info.hpp"
#include "init_sdl.hpp"
#include "input.hpp"
#include "sdl.h"
#include "system/file_locator.hpp"
#include "system/preprocessor.h"

#include <chrono>
#include <iostream>
#include <thread>

void sleep(int milliseconds)
{
    std::this_thread::sleep_for(std::chrono::milliseconds(milliseconds));
}

int main(int argc, char *argv[])
{
    cge::set_system_paths(argv[0]);
    cge::init_sdl();

    cge::SDLInfo sdl_info;

    constexpr int SCREEN_WIDTH = 800;
    constexpr int SCREEN_HEIGHT = 600;

    cge::create_sdl_components(sdl_info, SCREEN_WIDTH, SCREEN_HEIGHT);

    SDL_SetRenderDrawColor(sdl_info.renderer, 64, 64, 64, 255);

    SDL_SetRenderDrawBlendMode(sdl_info.renderer, SDL_BLENDMODE_BLEND);

    auto box_file_info = cge::locate_path_for_filename("images/box.png");
    auto box_texture = create_texture(sdl_info, box_file_info.path);

    cge::SDLTextureOptions box_opts;
    box_opts.width = 100;
    box_opts.height = 100;
    box_opts.blend_mode = SDL_BLENDMODE_BLEND;
    box_opts.blend_alpha = 128;
    box_opts.color_mod[0] = 255;
    box_opts.color_mod[1] = 228;
    box_opts.color_mod[2] = 20;

    SDL_FPoint pts[3] = {
        {100.0f, 100.0f}, // top-left
        {400.0f, 100.0f}, // top-right
        {100.0f, 400.0f}  // bottom-left
    };

    bool run_game = true;
    while(run_game)
    {
        auto curr_events = cge::get_current_events();
        for(uint8_t i = 0; i < curr_events.num_events; ++i)
        {
            switch(curr_events.events[i])
            {
                case cge::EventType::QUIT: // 'esc' or close window
                    run_game = false;
                    break;
                default: break;
            }
        }

        SDL_RenderClear(sdl_info.renderer);

        cge::render_texture(sdl_info, box_texture, pts, box_opts);

        SDL_RenderPresent(sdl_info.renderer);
        sleep(16);
    }

    cge::destroy_texture(box_texture);
    cge::destroy_sdl_components(sdl_info);
    return 0;
}
