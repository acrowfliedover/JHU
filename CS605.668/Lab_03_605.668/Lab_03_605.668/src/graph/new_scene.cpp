/*
Developed for JHU 605.668: Computer Gaming Engines

This is free and unencumbered software released into the public domain.
For more information, please refer to <https://unlicense.org>
*/

#include "graph/new_scene.hpp"

#include "graph/geometry_node.hpp"
#include "graph/texture_node.hpp"
#include "graph/sprite_node.hpp"

namespace cge
{

void NewScene::init(SDLInfo *sdl_info)
{
    sdl_info_ = sdl_info;

    SDL_SetRenderDrawColor(sdl_info->renderer, 80, 164, 234, 55);
    SDL_SetRenderDrawBlendMode(sdl_info->renderer, SDL_BLENDMODE_BLEND);

    uint8_t cyan[3] = {0, 255, 255};
    uint8_t orange[3] = {255, 128, 0};

    auto spr_0 = std::make_shared<SpriteNode>();
    spr_0->set_filepath("images/note.png");
    spr_0->set_blend(true);
    spr_0->set_blend_alpha(200);
    spr_0->set_color_mods(cyan);
    spr_0->set_top_left(100.0f, 100.0f);
    spr_0->set_top_right(300.0f, 100.0f);
    spr_0->set_bottom_left(300.0f, 300.0f);


    auto spr_1 = std::make_shared<SpriteNode>();
    spr_1->set_filepath("images/background.png");
    spr_1->set_blend(true);
    spr_1->set_blend_alpha(200);
    spr_1->set_color_mods(orange);
    spr_1->set_top_left(400.0f, 100.0f);
    spr_1->set_top_right(600.0f, 100.0f);
    spr_1->set_bottom_left(500.0f, 400.0f);


    root_.add_child(spr_0);
    root_.add_child(spr_1);


    scene_state_.reset();
    scene_state_.sdl_info = sdl_info_;
    root_.init(scene_state_);
}

void NewScene::destroy() { root_.destroy(); }

void NewScene::update(float time_delta)
{
    scene_state_.reset();
    scene_state_.sdl_info = sdl_info_;
    scene_state_.time_delta = time_delta;
}

void NewScene::render()
{
    scene_state_.reset();
    scene_state_.sdl_info = sdl_info_;
    root_.draw(scene_state_);
}

} // namespace cge
