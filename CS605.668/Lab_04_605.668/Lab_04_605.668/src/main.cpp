/*
Developed for JHU 605.668: Computer Gaming Engines

This is free and unencumbered software released into the public domain.
For more information, please refer to <https://unlicense.org>
*/

#include "platform/core.hpp"
#include "platform/event.hpp"
#include "system/file_locator.hpp"
#include "system/preprocessor.h"

#include "examples/dynamic_scene.hpp"
#include "examples/hybrid_scene.hpp"
#include "examples/static_scene.hpp"
#include "graph/new_scene.hpp"
#include "system/time_manager.hpp"

#include <chrono>
#include <iostream>
#include <thread>

void sleep(int milliseconds)
{
    std::this_thread::sleep_for(std::chrono::milliseconds(milliseconds));
}

int main(int argc, char *argv[])
{
    auto source_path = STD_STRING(SRC_DIR);
    auto resource_path = STD_STRING(RESOURCE_DIR);
    cge::set_system_paths(argv[0], source_path, resource_path);
    cge::init_sdl();

    cge::SDLInfo sdl_info;

    constexpr int SCREEN_WIDTH = 800;
    constexpr int SCREEN_HEIGHT = 600;

    cge::create_sdl_components(sdl_info, SCREEN_WIDTH, SCREEN_HEIGHT, "Class 605.688");

    //cge::DynamicScene scene;
    // cge::StaticScene scene;
    // cge::HybridScene scene;
    cge::NewScene scene;

    scene.init(&sdl_info);
    const int frame_rate = 20;
    const float      delta = 1.0 / frame_rate;
    cge::TimeManager time_manager = cge::TimeManager();
    bool run_game = true;
    // had no time to create new class for game loop just had some files as placeholders
    int number_of_updates = 0;
    int number_of_draws = 0;
    std::cout << "Time before:" << time_manager.get_current_time() << "\n";

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
        if(time_manager.update_scene(delta))
        {
            scene.update(delta);
            number_of_updates++;
            std::cout << "Number of updates: " << number_of_updates << "\n";
        }
        if(time_manager.draw_scene(delta))
        {
            scene.render();
            number_of_draws++;
            std::cout << "Number of draws: " << number_of_draws << "\n";
        }
        //sleep(16);
    }
    std::cout << "Time after:" << time_manager.get_current_time() << "\n";
    scene.destroy();
    cge::destroy_sdl_components(sdl_info);
    return 0;
}
