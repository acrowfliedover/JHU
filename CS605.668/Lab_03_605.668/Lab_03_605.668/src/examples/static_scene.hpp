/*
Developed for JHU 605.668: Computer Gaming Engines

This is free and unencumbered software released into the public domain.
For more information, please refer to <https://unlicense.org>
*/

#include "graph/geometry_node.hpp"
#include "graph/root_node.hpp"
#include "graph/scene_state.hpp"
#include "graph/texture_node.hpp"

namespace cge
{

class StaticScene
{
  public:
    void init(SDLInfo *sdl_info);

    void destroy();

    void update(float time_delta);

    void render();

  private:
    SDLInfo      *sdl_info_;
    RootNodeT< //
        TextureNodeT<GeometryNodeT<>>,
        TextureNodeT<GeometryNodeT<>>>
               root_;
    SceneState    scene_state_;
};

} // namespace cge
