/*
Developed for JHU 605.668: Computer Gaming Engines

This is free and unencumbered software released into the public domain.
For more information, please refer to <https://unlicense.org>
*/

#include "graph/geometry_node.hpp"
#include "graph/root_node.hpp"
#include "graph/scene_state.hpp"
#include "graph/texture_node.hpp"
#include "graph/sprite_node.hpp"
#include "graph/transform_node.hpp"

namespace cge
{

    class NewScene
    {
    public:
        void init(SDLInfo* sdl_info);

        void destroy();

        void update(float time_delta);

        void render();

    private:
        SDLInfo* sdl_info_;
        RootNode   root_;
        SceneState scene_state_;
        std::shared_ptr<TransformNode> main_transform;
    };

} // namespace cge
