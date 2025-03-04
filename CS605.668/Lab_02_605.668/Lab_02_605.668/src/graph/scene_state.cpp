/*
Developed for JHU 605.668: Computer Gaming Engines

This is free and unencumbered software released into the public domain.
For more information, please refer to <https://unlicense.org>
*/

#include "graph/scene_state.hpp"

#include "graph/texture_node.hpp"

namespace cge
{

void SceneState::reset()
{
    sdl_info = nullptr;
    texture_node = nullptr;
    sprite_node = nullptr;
}

} // namespace cge
