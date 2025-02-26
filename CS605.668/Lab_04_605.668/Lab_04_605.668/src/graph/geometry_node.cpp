/*
Developed for JHU 605.668: Computer Gaming Engines

This is free and unencumbered software released into the public domain.
For more information, please refer to <https://unlicense.org>
*/

#include "graph/geometry_node.hpp"

#include "graph/texture_node.hpp"

#include <iostream>

namespace cge
{

void GeometryNode::init(SceneState &scene_state) {}

void GeometryNode::destroy() { clear_children(); }

void GeometryNode::draw(SceneState &scene_state)
{
    SDL_FRect rect;
    //rect.x = 0.0f;
    //rect.w = static_cast<float>(scene_state.texture_node->width());
    //rect.y = 0.0f;
    //rect.h = static_cast<float>(scene_state.texture_node->height());

    //SDL_RenderTextureAffine(scene_state.sdl_info->renderer,
    //                        scene_state.texture_node->sdl_texture(),
    //                        &rect,
    //                        &corners_[0],
    //                        &corners_[1],
    //                        &corners_[2]);
    //auto       tl = scene_state.matrix_stack->top() * Vector2(-0.5f, -0.5f);
    //auto       tr = scene_state.matrix_stack->top() * Vector2(0.5f, -0.5f);
    //auto       bl = scene_state.matrix_stack->top() * Vector2(-0.5f, 0.5f);
    SDL_FPoint top_left = scene_state.matrix_stack->top() * SDL_FPoint{-0.5f, -0.5f};
    SDL_FPoint top_right = scene_state.matrix_stack->top() * SDL_FPoint{0.5f, -0.5f};
    SDL_FPoint bot_left = scene_state.matrix_stack->top() * SDL_FPoint{-0.5f, 0.5f};
    SDL_RenderTextureAffine(scene_state.sdl_info->renderer,
                            scene_state.texture_node->sdl_texture(),
                            &rect,
                            &top_left,
                            &top_right,
                            &bot_left);
}

void GeometryNode::update(SceneState &scene_state) { update_children(scene_state); }

void GeometryNode::set_top_left(float x, float y) { corners_[0] = {x, y}; }

void GeometryNode::set_top_right(float x, float y) { corners_[1] = {x, y}; }

void GeometryNode::set_bottom_left(float x, float y) { corners_[2] = {x, y}; }



} // namespace cge
