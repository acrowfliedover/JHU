/*
Developed for JHU 605.668: Computer Gaming Engines

This is free and unencumbered software released into the public domain.
For more information, please refer to <https://unlicense.org>
*/

#include "graph/sprite_node.hpp"
#include <iostream>
#include "image/image.hpp"
#include "system/file_locator.hpp"

namespace cge
{

SpriteNode::SpriteNode() :
    texture_{nullptr},
    width_{0},
    height_{0},
    filepath_{""},
    apply_color_mod_{false},
    color_mods_{0},
    apply_blend_{false},
    blend_alpha_{0}
{
}

void SpriteNode::init(SceneState &scene_state)
{
    auto file_info = locate_path_for_filename(filepath_);
    auto result = image::create_texture(*scene_state.sdl_info, file_info.path);

    texture_ = result.texture;
    width_ = result.width;
    height_ = result.height;

    init_children(scene_state);
}

void SpriteNode::destroy()
{
    destroy_children();
    clear_children();

    SDL_DestroyTexture(texture_);
}

void SpriteNode::draw(SceneState &scene_state)
{
    SpriteNode *prev_sprite_node = scene_state.sprite_node;
    scene_state.sprite_node = this;

    if(apply_blend_)
    {
        SDL_SetTextureBlendMode(texture_, SDL_BLENDMODE_BLEND);
        SDL_SetTextureAlphaMod(texture_, blend_alpha_);
    }
    else { SDL_SetTextureBlendMode(texture_, SDL_BLENDMODE_NONE); }

    if(apply_color_mod_)
    {
        SDL_SetTextureBlendMode(texture_, SDL_BLENDMODE_BLEND);
        SDL_SetTextureColorMod(texture_, color_mods_[0], color_mods_[1], color_mods_[2]);
    }
    SDL_FRect rect;
    SDL_FPoint top_left = scene_state.matrix_stack->top() * SDL_FPoint{-0.5f, -0.5f};
    SDL_FPoint top_right = scene_state.matrix_stack->top() * SDL_FPoint{0.5f, -0.5f};
    SDL_FPoint bot_left = scene_state.matrix_stack->top() * SDL_FPoint{-0.5f, 0.5f};
    SDL_RenderTextureAffine(scene_state.sdl_info->renderer,
                            scene_state.sprite_node->sdl_texture(),
                            &rect,
                            &top_left,
                            &top_right,
                            &bot_left);
    draw_children(scene_state);

    scene_state.sprite_node = prev_sprite_node;
}

void SpriteNode::update(SceneState &scene_state)
{
    update_children(scene_state);
}

SDL_Texture *SpriteNode::sdl_texture() { return texture_; }

int SpriteNode::width() const { return width_; }

int SpriteNode::height() const { return height_; }

void SpriteNode::set_filepath(const std::string &filepath) { filepath_ = filepath; }

void SpriteNode::set_color_mods(const uint8_t mods[3])
{
    apply_color_mod_ = true;
    color_mods_[0] = mods[0];
    color_mods_[1] = mods[1];
    color_mods_[2] = mods[2];
}
void SpriteNode::set_top_left(float x, float y) { corners_[0] = {x, y}; }

void SpriteNode::set_top_right(float x, float y) { corners_[1] = {x, y}; }

void SpriteNode::set_bottom_left(float x, float y) { corners_[2] = {x, y}; }

void SpriteNode::set_blend(bool blend) { apply_blend_ = blend; }

void SpriteNode::set_blend_alpha(uint8_t alpha) { blend_alpha_ = alpha; }

} // namespace cge
